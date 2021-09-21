use crate::core::PluginDataClass;
use serde::Deserialize;
use serde_xml_rs::from_reader;
use std::{
    fs::File,
    path::{Path, PathBuf},
};

use super::plugin_parser::parse_plugin_file;

pub fn parse_compendium_file(path: &Path) -> PluginDataClass {
    let file = File::open(&path).unwrap();

    let content: PluginCompendiumContent = from_reader(file).unwrap();
    let compendium_content = content._purge_descriptors();

    if compendium_content.description.is_some() {
        PluginDataClass::new(
            &compendium_content.name,
            &compendium_content.author,
            &compendium_content.version,
        )
        .with_id(compendium_content.id)
        .with_description(&compendium_content.description.unwrap())
        .build()
    } else if !compendium_content.plugin_file_location.is_empty()
        && is_backslash_separator(&compendium_content.plugin_file_location)
    {
        let plugin_path = build_plugin_path(path, &compendium_content.plugin_file_location, '\\');
        let plugin_content = parse_plugin_file(plugin_path);
        PluginDataClass::new(
            &compendium_content.name,
            &compendium_content.author,
            &compendium_content.version,
        )
        .with_id(compendium_content.id)
        .with_description(&plugin_content.description.unwrap())
        .build()
    } else if !compendium_content.plugin_file_location.is_empty()
        && is_dot_separator(&compendium_content.plugin_file_location)
    {
        let plugin_path = build_plugin_path(path, &compendium_content.plugin_file_location, '.');
        let plugin_content = parse_plugin_file(plugin_path);
        PluginDataClass::new(
            &compendium_content.name,
            &compendium_content.author,
            &compendium_content.version,
        )
        .with_id(compendium_content.id)
        .with_description(&plugin_content.description.unwrap())
        .build()
    } else {
        PluginDataClass::new(
            &compendium_content.name,
            &compendium_content.author,
            &compendium_content.version,
        )
        .with_id(compendium_content.id)
        .build()
    }
}

fn is_backslash_separator(descriptor: &str) -> bool {
    let dots = descriptor.matches('.').count();
    let backslashes = descriptor.matches('\\').count();
    backslashes >= dots
}

fn is_dot_separator(descriptor: &str) -> bool {
    let dots = descriptor.matches('.').count();
    let backslashes = descriptor.matches('\\').count();
    backslashes < dots
}

fn build_plugin_path(plugin_folder_path: &Path, file_path: &str, separator: char) -> PathBuf {
    let splitted_path: Vec<&str> = file_path.split(separator).collect();
    let splited_path_length = splitted_path.len();
    let mut manipulated_path = plugin_folder_path.to_path_buf();

    if separator == '.' {
        manipulated_path.set_file_name(splitted_path[splited_path_length - 2..].join("."));
    } else {
        manipulated_path.set_file_name(splitted_path[splited_path_length - 1]);
    }
    manipulated_path
}

#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
#[serde(rename_all = "PascalCase")]
struct PluginCompendiumContent {
    id: i32,
    name: String,
    version: String,
    author: String,
    description: Option<String>,
    info_url: String,
    download_url: String,
    #[serde(default)]
    descriptors: Descriptors,
    #[serde(default)]
    dependencies: Dependencies,
}

#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
struct PluginCompendium {
    pub id: i32,
    pub name: String,
    pub version: String,
    pub author: String,
    pub description: Option<String>,
    pub info_url: String,
    pub download_url: String,
    pub plugin_file_location: String,
    pub dependencies: Vec<String>,
}

impl PluginCompendiumContent {
    pub fn _purge_descriptors(&self) -> PluginCompendium {
        let purged_descriptors: Vec<String> = self
            .descriptors
            .descriptor
            .clone()
            .into_iter()
            .filter(|element| !element.contains("loader") && element.contains(".plugin"))
            .collect();

        if purged_descriptors.is_empty() {
            PluginCompendium {
                id: self.id,
                name: self.name.clone(),
                version: self.version.clone(),
                author: self.author.clone(),
                description: self.description.clone(),
                info_url: self.info_url.clone(),
                download_url: self.download_url.clone(),
                plugin_file_location: String::new(),
                dependencies: self.dependencies.dependency.clone(),
            }
        } else {
            PluginCompendium {
                id: self.id,
                name: self.name.clone(),
                version: self.version.clone(),
                author: self.author.clone(),
                description: self.description.clone(),
                info_url: self.info_url.clone(),
                download_url: self.download_url.clone(),
                plugin_file_location: purged_descriptors[0].clone(),
                dependencies: self.dependencies.dependency.clone(),
            }
        }
    }
}

