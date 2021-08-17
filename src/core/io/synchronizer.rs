use super::plugin_parser::PluginCompendium;
use crate::core::io::{APIConnector, PluginParser};
use crate::core::{Config, Plugin};
use globset::Glob;
use rusqlite::{params, Connection, Statement};
use std::fs::metadata;
use std::path::MAIN_SEPARATOR;
use std::{collections::HashMap, error::Error, fs::read_dir, path::Path};

#[derive(Default, Debug, Clone)]
pub struct Synchronizer {
    config: Config,
}

impl Synchronizer {
    pub async fn synchronize_application(
        plugins_dir: &str,
        db_file: &str,
    ) -> Result<(), Box<dyn Error>> {
        let local_plugins = Synchronizer::search_local(plugins_dir).unwrap();
        let local_db_plugins = Synchronizer::get_plugins(db_file);

        Synchronizer::compare_local_state(&local_plugins, &local_db_plugins, plugins_dir, db_file)
            .await;

        Ok(())
    }

    pub async fn compare_local_state(
        local_plugins: &HashMap<String, PluginCompendium>,
        db_plugins: &HashMap<String, Plugin>,
        plugins_dir: &str,
        db_file: &str,
    ) {
        for (key, element) in local_plugins {
            if db_plugins.contains_key(key) {
                if let Ok(retrieved_plugin) =
                    APIConnector::fetch_details(db_plugins.get(key).unwrap().plugin_id).await
                {
                    let local_plugin = db_plugins.get(key).unwrap();
                    if local_plugin.latest_version != retrieved_plugin.latest_version {
                        Synchronizer::update_plugin(
                            &local_plugin.title,
                            &retrieved_plugin.latest_version,
                            db_file,
                        )
                        .unwrap();
                    }
                }
            } else if let Ok(retrieved_plugin) =
                APIConnector::fetch_details(local_plugins.get(key).unwrap().id).await
            {
                let mut description = String::new();
                if !&local_plugins
                    .get(key)
                    .unwrap()
                    .plugin_file_location
                    .is_empty()
                {
                    let information = PluginParser::parse_file(
                        Path::new(&plugins_dir).join(
                            &local_plugins
                                .get(key)
                                .unwrap()
                                .plugin_file_location
                                .replace("\\", &MAIN_SEPARATOR.to_string()),
                        ),
                    );
                    description = information.description;
                }

                Synchronizer::insert_plugin(
                    &Plugin::new(
                        retrieved_plugin.plugin_id,
                        &retrieved_plugin.title,
                        &description,
                        &retrieved_plugin.category,
                        &element.version,
                        &retrieved_plugin.latest_version,
                        &retrieved_plugin.folder,
                    ),
                    plugins_dir,
                    db_file,
                )
                .unwrap();
            }
        }

        for (key, element) in db_plugins {
            if !local_plugins.contains_key(key) {
                Synchronizer::delete_plugin(&element.title, db_file).unwrap();
            }
        }
    }

    pub fn search_local(
        plugins_dir: &str,
    ) -> Result<HashMap<String, PluginCompendium>, Box<dyn Error>> {
        let mut local_plugins = HashMap::new();
        let glob = Glob::new("*.plugincompendium")?.compile_matcher();

        for entry in read_dir(Path::new(&plugins_dir))? {
            let direcorty_path = Path::new(&plugins_dir).join(entry.unwrap().path());
            if metadata(&direcorty_path).unwrap().is_dir() {
                let directory = read_dir(&direcorty_path.to_str().unwrap());

                for file in directory? {
                    let path = file?.path();
                    if !path.to_str().unwrap().to_lowercase().contains("loader")
                        && glob.is_match(&path)
                    {
                        let xml_content = PluginParser::parse_compendium_file(&path);
                        local_plugins.insert(xml_content.name.clone(), xml_content);
                    }
                }
            }
        }

        Ok(local_plugins)
    }

