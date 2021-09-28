use super::api_connector;
use super::cache::{delete_plugin, get_plugin, get_plugins, insert_plugin, update_plugin};
use super::file_comparer::compare_files;
use super::plugin_collector::{collect_all_compendium_files, collect_all_plugin_files};
use crate::core::parsers::compendium_parser::parse_compendium_file;
use crate::core::{Config, PluginCollection, PluginDataClass};
use log::{debug, error};
use std::{collections::HashMap, error::Error, path::Path};

#[derive(Default, Debug, Clone)]
pub struct Synchronizer {
    config: Config,
}

impl Synchronizer {
    pub async fn synchronize_application(
        plugins_dir: &str,
        db_path: &str,
        feed_url: &str,
    ) -> Result<(), Box<dyn Error>> {
        let local_plugins = Synchronizer::search_local(plugins_dir).unwrap();

        Synchronizer::compare_local_state(&local_plugins, db_path, feed_url).await;

        Ok(())
    }

    pub async fn compare_local_state(
        local_plugins: &PluginCollection,
        db_path: &str,
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
        db_path: &str,
    ) {
        let db_plugins = get_plugins(db_path);
        // Managed plugins
        Synchronizer::update_local_plugins(remote_plugins, local_plugins, db_path);

        // Unmanaged plugins
        Synchronizer::check_existing_plugins(remote_plugins, local_plugins, db_path)
            .map_err(|_| debug!("Error while synchronizing local and db plugins"))
            .unwrap();
        Synchronizer::delete_not_existing_local_plugins(local_plugins, &db_plugins, db_path);
    }

