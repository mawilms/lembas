use super::api_connector::APIOperations;
use super::plugin_parser::Information;
use crate::core::config::CONFIGURATION;
use crate::core::{APIConnector, Installed as InstalledPlugin, PluginParser};
use globset::Glob;
use rusqlite::{params, Connection, Statement};
use std::fs::metadata;
use std::{collections::HashMap, error::Error, fs::read_dir, path::Path};

pub struct Synchronizer {}

impl Synchronizer {
    pub async fn synchronize_application() -> Result<(), Box<dyn Error>> {
        let local_plugins = Self::search_local().unwrap();
        let local_db_plugins = Self::get_plugins();

        Self::compare_local_state(&local_plugins, &local_db_plugins).await;

        Ok(())
    }

    pub async fn compare_local_state(
        local_plugins: &HashMap<String, Information>,
        db_plugins: &HashMap<String, InstalledPlugin>,
    ) {
        for (key, element) in local_plugins {
            if let Ok(retrieved_plugin) = APIConnector::fetch_details(element.name.clone()).await {
                if db_plugins.contains_key(key) {
                    let local_plugin = db_plugins.get(key).unwrap();
                    if local_plugin.latest_version != retrieved_plugin.base_plugin.latest_version {
                        Self::update_plugin(
                            &local_plugin.title,
                            &retrieved_plugin.base_plugin.latest_version,
                        )
                        .unwrap();
                    }
                } else {
                    Self::insert_plugin(&InstalledPlugin::new(
                        retrieved_plugin.base_plugin.plugin_id,
                        &retrieved_plugin.base_plugin.title,
                        &element.description,
                        &retrieved_plugin.base_plugin.category,
                        &element.version,
                        &retrieved_plugin.base_plugin.latest_version,
                        &retrieved_plugin.base_plugin.folder,
                    ))
                    .unwrap();
                }
            }
        }

        for (key, element) in db_plugins {
            if !local_plugins.contains_key(key) {
                Self::delete_plugin(&element.title).unwrap();
            }
        }
    }

    pub fn search_local() -> Result<HashMap<String, Information>, Box<dyn Error>> {
        let mut local_plugins = HashMap::new();
        let glob = Glob::new("*.plugin")?.compile_matcher();
        let plugins_dir = &CONFIGURATION.lock().unwrap().plugins_dir;

        for entry in read_dir(Path::new(plugins_dir))? {
            let direcorty_path = Path::new(plugins_dir).join(entry.unwrap().path());
            if metadata(&direcorty_path).unwrap().is_dir() {
                let directory = read_dir(&direcorty_path.to_str().unwrap());

                for file in directory? {
                    let path = file?.path();
                    if !path.to_str().unwrap().to_lowercase().contains("loader")
                        && glob.is_match(&path)
                    {
                        let xml_content = PluginParser::parse_file(&path);
                        local_plugins.insert(xml_content.name.clone(), xml_content);
                    }
                }
            }
        }

        Ok(local_plugins)
    }

    // Creates the local database if it doesn't exist.
    pub fn create_plugins_db() {
        let conn = Connection::open(&CONFIGURATION.lock().unwrap().db_file).unwrap();
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

    pub fn insert_plugin(plugin: impl AsRef<InstalledPlugin>) -> Result<(), Box<dyn Error>> {
        let glob = Glob::new("*.plugin")?.compile_matcher();
        let directory = read_dir(
            Path::new(&CONFIGURATION.lock().unwrap().plugins_dir).join(&plugin.as_ref().folder),
        );

        for file in directory? {
            let path = file?.path();
            if glob.is_match(&path) {
                let xml_content = PluginParser::parse_file(&path);
                let conn = Connection::open(&CONFIGURATION.lock().unwrap().db_file)?;
                conn.execute(
                "INSERT INTO plugin (plugin_id, title, description, category, current_version, latest_version, folder_name) VALUES (?1, ?2, ?3, ?4, ?5, ?6, ?7) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, description=?3, category=?4, current_version=?5, latest_version=?6, folder_name=?7;",
                params![plugin.as_ref().plugin_id, plugin.as_ref().title, &xml_content.description, plugin.as_ref().category, plugin.as_ref().latest_version, plugin.as_ref().latest_version, plugin.as_ref().folder])?;
            }
        }

        Ok(())
    }

    fn update_plugin(title: &str, version: &str) -> Result<(), Box<dyn Error>> {
        let conn = Connection::open(&CONFIGURATION.lock().unwrap().db_file)?;
        conn.execute(
            "UPDATE plugin SET latest_version=?2 WHERE title=?1;",
            params![title, version],
        )?;
        Ok(())
    }

    pub fn delete_plugin(title: &str) -> Result<(), Box<dyn Error>> {
        let conn = Connection::open(&CONFIGURATION.lock().unwrap().db_file)?;
        conn.execute("DELETE FROM plugin WHERE title=?1;", params![title])?;
        Ok(())
    }

    fn execute_stmt(stmt: &mut Statement, params: &str) -> Vec<InstalledPlugin> {
        let mut all_plugins = Vec::new();

        let empty_params = params![];
        let has_params = params![params];
        let mut query_params = empty_params;

        if !params.is_empty() {
            query_params = has_params;
        }

        let plugin_iter = stmt
            .query_map(query_params, |row| {
                Ok(InstalledPlugin {
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

    pub fn get_plugins() -> HashMap<String, InstalledPlugin> {
        let mut plugins = HashMap::new();

        let conn = Connection::open(&CONFIGURATION.lock().unwrap().db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, description, category, current_version, latest_version, folder_name FROM plugin ORDER BY title;")
            .unwrap();

        for element in Self::execute_stmt(&mut stmt, "") {
            plugins.insert(element.title.clone(), element);
        }
        plugins
    }
}
