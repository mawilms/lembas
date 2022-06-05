use bytes::Bytes;
use chrono::offset::Utc;
use chrono::DateTime;
use fs_extra::{
    self,
    dir::{copy, CopyOptions},
};
use log::debug;
use std::time::SystemTime;
use std::{
    error::Error,
    fs::{create_dir_all, File, OpenOptions},
    path::PathBuf,
};
use std::{fs, io::prelude::*};
use std::{fs::metadata, path::Path};

use crate::gui::views::plugins::{Event, PluginRow};

use super::{
    config::{get_plugins_backup_dir, read_existing_settings_file},
    io::{cache::DatabaseHandler, Cache},
};

pub struct Installer {
    pub plugins_dir: PathBuf,
    pub tmp_file_path: PathBuf,
    pub files: Vec<String>,
}

impl Installer {
    pub fn new(tmp_dir: &Path, plugins_dir: &Path, plugin_id: i32, plugin_title: &str) -> Self {
        Self {
            plugins_dir: plugins_dir.to_path_buf(),
            tmp_file_path: tmp_dir.join(&format!(
                "{}_{}",
                plugin_id,
                plugin_title.replace(' ', "_")
            )),
            files: Vec::new(),
        }
    }

    pub fn run_installation(
        &mut self,
        cache: &Cache,
        plugin: &PluginRow,
    ) -> (Event, String, String) {
        if let Ok(bytes) = self.download(&plugin.download_url) {
            if let Ok(root_folder_name) = self.install(&bytes) {
                if self.delete().is_ok() {
                    if cache.delete_plugin(&plugin.title).is_ok() {
                        self.move_files(&root_folder_name);
                        if cache
                            .mark_as_installed(plugin.id, &plugin.latest_version)
                            .is_ok()
                        {
                            self.delete_cache_folder();
                            (
                                Event::Synchronize,
                                "Updated".to_string(),
                                plugin.latest_version.clone(),
                            )
                        } else {
                            (Event::Nothing, "Update failed".to_string(), String::new())
                        }
                    } else {
                        (Event::Nothing, "Update failed".to_string(), String::new())
                    }
                } else {
                    (Event::Nothing, "Update failed".to_string(), String::new())
                }
            } else {
                (Event::Nothing, "Update failed".to_string(), String::new())
            }
        } else {
            (Event::Nothing, "Update failed".to_string(), String::new())
        }
    }

    pub fn download(&self, download_url: &str) -> Result<Bytes, Box<dyn Error>> {
        let settings = read_existing_settings_file();

        if settings.backup_enabled {
            self.backup_plugin_folder();
        }
        let bytes = reqwest::blocking::get(download_url)?.bytes()?;

        Ok(bytes)
    }

    pub fn install(&mut self, bytes: &Bytes) -> Result<String, Box<dyn Error>> {
        if self.tmp_file_path.exists() {
            fs::remove_dir_all(&self.tmp_file_path).unwrap();
        }

        fs::create_dir(&self.tmp_file_path)?;

        let cache_path = &self.tmp_file_path.join("plugin.zip");

        match File::create(&cache_path) {
            Err(why) => panic!("couldn't create {}", why),
            Ok(mut file) => {
                file.write_all(bytes)?;
                let file = OpenOptions::new()
                    .write(true)
                    .read(true)
                    .open(&cache_path)
                    .unwrap();
                let mut zip_archive = zip::ZipArchive::new(file)?;
                zip::ZipArchive::extract(&mut zip_archive, &self.tmp_file_path)?;
                let root_folder_name = zip_archive
                    .by_index(0)?
                    .name()
                    .to_string()
                    .replace(' ', "_")
                    .split('/')
                    .next()
                    .unwrap()
                    .to_string();

                self.files = zip_archive
                    .file_names()
                    .map(std::string::ToString::to_string)
                    .collect::<Vec<String>>();

                Ok(root_folder_name)
            }
        }
    }

    pub fn delete(&self) -> Result<(), Box<dyn Error>> {
        let root_name = self.files[0].split('/').next().unwrap();

        fs::remove_dir_all(&self.plugins_dir.join(root_name))?;

        Ok(())
    }

    pub fn move_files(&self, folder_name: &str) {
        let tmp_folder = fs::read_dir(&self.tmp_file_path.join(&folder_name))
            .map_err(|_| {
                debug!(
                    "Error while reading tmp folder with the name {}",
                    &self.tmp_file_path.join(&folder_name).to_str().unwrap()
                );
            })
            .unwrap();
        fs::remove_file(&self.tmp_file_path.join("plugin.zip")).unwrap();

        if !&self.plugins_dir.join(&folder_name).exists() {
            fs::create_dir_all(&self.plugins_dir.join(&folder_name)).unwrap();
        }

        for file in tmp_folder {
            let file_str = file.unwrap().file_name().into_string().unwrap();

            let md = metadata(&self.tmp_file_path.join(&folder_name).join(&file_str)).unwrap();

            if md.is_dir() {
                let mut options = fs_extra::dir::CopyOptions::new();
                options.overwrite = true;
                options.copy_inside = true;
                fs_extra::dir::move_dir(
                    &self.tmp_file_path.join(&folder_name).join(&file_str),
                    &self.plugins_dir.join(folder_name),
                    &options,
                )
                .unwrap();
            } else {
                let mut options = fs_extra::file::CopyOptions::new();
                options.overwrite = true;
                fs_extra::file::move_file(
                    &self.tmp_file_path.join(&folder_name).join(&file_str),
                    &self.plugins_dir.join(&folder_name).join(&file_str),
                    &options,
                )
                .unwrap();
            }
        }
    }

    pub fn delete_cache_folder(&self) {
        fs::remove_dir_all(&self.tmp_file_path).unwrap();
    }

    fn backup_plugin_folder(&self) {
        let backup_path = get_plugins_backup_dir();

        if !backup_path.exists() {
            create_dir_all(&backup_path).unwrap();
        }

        let options = CopyOptions::new();

        let system_time = SystemTime::now();
        let datetime: DateTime<Utc> = system_time.into();
        let datetime = datetime.format("%Y_%m_%d_%H%M%S").to_string();

        let tmp_backup_path = &backup_path.join(format!("{}_backup", datetime));
        create_dir_all(&tmp_backup_path).unwrap();

        copy(&self.plugins_dir, &tmp_backup_path, &options).unwrap();
    }
}
