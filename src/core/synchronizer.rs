use crate::core::config::Config;
use serde::{Deserialize, Serialize};
use std::{
    collections::HashMap,
    fs::{read_to_string, File},
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
        self.write_plugins(&response);
        Ok(())
    }

    fn write_plugins(&self, packages: &HashMap<String, Package>) {
        println!("{}", &self.config.plugins_file);
        let filestream =
            File::create(&self.config.plugins_file).expect("Couldn't update plugins.json");
        serde_json::to_writer(filestream, &packages).expect("Couldn't update plugins.json");
    }

    pub fn read_plugins(&self) {
        let data = read_to_string(&self.config.plugins_file).expect("Couldn't read plugins.json");
        let res: serde_json::Value = serde_json::from_str(&data).unwrap();
    }
}

#[derive(Serialize, Deserialize, Debug)]
struct Package {
    plugin_id: i32,
    title: String,
    version: String,
}
