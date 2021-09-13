use super::api_connector::APIOperations;
use super::cache;
use crate::core::io::{APIConnector, PluginParser};
use crate::core::{Config, Plugin, PluginDataClass};
use globset::{Glob, GlobMatcher};
use log::{debug, error};
use std::fs::metadata;
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
        local_plugins: &HashMap<String, PluginDataClass>,
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
        local_plugins: &HashMap<String, PluginDataClass>,
        remote_plugins: &HashMap<String, Plugin>,
        db_file: &str,
    ) {
        for key in local_plugins.keys() {
            if remote_plugins.contains_key(key) {
                let remote_plugin = remote_plugins.get(key).unwrap();
                if local_plugins.contains_key(&remote_plugin.title) {
                    let local_plugin = local_plugins.get(&remote_plugin.title).unwrap();
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
                            &remote_plugin.current_version,
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
            }
        }
    }

    pub fn search_local(
        plugins_dir: &str,
    ) -> Result<HashMap<String, PluginDataClass>, Box<dyn Error>> {
        let mut local_plugins = HashMap::new();
        let primary_glob = Glob::new("*.plugincompendium")?.compile_matcher();
        let secondary_glob = Glob::new("*.plugin")?.compile_matcher();

        for entry in read_dir(Path::new(&plugins_dir))? {
            let direcorty_path = Path::new(&plugins_dir).join(entry.unwrap().path());
            if metadata(&direcorty_path).unwrap().is_dir() {
                let directory = read_dir(&direcorty_path.to_str().unwrap());

                for file in directory? {
                    let path = file?.path();

                    if Synchronizer::is_plugin_compendium_file(&path, &primary_glob) {
                        let xml_content = PluginParser::parse_compendium_file(&path);
                        local_plugins.insert(xml_content.name.clone(), xml_content);

                        debug!("{}", format!("Found .plugincompendium file at {:?}", &path));
                    } else if Synchronizer::is_plugin_file(&path, &secondary_glob) {
                        let xml_content = PluginParser::parse_file(&path);
                        local_plugins.insert(xml_content.name.clone(), xml_content);

                        debug!("{}", format!("Found .plugin file at {:?}", &path));
                    }
                }
            }
        }

        Ok(local_plugins)
    }

    fn is_plugin_compendium_file(path: &Path, glob: &GlobMatcher) -> bool {
        !path.to_str().unwrap().to_lowercase().contains("loader") && glob.is_match(&path)
    }

    fn is_plugin_file(path: &Path, glob: &GlobMatcher) -> bool {
        !path.to_str().unwrap().to_lowercase().contains("loader")
            && !path.to_str().unwrap().to_lowercase().contains("demo")
            && glob.is_match(&path)
    }
}

#[cfg(test)]
mod tests {
    use super::Synchronizer;
    use crate::core::PluginDataClass;
    use fs_extra::dir::{copy, CopyOptions};
    use globset::Glob;
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

    fn create_expected_result() -> HashMap<String, PluginDataClass> {
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
    fn check_if_compendium_file_exists_positive() {
        let test_dir = setup();
        let plugin_dir = test_dir
            .join("HabnaPlugins")
            .join("TitanBar.plugincompendium");
        let glob = Glob::new("*.plugincompendium").unwrap().compile_matcher();

        let is_existing = Synchronizer::is_plugin_compendium_file(&plugin_dir, &glob);

        assert!(is_existing);

        teardown(&test_dir);
    }

    #[test]
    fn check_if_compendium_file_exists_negative() {
        let test_dir = setup();
        let plugin_dir = test_dir
            .join("HabnaPlugins")
            .join("TitanBar.plugincompendium");
        let glob = Glob::new("*.plugin").unwrap().compile_matcher();

        let is_existing = Synchronizer::is_plugin_compendium_file(&plugin_dir, &glob);

        assert!(!is_existing);

        teardown(&test_dir);
    }

    #[test]
    fn search_local_plugins() {
        // TItan bars description missing. TODO
        let test_dir = setup();
        //let expected_result = create_expected_result();

        let local_plugins = Synchronizer::search_local(test_dir.to_str().unwrap()).unwrap();

        assert!(local_plugins.contains_key("CraftTimer"));

        //assert_eq!(local_plugins, expected_result);

        teardown(&test_dir);
    }
}
