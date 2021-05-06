use super::plugin_parser::Information;
use crate::core::config::CONFIGURATION;
use crate::core::{Plugin, PluginParser};
use globset::Glob;
use rusqlite::{params, Connection, Statement};
use std::{
    collections::{HashMap, HashSet},
    error::Error,
    fs::read_dir,
    path::Path,
};

// TODO: Aktuell womöglich noch ein Bug wegen des Plugin Namens. Es könnte eine Diskrepanz zwischen dem .plugin name und dem db name bestehen

pub struct Synchronizer {}

impl Synchronizer {
    #[tokio::main]
    pub async fn synchronize_application() -> Result<(), Box<dyn Error>> {
        let local_plugins = Self::search_local().unwrap();
        let local_db_plugins = Self::get_installed_plugins();
        //Compare to local db plugins
        Self::compare_local_state(&local_plugins, &local_db_plugins);

        Ok(())
    }

    fn compare_local_state(
        local_plugins: &HashMap<String, Information>,
        db_plugins: &HashMap<String, Plugin>,
    ) {
        for (key, element) in local_plugins {
            if !db_plugins.contains_key(key) {
                let retrieved_plugin = Self::get_exact_plugin(&element.name);
                if !retrieved_plugin.is_empty() {
                    Self::insert_plugin(&Plugin::new(
                        retrieved_plugin[0].plugin_id,
                        &retrieved_plugin[0].title,
                        &element.description,
                        &element.version,
                        &retrieved_plugin[0].latest_version,
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

        for entry in read_dir(Path::new(&CONFIGURATION.plugins_dir))? {
            let directory = read_dir(
                Path::new(&CONFIGURATION.plugins_dir)
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

    pub async fn fetch_plugins() -> Result<HashSet<String, Plugin>, Box<dyn Error>> {
        let response = reqwest::get("https://young-hamlet-23901.herokuapp.com/plugins")
            .await?
            .json::<HashSet<String, Plugin>>()
            .await?;

        Ok(response)
    }

    // Used to synchronize the local database with the remote plugin server
    #[tokio::main]
    pub async fn update_local_plugins() -> Result<(), ()> {
        if let Ok(fetched_plugins) = Self::fetch_plugins().await {
            let conn = Connection::open(&CONFIGURATION.db_file).unwrap();

            for (_, plugin) in fetched_plugins {
                let installed_plugin = Synchronizer::get_exact_plugin(&plugin.title);
                if installed_plugin.is_empty() {
                    conn.execute(
                        "INSERT INTO plugins (plugin_id, title, description, current_version, latest_version) VALUES (?1, ?2, ?3, ?4, ?5) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, description=?3, current_version=?4, latest_version=?5;",
                        params![plugin.plugin_id, plugin.title, "", "", plugin.latest_version]).unwrap();
                } else {
                    conn.execute(
                        "INSERT INTO plugins (plugin_id, title, description,current_version, latest_version) VALUES (?1, ?2, ?3, ?4, ?5) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, description=?3, current_version=?4, latest_version=?5;",
                        params![plugin.plugin_id, plugin.title, plugin.description, installed_plugin[0].current_version, plugin.latest_version]).unwrap();
                }
            }
            Ok(())
        } else {
            Err(())
        }
    }

    // Creates the local database if it doesn't exist.
    pub fn create_plugins_db() {
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        conn.execute(
            "
                CREATE TABLE IF NOT EXISTS plugin (
                    id INTEGER PRIMARY KEY,
                    plugin_id INTEGER UNIQUE,
                    title TEXT,
                    description TEXT,
                    current_version TEXT,
                    latest_version TEXT,
                    folder_name TEXT
                );
        ",
            [],
        )
        .unwrap();

        conn.execute(
            "
                CREATE TABLE IF NOT EXISTS file (
                    id INTEGER PRIMARY KEY,
                    name INTEGER UNIQUE,
                    CONSTRAINT fk_plugin_file
                      FOREIGN KEY (fk_plugin_id)
                        REFERENCES plugin (plugin_id)
                );
        ",
            [],
        )
        .unwrap();
    }

    pub fn insert_plugin(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
        let conn = Connection::open(&CONFIGURATION.db_file)?;
        conn.execute(
                "INSERT INTO plugins (plugin_id, title, description, current_version, latest_version) VALUES (?1, ?2, ?3, ?4, ?5) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, description=?3, current_version=?4, latest_version=?5;",
                params![plugin.plugin_id, plugin.title, plugin.description, plugin.latest_version, plugin.latest_version])?;

        Ok(())
    }

    pub fn delete_plugin(title: &str) -> Result<(), Box<dyn Error>> {
        let conn = Connection::open(&CONFIGURATION.db_file)?;
        conn.execute("DELETE FROM plugins WHERE title=?1;", params![title])?;
        Ok(())
    }

    fn execute_stmt(stmt: &mut Statement, params: &str) -> Vec<Plugin> {
        let mut all_plugins: Vec<Plugin> = Vec::new();

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
                    current_version: row.get(3).unwrap(),
                    latest_version: row.get(4).unwrap(),
                })
            })
            .unwrap();
        for plugin in plugin_iter {
            all_plugins.push(plugin.unwrap());
        }
        all_plugins
    }

    pub fn get_plugins() -> Vec<Plugin> {
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, description, current_version, latest_version FROM plugins ORDER BY title ASC;")
            .unwrap();

        Self::execute_stmt(&mut stmt, "")
    }

    pub fn get_installed_plugins() -> HashMap<String, Plugin> {
        let mut plugins = HashMap::new();

        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, description, current_version, latest_version FROM plugins WHERE current_version != '' ORDER BY title;")
            .unwrap();

        for element in Self::execute_stmt(&mut stmt, "") {
            plugins.insert(element.title.clone(), element);
        }
        plugins
    }

    pub fn search_plugin(name: &str) -> Vec<Plugin> {
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, description, current_version, latest_version FROM plugins WHERE LOWER(title) LIKE ?1;")
            .unwrap();

        Self::execute_stmt(&mut stmt, &format!("%{}%", name.to_lowercase()))
    }

    pub fn get_exact_plugin(name: &str) -> Vec<Plugin> {
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, description, current_version, latest_version FROM plugins WHERE LOWER(title) = ?1")
            .unwrap();

        Self::execute_stmt(&mut stmt, &name.to_lowercase())
    }
}
