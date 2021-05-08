use super::Plugin;
use crate::core::config::CONFIGURATION;
use fs_extra;
use std::{error::Error, fs::File};
use std::{fs, io::prelude::*};
use std::{fs::metadata, path::Path};

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

        Self::move_files(
            &tmp_file_path.to_str().unwrap(),
            &plugin.folder_name,
            &plugin.files,
        );

        Ok(())
    }

    fn move_files(tmp_path: &str, folder_name: &str, files: &[String]) {
        let tmp_folder = fs::read_dir(&Path::new(tmp_path).join(&folder_name)).unwrap();
        fs::remove_file(&Path::new(tmp_path).join("plugin.zip")).unwrap();

        if !Path::new(&CONFIGURATION.plugins_dir)
            .join(&folder_name)
            .exists()
        {
            // TODO: Check if the options are really doing what I want
            fs::create_dir_all(Path::new(&CONFIGURATION.plugins_dir).join(&folder_name)).unwrap();
        }

        for file in tmp_folder {
            let file_str = file.unwrap().file_name().into_string().unwrap();

            let md = metadata(Path::new(tmp_path).join(&folder_name).join(&file_str)).unwrap();
            if md.is_dir() {
                let mut options = fs_extra::dir::CopyOptions::new();
                options.overwrite = true;
                options.copy_inside = true;
                fs_extra::dir::move_dir(
                    Path::new(tmp_path).join(&folder_name).join(&file_str),
                    Path::new(&CONFIGURATION.plugins_dir).join(folder_name),
                    &options,
                )
                .unwrap();
            } else {
                let mut options = fs_extra::file::CopyOptions::new();
                options.overwrite = true;
                fs_extra::file::move_file(
                    Path::new(tmp_path).join(&folder_name).join(&file_str),
                    Path::new(&CONFIGURATION.plugins_dir).join(&folder_name).join(&file_str),
                    &options,
                )
                .unwrap();
            }
        }
    }

    pub fn delete_cache_folder(plugin: &Plugin) -> Result<(), Box<dyn Error>> {
        let tmp_file_path = Path::new(&CONFIGURATION.cache_dir)
            .join(format!("{}_{}", &plugin.plugin_id, &plugin.title));

        //fs::remove_dir_all(tmp_file_path).unwrap();

        Ok(())
    }
}
