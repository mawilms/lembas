use rusqlite::{params, Connection, Statement};
use std::{collections::HashMap, error::Error};

use crate::core::{PluginCollection, PluginDataClass};

pub fn create_cache_db(db_path: &str) {
    let conn = Connection::open(db_path).unwrap();
    conn.execute(
        "
            CREATE TABLE IF NOT EXISTS plugin (
                id TEXT PRIMARY KEY,
                name TEXT NOT NULL,
                author TEXT NOT NULL,
                current_version TEXT NOT NULL,
                plugin_id INTEGER,
                description TEXT,
                download_url TEXT,
                info_url TEXT,
                category TEXT,
                latest_version TEXT,
                downloads INT,
                archive_name TEXT
            );
    ",
        [],
    )
    .unwrap();
}

pub fn insert_plugin(
    id: u64,
    plugin: &PluginDataClass,
    db_path: &str,
) -> Result<(), Box<dyn Error>> {
    let conn = Connection::open(db_path)?;

    conn.execute(
        "INSERT INTO plugin (id, name, author, current_version, plugin_id, description, download_url, info_url, category, latest_version, downloads, archive_name) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7, ?8, ?9, ?10, ?11, ?12) ON CONFLICT (id) DO UPDATE SET id=?1, name=?2, author=?3, current_version=?4, plugin_id=?5, description=?6, download_url=?7, info_url=?8, category=?9, latest_version=?10, downloads=?11, archive_name=?12;",
    params![format!("{}",id), plugin.name, plugin.author, plugin.version, plugin.id.unwrap_or(0), plugin.description.as_ref().unwrap_or(&String::new()), plugin.download_url.as_ref().unwrap_or(&String::new()), plugin.info_url.as_ref().unwrap_or(&String::new()), plugin.category.as_ref().unwrap_or(&String::new()), plugin.latest_version.as_ref().unwrap_or(&String::new()), plugin.downloads.unwrap_or(0), plugin.archive_name.as_ref().unwrap_or(&String::new())])?;

    Ok(())
}

pub fn update_plugin(id: u64, version: &str, db_path: &str) -> Result<(), Box<dyn Error>> {
    let conn = Connection::open(db_path)?;
    conn.execute(
        "UPDATE plugin SET latest_version=?2 WHERE id=?1;",
        params![format!("{}", id), version],
    )?;
    Ok(())
}

pub fn get_plugin(id: u64, db_path: &str) -> Option<PluginDataClass> {
    let conn = Connection::open(db_path).unwrap();
    let mut stmt = conn
        .prepare("SELECT id, name, author, current_version, plugin_id, description, download_url, info_url, category, latest_version, downloads, archive_name FROM plugin WHERE id=?1;")
        .unwrap();
    let mut plugin_iter = stmt
        .query_map([format!("{}", id)], |row| {
            Ok(PluginDataClass {
                name: row.get(1).unwrap(),
                author: row.get(2).unwrap(),
                version: row.get(3).unwrap(),
                id: Some(row.get(4).unwrap()),
                description: Some(row.get(5).unwrap()),
                download_url: Some(row.get(6).unwrap()),
                info_url: Some(row.get(7).unwrap()),
                category: Some(row.get(8).unwrap()),
                latest_version: Some(row.get(9).unwrap()),
                downloads: Some(row.get(10).unwrap()),
                archive_name: Some(row.get(11).unwrap()),
            })
        })
        .unwrap();

    plugin_iter.next().transpose().unwrap()
}

pub fn delete_plugin(id: u64, db_path: &str) -> Result<(), Box<dyn Error>> {
    let conn = Connection::open(db_path)?;
    conn.execute(
        "DELETE FROM plugin WHERE id=?1;",
        params![format!("{}", id)],
    )?;
    Ok(())
}

