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
            self.linux_settings();
        } else if os == "windows" {
            self.windows_settings();
        } else if os == "macos" {
            println!("Mac");
        }
    }

    fn windows_settings(&mut self) {
        let mut path = home_dir().expect("Couldn't find your home directory");
        path = path.join("Dokumente").join("The Lord of the Rings Online");
        let plugin_path = path.join("plugins");
        fs::create_dir_all(&plugin_path).expect("Couldn't create the plugins folder");

        self.settings = data_dir()
            .expect("Couldn't find the default data directory")
            .into_os_string()
            .into_string()
            .unwrap();
        self.plugins = plugin_path
            .join("plugins")
            .into_os_string()
            .into_string()
            .unwrap();
    }

    fn linux_settings(&mut self) {
        let mut path = home_dir().expect("Couldn't find your home directory");
        path = path.join("Dokumente").join("The Lord of the Rings Online");
        let plugin_path = path.join("plugins");
        fs::create_dir_all(&plugin_path).expect("Couldn't create the plugins folder");

        self.settings = plugin_path.clone().into_os_string().into_string().unwrap();
        self.plugins = plugin_path.into_os_string().into_string().unwrap();
    }
}

/// Reads the given plugin.json that is basically the database to keep the user based information centralised
pub fn read_plugins() {
    let data = fs::read_to_string("samples/plugins.json").unwrap();
    let json: serde_json::Value = serde_json::from_str(&data).unwrap();
    println!("{}", json);
}
