use crate::core::config::CONFIGURATION;
use crate::gui::main_window::Message;
use crate::gui::style;
use iced::{Container, Element, Length};
use rusqlite::NO_PARAMS;
use rusqlite::{params, Connection};
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

// Used to synchronize the local database with the remote plugin server
pub fn update_local_plugins() {
    let response = reqwest::blocking::get("https://young-hamlet-23901.herokuapp.com/plugins")
        .expect("Server not responding")
        .json::<HashMap<String, Plugin>>()
        .expect("Unable to parse JSON");
    let mut remote_plugins: Vec<Plugin> = Vec::new();
    for (_, element) in response {
        remote_plugins.push(element);
    }
    write_plugins(&remote_plugins);
}

// Creates the local database if it doesn't exist.
pub fn create_plugins_db() {
    let conn = Connection::open(&CONFIGURATION.plugins_file).unwrap();
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
        NO_PARAMS,
    )
    .unwrap();
}

fn write_plugins(plugins: &[Plugin]) {
    for value in plugins {
        insert_plugin(&value);
    }
}

fn insert_plugin(plugin: &Plugin) {
    // "INSERT INTO plugins (plugin_id, title, current_version, latest_version) VALUES (?1, ?2, ?3, ?4) ON CONFLICT (plugin_id, title, current_version, latest_version) DO UPDATE SET plugin_id=?1 title=?2 current_version=?3 latest_version=?4;"
    let conn = Connection::open(&CONFIGURATION.plugins_file).unwrap();
    conn.execute(
            "INSERT INTO plugins (plugin_id, title, current_version, latest_version) VALUES (?1, ?2, ?3, ?4) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, current_version=?3, latest_version=?4;",
            params![plugin.plugin_id, plugin.title, "", plugin.latest_version],
        )
        .unwrap();
}

pub fn get_plugins() -> Vec<Plugin> {
    let mut all_plugins: Vec<Plugin> = Vec::new();
    let conn = Connection::open(&CONFIGURATION.plugins_file).unwrap();
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

pub fn get_installed_plugins() -> Vec<Plugin> {
    let mut installed_plugins: Vec<Plugin> = Vec::new();
    let conn = Connection::open(&CONFIGURATION.plugins_file).unwrap();
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

pub fn get_plugin(name: &str) -> Vec<Plugin> {
    let mut installed_plugins: Vec<Plugin> = Vec::new();
    let conn = Connection::open(&CONFIGURATION.plugins_file).unwrap();
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

    #[test]
    fn exploration() {
        assert_eq!(2 + 2, 4);
    }
}
