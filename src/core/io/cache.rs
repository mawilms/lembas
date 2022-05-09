use crate::core::{PluginCollection, PluginDataClass};
use r2d2::Pool;
use r2d2_sqlite::SqliteConnectionManager;
use rusqlite::{params, Statement};
use std::{collections::HashMap, error::Error, sync::Arc};

use super::feed_url_parser::Plugin;

#[derive(Debug, Clone)]
pub struct Cache {
    pool: Arc<Pool<SqliteConnectionManager>>,
}

impl Cache {
    pub fn new(connection: Pool<SqliteConnectionManager>) -> Self {
        Self {
            pool: Arc::new(connection),
        }
    }

    pub fn create_cache_db(&self) -> Result<(), rusqlite::Error> {
        let connection = self
            .pool
            .get()
            .expect("Error while creating a pooled connection");
        connection.execute(
            "
                CREATE TABLE IF NOT EXISTS plugin (
                    id INTEGER PRIMARY KEY,
                    name TEXT UNIQUE NOT NULL,
                    author TEXT NOT NULL,
                    current_version TEXT NOT NULL,
                    plugin_id INTEGER,
                    description TEXT,
                    download_url TEXT,
                    info_url TEXT,
                    category TEXT,
                    latest_version TEXT,
                    downloads INT,
                    archive_name TEXT,
                    updated_at INT,
                    hash TEXT,
                    installed INT DEFAULT 0
                );
        ",
            [],
        )?;

        Ok(())
    }

    pub fn insert_plugin(&self, plugin: &Plugin, installed: i32) -> Result<(), Box<dyn Error>> {
        let connection = self
            .pool
            .get()
            .expect("Error while creating a pooled connection");
        connection.execute(
            "INSERT INTO plugin (name, author, current_version, plugin_id, description, download_url, info_url, category, latest_version, downloads, archive_name, updated_at, hash, installed)
            VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12, ?13, ?14)
            ON CONFLICT (name)
            DO UPDATE SET name=?1, author=?2, current_version=?3, plugin_id=?4, description=?5, download_url=?6, info_url=?7, category=?8, latest_version=?9, downloads=?10, archive_name=?11, updated_at=?12, hash=?13, installed=?14;",
        params![plugin.name, plugin.author, plugin.current_version, plugin.id.unwrap_or(0), plugin.description.as_ref().unwrap_or(&String::new()), plugin.download_url.as_ref().unwrap_or(&String::new()), plugin.info_url.as_ref().unwrap_or(&String::new()), plugin.category.as_ref().unwrap_or(&String::new()), plugin.latest_version.as_ref().unwrap_or(&String::new()), plugin.downloads.unwrap_or(0), plugin.archive_name.as_ref().unwrap_or(&String::new()), plugin.updated.unwrap_or_default(), plugin.hash.as_deref().unwrap_or_default(), installed])?;