    // Creates the local database if it doesn't exist.
    pub fn create_plugins_db(db_file: &str) {
        let conn = Connection::open(db_file).unwrap();
        conn.execute(
            "
                CREATE TABLE IF NOT EXISTS plugin (
                    id INTEGER PRIMARY KEY,
                    plugin_id INTEGER UNIQUE,
                    title TEXT,
                    description TEXT,
                    category TEXT,
                    current_version TEXT,
                    latest_version TEXT,
                    folder_name TEXT
                );
        ",
            [],
        )
        .unwrap();
    }

    pub fn insert_plugin(
        plugin: impl AsRef<Plugin>,
        plugins_dir: &str,
        db_file: &str,
    ) -> Result<(), Box<dyn Error>> {
        let glob = Glob::new("*.plugin")?.compile_matcher();
        let directory = read_dir(Path::new(plugins_dir).join(&plugin.as_ref().folder));

        for file in directory? {
            let path = file?.path();
            if glob.is_match(&path) {
                let xml_content = PluginParser::parse_file(&path);
                if xml_content.name == plugin.as_ref().title {
                    let conn = Connection::open(db_file)?;

                    conn.execute(
                        "INSERT INTO plugin (plugin_id, title, description, category, current_version, latest_version, folder_name) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, description=?3, category=?4, current_version=?5, latest_version=?6, folder_name=?7;",
                        params![plugin.as_ref().plugin_id, plugin.as_ref().title,xml_content.description, plugin.as_ref().category, plugin.as_ref().latest_version, plugin.as_ref().latest_version, plugin.as_ref().folder])?;
                }
            }
        }

        Ok(())
    }

    fn update_plugin(title: &str, version: &str, db_file: &str) -> Result<(), Box<dyn Error>> {
        let conn = Connection::open(db_file)?;
        conn.execute(
            "UPDATE plugin SET latest_version=?2 WHERE title=?1;",
            params![title, version],
        )?;
        Ok(())
    }

    pub fn delete_plugin(title: &str, db_file: &str) -> Result<(), Box<dyn Error>> {
        let conn = Connection::open(db_file)?;
        conn.execute("DELETE FROM plugin WHERE title=?1;", params![title])?;
        Ok(())
    }

    fn execute_stmt(stmt: &mut Statement, params: &str) -> Vec<Plugin> {
        let mut all_plugins = Vec::new();

        let empty_params = params![];
        let has_params = params![params];
        let mut query_params = empty_params;

        if !params.is_empty() {
            query_params = has_params;
        }

        let plugin_iter = stmt
            .query_map(query_params, |row| {
                Ok(Plugin {
                    plugin_id: row.get(0).unwrap(),
                    title: row.get(1).unwrap(),
                    description: row.get(2).unwrap(),
                    category: row.get(3).unwrap(),
                    current_version: row.get(4).unwrap(),
                    latest_version: row.get(5).unwrap(),
                    folder: row.get(6).unwrap(),
                })
            })
            .unwrap();

        for plugin in plugin_iter {
            all_plugins.push(plugin.unwrap());
        }
        all_plugins
    }

    pub fn get_plugins(db_file: &str) -> HashMap<String, Plugin> {
        let mut plugins = HashMap::new();

        let conn = Connection::open(db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, description, category, current_version, latest_version, folder_name FROM plugin ORDER BY title;")
            .unwrap();

        for element in Self::execute_stmt(&mut stmt, "") {
            plugins.insert(element.title.clone(), element);
        }
        plugins
    }
}

#[cfg(test)]
mod tests {
    use super::{Plugin, Synchronizer};
    use std::{
        fs::{create_dir_all, remove_dir_all},
        path::PathBuf,
    };

