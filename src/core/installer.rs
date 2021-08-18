use chrono::offset::Utc;
use chrono::DateTime;
use dirs::home_dir;
use fs_extra::{
    self,
    dir::{copy, CopyOptions},
};
use std::{error::Error, fs::File};
use std::{fs, io::prelude::*};
use std::{fs::create_dir, time::SystemTime};
use std::{fs::metadata, path::Path};

pub struct Installer;

impl Installer {
    pub fn download(
        plugin_id: i32,
        plugin_title: &str,
        download_url: &str,
        plugins_dir: &str,
        cache_dir: &str,
        backup_enabled: bool,
    ) -> Result<(), Box<dyn Error>> {
        if backup_enabled {
            Self::back_plugin_folder(plugins_dir);
        }
        let response = reqwest::blocking::get(download_url)?;

        let tmp_file_path = Path::new(cache_dir).join(&format!("{}_{}", plugin_id, plugin_title));

        fs::create_dir(&tmp_file_path)?;

        let cache_path = Path::new(cache_dir)
            .join(&format!("{}_{}", plugin_id, plugin_title))
            .join("plugin.zip");
        match File::create(cache_path) {
            Err(why) => panic!("couldn't create {}", why),
            Ok(mut file) => {
                let content = response.bytes()?;
                file.write_all(&content)?;
                let mut zip_archive = zip::ZipArchive::new(file)?;

                let root_folder_name = zip_archive.by_index(0).unwrap().name();

                zip::ZipArchive::extract(&mut zip_archive, Path::new(&tmp_file_path))?;

                Self::move_files(
                    tmp_file_path.to_str().unwrap(),
                    root_folder_name,
                    plugins_dir,
                );
            }
        };
        Ok(())
    }

    pub fn delete(name: &str, files: &[String], plugins_dir: &str) -> Result<(), Box<dyn Error>> {
        for file in files {
            let path = Path::new(&plugins_dir).join(name).join(file);
            let md = metadata(&path).unwrap();
            if md.is_dir() {
                fs::remove_dir_all(&path)?;
            } else {
                fs::remove_file(Path::new(&path))?;
            }
        }

        if Path::new(&plugins_dir)
            .join(name)
            .read_dir()?
            .next()
            .is_none()
        {
            fs::remove_dir_all(Path::new(&plugins_dir).join(name))?;
        }

        Ok(())
    }

    fn move_files(tmp_path: &str, folder_name: &str, plugins_dir: &str) {
        let tmp_folder = fs::read_dir(&Path::new(tmp_path).join(&folder_name)).unwrap();
        fs::remove_file(&Path::new(tmp_path).join("plugin.zip")).unwrap();

        if !Path::new(&plugins_dir).join(&folder_name).exists() {
            fs::create_dir_all(Path::new(&plugins_dir).join(&folder_name)).unwrap();
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
                    Path::new(&plugins_dir).join(folder_name),
                    &options,
                )
                .unwrap();
            } else {
                let mut options = fs_extra::file::CopyOptions::new();
                options.overwrite = true;
                fs_extra::file::move_file(
                    Path::new(tmp_path).join(&folder_name).join(&file_str),
                    Path::new(&plugins_dir).join(&folder_name).join(&file_str),
                    &options,
                )
                .unwrap();
            }
        }
    }

    pub fn delete_cache_folder(plugin_id: i32, plugin_title: &str, cache_dir: &str) {
        let tmp_file_path = Path::new(&cache_dir).join(format!("{}_{}", plugin_id, plugin_title));

        fs::remove_dir_all(tmp_file_path).unwrap();
    }

    fn back_plugin_folder(plugins_dir: &str) {
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

        let tmp_backup_path = Path::new(&backup_path).join(format!("{}_backup", datetime));
        create_dir(&tmp_backup_path).unwrap();

        copy(&plugins_dir, &tmp_backup_path, &options).unwrap();
    }
}

#[cfg(test)]
mod tests {}
