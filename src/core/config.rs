use dirs::{data_dir, home_dir};
use std::env;
use std::{fs, path::PathBuf};

#[derive(Default)]
pub struct Config {
    settings: String,
    plugins: String,
}

impl Config {
    pub fn get_settings(&mut self) {
        let os = env::consts::OS;
        if os == "linux" {
            println!("Linux");
        } else if os == "windows" {
            self.windows_settings();
        } else if os == "macos" {
            println!("Mac");
        }
    }

    fn windows_settings(&mut self) {
        let mut path = home_dir().expect("Couldn't find your home directory");
        path = path.join("Dokumente").join("The Lord of the Rings Online");
        fs::create_dir_all(path.join("plugins")).expect("Couldn't create the plugins folder");

        self.settings = data_dir()
            .expect("Couldn't find the default data directory")
            .into_os_string()
            .into_string()
            .unwrap();
        self.plugins = path.into_os_string().into_string().unwrap();
    }

    fn linux_settings(&mut self) {}
}

/// Reads the given plugin.json that is basically the database to keep the user based information centralised
pub fn read_plugins() {
    let data = fs::read_to_string("samples/plugins.json").unwrap();
    let json: serde_json::Value = serde_json::from_str(&data).unwrap();
    println!("{}", json);
}

pub fn initialize_plugin_folder() {
    let mut path = home_dir().expect("Couldn't find your home directory");
    path = path.join("Dokumente").join("The Lord of the Rings Online");
    fs::create_dir_all(path.join("plugins")).expect("Couldn't create the plugins folder");
}

pub fn get_plugin_folder() -> PathBuf {
    let path = home_dir().expect("Couldn't find your home directory");
    path.join("Dokumente")
        .join("The Lord of the Rings Online")
        .join("plugins")
}
