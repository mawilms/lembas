use super::api_connector::APIOperations;
use super::cache;
use super::plugin_parser::PluginCompendium;
use crate::core::io::{APIConnector, PluginParser};
use crate::core::Config;
use globset::Glob;
use std::fs::metadata;
use std::path::MAIN_SEPARATOR;
use std::{collections::HashMap, error::Error, fs::read_dir, path::Path};

#[derive(Default, Debug, Clone)]
pub struct Synchronizer {
    config: Config,
}

impl Synchronizer {
    pub async fn synchronize_application(
        plugins_dir: &str,
        db_file: &str,
        feed_url: &str,
    ) -> Result<(), Box<dyn Error>> {
        let local_plugins = Synchronizer::search_local(plugins_dir).unwrap();
        let local_db_plugins = cache::get_plugins(db_file);

        Synchronizer::compare_local_state(
            &local_plugins,
            &local_db_plugins,
            plugins_dir,
            db_file,
            feed_url,
        )
        .await;

        Ok(())
    }

    pub async fn compare_local_state(
        local_plugins: &HashMap<String, PluginCompendium>,
        db_plugins: &HashMap<String, cache::CacheItem>,
        plugins_dir: &str,
        db_file: &str,
        feed_url: &str,
    ) {
        match APIConnector::fetch_plugins(feed_url.to_string()).await {
            Ok(remote_plugins) => {
                for (key, element) in local_plugins {
                    if db_plugins.contains_key(key) {
                        if remote_plugins.contains_key(key) {
                            let local_plugin = db_plugins.get(key).unwrap();
                            if local_plugin.latest_version
                                != remote_plugins.get(key).unwrap().latest_version
                            {
                                cache::update_plugin(
                                    &local_plugin.title,
                                    &remote_plugins.get(key).unwrap().latest_version,
                                    db_file,
                                )
                                .unwrap();
                            }
                        } else {
                            cache::update_plugin(&db_plugins.get(key).unwrap().title, "", db_file)
                                .unwrap();
                        }
                    } else {
                        let mut description = String::new();
                        if !&local_plugins
                            .get(key)
                            .unwrap()
                            .plugin_file_location
                            .is_empty()
                        {
                            let information = PluginParser::parse_file(
                                Path::new(&plugins_dir).join(
                                    &local_plugins
                                        .get(key)
                                        .unwrap()
                                        .plugin_file_location
                                        .replace("\\", &MAIN_SEPARATOR.to_string()),
                                ),
                            );
                            description = information.description;
                        }
                        if remote_plugins.contains_key(key) {
                            let remote_plugin = remote_plugins.get(key).unwrap();
                            cache::insert_plugin(
                                &cache::CacheItem::new(
                                    remote_plugin.plugin_id,
                                    &remote_plugin.title,
                                    &remote_plugin.description,
                                    &remote_plugin.current_version,
                                    &remote_plugin.latest_version,
                                    &remote_plugin.download_url,
                                ),
                                db_file,
                            )
                            .unwrap();
                        } else {
                            let local_plugin = local_plugins.get(key).unwrap();
                            cache::insert_plugin(
                                &cache::CacheItem::new(
                                    local_plugin.id,
                                    &local_plugin.name,
                                    "",
                                    &local_plugin.version,
                                    "",
                                    &local_plugin.download_url,
                                ),
                                db_file,
                            )
                            .unwrap();
                        }
                    }
                }
            }
            Err(_) => todo!(),
        };

        for (key, element) in db_plugins {
            if !local_plugins.contains_key(key) {
                cache::delete_plugin(&element.title, db_file).unwrap();
            }
        }
    }

    pub fn search_local(
        plugins_dir: &str,
    ) -> Result<HashMap<String, PluginCompendium>, Box<dyn Error>> {
        let mut local_plugins = HashMap::new();
        let glob = Glob::new("*.plugincompendium")?.compile_matcher();

        for entry in read_dir(Path::new(&plugins_dir))? {
            let direcorty_path = Path::new(&plugins_dir).join(entry.unwrap().path());
            if metadata(&direcorty_path).unwrap().is_dir() {
                let directory = read_dir(&direcorty_path.to_str().unwrap());

                for file in directory? {
                    let path = file?.path();
                    if !path.to_str().unwrap().to_lowercase().contains("loader")
                        && glob.is_match(&path)
                    {
                        let xml_content = PluginParser::parse_compendium_file(&path);
                        local_plugins.insert(xml_content.name.clone(), xml_content);
                    }
                }
            }
        }

        Ok(local_plugins)
    }
}

// #[cfg(test)]
// mod tests {
//     use super::{Plugin, Synchronizer};
//     use std::{
//         fs::{create_dir_all, remove_dir_all},
//         path::PathBuf,
//     };