pub fn get_plugins(db_path: &str) -> PluginCollection {
    let mut plugins = HashMap::new();

    let conn = Connection::open(db_path).unwrap();
    let mut stmt = conn
        .prepare("SELECT id, name, author, current_version, plugin_id, description, download_url, info_url, category, latest_version, downloads, archive_name FROM plugin ORDER BY name;")
        .unwrap();

    for element in execute_stmt(&mut stmt, "") {
        plugins.insert(PluginDataClass::calculate_hash(&element), element);
    }
    plugins
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
                name: row.get(1).unwrap(),
                author: row.get(2).unwrap(),
                version: row.get(3).unwrap(),
                id: Some(row.get(4).unwrap()),
                description: Some(row.get(5).unwrap()),
                download_url: Some(row.get(6).unwrap()),
                info_url: Some(row.get(7).unwrap()),
                category: Some(row.get(8).unwrap()),
                latest_version: Some(row.get(9).unwrap()),
                downloads: Some(row.get(10).unwrap()),
                archive_name: Some(row.get(11).unwrap()),
            })
        })
        .unwrap();

    for plugin in plugin_iter {
        all_plugins.push(plugin.unwrap());
    }
    all_plugins
}

#[cfg(test)]
mod tests {
    use crate::core::PluginDataClass;

    use super::{
        create_cache_db, delete_plugin, get_plugin, get_plugins, insert_plugin, update_plugin,
    };
    use std::{
        env,
        fs::{create_dir_all, remove_dir_all},
        path::PathBuf,
    };
    use uuid::Uuid;

    type TemporaryPaths = (PathBuf, String);

    fn setup() -> TemporaryPaths {
        let uuid = Uuid::new_v4().to_string();
        let test_dir = env::temp_dir().join(format!("lembas_test_{}", &uuid[..7]));
        let db_path = test_dir.join("db.sqlite3");

        create_dir_all(&test_dir).unwrap();
        create_cache_db(db_path.to_str().unwrap());

        (test_dir, db_path.to_str().unwrap().to_string())
    }

    fn setup_with_items() -> TemporaryPaths {
        let uuid = Uuid::new_v4().to_string();
        let test_dir = env::temp_dir().join(format!("lembas_test_{}", &uuid[..7]));
        let db_path = test_dir.join("db.sqlite3");

        create_dir_all(&test_dir).expect("Error while running test setup");
        create_cache_db(db_path.to_str().expect("Error while running test setup"));

        let data_class = PluginDataClass::new("Hello World", "Marius", "0.1.0")
            .with_id(1)
            .with_description("Lorem ipsum")
            .build();
        insert_plugin(
            PluginDataClass::calculate_hash(&data_class),
            &data_class,
            db_path.to_str().unwrap(),
        )
        .expect("Error while running test setup");

        let data_class = PluginDataClass::new("PetStable", "Marius", "1.0")
            .with_id(2)
            .with_description("Lorem ipsum")
            .with_remote_information("", "1.1", 0, "")
            .build();
        insert_plugin(
            PluginDataClass::calculate_hash(&data_class),
            &data_class,
            db_path.to_str().unwrap(),
        )
        .expect("Error while running test setup");

        (test_dir, db_path.to_str().unwrap().to_string())
    }

    fn teardown(test_dir: PathBuf) {
        remove_dir_all(test_dir).expect("Error while running test teardown");
    }

    #[test]
    fn test_insert_plugin() {
        let (test_dir, db_path) = setup();

        let data_class = PluginDataClass::new("PetStable", "Marius", "1.0")
            .with_id(1)
            .with_description("Lorem ipsum")
            .build();
        insert_plugin(
            PluginDataClass::calculate_hash(&data_class),
            &data_class,
            &db_path,
        )
        .unwrap();

        teardown(test_dir);
    }

    #[test]
    fn get_one_plugin() {
        let (test_dir, db_path) = setup_with_items();

        let plugin = get_plugin(17_418_645_804_149_917_555, &db_path).unwrap();

        assert_eq!(plugin.name, "Hello World");

        teardown(test_dir);
    }

    #[test]
    fn test_update_plugin() {
        let (test_dir, db_path) = setup_with_items();

        update_plugin(17_418_645_804_149_917_555, "1.1", &db_path).unwrap();

        teardown(test_dir);
    }

    #[test]
    fn test_delete_plugin() {
        let (test_dir, db_path) = setup_with_items();

        delete_plugin(17_418_645_804_149_917_555, &db_path).unwrap();

        teardown(test_dir);
    }

    #[test]
    fn test_get_plugins() {
        let (test_dir, db_path) = setup_with_items();

        let plugins = get_plugins(&db_path);

        assert_eq!(plugins.keys().len(), 2);
        assert!(plugins.contains_key(&17_418_645_804_149_917_555));
        assert!(plugins.contains_key(&12_652_764_195_116_899_398));

        teardown(test_dir);
    }
}
