use super::Plugin;
use crate::core::config::CONFIGURATION;
use fs_extra::dir::{move_dir, CopyOptions};
use futures::TryFutureExt;
use std::{error::Error, fs::File};
use std::{fs, io::prelude::*};
use std::{fs::metadata, fs::remove_dir_all, path::Path};

pub struct Installer {}

impl Installer {
    #[tokio::main]
    pub async fn download(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
        let response = reqwest::get(&format!(
            "https://www.lotrointerface.com/downloads/download{}-{}",
            &plugin.plugin_id, &plugin.title
        ))
        .await?;

        let tmp_file_path = Path::new(&CONFIGURATION.cache_dir)
            .join(&format!("{}_{}", &plugin.plugin_id, &plugin.title));

        fs::create_dir(&tmp_file_path)?;

        let cache_path = Path::new(&CONFIGURATION.cache_dir)
            .join(&format!("{}_{}", &plugin.plugin_id, &plugin.title))
            .join("plugin.zip");
        match File::create(cache_path) {
            Err(why) => panic!("couldn't create {}", why),
            Ok(mut file) => {
                let content = response.bytes().await?;
                file.write_all(&content)?;
            }
        };
        Ok(())
    }

    pub fn delete(name: &str, files: &[String]) -> Result<(), Box<dyn Error>> {
        for file in files {
            let path = Path::new(&CONFIGURATION.plugins_dir).join(name).join(file);
            let md = metadata(&path).unwrap();
            if md.is_dir() {
                fs::remove_dir_all(&path)?;
            } else {
                fs::remove_file(Path::new(&path))?;
            }
        }

        if Path::new(&CONFIGURATION.plugins_dir)
            .join(name)
            .read_dir()?
            .next()
            .is_none()
        {
            fs::remove_dir_all(Path::new(&CONFIGURATION.plugins_dir).join(name))?;
        }

        Ok(())
    }

    pub fn extract(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
        let tmp_file_path = Path::new(&CONFIGURATION.cache_dir)
            .join(format!("{}_{}", &plugin.plugin_id, &plugin.title));

        let cache_path = Path::new(&CONFIGURATION.cache_dir)
            .join(format!("{}_{}", &plugin.plugin_id, &plugin.title))
            .join("plugin.zip");
        let file = File::open(&cache_path)?;
        let mut zip_archive = zip::ZipArchive::new(file)?;

        zip::ZipArchive::extract(&mut zip_archive, Path::new(&tmp_file_path))?;

        Self::move_files(&tmp_file_path.to_str().unwrap());

        Ok(())
    }

    fn move_files(tmp_path: &str) {
        let folders = fs::read_dir(&Path::new(tmp_path)).unwrap();

        for file in folders {
            let file_str = file.unwrap().file_name().into_string().unwrap();
            if !file_str.contains("plugin.zip") {
                remove_dir_all(Path::new(&CONFIGURATION.plugins_dir).join(&file_str)).unwrap();

                let mut options = CopyOptions::new();
                options.overwrite = true;

                if Path::new(&tmp_path).join(&file_str).exists() {
                    options.content_only = true;
                    options.copy_inside = true;
                }
                move_dir(
                    Path::new(&tmp_path).join(&file_str),
                    &CONFIGURATION.plugins_dir,
                    &options,
                )
                .unwrap();
            }
        }
    }

    pub fn delete_cache_folder(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
        let tmp_file_path = Path::new(&CONFIGURATION.cache_dir)
            .join(format!("{}_{}", &plugin.plugin_id, &plugin.title));

        fs::remove_dir_all(tmp_file_path)?;

        Ok(())
    }
}
