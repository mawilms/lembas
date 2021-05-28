use dirs::{cache_dir, data_dir, home_dir};
use lazy_static::lazy_static;
use serde::{Deserialize, Serialize};
use std::path::Path;
use std::sync::Mutex;
use std::{
    fs::{self, write, File},
    io::Read,
};

trait FileConfigurations {
    fn new() -> Self;
}

lazy_static! {
    pub static ref CONFIGURATION: Mutex<Config> = Mutex::new(Config::new());
}

#[derive(Debug, Clone)]
pub struct Config {
    pub settings: String,
    pub plugins_dir: String,
    pub db_file: String,
    pub cache_dir: String,
    pub application_settings: SettingsFile,
}

impl FileConfigurations for Config {
    fn new() -> Self {
        let plugins_path = home_dir()
            .expect("Couldn't find your home directory")
            .join("Documents")
            .join("The Lord of the Rings Online")
            .join("plugins");
        let settings_path = data_dir().unwrap().join("lembas");
        let cache_path = cache_dir().unwrap().join("lembas");

        fs::create_dir_all(&plugins_path).expect("Couldn't create the plugins folder");
        fs::create_dir_all(&settings_path).expect("Couldn't create the lembas settings folder");
        fs::create_dir_all(&cache_path).expect("Couldn't create the lembas cache folder");

        let path = Path::new(&settings_path).join("plugins.sqlite3");

        let mut initial_settings = SettingsFile::default();
        let settings_file_path = Path::new(&settings_path).join("settings.json");

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
            settings: settings_path.into_os_string().into_string().unwrap(),
            plugins_dir: plugins_path.into_os_string().into_string().unwrap(),
            db_file: path.into_os_string().into_string().unwrap(),
            cache_dir: cache_path.into_os_string().into_string().unwrap(),
            application_settings: initial_settings,
        }
    }
}

impl Config {
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
