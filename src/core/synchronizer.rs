use crate::core::config::Config;
use serde::{Deserialize, Serialize};
use std::{fs::File, path::Path};

pub struct Synchronizer {
    config: Config,
}

impl Synchronizer {
    pub fn new(config: Config) -> Self {
        Self { config }
    }

    pub fn synchronize_plugins(&self) -> Result<(), Box<dyn std::error::Error>> {
        let response =
            reqwest::blocking::get("http://localhost:8000/plugins")?.json::<Vec<Package>>()?;
        println!("{:?}", response);
        self.write_plugins(&response);
        Ok(())
    }

    fn write_plugins(&self, packages: &[Package]) {
        let path = Path::new(&self.config.settings);
        let filestream =
            File::create(path.join("plugins.json")).expect("Couldn't open plugins.json");
        serde_json::to_writer(filestream, &packages).expect("Couldn't update plugins.json");
    }
}

#[derive(Serialize, Deserialize, Debug)]
struct Package {
    plugin_id: i32,
    title: String,
}
