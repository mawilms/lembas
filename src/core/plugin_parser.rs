use serde::Deserialize;
use serde_xml_rs::from_reader;
use std::{fs::File, path::Path};

#[derive(Debug, Default)]
pub struct PluginParser {}

impl PluginParser {
    pub fn parse_file<P>(path: P) -> Plugin
    where
        P: AsRef<Path>,
    {
        let file = File::open(path).unwrap();

        let content: Plugin = from_reader(file).unwrap();
        content
    }
}

#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
#[serde(rename_all = "PascalCase")]
pub struct Plugin {
    pub information: Information,
}

#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
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
    use crate::core::PluginParser;

    #[test]
    fn it_works() {
        let plugin = PluginParser::parse_file("tests/samples/xml_files/PreciseCoords.plugin");
        assert_eq!(plugin.information.name, "Precise Coords");
    }
}
