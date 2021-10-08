use super::api_connector;
use super::cache::{delete_plugin, get_plugin, get_plugins, insert_plugin};
use super::file_comparer::compare_files;
use super::plugin_collector::{collect_all_compendium_files, collect_all_plugin_files};
use crate::core::parsers::compendium_parser::parse_compendium_file;
use crate::core::parsers::plugin_parser::parse_plugin_file;
use crate::core::{is_not_existing_in_blacklist, Config, PluginCollection, PluginDataClass};
use log::{debug, error};
use std::path::PathBuf;
use std::{collections::HashMap, error::Error, path::Path};

#[derive(Default, Debug, Clone)]
pub struct Synchronizer {
    config: Config,
}

impl Synchronizer {
    pub async fn synchronize_application(
        plugins_dir: &PathBuf,
        db_path: &PathBuf,
        feed_url: &str,
    ) -> Result<(), Box<dyn Error>> {
        let local_plugins = Synchronizer::search_local(plugins_dir).unwrap();

        Synchronizer::compare_local_state(&local_plugins, db_path, feed_url).await;

        Ok(())
    }

    pub async fn compare_local_state(
        local_plugins: &PluginCollection,
        db_path: &PathBuf,
        feed_url: &str,
    ) {
        match api_connector::fetch_plugins(feed_url.to_string()).await {
            Ok(remote_plugins) => {
                Synchronizer::sync_cache(local_plugins, &remote_plugins, db_path);
            }
            Err(_) => {
                error!(
                    "{}",
                    format!(
                        "Couldn't fetch plugins with the given feed url: {}",
                        feed_url
                    )
                );
            }
        };
    }

    fn sync_cache(
        local_plugins: &PluginCollection,
        remote_plugins: &PluginCollection,
        db_path: &PathBuf,
    ) {
        let db_plugins = get_plugins(db_path);
        // Managed plugins
        Synchronizer::update_local_plugins(remote_plugins, local_plugins, db_path);

        // Unmanaged plugins
        Synchronizer::check_existing_plugins(remote_plugins, local_plugins, db_path).unwrap();

        Synchronizer::delete_not_existing_local_plugins(local_plugins, &db_plugins, db_path);
    }

    fn update_local_plugins(
        remote_plugins: &HashMap<String, PluginDataClass>,
        local_plugins: &HashMap<String, PluginDataClass>,
        db_path: &PathBuf,
    ) {
        for (title, remote_plugin) in remote_plugins {
            if local_plugins.contains_key(title) && is_not_existing_in_blacklist(title) {
                match insert_plugin(remote_plugin, db_path) {
                    Ok(_) => {
                        debug!("Local plugin {} updated", remote_plugin.name);
                    }
                    Err(_) => {
                        debug!("Error while updating local plugin {}", remote_plugin.name);
                    }
                }
            }
        }
    }

    /// Checks if local plugins exist in the database. If they exist and their versions are different,
    /// the versions are updated. If they don't exist the missing plugin is inserted.
    fn check_existing_plugins(
        remote_plugins: &HashMap<String, PluginDataClass>,
        local_plugins: &HashMap<String, PluginDataClass>,
        db_path: &PathBuf,
    ) -> Result<(), Box<dyn Error>> {
        for (title, local_plugin) in local_plugins {
            if !remote_plugins.contains_key(title) && is_not_existing_in_blacklist(title) {
                insert_plugin(local_plugin, db_path)?;
            } else if let Some(db_plugin) = get_plugin(&local_plugin.name, db_path)? {
                insert_plugin(&db_plugin, db_path)?;
            }
        }

        Ok(())
    }

    /// Checks if the database contains plugins that are not existing anymore in the local plugins folder
    /// If a plugin doesn't exist in the plugin folder but in the database, the database entry gets deleted.
    fn delete_not_existing_local_plugins(
        local_plugins: &HashMap<String, PluginDataClass>,
        db_plugins: &HashMap<String, PluginDataClass>,
        db_path: &PathBuf,
    ) {
        for keys in db_plugins.keys() {
            if !local_plugins.contains_key(keys) {
                delete_plugin(keys, db_path).unwrap();
            }
        }
    }

