use dirs::{cache_dir, data_dir, home_dir};
use lazy_static::lazy_static;
use std::fs;
use std::path::Path;

lazy_static! {
    pub static ref CONFIGURATION: Config = Config::default();
}

#[derive(Debug, Clone)]
pub struct Config {
    pub settings: String,
    pub plugins_dir: String,
    pub db_file: String,
    pub cache_dir: String,
}

impl Default for Config {
    fn default() -> Self {
        let plugins_path = home_dir()
            .expect("Couldn't find your home directory")
            .join("Documents")
            .join("The Lord of the Rings Online")
            .join("plugins");
        let settings_path = data_dir().unwrap().join("lembas");
        let cache_path = cache_dir().unwrap().join("lembas");

        fs::create_dir_all(&plugins_path).expect("Couldn't create the plugins folder");
        fs::create_dir_all(&settings_path).expect("Couldn't create the lembas settings folder");
        fs::create_dir_all(&cache_path).expect("Couldn't create the lembas settings folder");

        let path = Path::new(&settings_path).join("plugins.sqlite3");

        Self {
            settings: settings_path.into_os_string().into_string().unwrap(),
            plugins_dir: plugins_path.into_os_string().into_string().unwrap(),
            db_file: path.into_os_string().into_string().unwrap(),
            cache_dir: cache_path.into_os_string().into_string().unwrap(),
        }
    }
}
