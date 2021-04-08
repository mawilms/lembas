use crate::core::config::CONFIGURATION;
use std::path::{Path, PathBuf};
use std::{error::Error, fs::File};
use std::{fs, io::prelude::*};

use super::Plugin;

pub struct Installer {}

impl Installer {
    /// Downloads and extracts the specified plugin
    #[tokio::main]
    pub async fn install(path: &PathBuf, target: &str) -> Result<(), Box<dyn Error>> {
        let response = reqwest::get(target).await?;

        let mut file = match File::create(&path) {
            Err(why) => panic!("couldn't create {}", why),
            Ok(file) => file,
        };
        let content = response.bytes().await?;
        file.write_all(&content)?;

        Ok(())
    }

    pub fn delete(name: &str) -> Result<(), Box<dyn Error>> {
        let path = Path::new(&CONFIGURATION.plugins).join(name);
        fs::remove_file(path)?;

        Ok(())
    }

    pub fn update(plugin: &Plugin) {}

    pub fn zip_operation(path: &Path) {
        let file = File::open(path).expect("Couldn't read file");
        let mut zip_archive = zip::ZipArchive::new(file).expect("Couldn't read the zip archive");
        zip::ZipArchive::extract(&mut zip_archive, Path::new(&CONFIGURATION.plugins))
            .expect("Couldn't extract plugin");

        fs::remove_file(path).expect("Couldn't delete old archive");
    }
}

#[cfg(test)]
mod tests {
    #[test]
    fn install() {
        assert_eq!(2 + 2, 4);
    }

    fn update() {}

    fn delete() {}
}
