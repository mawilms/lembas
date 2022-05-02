//! # Config
//!
//! Contains the config logic that is used to determine the storage paths for the `settings` and `plugins` directory.
//! The `settings` directory contains:
//! - settings.json -> Contains all settings that is specified by the user in the `settings` view.
//! - plugins.sqlite3 -> Contains the cache plugins which are installed on the users computer.
//! - tmp/ -> Temporary directory that contains data which is created while installing new plugins.
use dirs::{data_dir, home_dir};
use serde::{Deserialize, Serialize};
use std::path::PathBuf;
use std::{
    fs::{self, write, File},
    io::Read,
};

/// Basic struct which holds all necessary paths.
#[derive(Default, Debug, Clone)]
pub struct Config {
    pub settings: PathBuf,
    pub plugins_dir: PathBuf,
    pub database_path: PathBuf,
    pub tmp_dir: PathBuf,
    pub application_settings: SettingsFile,
}

pub struct FileNames {
    settings: String,
    database: String,
    tmp: String,
}

impl Default for FileNames {
    fn default() -> Self {
        Self {
            settings: String::from("settings.json"),
            database: String::from("plugins.sqlite3"),
            tmp: String::from("tmp"),
        }
    }
}

impl Config {
    pub fn new() -> Self {
        let file_names = FileNames::default();
        let plugins_dir = home_dir()
            .expect("Couldn't find your home directory")
            .join("Documents")
            .join("The Lord of the Rings Online")
            .join("Plugins");
        let storage_folder = data_dir().unwrap().join("lembas");

        fs::create_dir_all(&plugins_dir).expect("Couldn't create the plugins folder");
        fs::create_dir_all(&storage_folder).expect("Couldn't create the storage folder");

        let mut initial_settings = SettingsFile::default();
        let settings_file_path = &storage_folder.join(&file_names.settings);

        if settings_file_path.exists() {
            initial_settings = read_existing_settings_file(&settings_file_path);
        } else {
            initial_settings = create_existing_settings_file(&settings_file_path)
        }

        Self {
            settings: storage_folder,
            plugins_dir,
            database_path: storage_folder.join(&file_names.database).clone(),
            tmp_dir: storage_folder.join(&file_names.tmp),
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

fn create_existing_settings_file(settings_path: &PathBuf) -> SettingsFile {
    let mut initial_settings = SettingsFile::default();
    File::create(&settings_path).unwrap();
    write(
        &settings_path,
        serde_json::to_string(&initial_settings).unwrap(),
    )
    .unwrap();
    initial_settings
}

fn read_existing_settings_file(settings_path: &PathBuf) -> SettingsFile {
    let mut file = File::open(settings_path).unwrap();
    let mut data = String::new();
    file.read_to_string(&mut data).unwrap();
    serde_json::from_str(&data).unwrap()
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct SettingsFile {
    pub backup_enabled: bool,
    pub feed_url: String,
}

impl Default for SettingsFile {
    fn default() -> Self {
        Self {
            backup_enabled: true,
            feed_url: String::from("http://api.lotrointerface.com/fav/plugincompendium.xml"),
        }
    }
}
