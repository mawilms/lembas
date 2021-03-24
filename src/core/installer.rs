use crate::core::config::get_plugin_folder;
use std::path::{Path, PathBuf};
use std::{error::Error, fs::File};
use std::{fs, io::prelude::*};

/// Downloads and extracts the specified plugin
pub fn install(plugin_id: &str, name: &str) -> Result<(), Box<dyn Error>> {
    let plugin_folder_path = get_plugin_folder();
    let target = format!(
        "https://www.lotrointerface.com/downloads/download{}-{}",
        plugin_id, name
    );
    let response = reqwest::blocking::get(target).unwrap();

    let filename = format!("{}_{}.zip", plugin_id, name);
    let path = plugin_folder_path.join(filename);

    let mut file = match File::create(&path) {
        Err(why) => panic!("couldn't create {}", why),
        Ok(file) => file,
    };
    let content = response.bytes().unwrap();
    file.write_all(&content)?;

    zip_operation(path.as_path(), &plugin_folder_path);

    Ok(())
}

fn zip_operation(path: &Path, plugin_folder_path: &PathBuf) {
    let file = File::open(path).expect("Couldn't read file");
    let mut zip_archive = zip::ZipArchive::new(file).expect("Couldn't read the zip archive");
    zip::ZipArchive::extract(&mut zip_archive, plugin_folder_path)
        .expect("Couldn't extract plugin");

    fs::remove_file(path).expect("Couldn't delete old archive");
}

/// Updates already installed plugins
pub fn update() {}

/// Deletes the specified plugin
pub fn delete(plugin_id: &str) {}

#[cfg(test)]
mod tests {
    #[test]
    fn install() {
        assert_eq!(2 + 2, 4);
    }

    fn update() {}

    fn delete() {}
}
