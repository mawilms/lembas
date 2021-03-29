use crate::{core::config::Config, gui::main_window::Message};
use iced::{Element, Length};
use rusqlite::NO_PARAMS;
use rusqlite::{params, Connection, Result};
use serde::{Deserialize, Serialize};
use std::{collections::HashMap, path::Path};

#[derive(Debug, Clone, Default)]
pub struct Synchronizer {
    config: Config,
}

impl Synchronizer {
    pub fn new(config: Config) -> Self {
        Self { config }
    }

    pub fn synchronize_plugins(&self) -> Result<(), Box<dyn std::error::Error>> {
        let response = reqwest::blocking::get("http://localhost:8000/plugins")?
            .json::<HashMap<String, Plugin>>()?;
        if Path::new(&self.config.plugins_file).exists() {
        } else {
            self.create_plugins_db();
            self.write_plugins(&response);
        }
        Ok(())
    }

    pub fn create_plugins_db(&self) {
        let conn = Connection::open(&self.config.plugins_file).unwrap();
        conn.execute(
            "
                CREATE TABLE IF NOT EXISTS plugins (
                    id INTEGER PRIMARY KEY,
                    plugin_id INTEGER,
                    title TEXT,
                    current_version TEXT,
                    latest_version TEXT
                );
        ",
            NO_PARAMS,
        )
        .unwrap();
    }

    fn write_plugins(&self, plugins: &HashMap<String, Plugin>) {
        for value in plugins.values() {
            self.insert_plugin(&value);
        }
    }

    fn insert_plugin(&self, plugin: &Plugin) {
        let conn = Connection::open(&self.config.plugins_file).unwrap();
        conn.execute(
            "INSERT INTO plugins (plugin_id, title, current_version, latest_version) VALUES (?1, ?2, ?3, ?4)",
            params![plugin.plugin_id, plugin.title, "", plugin.latest_version],
        )
        .unwrap();
    }

    fn update_plugins(&self, plugins: &HashMap<String, Plugin>) {
        //let plugins = self.read_plugins();
    }

    pub fn get_plugins(&self) -> Vec<Plugin> {
        let mut all_packages: Vec<Plugin> = Vec::new();
        let conn = Connection::open(&self.config.plugins_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, current_version, latest_version FROM plugins;")
            .unwrap();
        let package_iter = stmt
            .query_map(params![], |row| {
                Ok(Plugin {
                    plugin_id: row.get(0).unwrap(),
                    title: row.get(1).unwrap(),
                    current_version: row.get(2).unwrap(),
                    latest_version: row.get(3).unwrap(),
                })
            })
            .unwrap();

        for plugin in package_iter {
            all_packages.push(plugin.unwrap());
        }
        all_packages
    }

    fn get_installed_plugins(&self) -> Vec<Plugin> {
        let mut installed_packages: Vec<Plugin> = Vec::new();
        let conn = Connection::open(&self.config.plugins_file).unwrap();
        let mut stmt = conn
            .prepare("SELECT plugin_id, title, current_version, latest_version FROM plugins WHERE current_version != '';")
            .unwrap();
        let package_iter = stmt
            .query_map(params![], |row| {
                Ok(Plugin {
                    plugin_id: row.get(0).unwrap(),
                    title: row.get(1).unwrap(),
                    current_version: row.get(2).unwrap(),
                    latest_version: row.get(3).unwrap(),
                })
            })
            .unwrap();

        for plugin in package_iter {
            installed_packages.push(plugin.unwrap());
        }
        installed_packages
    }
}

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct Plugin {
    plugin_id: i32,
    title: String,
    #[serde(default)]
    current_version: String,
    latest_version: String,
}

impl Plugin {
    pub fn view(&mut self) -> Element<Message> {
        use iced::{Row, Text};

        Row::new()
            .push(Text::new(&self.title).width(Length::FillPortion(5)))
            .push(Text::new(&self.current_version).width(Length::FillPortion(3)))
            .push(Text::new(&self.latest_version).width(Length::FillPortion(3)))
            .push(Text::new("Update").width(Length::FillPortion(2)))
            .into()
    }
}
