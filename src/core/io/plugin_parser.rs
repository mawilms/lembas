use serde::Deserialize;
use serde_xml_rs::from_reader;
use std::{
    fs::File,
    path::{Path, PathBuf},
};

use crate::core::PluginDataClass;

#[derive(Debug, Default)]
pub struct PluginParser {}

impl PluginParser {
    pub fn parse_compendium_file<P>(path: P) -> PluginDataClass
    where
        P: AsRef<Path>,
    {
        let file = File::open(&path).unwrap();

        let content: PluginCompendiumContent = from_reader(file).unwrap();

        let data_class = PluginDataClass::new(&content.name, &content.author, &content.version)
            .with_id(content.id);

        if content.description.is_some() {
            data_class
                .with_description(&content.description.unwrap())
                .build()
        } else {
            //let plugin_content = PluginParser::parse_file(&path);

            data_class
                .build()
        }
    }

    pub fn parse_file<P>(path: P) -> PluginDataClass
    where
        P: AsRef<Path>,
    {
        let file = File::open(path).unwrap();

        let content: Plugin = from_reader(file).unwrap();

        PluginDataClass::new(
            &content.information.name,
            &content.information.author,
            &content.information.version,
        )
        .with_description(&content.information.description)
        .build()
    }
}

#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
#[serde(rename_all = "PascalCase")]
pub struct PluginCompendiumContent {
    pub id: i32,
    pub name: String,
    pub version: String,
    pub author: String,
    pub description: Option<String>,
    pub info_url: String,
    pub download_url: String,
    #[serde(default)]
    pub descriptors: Descriptors,
    #[serde(default)]
    pub dependencies: Dependencies,
}

#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
pub struct PluginCompendium {
    pub id: i32,
    pub name: String,
    pub version: String,
    pub author: String,
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
            .filter(|element| !element.contains("loader"))
            .collect();

        if !purged_descriptors.is_empty() && purged_descriptors.len() < 2 {
            PluginCompendium {
                id: self.id,
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
                id: self.id,
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
        assert_eq!(plugin.version, "1.9");
    }

    #[test]
    fn compendium_parsing_multiple_descriptor() {
        let plugin = PluginParser::parse_compendium_file(
            "tests/samples/xml_files/Compendium.plugincompendium",
        );
        assert_eq!(plugin.name, "LOTRO Compendium");
        assert_eq!(plugin.version, "1.8.0-beta");
        assert_eq!(plugin.id, Some(526));
    }

    #[test]
    fn compendium_parsing_without_description() {
        let plugin = PluginParser::parse_compendium_file(
            "tests/samples/xml_files/TitanBar.plugincompendium",
        );

        assert_eq!(plugin.name, "TitanBar");
        // assert_eq!(
        //     plugin.description,
        //     Some(String::from("This is the TitanBar plugin"))
        // );
    }

    #[test]
    fn compendium_parsing_with_description() {
        let plugin = PluginParser::parse_compendium_file(
            "tests/samples/xml_files/Animalerie.plugincompendium",
        );

        assert_eq!(plugin.name, "Animalerie");
        assert_eq!(plugin.description, Some(String::from("Hello World")));
    }

    #[test]
    fn plugin_parsing() {
        let plugin = PluginParser::parse_file("tests/samples/xml_files/PreciseCoords.plugin");
        assert_eq!(plugin.name, "Precise Coords");
    }
}
