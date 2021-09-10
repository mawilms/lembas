use super::api_connector::APIOperations;
use super::cache;
use crate::core::io::{APIConnector, PluginParser};
use crate::core::{Config, Plugin, PluginDataClass};
use globset::Glob;
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
                Synchronizer::successful_plugin_retrieval(
                    local_plugins,
                    &remote_plugins,
                    db_file,
                );
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
        let glob = Glob::new("*.plugincompendium")?.compile_matcher();
        let secondary_glob = Glob::new(".plugin")?.compile_matcher();

        for entry in read_dir(Path::new(&plugins_dir))? {
            let direcorty_path = Path::new(&plugins_dir).join(entry.unwrap().path());
            if metadata(&direcorty_path).unwrap().is_dir() {
                let directory = read_dir(&direcorty_path.to_str().unwrap());

                for file in directory? {
                    let path = file?.path();
                    if !path.to_str().unwrap().to_lowercase().contains("loader")
                        && glob.is_match(&path)
                    {
                        debug!("{}", format!("Found .plugincompendium file at {:?}", &path));
                        let xml_content = PluginParser::parse_compendium_file(&path);
                        local_plugins.insert(xml_content.name.clone(), xml_content);
                    } else if !path.to_str().unwrap().to_lowercase().contains("loader")
                        && !path.to_str().unwrap().to_lowercase().contains("demo")
                        && secondary_glob.is_match(&path)
                    {
                        debug!("{}", format!("Found .plugin file at {:?}", &path));
                        let xml_content = PluginParser::parse_file(&path);
                        local_plugins.insert(xml_content.name.clone(), xml_content);
                    }
                }
            }
        }

        Ok(local_plugins)
    }
}