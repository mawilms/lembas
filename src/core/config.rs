use dirs::{data_dir, home_dir};
use std::fs;
use std::path::Path;

#[derive(Default)]
pub struct Config {
    pub settings: String,
    pub plugins: String,
    pub plugins_file: String,
}

impl Config {
    pub fn init_settings(&mut self) {
        self.setup_folders();
    }

    fn setup_folders(&mut self) {
        let plugins_path = home_dir()
            .expect("Couldn't find your home directory")
            .join("Documents")
            .join("The Lord of the Rings Online")
            .join("plugins");
        fs::create_dir_all(&plugins_path).expect("Couldn't create the plugins folder");
        self.plugins = plugins_path.into_os_string().into_string().unwrap();

        let settings_path = data_dir().unwrap().join("Lembas");
        fs::create_dir_all(&settings_path).expect("Couldn't create the lembas settings folder");
        let path = Path::new(&settings_path).join("plugins.json");
        fs::File::create(&path).expect("Couldn't create plugins.json");
        self.plugins_file = path.into_os_string().into_string().unwrap();
        self.settings = settings_path.into_os_string().into_string().unwrap();
    }
}
