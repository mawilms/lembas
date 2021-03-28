use dirs::home_dir;
use std::{fs, path::PathBuf};

/// Reads the given plugin.json that is basically the database to keep the user based information centralised
pub fn read_plugins() {
    let data = fs::read_to_string("plugins.json").unwrap();
    let json: serde_json::Value = serde_json::from_str(&data).unwrap();
    println!("{}", json);
}

pub fn initialize_plugin_folder() {
    let mut path = home_dir().expect("Couldn't find your home directory");
    path = path.join("Documents").join("The Lord of the Rings Online");
    fs::create_dir_all(path.join("plugins")).expect("Couldn't create the plugins folder");
}

pub fn get_plugin_folder() -> PathBuf {
    let path = home_dir().expect("Couldn't find your home directory");
    path.join("Documents")
        .join("The Lord of the Rings Online")
        .join("plugins")
}
