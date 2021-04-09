use crate::core::config::CONFIGURATION;
use std::path::Path;
use std::{error::Error, fs::File};
use std::{fs, io::prelude::*};

use super::Plugin;

pub struct Installer {}

impl Installer {
    #[tokio::main]
    pub async fn download(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
        let response = reqwest::get(&format!(
            "https://www.lotrointerface.com/downloads/download{}-{}",
            &plugin.plugin_id, &plugin.title
        ))
        .await?;

        let cache_path = Path::new(&CONFIGURATION.cache_dir)
            .join(format!("{}_{}.zip", &plugin.plugin_id, &plugin.title));
        let mut file = match File::create(cache_path) {
            Err(why) => panic!("couldn't create {}", why),
            Ok(file) => file,
        };
        let content = response.bytes().await?;
        file.write_all(&content)?;

        Ok(())
    }

    pub fn delete(name: &str) -> Result<(), Box<dyn Error>> {
        let path = Path::new(&CONFIGURATION.plugins_dir).join(name);
        fs::remove_file(path)?;

        Ok(())
    }

    pub fn extract(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
        let cache_path = Path::new(&CONFIGURATION.cache_dir)
            .join(format!("{}_{}.zip", &plugin.plugin_id, &plugin.title));
        let file = File::open(&cache_path)?;
        let mut zip_archive = zip::ZipArchive::new(file)?;
        zip::ZipArchive::extract(&mut zip_archive, Path::new(&CONFIGURATION.plugins_dir))?;

        Ok(())
    }

    pub fn delete_archive(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
        let cache_path = Path::new(&CONFIGURATION.cache_dir)
            .join(format!("{}_{}.zip", &plugin.plugin_id, &plugin.title));

        fs::remove_file(cache_path)?;

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
