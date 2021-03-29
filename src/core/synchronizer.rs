use crate::core::config::Config;
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
            self.update_plugins(&response);
        } else {
            self.write_plugins(&response);
        }
        self.write_plugins(&response);
        Ok(())
    }

    fn write_plugins(&self, packages: &HashMap<String, Package>) {
        let filestream =
            File::create(&self.config.plugins_file).expect("Couldn't update plugins.json");
        serde_json::to_writer(filestream, &packages).expect("Couldn't update plugins.json");
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
