use serde::Deserialize;
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

        let content: PluginCompendium = from_reader(file).unwrap();
        content
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
pub struct PluginCompendium {
    pub id: String,
    pub name: String,
    pub version: String,
    pub author: String,
    pub info_url: String,
    pub download_url: String,
    pub descriptors: Descriptors,
}

#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
pub struct Descriptors {
    pub descriptor: String,
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
    use crate::core::*;

    #[test]
    fn compendium_parsing() {
        let plugin = PluginParser::parse_compendium_file(
            "tests/samples/xml_files/Waypoint.plugincompendium",
        );
        assert_eq!(plugin.name, "Waypoint");
        assert_eq!(plugin.descriptors.descriptor, "Lunarwater\\Waypoint.plugin");
    }

    #[test]
    fn plugin_parsing() {
        let plugin = PluginParser::parse_file("tests/samples/xml_files/PreciseCoords.plugin");
        assert_eq!(plugin.name, "Precise Coords");
    }
}