    pub fn search_local(plugins_dir: &PathBuf) -> Result<PluginCollection, Box<dyn Error>> {
        let mut local_plugins = HashMap::new();

        let compendium_files = collect_all_compendium_files(Path::new(&plugins_dir))?;
        let mut plugin_files = collect_all_plugin_files(Path::new(&plugins_dir))?;

        for compendium_file in &compendium_files {
            let tmp_plugin_name = Synchronizer::build_plugin_file_path(compendium_file);

            if let Some(position) = plugin_files
                .iter()
                .position(|element| element.to_str().unwrap().contains(&tmp_plugin_name))
            {
                let compendium_content = parse_compendium_file(compendium_file);
                local_plugins.insert(compendium_content.name.clone(), compendium_content);

                plugin_files.remove(position);
            }
        }

        plugin_files = compare_files(&compendium_files, &plugin_files);
        for plugin_file_path in plugin_files {
            let plugin = parse_plugin_file(&plugin_file_path);
            local_plugins.insert(plugin.name.clone(), plugin);
        }

        Ok(local_plugins)
    }

    fn build_plugin_file_path(path: &Path) -> String {
        let mut path = path.to_path_buf();
        path.set_extension("plugin");
        path.file_name().unwrap().to_str().unwrap().to_string()
    }
}

#[cfg(test)]
mod tests {
    use super::*;
    use crate::core::{
        io::cache::{create_cache_db, get_plugins, insert_plugin},
        PluginDataClass,
    };
    use fs_extra::dir::{copy, CopyOptions};
    use std::{
        collections::HashMap,
        env,
        fs::{create_dir_all, read_dir, remove_dir_all},
        path::{Path, PathBuf},
    };
    use uuid::Uuid;

    fn setup() -> PathBuf {
        // Create plugins directory and move items from the samples to this directory to test functionality
        let uuid = Uuid::new_v4().to_string();
        let plugins_dir = env::temp_dir().join(format!("lembas_test_{}", &uuid[..7]));
        let samples_path = Path::new("tests/samples/plugin_folders");
        let samples_content = read_dir(samples_path).unwrap();

        create_dir_all(&plugins_dir).unwrap();
        let options = CopyOptions::new();

        for element in samples_content {
            copy(element.unwrap().path(), &plugins_dir, &options)
                .expect("Error while running setup method");
        }

        plugins_dir
    }

    fn teardown(test_dir: &Path) {
        remove_dir_all(test_dir).expect("Error while running teardown method");
    }

    #[test]
    fn search_local_plugins() {
        let test_dir = setup();

        let local_plugins = Synchronizer::search_local(&test_dir).unwrap();

        assert_eq!(local_plugins.len(), 7);

        teardown(&test_dir);
    }

    #[test]
    fn cache_synching() {
        let (test_dir, db_path) = setup_db();
        let mut local_plugins = HashMap::new();
        let mut remote_plugins = HashMap::new();

        let plugin = PluginDataClass::new("GreenCar", "Marius", "1.0");
        local_plugins.insert(plugin.name.clone(), plugin);
        let plugin = PluginDataClass::new("BlueElephant", "Marius", "1.1");
        local_plugins.insert(plugin.name.clone(), plugin);

        let plugin = PluginDataClass::new("BlueElephant", "Marius", "1.2")
            .with_remote_information("", "1.2", 0, "");

        let remote_plugin_name = plugin.name.clone();
        remote_plugins.insert(remote_plugin_name.clone(), plugin);

        Synchronizer::sync_cache(&local_plugins, &remote_plugins, &db_path);

        get_plugins(&db_path);

        assert!(remote_plugins.contains_key(&remote_plugin_name));
        assert_eq!(
            remote_plugins.get(&remote_plugin_name).unwrap().version,
            "1.2"
        );

        teardown_db(&test_dir);
    }

