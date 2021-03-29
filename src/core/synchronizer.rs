use crate::core::config::Config;
use rusqlite::NO_PARAMS;
use rusqlite::{params, Connection, Result};
use serde::{Deserialize, Serialize};
use std::{
    collections::HashMap,
    fs::{read_to_string, File},
    path::Path,
};

pub struct Synchronizer {
    config: Config,
}

impl Synchronizer {
    pub fn new(config: Config) -> Self {
        Self { config }
    }

    pub fn synchronize_plugins(&self) -> Result<(), Box<dyn std::error::Error>> {
        let response = reqwest::blocking::get("http://localhost:8000/plugins")?
            .json::<HashMap<String, Package>>()?;
        if Path::new(&self.config.plugins_file).exists() {
            //self.update_plugins(&response);
            println!("Bla1");
            println!("{}", self.config.plugins_file)
        } else {
            self.create_plugins_db();
            self.write_plugins(&response);
        }
        Ok(())
    }

    fn create_plugins_db(&self) {
        let conn = Connection::open(&self.config.plugins_file).unwrap();
        conn.execute(
            "
                CREATE TABLE plugins (
                    id INTEGER PRIMARY KEY,
                    plugin_id INTEGER,
                    title TEXT,
                    current_version TEXT,
                    latest_version TEXT
                );
        ",
            NO_PARAMS,
        )
        .expect("Bla");
    }

    // fn write_plugins(&self, packages: &HashMap<String, Package>) {
    //     let filestream =
    //         File::create(&self.config.plugins_file).expect("Couldn't update plugins.json");
    //     serde_json::to_writer(filestream, &packages).expect("Couldn't update plugins.json");
    // }
    fn write_plugins(&self, packages: &HashMap<String, Package>) {
        for (key, value) in packages {
            self.insert_plugin(&value);
        }
    }

    fn insert_plugin(&self, package: &Package) {
        let conn = Connection::open(&self.config.plugins_file).unwrap();
        println!("{:?}", package);
        conn.execute(
            "INSERT INTO plugins (plugin_id, title, current_version, latest_version) VALUES (?1, ?2, ?3, ?4)",
            params![package.plugin_id, package.title, "", package.latest_version],
        )
        .unwrap();
    }

    fn update_plugins(&self, packages: &HashMap<String, Package>) {
        let plugins = self.read_plugins();
    }

    pub fn read_plugins(&self) -> serde_json::Value {
        let data = read_to_string(&self.config.plugins_file).expect("Couldn't read plugins.json");
        serde_json::from_str(&data).unwrap()
    }
}

#[derive(Serialize, Deserialize, Debug)]
struct Package {
    plugin_id: i32,
    title: String,
    #[serde(default)]
    current_version: String,
    latest_version: String,
}
