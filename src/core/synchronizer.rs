use crate::core::config::CONFIGURATION;
use crate::core::Plugin;
use rusqlite::{params, Connection};
use std::{collections::HashMap, error::Error, fs::read_dir, path::Path};

// Ordner Name des Plugins speichern für Deinstallation
// Bei Programmstart lokale Plugins abgleichen mit Datenbank
// Remote Datenbank synchronisieren

pub struct Synchronizer {}

impl Synchronizer {
    pub fn search_local() {
        let entries = read_dir(Path::new(&CONFIGURATION.plugins_dir)).unwrap();
        for entry in entries {
            
        }
    }

    // Used to synchronize the local database with the remote plugin server
    #[tokio::main]
    pub async fn update_local_plugins() -> Result<(), Box<dyn Error>> {
        let response = reqwest::get("https://young-hamlet-23901.herokuapp.com/plugins")
            .await?
            .json::<HashMap<String, Plugin>>()
            .await?;
        let mut remote_plugins: Vec<Plugin> = Vec::new();
        for (_, element) in response {
            remote_plugins.push(element);
        }
        let conn = Connection::open(&CONFIGURATION.db_file)?;

        for plugin in remote_plugins {
            let installed_plugin = Synchronizer::get_exact_plugin(&plugin.title);
            if installed_plugin.len() == 1 {
                conn.execute(
                    "INSERT INTO plugins (plugin_id, title, current_version, latest_version) VALUES (?1, ?2, ?3, ?4) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, current_version=?3, latest_version=?4;",
                    params![plugin.plugin_id, plugin.title, installed_plugin[0].current_version, plugin.latest_version])?;
            } else {
                conn.execute(
                    "INSERT INTO plugins (plugin_id, title, current_version, latest_version) VALUES (?1, ?2, ?3, ?4) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, current_version=?3, latest_version=?4;",
                    params![plugin.plugin_id, plugin.title, "", plugin.latest_version])?;
            }
        }

        Ok(())
    }

    // Creates the local database if it doesn't exist.
    pub fn create_plugins_db() {
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        conn.execute(
            "
                CREATE TABLE IF NOT EXISTS plugins (
                    id INTEGER PRIMARY KEY,
                    plugin_id INTEGER UNIQUE,
                    title TEXT,
                    current_version TEXT,
                    latest_version TEXT
                );
        ",
            [],
        )
        .unwrap();
    }

    pub fn insert_plugin(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
        let conn = Connection::open(&CONFIGURATION.db_file)?;
        conn.execute(
                "INSERT INTO plugins (plugin_id, title, current_version, latest_version) VALUES (?1, ?2, ?3, ?4) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, current_version=?3, latest_version=?4;",
                params![plugin.plugin_id, plugin.title, plugin.latest_version, plugin.latest_version])?;

        Ok(())
    }

    pub fn delete_plugin(title: &str) -> Result<(), Box<dyn Error>> {
        let conn = Connection::open(&CONFIGURATION.db_file)?;
        conn.execute("DELETE FROM plugins WHERE title=?1;", params![title])?;
        Ok(())
    }

    pub fn get_plugins() -> Vec<Plugin> {
        let mut all_plugins: Vec<Plugin> = Vec::new();
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, current_version, latest_version FROM plugins;")
            .unwrap();
        let plugin_iter = stmt
            .query_map(params![], |row| {
                Ok(Plugin {
                    plugin_id: row.get(0).unwrap(),
                    title: row.get(1).unwrap(),
                    current_version: row.get(2).unwrap(),
                    latest_version: row.get(3).unwrap(),
                })
            })
            .unwrap();

        for plugin in plugin_iter {
            all_plugins.push(plugin.unwrap());
        }
        all_plugins
    }

    // TODO: Hier nach lokalen Plugins suchen
    pub fn get_installed_plugins() -> Vec<Plugin> {
        let mut installed_plugins: Vec<Plugin> = Vec::new();
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, current_version, latest_version FROM plugins WHERE current_version != '';")
            .unwrap();
        let plugin_iter = stmt
            .query_map(params![], |row| {
                Ok(Plugin {
                    plugin_id: row.get(0).unwrap(),
                    title: row.get(1).unwrap(),
                    current_version: row.get(2).unwrap(),
                    latest_version: row.get(3).unwrap(),
                })
            })
            .unwrap();

        for plugin in plugin_iter {
            installed_plugins.push(plugin.unwrap());
        }
        installed_plugins
    }

    pub fn search_plugin(name: &str) -> Vec<Plugin> {
        let mut installed_plugins: Vec<Plugin> = Vec::new();
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, current_version, latest_version FROM plugins WHERE LOWER(title) LIKE ?1;")
            .unwrap();
        let plugin_iter = stmt
            .query_map(params![format!("%{}%", name.to_lowercase())], |row| {
                Ok(Plugin {
                    plugin_id: row.get(0).unwrap(),
                    title: row.get(1).unwrap(),
                    current_version: row.get(2).unwrap(),
                    latest_version: row.get(3).unwrap(),
                })
            })
            .unwrap();
        for plugin in plugin_iter {
            installed_plugins.push(plugin.unwrap());
        }
        installed_plugins
    }

    pub fn get_exact_plugin(name: &str) -> Vec<Plugin> {
        let mut installed_plugins: Vec<Plugin> = Vec::new();
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, current_version, latest_version FROM plugins WHERE LOWER(title) = ?1")
            .unwrap();
        let plugin_iter = stmt
            .query_map(params![name.to_lowercase()], |row| {
                Ok(Plugin {
                    plugin_id: row.get(0).unwrap(),
                    title: row.get(1).unwrap(),
                    current_version: row.get(2).unwrap(),
                    latest_version: row.get(3).unwrap(),
                })
            })
            .unwrap();
        for plugin in plugin_iter {
            installed_plugins.push(plugin.unwrap());
        }
        installed_plugins
    }
}
