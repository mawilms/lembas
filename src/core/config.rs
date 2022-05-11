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

pub fn initialize_directories() {
    let storage_dir = get_storage_dir();

    fs::create_dir_all(&get_plugins_dir()).expect("Couldn't create the plugins folder");
    fs::create_dir_all(&storage_dir).expect("Couldn't create the storage folder");
    fs::create_dir_all(&storage_dir.join("tmp")).expect("Couldn't create the storage folder");

    let settings_file_path = &storage_dir.join("settings.json");

    if !settings_file_path.exists() {
        create_existing_settings_file(settings_file_path);
    }
}

pub fn get_plugins_dir() -> PathBuf {
    home_dir()
        .expect("Couldn't find your home directory")
        .join("Documents")
        .join("The Lord of the Rings Online")
        .join("Plugins")
}

pub fn get_storage_dir() -> PathBuf {
    data_dir().unwrap().join("lembas")
}

pub fn get_settings_file_path() -> PathBuf {
    let storage_dir = get_storage_dir();

    storage_dir.join("settings.json")
}

pub fn get_database_file_path() -> PathBuf {
    let storage_dir = get_storage_dir();

    storage_dir.join("plugins.sqlite3")
}

pub fn get_tmp_dir() -> PathBuf {
    let storage_dir = get_storage_dir();

    storage_dir.join("tmp")
}

pub fn save_settings_changes(settings: &SettingsFile) {
    let settings_file_path = get_settings_file_path();

    write(
        &settings_file_path,
        serde_json::to_string(&settings).unwrap(),
    )
    .unwrap();
}

fn create_existing_settings_file(settings_path: &PathBuf) {
    let initial_settings = SettingsFile::default();
    File::create(&settings_path).unwrap();
    write(
        &settings_path,
        serde_json::to_string(&initial_settings).unwrap(),
    )
    .unwrap();
}

pub fn read_existing_settings_file() -> SettingsFile {
    let mut file = File::open(get_settings_file_path()).unwrap();
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