#[derive(Default, Deserialize, Debug, PartialEq, Hash, Eq)]
pub struct Descriptors {
    #[serde(default)]
    pub descriptor: Vec<String>,
}

#[derive(Default, Deserialize, Debug, PartialEq, Hash, Eq)]
pub struct Dependencies {
    #[serde(default)]
    pub dependency: Vec<String>,
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn extract_plugin_descriptor() {
        let file = File::open(&"tests/samples/xml_files/TitanBar.plugincompendium").unwrap();
        let content: PluginCompendiumContent = from_reader(file).unwrap();
        let content = content._purge_descriptors();

        assert_eq!(content.plugin_file_location, "HabnaPlugins.TitanBar.plugin");
    }

    mod build_plugin_paths_tests {
        use super::*;

        #[test]
        fn plugin_path_dot() {
            let file_path = "HabnaPlugins.TitanBar.plugin";
            let result = build_plugin_path(
                Path::new("tests/samples/plugin_folders/HabnaPlugins/TitanBar.plugincompendium"),
                file_path,
                '.',
            );
            assert_eq!(
                result,
                Path::new("tests/samples/plugin_folders/HabnaPlugins/TitanBar.plugin")
            );
        }

        #[test]
        fn plugin_path_backslash() {
            let file_path = "Homeopatix\\Voyage.plugin";
            let result = build_plugin_path(
                Path::new("tests/samples/plugin_folders/Homeopatix/Voyage.plugincompendium"),
                file_path,
                '\\',
            );
            assert_eq!(
                result,
                Path::new("tests/samples/plugin_folders/Homeopatix/Voyage.plugin")
            );
        }
    }

    mod backslash_separator_tests {
        use super::*;

        #[test]
        fn positive() {
            let result = is_backslash_separator("Lunarwater\\Waypoint.plugin");
            assert!(result);
        }

        #[test]
        fn negative() {
            let result = is_backslash_separator("HabnaPlugins.TitanBar.plugin");
            assert!(!result);
        }
    }

    mod dot_separator_tests {
        use super::*;

        #[test]
        fn positive() {
            let result = is_dot_separator("HabnaPlugins.TitanBar.plugin");
            assert!(result);
        }

        #[test]
        fn negative() {
            let result = is_dot_separator("Lunarwater\\Waypoint.plugin");
            assert!(!result);
        }
    }

    mod plugin_compendium_tests {
        use super::*;

        #[test]
        fn single_descriptor() {
            let plugin = parse_compendium_file(Path::new(
                "tests/samples/plugin_folders/Homeopatix/Voyage.plugincompendium",
            ));
            assert_eq!(plugin.name, "Voyage");
            assert_eq!(plugin.version, "3.13");
        }

        #[test]
        fn multiple_descriptors() {
            let plugin = parse_compendium_file(Path::new(
                "tests/samples/xml_files/Compendium.plugincompendium",
            ));
            assert_eq!(plugin.name, "LOTRO Compendium");
            assert_eq!(plugin.version, "1.8.0-beta");
            assert_eq!(plugin.id, Some(526));
        }

        #[test]
        fn without_description() {
            let plugin = parse_compendium_file(Path::new(
                "tests/samples/plugin_folders/HabnaPlugins/TitanBar.plugincompendium",
            ));

            assert_eq!(plugin.name, "TitanBar");
            assert_eq!(
                plugin.description,
                Some(String::from("This is the TitanBar plugin"))
            );
        }

        #[test]
        fn with_description() {
            let plugin = parse_compendium_file(Path::new(
                "tests/samples/xml_files/Animalerie.plugincompendium",
            ));

            assert_eq!(plugin.name, "Animalerie");
            assert_eq!(plugin.description, Some(String::from("Hello World")));
        }
    }
}
