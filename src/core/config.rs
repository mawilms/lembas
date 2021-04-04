use dirs::{data_dir, home_dir};
use std::fs;
use std::path::Path;

#[derive(Debug, Clone)]
pub struct Config {
    pub settings: String,
    pub plugins: String,
    pub plugins_file: String,
}

impl Default for Config {
    fn default() -> Self {
        let plugins_path = home_dir()
            .expect("Couldn't find your home directory")
            .join("Documents")
            .join("The Lord of the Rings Online")
            .join("plugins");
        let settings_path = data_dir().unwrap().join("lembas");

        fs::create_dir_all(&plugins_path).expect("Couldn't create the plugins folder");
        fs::create_dir_all(&settings_path).expect("Couldn't create the lembas settings folder");

        let path = Path::new(&settings_path).join("plugins.sqlite3");

        Self {
            settings: settings_path.into_os_string().into_string().unwrap(),
            plugins: plugins_path.into_os_string().into_string().unwrap(),
            plugins_file: path.into_os_string().into_string().unwrap(),
        }
    }
}
