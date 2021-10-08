use serde::{Deserialize, Serialize};
use std::path::PathBuf;
use std::{
    fs::{self, write, File},
    io::Read,
};

use crate::gui::views::Paths;

#[derive(Default, Debug, Clone)]
pub struct Config {
    pub settings: PathBuf,
    pub plugins_dir: PathBuf,
    pub db_file_path: PathBuf,
    pub cache_dir: PathBuf,
    pub application_settings: SettingsFile,
}

impl Config {
    pub fn new(paths: Paths) -> Self {
        fs::create_dir_all(&paths.plugins).expect("Couldn't create the plugins folder");
        fs::create_dir_all(&paths.settings).expect("Couldn't create the lembas settings folder");
        fs::create_dir_all(&paths.cache).expect("Couldn't create the lembas cache folder");

        let path = &paths.settings.join("plugins.sqlite3");

        let mut initial_settings = SettingsFile::default();
        let settings_file_path = &paths.settings.join("settings.json");

        if settings_file_path.exists() {
            let mut file = File::open(settings_file_path).unwrap();
            let mut data = String::new();
            file.read_to_string(&mut data).unwrap();
            initial_settings = serde_json::from_str(&data).unwrap();
        } else {
            File::create(&settings_file_path).unwrap();
            initial_settings.backup_enabled = true;
            initial_settings.feed_url =
                String::from("http://api.lotrointerface.com/fav/plugincompendium.xml");
            write(
                &settings_file_path,
                serde_json::to_string(&initial_settings).unwrap(),
            )
            .unwrap();
        }

        Self {
            settings: paths.settings,
            plugins_dir: paths.plugins,
            db_file_path: path.clone(),
            cache_dir: paths.cache,
            application_settings: initial_settings,
        }
    }

    pub fn save_changes(&self) {
        let settings_file_path = &self.settings.join("settings.json");

        write(
            &settings_file_path,
            serde_json::to_string(&self.application_settings).unwrap(),
        )
        .unwrap();
    }
}

#[derive(Default, Debug, Clone, Serialize, Deserialize)]
pub struct SettingsFile {
    pub backup_enabled: bool,
    pub feed_url: String,
}
