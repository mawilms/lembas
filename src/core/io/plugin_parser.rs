use serde::{Deserialize, Serialize};
use serde_xml_rs::from_reader;
use std::{fs::File, path::Path};

#[derive(Debug, Default)]
pub struct PluginParser {}

impl PluginParser {
    pub fn parse_compendium_file<P>(path: P) -> PluginCompendium
    where
        P: AsRef<Path>,
    {
        let file = File::open(path).unwrap();

        let content: PluginCompendiumContent = from_reader(file).unwrap();
        content.purge_descriptors()
    }

    pub fn parse_file<P>(path: P) -> Information
    where
        P: AsRef<Path>,
    {
        let file = File::open(path).unwrap();

        let content: Plugin = from_reader(file).unwrap();
        content.information
    }
}

#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
#[serde(rename_all = "PascalCase")]
pub struct PluginCompendiumContent {
    pub id: String,
    pub name: String,
    pub version: String,
    pub author: String,
    pub info_url: String,
    pub download_url: String,
    #[serde(default)]
    pub descriptors: Descriptors,
    #[serde(default)]
    pub dependencies: Dependencies,
}

pub struct PluginCompendium {
    pub id: String,
    pub name: String,
    pub version: String,
    pub author: String,
    pub info_url: String,
    pub download_url: String,
    pub plugin_file_location: String,
    pub dependencies: Vec<String>,
}

impl PluginCompendiumContent {
    pub fn purge_descriptors(&self) -> PluginCompendium {
        let purged_descriptors: Vec<String> = self
            .descriptors
            .descriptor
            .clone()
            .into_iter()
            .filter(|element| !element.contains("loader"))
            .collect();

        if !purged_descriptors.is_empty() && purged_descriptors.len() < 2 {
            PluginCompendium {
                id: self.id.clone(),
                name: self.name.clone(),
                version: self.version.clone(),
                author: self.author.clone(),
                info_url: self.info_url.clone(),
                download_url: self.download_url.clone(),
                plugin_file_location: purged_descriptors[0].clone(),
                dependencies: self.dependencies.dependency.clone(),
            }
        } else {
            PluginCompendium {
                id: self.id.clone(),
                name: self.name.clone(),
                version: self.version.clone(),
                author: self.author.clone(),
                info_url: self.info_url.clone(),
                download_url: self.download_url.clone(),
                plugin_file_location: String::new(),
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

#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
#[serde(rename_all = "PascalCase")]
pub struct Plugin {
    pub information: Information,
}

#[derive(Deserialize, Debug, PartialEq, Hash, Eq, Clone)]
#[serde(rename_all = "PascalCase")]
pub struct Information {
    pub name: String,
    #[serde(default)]
    pub description: String,
    pub author: String,
    pub version: String,
}

#[cfg(test)]
mod tests {
    use crate::core::io::PluginParser;

    #[test]
    fn compendium_parsing_single_descriptor() {
        let plugin = PluginParser::parse_compendium_file(
            "tests/samples/xml_files/Waypoint.plugincompendium",
        );
        assert_eq!(plugin.name, "Waypoint");
        assert_eq!(plugin.plugin_file_location, "Lunarwater\\Waypoint.plugin");
        assert_eq!(plugin.dependencies.len(), 0);
    }

    #[test]
    fn compendium_parsing_multiple_descriptor() {
        let plugin = PluginParser::parse_compendium_file(
            "tests/samples/xml_files/Compendium.plugincompendium",
        );
        assert_eq!(plugin.name, "LOTRO Compendium");
        assert_eq!(plugin.plugin_file_location, "Compendium\\Compendium.plugin");
        assert_eq!(plugin.dependencies, vec!["640"]);
    }

    #[test]
    fn plugin_parsing() {
        let plugin = PluginParser::parse_file("tests/samples/xml_files/PreciseCoords.plugin");
        assert_eq!(plugin.name, "Precise Coords");
    }
}
