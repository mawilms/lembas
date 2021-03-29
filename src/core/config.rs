use dirs::{data_dir, home_dir};
use std::{env, path::Path};
use std::{fs, path::PathBuf};

#[derive(Default)]
pub struct Config {
    pub settings: String,
    pub plugins: String,
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
        path = path.join("Documents").join("The Lord of the Rings Online");
        let plugin_path = path.join("plugins");
        fs::create_dir_all(&plugin_path).expect("Couldn't create the plugins folder");
        fs::create_dir(data_dir().unwrap().join("Lembas"))
            .expect("Couldn't create the lembas settings folder");

        self.settings = data_dir()
            .expect("Couldn't find the default data directory")
            .into_os_string()
            .into_string()
            .unwrap();
        self.plugins = plugin_path.into_os_string().into_string().unwrap();

        Config::create_plugins_fole(&self.settings);
    }

    fn linux_settings(&mut self) {
        let mut path = home_dir().expect("Couldn't find your home directory");
        path = path.join("Documents").join("The Lord of the Rings Online");
        let plugin_path = path.join("plugins");
        fs::create_dir_all(&plugin_path).expect("Couldn't create the plugins folder");
        fs::create_dir_all(data_dir().unwrap().join("Lembas"))
            .expect("Couldn't create the lembas settings folder");

        self.settings = plugin_path.clone().into_os_string().into_string().unwrap();
        self.plugins = plugin_path.into_os_string().into_string().unwrap();

        Config::create_plugins_fole(&self.settings);
    }

    fn create_plugins_fole(path: &str) {
        let path = Path::new(path);
        fs::File::create(path.join("plugins.json")).expect("Couldn't create plugins.json");
    }
}
