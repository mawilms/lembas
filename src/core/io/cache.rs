use rusqlite::{params, Connection, Statement};
use std::{collections::HashMap, error::Error};

#[derive(Debug, Clone)]
pub struct Item {
    pub id: i32,
    pub title: String,
    pub description: String,
    pub current_version: String,
    pub latest_version: String,
    pub download_url: String,
}

impl Item {
    pub fn new(
        id: i32,
        title: &str,
        description: &str,
        current_version: &str,
        latest_version: &str,
        download_url: &str,
    ) -> Self {
        Item {
            id,
            title: title.to_string(),
            description: description.to_string(),
            current_version: current_version.to_string(),
            latest_version: latest_version.to_string(),
            download_url: download_url.to_string(),
        }
    }
}

pub fn create_cache_db(db_file: &str) {
    let conn = Connection::open(db_file).unwrap();
    conn.execute(
        "
            CREATE TABLE IF NOT EXISTS plugin (
                id INTEGER PRIMARY KEY,
                plugin_id INTEGER UNIQUE,
                title TEXT,
                description TEXT,
                current_version TEXT,
                latest_version TEXT,
                download_url TEXT
            );
    ",
        [],
    )
    .unwrap();
}

pub fn insert_plugin(cache_item: &Item, db_file: &str) -> Result<(), Box<dyn Error>> {
    let conn = Connection::open(db_file)?;

    conn.execute(
        "INSERT INTO plugin (plugin_id, title, description, current_version, latest_version, download_url) VALUES (?1, ?2, ?3, ?4, ?5, ?6) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, description=?3, current_version=?4, latest_version=?5, download_url=?6;",
    params![cache_item.id, cache_item.title, cache_item.description, cache_item.current_version, cache_item.latest_version, cache_item.download_url])?;

    Ok(())
}

pub fn update_plugin(plugin_id: i32, version: &str, db_file: &str) -> Result<(), Box<dyn Error>> {
    let conn = Connection::open(db_file)?;
    conn.execute(
        "UPDATE plugin SET latest_version=?2 WHERE plugin_id=?1;",
        params![plugin_id, version],
    )?;
    Ok(())
}

pub fn delete_plugin(plugin_id: i32, db_file: &str) -> Result<(), Box<dyn Error>> {
    let conn = Connection::open(db_file)?;
    conn.execute("DELETE FROM plugin WHERE plugin_id=?1;", params![plugin_id])?;
    Ok(())
}

pub fn get_plugins(db_file: &str) -> HashMap<String, Item> {
    let mut plugins = HashMap::new();

    let conn = Connection::open(db_file).unwrap();
    let mut stmt = conn
        .prepare("SELECT plugin_id, title, description, current_version, latest_version, download_url FROM plugin ORDER BY title;")
        .unwrap();

    for element in execute_stmt(&mut stmt, "") {
        plugins.insert(element.title.clone(), element);
    }
    plugins
}

fn execute_stmt(stmt: &mut Statement, params: &str) -> Vec<Item> {
    let mut all_plugins = Vec::new();

    let empty_params = params![];
    let has_params = params![params];
    let mut query_params = empty_params;

    if !params.is_empty() {
        query_params = has_params;
    }

    let plugin_iter = stmt
        .query_map(query_params, |row| {
            Ok(Item {
                id: row.get(0).unwrap(),
                title: row.get(1).unwrap(),
                description: row.get(2).unwrap(),
                current_version: row.get(3).unwrap(),
                latest_version: row.get(4).unwrap(),
                download_url: row.get(5).unwrap(),
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
    use super::{create_cache_db, delete_plugin, get_plugins, insert_plugin, update_plugin, Item};
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
        create_cache_db(db_path.clone().to_str().unwrap());

        (test_dir, db_path.to_str().unwrap().to_string())
    }

    fn setup_with_items() -> TemporaryPaths {
        let uuid = Uuid::new_v4().to_string();
        let test_dir = env::temp_dir().join(format!("lembas_test_{}", &uuid[..7]));
        let db_path = test_dir.join("db.sqlite3");

        create_dir_all(&test_dir).expect("Error while running test setup");
        create_cache_db(
            db_path
                .clone()
                .to_str()
                .expect("Error while running test setup"),
        );

        let item = Item::new(1, "TitanBars", "Lorem ipsum", "1.0", "1.1", "example.com");
        insert_plugin(&item, &db_path.to_str().unwrap()).expect("Error while running test setup");
        let item = Item::new(2, "PetStable", "Lorem ipsum", "1.1", "1.1", "example.com");
        insert_plugin(&item, &db_path.to_str().unwrap()).expect("Error while running test setup");

        (test_dir, db_path.to_str().unwrap().to_string())
    }

    fn teardown(test_dir: PathBuf) {
        remove_dir_all(test_dir).expect("Error while running test teardown");
    }

    #[test]
    fn test_insert_plugin() {
        let (test_dir, db_path) = setup();

        let item = Item::new(1, "TitanBars", "Lorem ipsum", "1.0", "1.1", "example.com");
        insert_plugin(&item, &db_path).unwrap();

        teardown(test_dir);
    }

    #[test]
    fn test_update_plugin() {
        let (test_dir, db_path) = setup_with_items();

        update_plugin(1, "1.1", &db_path).unwrap();

        teardown(test_dir);
    }

    #[test]
    fn test_delete_plugin() {
        let (test_dir, db_path) = setup_with_items();

        delete_plugin(1, &db_path).unwrap();

        teardown(test_dir);
    }

    #[test]
    fn test_get_plugins() {
        let (test_dir, db_path) = setup_with_items();

        let plugins = get_plugins(&db_path);

        assert_eq!(plugins.keys().len(), 2);
        assert!(plugins.contains_key("TitanBars"));
        assert!(plugins.contains_key("PetStable"));

        teardown(test_dir);
    }
}