    #[test]
    fn insert_plugin_succesful() {
        let test_directory = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("tests")
            .join("environment");
        let plugins_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("tests")
            .join("samples");
        let db_file = test_directory.join("db.sqlite3");

        // Setup
        create_dir_all(&test_directory).unwrap();
        Synchronizer::create_plugins_db(test_directory.join("db.sqlite3").to_str().unwrap());

        let plugin = Plugin::new(
            1108,
            "Animalerie",
            "Test",
            "Lore-Master",
            "1.24",
            "1.24",
            "Homeopatix",
        );

        Synchronizer::insert_plugin(
            plugin,
            plugins_dir.to_str().unwrap(),
            db_file.to_str().unwrap(),
        )
        .unwrap();
        let result = Synchronizer::get_plugins(db_file.to_str().unwrap());

        assert_eq!(result.len(), 1);
        assert!(result.contains_key("Animalerie"));

        // Teardown
        remove_dir_all(test_directory).unwrap();
    }

    #[test]
    fn insert_plugin_failure() {
        println!("Bla");
        let test_directory = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("tests")
            .join("environment");
        println!("{:?}", test_directory);
        let plugins_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("tests")
            .join("samples");
        let db_file = test_directory.join("db.sqlite3");

        // Setup
        create_dir_all(&test_directory).unwrap();
        Synchronizer::create_plugins_db(test_directory.join("db.sqlite3").to_str().unwrap());

        let plugin = Plugin::new(
            1108,
            "Hello World",
            "Test",
            "Lore-Master",
            "1.24",
            "1.24",
            "Homeopatix",
        );

        Synchronizer::insert_plugin(
            plugin,
            plugins_dir.to_str().unwrap(),
            db_file.to_str().unwrap(),
        )
        .unwrap();
        let result = Synchronizer::get_plugins(db_file.to_str().unwrap());

        assert_eq!(result.len(), 0);

        // Teardown
        remove_dir_all(test_directory).unwrap();
        println!("Blagjghj");
    }

    #[test]
    fn update() {
        let test_directory = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("tests")
            .join("environment");
        let plugins_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("tests")
            .join("samples");
        let db_file = test_directory.join("db.sqlite3");

        // Setup
        create_dir_all(&test_directory).unwrap();
        Synchronizer::create_plugins_db(test_directory.join("db.sqlite3").to_str().unwrap());

        let plugin = Plugin::new(
            1108,
            "Animalerie",
            "Test",
            "Lore-Master",
            "1.24",
            "1.24",
            "Homeopatix",
        );

        Synchronizer::insert_plugin(
            plugin,
            plugins_dir.to_str().unwrap(),
            db_file.to_str().unwrap(),
        )
        .unwrap();
        Synchronizer::update_plugin("Animalerie", "1.25", db_file.to_str().unwrap()).unwrap();
        let result = Synchronizer::get_plugins(db_file.to_str().unwrap());
        assert_eq!(result.len(), 1);
        assert_eq!(result.get("Animalerie").unwrap().latest_version, "1.25");

        // Teardown
        remove_dir_all(test_directory).unwrap();
    }

    #[test]
    fn delete() {
        let test_directory = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("tests")
            .join("environment");
        let plugins_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
            .join("tests")
            .join("samples");
        let db_file = test_directory.join("db.sqlite3");

        // Setup
        create_dir_all(&test_directory).unwrap();
        Synchronizer::create_plugins_db(test_directory.join("db.sqlite3").to_str().unwrap());

        let plugin = Plugin::new(
            1108,
            "Animalerie",
            "Test",
            "Lore-Master",
            "1.24",
            "1.24",
            "Homeopatix",
        );

        Synchronizer::insert_plugin(
            plugin,
            plugins_dir.to_str().unwrap(),
            db_file.to_str().unwrap(),
        )
        .unwrap();
        Synchronizer::delete_plugin("Animalerie", db_file.to_str().unwrap()).unwrap();
        let result = Synchronizer::get_plugins(db_file.to_str().unwrap());

        assert_eq!(result.len(), 0);

        // Teardown
        remove_dir_all(test_directory).unwrap();
    }
}
