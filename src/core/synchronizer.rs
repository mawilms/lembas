use crate::core::config::CONFIGURATION;
use crate::core::Plugin;
use iced::button;
use rusqlite::NO_PARAMS;
use rusqlite::{params, Connection};
use std::{collections::HashMap, error::Error};

// Used to synchronize the local database with the remote plugin server
pub async fn update_local_plugins() -> Result<(), Box<dyn Error>> {
    let response = reqwest::get("https://young-hamlet-23901.herokuapp.com/plugins")
        .await?
        .json::<HashMap<String, Plugin>>()
        .await?;
    let mut remote_plugins: Vec<Plugin> = Vec::new();
    for (_, element) in response {
        remote_plugins.push(element);
    }
    write_plugins(&remote_plugins)?;

    Ok(())
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

fn write_plugins(plugins: &[Plugin]) -> Result<(), Box<dyn Error>> {
    for value in plugins {
        insert_plugin(&value)?;
    }
    Ok(())
}

fn insert_plugin(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
    let conn = Connection::open(&CONFIGURATION.plugins_file).unwrap();
    conn.execute(
            "INSERT INTO plugins (plugin_id, title, current_version, latest_version) VALUES (?1, ?2, ?3, ?4) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, latest_version=?4;",
            params![plugin.plugin_id, plugin.title, "", plugin.latest_version],
        )?;
    Ok(())
}

pub fn install_plugin(plugin: &Plugin) {
    println!("Bla");
    let conn = Connection::open(&CONFIGURATION.plugins_file).unwrap();
    conn.execute(
            "INSERT INTO plugins (plugin_id, title, current_version, latest_version) VALUES (?1, ?2, ?3, ?4) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, latest_version=?4;",
            params![plugin.plugin_id, plugin.title, plugin.latest_version, plugin.latest_version],
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
                install_btn_state: button::State::default(),
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
                install_btn_state: button::State::default(),
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
                install_btn_state: button::State::default(),
            })
        })
        .unwrap();
    for plugin in plugin_iter {
        installed_plugins.push(plugin.unwrap());
    }
    installed_plugins
}
