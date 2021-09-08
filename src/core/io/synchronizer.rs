use super::api_connector::APIOperations;
use super::cache;
use super::plugin_parser::PluginCompendium;
use crate::core::io::{APIConnector, PluginParser};
use crate::core::{Config, Plugin};
use globset::{Glob, GlobMatcher};
use log::{debug, error};
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
        let folder_plugins = Synchronizer::search_local(plugins_dir).unwrap();

        Synchronizer::compare_local_state(&folder_plugins, db_file, feed_url).await;

        Ok(())
    }

    pub async fn compare_local_state(
        local_plugins: &HashMap<String, PluginCompendium>,
        db_file: &str,
        feed_url: &str,
    ) {
        match APIConnector::fetch_plugins(feed_url.to_string()).await {
            Ok(remote_plugins) => {
                Synchronizer::successful_plugin_retrieval(local_plugins, &remote_plugins, db_file);
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

    fn successful_plugin_retrieval(
        local_plugins: &HashMap<String, PluginCompendium>,
        remote_plugins: &HashMap<String, Plugin>,
        db_file: &str,
    ) {
        for key in local_plugins.keys() {
            if remote_plugins.contains_key(key) {
                let remote_plugin = remote_plugins.get(key).unwrap();
                if local_plugins.contains_key(&remote_plugin.title.to_lowercase().replace(" ", ""))
                {
                    let local_plugin = local_plugins
                        .get(&remote_plugin.title.to_lowercase().replace(" ", ""))
                        .unwrap();
                    cache::insert_plugin(
                        &cache::Item::new(
                            remote_plugin.plugin_id,
                            &remote_plugin.title,
                            &remote_plugin.description,
                            &local_plugin.version,
                            &remote_plugin.latest_version,
                            &remote_plugin.download_url,
                        ),
                        db_file,
                    )
                    .unwrap();
                    debug!(
                        "{}",
                        format!("Cached remote plugin {}", &remote_plugin.title)
                    );
                } else {
                    cache::insert_plugin(
                        &cache::Item::new(
                            remote_plugin.plugin_id,
                            &remote_plugin.title,
                            &remote_plugin.description,
                            "",
                            &remote_plugin.latest_version,
                            &remote_plugin.download_url,
                        ),
                        db_file,
                    )
                    .unwrap();
                    debug!(
                        "{}",
                        format!("Cached remote plugin {}", &remote_plugin.title)
                    );
                }
            } else {
                let local_plugin = local_plugins.get(key).unwrap();

                cache::insert_plugin(
                    &cache::Item::new(
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
                debug!("{}", format!("Cached local plugin {}", &local_plugin.name));
            }
        }
    }

    pub fn search_local(
        plugins_dir: &str,
    ) -> Result<HashMap<String, PluginCompendium>, Box<dyn Error>> {
        let mut local_plugins = HashMap::new();
        let primary_glob = Glob::new("*.plugincompendium")?.compile_matcher();
        let secondary_glob = Glob::new("*.plugin")?.compile_matcher();

        for entry in read_dir(Path::new(&plugins_dir))? {
            let direcorty_path = Path::new(&plugins_dir).join(entry.unwrap().path());
            if direcorty_path.is_dir() {
                Synchronizer::check_directory(
                    &mut local_plugins,
                    &direcorty_path,
                    &primary_glob,
                    &secondary_glob,
                );
            }
        }

        Ok(local_plugins)
    }

    fn check_directory(
        local_plugins: &mut HashMap<String, PluginCompendium>,
        direcorty_path: &Path,
        primary_glob: &GlobMatcher,
        secondary_glob: &GlobMatcher,
    ) {
        let directory = read_dir(&direcorty_path.to_str().unwrap()).unwrap();

        // let paths: Vec<String> = directory
        //     .into_iter()
        //     .map(|element| element.unwrap().path().display().to_string())
        //     .collect();

        // let plugin_compendium_files = is_matching_glob(&paths, primary_glob);
        // let plugin_files = is_matching_glob(&paths, secondary_glob);

        // if !plugin_compendium_files.is_empty() {
        //     for element in plugin_compendium_files {
        //         debug!(
        //             "{}",
        //             format!("Found .plugincompendium file at {:?}", &element)
        //         );
        //         let xml_content = PluginParser::parse_compendium_file(&element);
        //         if !local_plugins.contains_key(&xml_content.name) {
        //             local_plugins.insert(xml_content.name.clone(), xml_content);
        //         }
        //     }
        // }
        // if !plugin_files.is_empty() {
        //     for element in plugin_files {
        //         debug!("{}", format!("Found .plugin file at {:?}", &element));
        //         let xml_content = PluginParser::parse_file(&element);
        //         if !local_plugins.contains_key(&xml_content.name) {
        //             local_plugins.insert(
        //                 xml_content.name.clone(),
        //                 PluginCompendium::new(
        //                     &format!("{} (unmaintained)", &xml_content.name),
        //                     &xml_content.version,
        //                     &xml_content.author,
        //                 ),
        //             );
        //         }
        //     }
        // }

        for file in directory {
            let path = file.unwrap().path();

            if !path.to_str().unwrap().to_lowercase().contains("loader")
                && !path.to_str().unwrap().to_lowercase().contains("demo")
                && primary_glob.is_match(&path)
            {
                debug!("{}", format!("Found .plugincompendium file at {:?}", &path));
                let xml_content = PluginParser::parse_compendium_file(&path);
                if !local_plugins.contains_key(&xml_content.name.to_lowercase().replace(" ", "")) {
                    local_plugins.insert(
                        xml_content.name.clone().to_lowercase().replace(" ", ""),
                        xml_content,
                    );
                }
            } else if !path.to_str().unwrap().to_lowercase().contains("loader")
                && !path.to_str().unwrap().to_lowercase().contains("demo")
                && secondary_glob.is_match(&path)
            {
                debug!("{}", format!("Found .plugin file at {:?}", &path));
                let xml_content = PluginParser::parse_file(&path);
                if !local_plugins.contains_key(&xml_content.name.to_lowercase().replace(" ", "")) {
                    local_plugins.insert(
                        xml_content.name.clone().to_lowercase().replace(" ", ""),
                        PluginCompendium::new(
                            &format!("{} (unmaintained)", &xml_content.name),
                            &xml_content.version,
                            &xml_content.author,
                        ),
                    );
                }
            } else if path.is_dir() {
                Synchronizer::check_directory(local_plugins, &path, primary_glob, secondary_glob);
            }
        }
    }
}

fn is_matching_glob1(paths: &[String], glob: &GlobMatcher) -> bool {
    paths.iter().any(|element| {
        glob.is_match(element)
            && !element.to_lowercase().contains("loader")
            && !element.to_lowercase().contains("demo")
    })
}

fn is_matching_glob<'a>(paths: &'a [std::string::String], glob: &GlobMatcher) -> Vec<&'a String> {
    paths
        .iter()
        .filter(|element| {
            glob.is_match(element)
                && !element.to_lowercase().contains("loader")
                && !element.to_lowercase().contains("demo")
        })
        .collect()
}

#[cfg(test)]
mod tests {
    use globset::Glob;

    use super::is_matching_glob;

    #[test]
    fn test_is_matching_glob_positive() {
        let glob = Glob::new("*.plugincompendium").unwrap().compile_matcher();
        let paths: Vec<String> = vec![
            String::from("Hello World"),
            String::from("hello.plugincompendium"),
        ];

        assert_eq!(is_matching_glob(&paths, &glob).len(), 1);
    }

    #[test]
    fn test_is_matching_glob_positive_multiple() {
        let glob = Glob::new("*.plugincompendium").unwrap().compile_matcher();
        let paths: Vec<String> = vec![
            String::from("Hello World"),
            String::from("hello.plugincompendium"),
            String::from("world.plugincompendium"),
        ];

        assert_eq!(is_matching_glob(&paths, &glob).len(), 2);
    }

    #[test]
    fn test_is_matching_glob_negative() {
        let glob = Glob::new("*.plugincompendium").unwrap().compile_matcher();
        let paths: Vec<String> = vec![String::from("Hello World"), String::from("hello.plugin")];

        assert_eq!(is_matching_glob(&paths, &glob).len(), 0);
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
