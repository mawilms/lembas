use chrono::offset::Utc;
use chrono::DateTime;
use dirs::home_dir;
use fs_extra::{
    self,
    dir::{copy, CopyOptions},
};
use std::{
    error::Error,
    fs::{File, OpenOptions},
    path::PathBuf,
};
use std::{fs, io::prelude::*};
use std::{fs::create_dir, time::SystemTime};
use std::{fs::metadata, path::Path};

use super::config::{get_plugins_dir, read_existing_settings_file};

pub struct Installer {
    plugins_dir: PathBuf,
    tmp_file_path: PathBuf,
}

impl Installer {
    pub fn new(tmp_dir: &Path, plugins_dir: &Path, plugin_id: i32, plugin_title: &str) -> Self {
        Self {
            plugins_dir: plugins_dir.to_path_buf(),
            tmp_file_path: tmp_dir.join(&format!("{}_{}", plugin_id, plugin_title)),
        }
    }

    pub fn download(&self, download_url: &str) -> Result<Vec<String>, Box<dyn Error>> {
        let settings = read_existing_settings_file();

        if settings.backup_enabled {
            self.backup_plugin_folder();
        }

        let response = reqwest::blocking::get(download_url)?;

        fs::create_dir(&self.tmp_file_path)?;

        let cache_path = &self.tmp_file_path.join("plugin.zip");
        match File::create(&cache_path) {
            Err(why) => panic!("couldn't create {}", why),
            Ok(mut file) => {
                let content = response.bytes()?;
                file.write_all(&content)?;
                let file = OpenOptions::new()
                    .write(true)
                    .read(true)
                    .open(&cache_path)
                    .unwrap();
                let mut zip_archive = zip::ZipArchive::new(file).unwrap();
                zip::ZipArchive::extract(&mut zip_archive, &self.tmp_file_path)?;
                let root_folder_name = zip_archive.by_index(0).unwrap().name().to_string();

                let files = zip_archive
                    .file_names()
                    .map(std::string::ToString::to_string)
                    .collect::<Vec<String>>();

                self.move_files(&root_folder_name);
                Ok(files)
            }
        }
    }

    pub fn delete(&self, files: &[String]) -> Result<(), Box<dyn Error>> {
        let root_name = files[0].split('/').next().unwrap();
        for file in files {
            let path = self.plugins_dir.join(file);
            if let Ok(md) = metadata(&path) {
                if md.is_dir() {
                    fs::remove_dir_all(&path)?;
                } else {
                    fs::remove_file(&path)?;
                }
            }
        }

        if self.plugins_dir.read_dir()?.next().is_none() {
            fs::remove_dir_all(&self.plugins_dir.join(root_name))?;
        }

        Ok(())
    }

    fn move_files(&self, folder_name: &str) {
        let tmp_folder = fs::read_dir(&self.tmp_file_path.join(&folder_name)).unwrap();
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
                let options = fs_extra::file::CopyOptions::new();
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
        let backup_path = &self.plugins_dir.join("PluginsBackup");

        if !backup_path.exists() {
            create_dir(&backup_path).unwrap();
        }

        let options = CopyOptions::new();

        let system_time = SystemTime::now();
        let datetime: DateTime<Utc> = system_time.into();
        let datetime = datetime.format("%Y_%m_%d_%H%M%S").to_string();

        let tmp_backup_path = &backup_path.join(format!("{}_backup", datetime));
        create_dir(&tmp_backup_path).unwrap();

        copy(&self.plugins_dir, &tmp_backup_path, &options).unwrap();
    }
}

#[cfg(test)]
mod tests {}