//     #[test]
//     fn insert_plugin_succesful() {
//         let test_directory = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
//             .join("tests")
//             .join("environment");
//         let plugins_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
//             .join("tests")
//             .join("samples");
//         let db_file = test_directory.join("db.sqlite3");

//         // Setup
//         create_dir_all(&test_directory).unwrap();
//         Synchronizer::create_plugins_db(test_directory.join("db.sqlite3").to_str().unwrap());

//         let plugin = Plugin::new(
//             1108,
//             "Animalerie",
//             "Test",
//             "Lore-Master",
//             "1.24",
//             "1.24",
//             "Homeopatix",
//         );

//         Synchronizer::insert_plugin(
//             plugin,
//             plugins_dir.to_str().unwrap(),
//             db_file.to_str().unwrap(),
//         )
//         .unwrap();
//         let result = Synchronizer::get_plugins(db_file.to_str().unwrap());

//         assert_eq!(result.len(), 1);
//         assert!(result.contains_key("Animalerie"));

//         // Teardown
//         remove_dir_all(test_directory).unwrap();
//     }

//     #[test]
//     fn insert_plugin_failure() {
//         println!("Bla");
//         let test_directory = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
//             .join("tests")
//             .join("environment");
//         println!("{:?}", test_directory);
//         let plugins_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
//             .join("tests")
//             .join("samples");
//         let db_file = test_directory.join("db.sqlite3");

//         // Setup
//         create_dir_all(&test_directory).unwrap();
//         Synchronizer::create_plugins_db(test_directory.join("db.sqlite3").to_str().unwrap());

//         let plugin = Plugin::new(
//             1108,
//             "Hello World",
//             "Test",
//             "Lore-Master",
//             "1.24",
//             "1.24",
//             "Homeopatix",
//         );

//         Synchronizer::insert_plugin(
//             plugin,
//             plugins_dir.to_str().unwrap(),
//             db_file.to_str().unwrap(),
//         )
//         .unwrap();
//         let result = Synchronizer::get_plugins(db_file.to_str().unwrap());

//         assert_eq!(result.len(), 0);

//         // Teardown
//         remove_dir_all(test_directory).unwrap();
//         println!("Blagjghj");
//     }

//     #[test]
//     fn update() {
//         let test_directory = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
//             .join("tests")
//             .join("environment");
//         let plugins_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
//             .join("tests")
//             .join("samples");
//         let db_file = test_directory.join("db.sqlite3");

//         // Setup
//         create_dir_all(&test_directory).unwrap();
//         Synchronizer::create_plugins_db(test_directory.join("db.sqlite3").to_str().unwrap());

//         let plugin = Plugin::new(
//             1108,
//             "Animalerie",
//             "Test",
//             "Lore-Master",
//             "1.24",
//             "1.24",
//             "Homeopatix",
//         );

//         Synchronizer::insert_plugin(
//             plugin,
//             plugins_dir.to_str().unwrap(),
//             db_file.to_str().unwrap(),
//         )
//         .unwrap();
//         Synchronizer::update_plugin("Animalerie", "1.25", db_file.to_str().unwrap()).unwrap();
//         let result = Synchronizer::get_plugins(db_file.to_str().unwrap());
//         assert_eq!(result.len(), 1);
//         assert_eq!(result.get("Animalerie").unwrap().latest_version, "1.25");

//         // Teardown
//         remove_dir_all(test_directory).unwrap();
//     }

//     #[test]
//     fn delete() {
//         let test_directory = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
//             .join("tests")
//             .join("environment");
//         let plugins_dir = PathBuf::from(env!("CARGO_MANIFEST_DIR"))
//             .join("tests")
//             .join("samples");
//         let db_file = test_directory.join("db.sqlite3");

//         // Setup
//         create_dir_all(&test_directory).unwrap();
//         Synchronizer::create_plugins_db(test_directory.join("db.sqlite3").to_str().unwrap());

//         let plugin = Plugin::new(
//             1108,
//             "Animalerie",
//             "Test",
//             "Lore-Master",
//             "1.24",
//             "1.24",
//             "Homeopatix",
//         );

//         Synchronizer::insert_plugin(
//             plugin,
//             plugins_dir.to_str().unwrap(),
//             db_file.to_str().unwrap(),
//         )
//         .unwrap();
//         Synchronizer::delete_plugin("Animalerie", db_file.to_str().unwrap()).unwrap();
//         let result = Synchronizer::get_plugins(db_file.to_str().unwrap());

//         assert_eq!(result.len(), 0);

//         // Teardown
//         remove_dir_all(test_directory).unwrap();
//     }
// }
