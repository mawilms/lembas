use crate::core::config::CONFIGURATION;
use std::path::{Path, PathBuf};
use std::{error::Error, fs::File};
use std::{fs, io::prelude::*};

use super::Plugin;

pub struct Installer {}

impl Installer {
    #[tokio::main]
    pub async fn download(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
        // Daten für Download, Extrahieren, Löschen und Eintrag in DB
        let response = reqwest::get(&format!(
            "https://www.lotrointerface.com/downloads/download{}-{}",
            &plugin.plugin_id, &plugin.title
        ))
        .await?;

        let mut file = match File::create(&format!("{}_{}.zip", &plugin.plugin_id, &plugin.title)) {
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

    pub fn extract(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
        let path = Path::new(&CONFIGURATION.plugins)
            .join(&format!("{}_{}.zip", &plugin.plugin_id, &plugin.title));
        let file = File::open(path)?;
        let mut zip_archive = zip::ZipArchive::new(file)?;
        zip::ZipArchive::extract(&mut zip_archive, Path::new(&CONFIGURATION.plugins))?;

        fs::remove_file(path)?;

        Ok(())
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