    #[test]
    fn update_local_plugin() {
        let (test_dir, db_path) = setup_db();

        let mut remote_plugins = HashMap::new();
        let data_class_one = PluginDataClass::new("Hello World", "Marius", "0.1.0")
            .with_remote_information("", "0.1.0", 0, "")
            .build();
        let data_class_two = PluginDataClass::new("PetStable", "Marius", "1.1")
            .with_remote_information("", "1.1", 0, "")
            .build();
        remote_plugins.insert(data_class_one.name.clone(), data_class_one.clone());
        remote_plugins.insert(data_class_two.name.clone(), data_class_two);

        let mut local_plugins = HashMap::new();
        let local_data_class_two = PluginDataClass::new("PetStable", "Marius", "1.0").build();

        local_plugins.insert(data_class_one.name.clone(), data_class_one);
        local_plugins.insert(
            local_data_class_two.name.clone(),
            local_data_class_two.clone(),
        );

        Synchronizer::update_local_plugins(&remote_plugins, &local_plugins, &db_path);

        let plugin = get_plugins(&db_path)
            .get(&local_data_class_two.name)
            .unwrap()
            .clone();

        assert_eq!(plugin.name, "PetStable");
        assert_eq!(plugin.latest_version.unwrap(), "1.1");

        teardown_db(&test_dir);
    }

    #[test]
    fn insert_not_existing_local_plugin() {
        let (test_dir, db_path) = setup_db();

        let mut remote_plugins = HashMap::new();
        let data_class_one = PluginDataClass::new("Hello World", "Marius", "0.1.0")
            .with_remote_information("", "0.1.0", 0, "")
            .build();
        let data_class_two = PluginDataClass::new("PetStable", "Marius", "1.1")
            .with_remote_information("", "1.1", 0, "")
            .build();
        remote_plugins.insert(data_class_one.name.clone(), data_class_one.clone());
        remote_plugins.insert(data_class_two.name.clone(), data_class_two);

        let mut local_plugins = HashMap::new();
        let local_data_class_two = PluginDataClass::new("PetStable", "Marius", "1.0").build();

        local_plugins.insert(data_class_one.name.clone(), data_class_one);
        local_plugins.insert(
            local_data_class_two.name.clone(),
            local_data_class_two.clone(),
        );

        Synchronizer::check_existing_plugins(&remote_plugins, &local_plugins, &db_path).unwrap();

        let plugin = get_plugins(&db_path)
            .get(&local_data_class_two.name)
            .unwrap()
            .clone();

        assert_eq!(plugin.name, "PetStable");
        assert_eq!(plugin.latest_version.unwrap(), "1.1");

        teardown_db(&test_dir);
    }

    #[test]
    fn delete_not_existing_plugin_from_db() {
        let (test_dir, db_path) = setup_db();

        let mut local_plugins = HashMap::new();
        let data_class_one = PluginDataClass::new("Hello World", "Marius", "0.1.0")
            .with_remote_information("", "0.1.0", 0, "")
            .build();
        let local_data_class_two = PluginDataClass::new("PetStable", "Marius", "1.0").build();
        let local_data_class_two_hash = local_data_class_two.name;
        local_plugins.insert(data_class_one.name.clone(), data_class_one);

        let db_plugins = get_plugins(&db_path);

        Synchronizer::delete_not_existing_local_plugins(&local_plugins, &db_plugins, &db_path);

        let plugins = get_plugins(&db_path);

        assert!(!plugins.contains_key(&local_data_class_two_hash));
        teardown_db(&test_dir);
    }

    type TemporaryPaths = (PathBuf, PathBuf);

    fn setup_db() -> TemporaryPaths {
        let uuid = Uuid::new_v4().to_string();
        let test_dir = env::temp_dir().join(format!("lembas_test_{}", &uuid[..7]));
        let db_path = test_dir.join("db.sqlite3");

        create_dir_all(&test_dir).unwrap();
        create_cache_db(&db_path).unwrap();

        let data_class = PluginDataClass::new("Hello World", "Marius", "0.1.0")
            .with_id(1)
            .with_description("Lorem ipsum")
            .build();
        insert_plugin(&data_class, &db_path).expect("Error while running test setup");

        let data_class = PluginDataClass::new("PetStable", "Marius", "1.0")
            .with_id(2)
            .with_description("Lorem ipsum")
            .with_remote_information("", "1.1", 0, "")
            .build();
        insert_plugin(&data_class, &db_path).expect("Error while running test setup");

        (test_dir, db_path)
    }

    fn teardown_db(test_dir: &Path) {
        remove_dir_all(test_dir).expect("Error while running test teardown");
    }
}