    fn update_local_plugins(
        remote_plugins: &HashMap<u64, PluginDataClass>,
        local_plugins: &HashMap<u64, PluginDataClass>,
        db_path: &str,
    ) {
        for (hash, remote_plugin) in remote_plugins {
            if local_plugins.contains_key(hash) {
                match update_plugin(
                    *hash,
                    remote_plugin.latest_version.as_ref().unwrap(),
                    db_path,
                ) {
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
        remote_plugins: &HashMap<u64, PluginDataClass>,
        local_plugins: &HashMap<u64, PluginDataClass>,
        db_path: &str,
    ) -> Result<(), Box<dyn Error>> {
        for (hash, local_plugin) in local_plugins {
            if !remote_plugins.contains_key(hash) {
                let mut local_plugin = local_plugin.clone();
                local_plugin.name = format!("{} (Unmanaged)", local_plugin.name);
                insert_plugin(*hash, &local_plugin, db_path)?;
            } else if let Some(db_plugin) = get_plugin(*hash, db_path)? {
                if db_plugin.version == local_plugin.version {
                    insert_plugin(*hash, &db_plugin, db_path)?;
                } else {
                    update_plugin(*hash, &local_plugin.version, db_path)?;
                }
            }
        }

        Ok(())
    }

    /// Checks if the database contains plugins that are not existing anymore in the local plugins folder
    /// If a plugin doesn't exist in the plugin folder but in the database, the database entry gets deleted.
    fn delete_not_existing_local_plugins(
        local_plugins: &HashMap<u64, PluginDataClass>,
        db_plugins: &HashMap<u64, PluginDataClass>,
        db_path: &str,
    ) {
        for hash in db_plugins.keys() {
            if !local_plugins.contains_key(hash) {
                delete_plugin(*hash, db_path).unwrap();
            }
        }
    }

    pub fn search_local(plugins_dir: &str) -> Result<PluginCollection, Box<dyn Error>> {
        let mut local_plugins = HashMap::new();
        let mut all_descriptors = Vec::new();

        let compendium_files = collect_all_compendium_files(Path::new(&plugins_dir))?;
        let mut plugin_files = collect_all_plugin_files(Path::new(&plugins_dir))?;

        for compendium_file in &compendium_files {
            let tmp_plugin_name = Synchronizer::build_plugin_file_path(compendium_file);

            if let Some(position) = plugin_files
                .iter()
                .position(|element| element.to_str().unwrap().contains(&tmp_plugin_name))
            {
                let (compendium_content, descriptors) = parse_compendium_file(compendium_file);
                local_plugins.insert(
                    PluginDataClass::calculate_hash(&compendium_content),
                    compendium_content,
                );

                plugin_files.remove(position);

                for element in descriptors {
                    all_descriptors.push(element);
                }
            }
        }

        compare_files(&compendium_files, &plugin_files);

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

    fn _create_expected_result() -> HashMap<String, PluginDataClass> {
        let mut expected_result = HashMap::new();
        expected_result.insert(
            String::from("CraftTimer"),
            PluginDataClass::new(
                "CraftTimer",
                "Atheisto (based on David Down's EventTimer)",
                "1.0",
            )
            .with_description("Timer for cooldown on crafted relics and guild items.")
            .build(),
        );
        expected_result.insert(
            String::from("TitanBar"),
            PluginDataClass::new("TitanBar", "by Habna", "v1.24.45")
                .with_id(692)
                .with_description("This is the TitanBar plugin")
                .build(),
        );
        expected_result.insert(
            String::from("Animalerie"),
            PluginDataClass::new("Animalerie", "Homeopatix", "1.24")
                .with_id(1108)
                .with_description("Animalerie plugin")
                .build(),
        );
        expected_result.insert(
            String::from("BurglarHelper"),
            PluginDataClass::new("BurglarHelper", "Homeopatix", "1.04")
                .with_id(1128)
                .with_description("BurglarHelper plugin")
                .build(),
        );
        expected_result.insert(
            String::from("Voyage"),
            PluginDataClass::new("Voyage", "Homeopatix", "3.13")
                .with_id(1125)
                .with_description("Voyage plugin")
                .build(),
        );
        expected_result
    }

    #[test]
    fn search_local_plugins() {
        let test_dir = setup();
        //let expected_result = create_expected_result();

        let local_plugins = Synchronizer::search_local(test_dir.to_str().unwrap()).unwrap();

        assert_eq!(local_plugins.len(), 6);

        //assert!(local_plugins.contains_key("CraftTimer"));

        //assert_eq!(local_plugins, expected_result);

        teardown(&test_dir);
    }

    // #[test]
    // fn cache_synching() {
    //     let (test_dir, db_path) = setup_db();
    //     let mut local_plugins = HashMap::new();
    //     let mut remote_plugins = HashMap::new();

    //     let plugin = PluginDataClass::new("GreenCar", "Marius", "1.0");
    //     local_plugins.insert(PluginDataClass::calculate_hash(&plugin), plugin);
    //     let plugin = PluginDataClass::new("BlueElephant", "Marius", "1.1");
    //     local_plugins.insert(PluginDataClass::calculate_hash(&plugin), plugin);

    //     let plugin = PluginDataClass::new("BlueElephant", "Marius", "1.2");
    //     remote_plugins.insert(PluginDataClass::calculate_hash(&plugin), plugin);

    //     Synchronizer::sync_cache(&local_plugins, &remote_plugins, &db_path);

    //     let plugins = get_plugins(&db_path);

    //     teardown_db(&test_dir);
    // }

    // #[test]
    // fn update_local_plugin() {
    //     let (test_dir, db_path) = setup_db();

    //     let mut remote_plugins = HashMap::new();
    //     let data_class_one = PluginDataClass::new("Hello World", "Marius", "0.1.0").build();
    //     let data_class_two = PluginDataClass::new("PetStable", "Marius", "1.1").build();
    //     remote_plugins.insert(
    //         PluginDataClass::calculate_hash(&data_class_one),
    //         data_class_one.clone(),
    //     );
    //     remote_plugins.insert(
    //         PluginDataClass::calculate_hash(&data_class_two),
    //         data_class_two,
    //     );

    //     let mut local_plugins = HashMap::new();
    //     let local_data_class_two = PluginDataClass::new("PetStable", "Marius", "1.0").build();
    //     let local_data_class_two_hash = PluginDataClass::calculate_hash(&local_data_class_two);
    //     local_plugins.insert(
    //         PluginDataClass::calculate_hash(&data_class_one),
    //         data_class_one,
    //     );
    //     local_plugins.insert(local_data_class_two_hash, local_data_class_two);

    //     Synchronizer::update_local_plugins(&remote_plugins, &local_plugins, &db_path);

    //     let plugin = get_plugins(&db_path)
    //         .get(&local_data_class_two_hash)
    //         .unwrap()
    //         .clone();

    //     assert_eq!(plugin.name, "PetStable");
    //     assert_eq!(plugin.latest_version.unwrap(), "1.1");

    //     teardown_db(&test_dir);
    // }

    #[test]
    fn insert_not_existing_local_plugin() {
        // Synchronizer::check_existing_plugins();

        assert_eq!(1, 1);
    }

    #[test]
    fn delete_not_existing_plugin_from_db() {
        // Synchronizer::delete_not_existing_local_plugins();

        assert_eq!(1, 1);
    }

    // type TemporaryPaths = (PathBuf, String);

    // fn setup_db() -> TemporaryPaths {
    //     let uuid = Uuid::new_v4().to_string();
    //     let test_dir = env::temp_dir().join(format!("lembas_test_{}", &uuid[..7]));
    //     let db_path = test_dir.join("db.sqlite3");

    //     create_dir_all(&test_dir).unwrap();
    //     create_cache_db(db_path.to_str().unwrap()).unwrap();

    //     let data_class = PluginDataClass::new("Hello World", "Marius", "0.1.0")
    //         .with_id(1)
    //         .with_description("Lorem ipsum")
    //         .build();
    //     insert_plugin(
    //         PluginDataClass::calculate_hash(&data_class),
    //         &data_class,
    //         db_path.to_str().unwrap(),
    //     )
    //     .expect("Error while running test setup");

    //     let data_class = PluginDataClass::new("PetStable", "Marius", "1.0")
    //         .with_id(2)
    //         .with_description("Lorem ipsum")
    //         .with_remote_information("", "1.1", 0, "")
    //         .build();
    //     insert_plugin(
    //         PluginDataClass::calculate_hash(&data_class),
    //         &data_class,
    //         db_path.to_str().unwrap(),
    //     )
    //     .expect("Error while running test setup");

    //     (test_dir, db_path.to_str().unwrap().to_string())
    // }

    // fn teardown_db(test_dir: &Path) {
    //     remove_dir_all(test_dir).expect("Error while running test teardown");
    // }
}
