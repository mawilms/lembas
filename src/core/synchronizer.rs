use crate::gui::style;
use crate::{core::config::Config, gui::main_window::Message};
use iced::{Container, Element, Length};
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

    // Used to synchronize the local database with the remote plugin server
    pub fn update_local_plugins(&self) -> Result<(), Box<dyn std::error::Error>> {
        let response = reqwest::blocking::get("https://young-hamlet-23901.herokuapp.com/plugins")?
            .json::<HashMap<String, Plugin>>()?;
        if Path::new(&self.config.plugins_file).exists() {
        } else {
            self.create_plugins_db();
            self.write_plugins(&response);
        }
        Ok(())
    }

    // Creates the local database if it doesn't exist.
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

    pub fn get_plugins(&self) -> Vec<Plugin> {
        let mut all_plugins: Vec<Plugin> = Vec::new();
        let conn = Connection::open(&self.config.plugins_file).unwrap();
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

    pub fn get_installed_plugins(&self) -> Vec<Plugin> {
        let mut installed_plugins: Vec<Plugin> = Vec::new();
        let conn = Connection::open(&self.config.plugins_file).unwrap();
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

    pub fn get_plugin(&self, name: &str) -> Vec<Plugin> {
        let mut installed_plugins: Vec<Plugin> = Vec::new();
        let conn = Connection::open(&self.config.plugins_file).unwrap();
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

        let row = Row::new()
            .push(Text::new(&self.title).width(Length::FillPortion(5)))
            .push(Text::new(&self.current_version).width(Length::FillPortion(3)))
            .push(Text::new(&self.latest_version).width(Length::FillPortion(3)))
            .push(Text::new("Update").width(Length::FillPortion(2)));

        Container::new(row)
            .width(Length::Fill)
            .padding(5)
            .style(style::PluginRow)
            .into()
    }
}

#[cfg(test)]
mod tests {
    use crate::core::{Config, Synchronizer};

    #[test]
    fn exploration() {
        assert_eq!(2 + 2, 4);
    }
}
