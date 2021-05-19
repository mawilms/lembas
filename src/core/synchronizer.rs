use super::plugin_parser::Information;
use crate::core::config::CONFIGURATION;
use crate::core::{
    Base as BasePlugin, Installed as InstalledPlugin, Plugin as DetailsPlugin, PluginParser,
};
use globset::Glob;
use rusqlite::{params, Connection, Statement};
use serde::{Deserialize, Serialize};
use std::{collections::HashMap, error::Error, fs::read_dir, path::Path};

pub struct Synchronizer {}

impl Synchronizer {
    pub async fn synchronize_application() -> Result<(), Box<dyn Error>> {
        let local_plugins = Self::search_local().unwrap();
        let local_db_plugins = Self::get_plugins();

        Self::compare_local_state(&local_plugins, &local_db_plugins);

        Ok(())
    }

    fn compare_local_state(
        local_plugins: &HashMap<String, Information>,
        db_plugins: &HashMap<String, InstalledPlugin>,
    ) {
        for (key, element) in local_plugins {
            if !db_plugins.contains_key(key) {
                let retrieved_plugin = Self::get_plugin(&element.name);
                if !retrieved_plugin.is_empty() {
                    Self::insert_plugin(&InstalledPlugin::new(
                        retrieved_plugin[0].plugin_id,
                        &retrieved_plugin[0].title,
                        &element.description,
                        &retrieved_plugin[0].category,
                        &element.version,
                        &retrieved_plugin[0].latest_version,
                        &retrieved_plugin[0].folder,
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

        for entry in read_dir(Path::new(&CONFIGURATION.lock().unwrap().plugins_dir))? {
            let directory = read_dir(
                Path::new(&CONFIGURATION.lock().unwrap().plugins_dir)
                    .join(entry.unwrap().path())
                    .to_str()
                    .unwrap(),
            );

            for file in directory? {
                let path = file?.path();
                if glob.is_match(&path) {
                    let xml_content = PluginParser::parse_file(&path);
                    local_plugins.insert(xml_content.name.clone(), xml_content);
                }
            }
        }
        Ok(local_plugins)
    }

    pub async fn fetch_plugins(
    ) -> Result<HashMap<String, BasePlugin>, crate::core::synchronizer::APIError> {
        match reqwest::get("https://young-hamlet-23901.herokuapp.com/plugins").await {
            Ok(response) => match response.json::<HashMap<String, BasePlugin>>().await {
                Ok(plugins) => Ok(plugins),
                Err(_) => Err(APIError::FetchError),
            },
            Err(_) => Err(APIError::FetchError),
        }
    }

    pub fn fetch_plugin_details(title: &str) -> DetailsPlugin {
        let response = reqwest::blocking::get(format!(
            "https://young-hamlet-23901.herokuapp.com/plugins/{}",
            title.to_lowercase()
        ))
        .expect("Failed to connect with API")
        .json::<JSONResponse>()
        .expect("Failed to parse response");

        DetailsPlugin::new(
            response.plugin_id,
            &response.title,
            "",
            &response.category,
            &response.current_version,
            &response.latest_version,
            &response.folders,
            &response.files,
        )
    }

    // Used to synchronize the local database with the remote plugin server
    pub async fn update_local_plugins() -> Result<(), ()> {
        let fetched_plugins = Self::fetch_plugins().await;
        let conn = Connection::open(&CONFIGURATION.lock().unwrap().db_file).unwrap();

        if fetched_plugins.is_ok() {
            for (_, plugin) in fetched_plugins.unwrap() {
                let installed_plugin = Synchronizer::get_plugin(&plugin.title);
                if !installed_plugin.is_empty()
                    && installed_plugin[0].latest_version != plugin.latest_version
                {
                    conn.execute("UPDATE plugin SET current_version = ?1, latest_version = ?2 WHERE plugin_id = ?3", params![installed_plugin[0].description, plugin.latest_version, plugin.plugin_id]).unwrap();
                }
            }
        }
        Ok(())
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

    pub fn get_plugin(name: &str) -> Vec<InstalledPlugin> {
        let conn = Connection::open(&CONFIGURATION.lock().unwrap().db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, description, category, current_version, latest_version, folder_name FROM plugin WHERE LOWER(title) = ?1")
            .unwrap();

        Self::execute_stmt(&mut stmt, &name.to_lowercase())
    }
}

#[derive(Default, Serialize, Deserialize, Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
struct JSONResponse {
    pub plugin_id: i32,
    pub title: String,
    #[serde(default)]
    pub description: String,
    pub category: String,
    #[serde(default)]
    pub current_version: String,
    pub latest_version: String,
    pub folders: String,
    pub files: Vec<String>,
}

#[derive(Debug, Clone)]
pub enum APIError {
    FetchError,
}