        Ok(())
    }

    pub fn delete_plugin(&self, name: &str) -> Result<(), Box<dyn Error>> {
        let connection = self
            .pool
            .get()
            .expect("Error while creating a pooled connection");
        connection.execute(
            "DELETE FROM plugin WHERE name=?1;",
            params![name.to_string()],
        )?;

        Ok(())
    }

    pub fn get_plugins(&self) -> PluginCollection {
        let mut plugins = HashMap::new();

        let connection = self
            .pool
            .get()
            .expect("Error while creating a pooled connection");
        let mut stmt = connection
            .prepare("SELECT name, author, current_version, plugin_id, description, download_url, info_url, category, latest_version, downloads, archive_name FROM plugin ORDER BY name;")
            .unwrap();

        for element in Cache::execute_stmt(&mut stmt, "") {
            plugins.insert(element.name.clone(), element);
        }

        plugins
    }

    pub fn get_plugin(&self, name: &str) -> Result<Option<PluginDataClass>, Box<dyn Error>> {
        let connection = self
            .pool
            .get()
            .expect("Error while creating a pooled connection");
        let mut stmt = connection
            .prepare("SELECT name, author, current_version, plugin_id, description, download_url, info_url, category, latest_version, downloads, archive_name FROM plugin WHERE name=?1;")
            .unwrap();
        let mut plugin_iter = stmt.query_map([name.to_string()], |row| {
            Ok(PluginDataClass {
                name: row.get(0).unwrap(),
                author: row.get(1).unwrap(),
                version: row.get(2).unwrap(),
                id: Some(row.get(3).unwrap()),
                description: Some(row.get(4).unwrap()),
                download_url: Some(row.get(5).unwrap()),
                info_url: Some(row.get(6).unwrap()),
                category: Some(row.get(7).unwrap()),
                latest_version: Some(row.get(8).unwrap()),
                downloads: Some(row.get(9).unwrap()),
                archive_name: Some(row.get(10).unwrap()),
            })
        })?;

        Ok(plugin_iter.next().transpose()?)
    }

    fn execute_stmt(stmt: &mut Statement, params: &str) -> Vec<PluginDataClass> {
        let mut all_plugins = Vec::new();

        let empty_params = params![];
        let has_params = params![params];
        let mut query_params = empty_params;

        if !params.is_empty() {
            query_params = has_params;
        }

        let plugin_iter = stmt
            .query_map(query_params, |row| {
                Ok(PluginDataClass {
                    name: row.get(0).unwrap(),
                    author: row.get(1).unwrap(),
                    version: row.get(2).unwrap(),
                    id: Some(row.get(3).unwrap()),
                    description: Some(row.get(4).unwrap()),
                    download_url: Some(row.get(5).unwrap()),
                    info_url: Some(row.get(6).unwrap()),
                    category: Some(row.get(7).unwrap()),
                    latest_version: Some(row.get(8).unwrap()),
                    downloads: Some(row.get(9).unwrap()),
                    archive_name: Some(row.get(10).unwrap()),
                })
            })
            .unwrap();

        for plugin in plugin_iter {
            all_plugins.push(plugin.unwrap());
        }

        all_plugins
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use r2d2_sqlite::SqliteConnectionManager;
    use std::{
        env,
        fs::{create_dir_all, remove_dir_all},
        path::PathBuf,
    };
    use uuid::Uuid;

    fn setup() -> (Cache, PathBuf) {
        let uuid = Uuid::new_v4().to_string();
        let test_dir = env::temp_dir().join(format!("lembas_test_{}", &uuid[..7]));
        let db_path = test_dir.join("db.sqlite3");

        create_dir_all(&test_dir).unwrap();

        let manager = SqliteConnectionManager::file(&db_path);
        let pool = r2d2::Pool::new(manager).expect("Error while creating a database pool");

        let cache = Cache::new(pool);
        cache
            .create_cache_db()
            .expect("Failed to create a temporary db");

        (cache, test_dir)
    }

    fn setup_with_items() -> (Cache, PathBuf) {
        let uuid = Uuid::new_v4().to_string();
        let test_dir = env::temp_dir().join(format!("lembas_test_{}", &uuid[..7]));
        let db_path = test_dir.join("db.sqlite3");

        create_dir_all(&test_dir).expect("Error while running test setup");

        let manager = SqliteConnectionManager::file(&db_path);
        let pool = r2d2::Pool::new(manager).expect("Error while creating a database pool");

        let cache = Cache::new(pool);
        cache
            .create_cache_db()
            .expect("Failed to create a temporary db");

        let data_class = Plugin::new("Hello World")
            .with_id(1)
            .with_author("Marius")
            .with_current_version("0.1.0")
            .with_description("Lorem ipsum")
            .build();
        cache
            .insert_plugin(&data_class, 0)
            .expect("Error while running test setup");

        let data_class = Plugin::new("PetStable")
            .with_author("Marius")
            .with_current_version("0.1.0")
            .with_id(2)
            .with_description("Lorem ipsum")
            .with_remote_information("", "1.1", 0, "", 0, "")
            .build();
        cache
            .insert_plugin(&data_class, 1)
            .expect("Error while running test setup");

        (cache, test_dir)
    }

    fn teardown(cache: Cache, test_dir: PathBuf) {
        drop(cache);
        remove_dir_all(test_dir).expect("Error while running test teardown");
    }

    #[test]
    fn insert_plugin() {
        let (cache, test_dir) = setup();

        let data_class = Plugin::new("PetStable")
            .with_id(1)
            .with_author("Marius")
            .with_current_version("0.1.0")
            .with_description("Lorem ipsum")
            .build();
        cache.insert_plugin(&data_class, 0).unwrap();

        teardown(cache, test_dir);
    }

    #[test]
    fn test_delete_plugin() {
        let (cache, test_dir) = setup_with_items();

        cache.delete_plugin("PetStable").unwrap();

        teardown(cache, test_dir);
    }

    #[test]
    fn get_one_plugin() {
        let (cache, test_dir) = setup_with_items();

        let plugin = cache.get_plugin("PetStable").unwrap().unwrap();

        assert_eq!(plugin.name, "PetStable");

        teardown(cache, test_dir);
    }

    #[test]
    fn test_get_plugins() {
        let (cache, test_dir) = setup_with_items();

        let plugins = cache.get_plugins();

        assert_eq!(plugins.keys().len(), 2);
        assert!(plugins.contains_key("PetStable"));
        assert!(plugins.contains_key("Hello World"));

        teardown(cache, test_dir);
    }
}
