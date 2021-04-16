use crate::core::config::CONFIGURATION;
use crate::core::{Plugin, PluginParser};
use globset::Glob;
use rusqlite::{params, Connection};
use std::{
    collections::{HashMap, HashSet},
    error::Error,
    fs::read_dir,
    path::Path,
};

// Ordner Name des Plugins speichern für Deinstallation
// Bei Programmstart lokale Plugins abgleichen mit Datenbank
// Remote Datenbank synchronisieren

pub struct Synchronizer {}

impl Synchronizer {
    pub async fn synchronize_application() -> Result<(), Box<dyn Error>> {
        let local_plugins = Self::search_local().await?;
        let local_db_plugins = Self::get_installed_plugins();
        //Compare to local db plugins
        Self::compare_local_state(&local_plugins, &local_db_plugins);

        Ok(())
    }
    pub fn compare_local_state(local_plugins: &HashSet<Plugin>, db_plugins: &HashSet<Plugin>) {
        for element in local_plugins {
            if !db_plugins.contains(&element) {
                Self::insert_plugin(&element);
            }
        }

        for element in db_plugins {
            if !local_plugins.contains(&element) {
                Self::delete_plugin(&element.title);
            }
        }
    }

    pub async fn search_local() -> Result<HashSet<Plugin>, Box<dyn Error>> {
        let mut local_plugins = HashSet::new();
        let glob = Glob::new("*.plugin")?.compile_matcher();

        for entry in read_dir(Path::new(&CONFIGURATION.plugins_dir))? {
            let directory = read_dir(
                Path::new(&CONFIGURATION.plugins_dir)
                    .join(entry.unwrap().path())
                    .to_str()
                    .unwrap(),
            );

            for file in directory? {
                let test = file?.path().clone();
                let bla = test.clone();
                if glob.is_match(test) {
                    let xml_content = PluginParser::parse_file(bla);
                    let retrieved_plugin =
                        Self::get_remote_exact_plugin(&xml_content.information.name).await;
                    local_plugins.insert(Plugin::new(
                        retrieved_plugin.plugin_id,
                        &retrieved_plugin.title.to_string(),
                        &xml_content.information.description.to_string(),
                        &xml_content.information.version.to_string(),
                        &retrieved_plugin.latest_version.to_string(),
                    ));
                }
            }
        }
        Ok(local_plugins)
    }

    pub async fn fetch_plugins() -> Result<HashSet<Plugin>, Box<dyn Error>> {
        let response = reqwest::get("https://young-hamlet-23901.herokuapp.com/plugins")
            .await?
            .json::<HashSet<Plugin>>()
            .await?;

        Ok(response)
    }

    // Used to synchronize the local database with the remote plugin server
    #[tokio::main]
    pub async fn update_local_plugins() -> Result<(), ()> {
        if let Ok(fetched_plugins) = Self::fetch_plugins().await {
            let conn = Connection::open(&CONFIGURATION.db_file).unwrap();

            for plugin in fetched_plugins {
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
            println!("Kein Verbindung zum Server");

            Err(())
        }
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
                    description TEXT,
                    current_version TEXT,
                    latest_version TEXT
                );
        ",
            [],
        )
        .unwrap();
    }

    pub fn insert_plugin(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
        println!("hallo");
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

    pub fn get_plugins() -> Vec<Plugin> {
        let mut all_plugins: Vec<Plugin> = Vec::new();
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, description, current_version, latest_version FROM plugins;")
            .unwrap();
        let plugin_iter = stmt
            .query_map(params![], |row| {
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

    // TODO: Hier nach lokalen Plugins suchen
    pub fn get_installed_plugins() -> HashSet<Plugin> {
        let mut installed_plugins = HashSet::new();
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, description, current_version, latest_version FROM plugins WHERE current_version != '';")
            .unwrap();

        let plugin_iter = stmt
            .query_map(params![], |row| {
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
            installed_plugins.insert(plugin.unwrap());
        }
        installed_plugins
    }

    pub fn search_plugin(name: &str) -> Vec<Plugin> {
        let mut installed_plugins: Vec<Plugin> = Vec::new();
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, description, current_version, latest_version FROM plugins WHERE LOWER(title) LIKE ?1;")
            .unwrap();
        let plugin_iter = stmt
            .query_map(params![format!("%{}%", name.to_lowercase())], |row| {
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
            installed_plugins.push(plugin.unwrap());
        }
        installed_plugins
    }

    pub fn get_exact_plugin(name: &str) -> Vec<Plugin> {
        let mut installed_plugins: Vec<Plugin> = Vec::new();
        let conn = Connection::open(&CONFIGURATION.db_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, description, current_version, latest_version FROM plugins WHERE LOWER(title) = ?1")
            .unwrap();
        let plugin_iter = stmt
            .query_map(params![name.to_lowercase()], |row| {
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
            installed_plugins.push(plugin.unwrap());
        }
        installed_plugins
    }

    pub async fn get_remote_exact_plugin(name: &str) -> Plugin {
        let response = reqwest::get(format!(
            "https://young-hamlet-23901.herokuapp.com/plugins/{}",
            name
        ))
        .await
        .unwrap()
        .json::<HashMap<String, Plugin>>()
        .await
        .unwrap();
        let mut plugins: Vec<Plugin> = Vec::new();
        for (_, element) in response {
            plugins.push(element);
        }
        plugins[0].clone()
    }
}
