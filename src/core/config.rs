use dirs::{data_dir, home_dir};
use std::path::Path;
use std::{fs, path::PathBuf};

#[derive(Default, Debug, Clone)]
pub struct Config {
    pub settings: String,
    pub plugins: String,
    pub plugins_file: String,
}

impl Config {
    pub fn init_settings(&mut self) {
        let plugins_path = home_dir()
            .expect("Couldn't find your home directory")
            .join("Documents")
            .join("The Lord of the Rings Online")
            .join("plugins");
        let settings_path = data_dir().unwrap().join("lembas");

        self.setup_plugin_folder(plugins_path);

        self.setup_settings_folder(settings_path);
    }

    fn setup_plugin_folder(&mut self, plugins_path: PathBuf) {
        fs::create_dir_all(&plugins_path).expect("Couldn't create the plugins folder");
        self.plugins = plugins_path.into_os_string().into_string().unwrap();
    }

    fn setup_settings_folder(&mut self, settings_path: PathBuf) {
        fs::create_dir_all(&settings_path).expect("Couldn't create the lembas settings folder");
        let path = Path::new(&settings_path).join("plugins.sqlite3");
        self.plugins_file = path.into_os_string().into_string().unwrap();
        self.settings = settings_path.into_os_string().into_string().unwrap();
    }
}
