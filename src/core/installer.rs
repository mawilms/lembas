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
};
use std::{fs, io::prelude::*};
use std::{fs::create_dir, time::SystemTime};
use std::{fs::metadata, path::Path};

pub struct Installer;

impl Installer {
    pub fn download(
        plugin_id: i32,
        plugin_title: &str,
        download_url: &str,
        plugins_dir: &Path,
        cache_dir: &Path,
        backup_enabled: bool,
    ) -> Result<Vec<String>, Box<dyn Error>> {
        if backup_enabled {
            Self::back_plugin_folder(plugins_dir);
        }
        let response = reqwest::blocking::get(download_url)?;

        let tmp_file_path = cache_dir.join(&format!("{}_{}", plugin_id, plugin_title));

        fs::create_dir(&tmp_file_path)?;

        let cache_path = cache_dir
            .join(&format!("{}_{}", plugin_id, plugin_title))
            .join("plugin.zip");
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
                zip::ZipArchive::extract(&mut zip_archive, &tmp_file_path)?;
                let root_folder_name = zip_archive.by_index(0).unwrap().name().to_string();

                let files = zip_archive
                    .file_names()
                    .map(std::string::ToString::to_string)
                    .collect::<Vec<String>>();

                Self::move_files(&tmp_file_path, &root_folder_name, plugins_dir);
                Ok(files)
            }
        }
    }

    pub fn delete(files: &[String], plugins_dir: &Path) -> Result<(), Box<dyn Error>> {
        let root_name = files[0].split('/').next().unwrap();
        for file in files {
            let path = plugins_dir.join(file);
            if let Ok(md) = metadata(&path) {
                if md.is_dir() {
                    fs::remove_dir_all(&path)?;
                } else {
                    fs::remove_file(&path)?;
                }
            }
        }

        if plugins_dir.read_dir()?.next().is_none() {
            fs::remove_dir_all(&plugins_dir.join(root_name))?;
        }

        Ok(())
    }

    fn move_files(tmp_path: &Path, folder_name: &str, plugins_dir: &Path) {
        let tmp_folder = fs::read_dir(&tmp_path.join(&folder_name)).unwrap();
        fs::remove_file(&tmp_path.join("plugin.zip")).unwrap();

        if !&plugins_dir.join(&folder_name).exists() {
            fs::create_dir_all(&plugins_dir.join(&folder_name)).unwrap();
        }

        for file in tmp_folder {
            let file_str = file.unwrap().file_name().into_string().unwrap();

            let md = metadata(&tmp_path.join(&folder_name).join(&file_str)).unwrap();
            if md.is_dir() {
                let mut options = fs_extra::dir::CopyOptions::new();
                options.overwrite = true;
                options.copy_inside = true;
                fs_extra::dir::move_dir(
                    &tmp_path.join(&folder_name).join(&file_str),
                    &plugins_dir.join(folder_name),
                    &options,
                )
                .unwrap();
            } else {
                let mut options = fs_extra::file::CopyOptions::new();
                options.overwrite = true;
                fs_extra::file::move_file(
                    &tmp_path.join(&folder_name).join(&file_str),
                    &plugins_dir.join(&folder_name).join(&file_str),
                    &options,
                )
                .unwrap();
            }
        }
    }

    pub fn delete_cache_folder(plugin_id: i32, plugin_title: &str, cache_dir: &Path) {
        let tmp_file_path = cache_dir.join(format!("{}_{}", plugin_id, plugin_title));

        fs::remove_dir_all(tmp_file_path).unwrap();
    }

    fn back_plugin_folder(plugins_dir: &Path) {
        let backup_path = home_dir()
            .expect("Couldn't find your home directory")
            .join("Documents")
            .join("The Lord of the Rings Online")
            .join("PluginsBackup");

        if !backup_path.exists() {
            create_dir(&backup_path).unwrap();
        }

        let options = CopyOptions::new();

        let system_time = SystemTime::now();
        let datetime: DateTime<Utc> = system_time.into();
        let datetime = datetime.format("%Y_%m_%d_%H%M%S").to_string();

        let tmp_backup_path = &backup_path.join(format!("{}_backup", datetime));
        create_dir(&tmp_backup_path).unwrap();

        copy(&plugins_dir, &tmp_backup_path, &options).unwrap();
    }
}

#[cfg(test)]
mod tests {}
