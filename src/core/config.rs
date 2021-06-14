use serde::{Deserialize, Serialize};
use std::path::Path;
use std::{
    fs::{self, write, File},
    io::Read,
};

use crate::gui::views::Paths;

#[derive(Default, Debug, Clone)]
pub struct Config {
    pub settings: String,
    pub plugins_dir: String,
    pub db_file: String,
    pub cache_dir: String,
    pub application_settings: SettingsFile,
}

impl Config {
    pub fn new(paths: Paths) -> Self {
        fs::create_dir_all(&paths.plugins).expect("Couldn't create the plugins folder");
        fs::create_dir_all(&paths.settings).expect("Couldn't create the lembas settings folder");
        fs::create_dir_all(&paths.cache).expect("Couldn't create the lembas cache folder");

        let path = Path::new(&paths.settings).join("plugins.sqlite3");

        let mut initial_settings = SettingsFile::default();
        let settings_file_path = Path::new(&paths.settings).join("settings.json");

        if settings_file_path.exists() {
            let mut file = File::open(settings_file_path).unwrap();
            let mut data = String::new();
            file.read_to_string(&mut data).unwrap();

            initial_settings = serde_json::from_str(&data).unwrap();
        } else {
            File::create(&settings_file_path).unwrap();
            initial_settings.backup_enabled = true;
            write(
                &settings_file_path,
                serde_json::to_string(&initial_settings).unwrap(),
            )
            .unwrap();
        }

        Self {
            settings: paths.settings.into_os_string().into_string().unwrap(),
            plugins_dir: paths.plugins.into_os_string().into_string().unwrap(),
            db_file: path.into_os_string().into_string().unwrap(),
            cache_dir: paths.cache.into_os_string().into_string().unwrap(),
            application_settings: initial_settings,
        }
    }

    pub fn save_changes(&self) {
        let settings_file_path = Path::new(&self.settings).join("settings.json");

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
}
