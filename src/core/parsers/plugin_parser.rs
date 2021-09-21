use crate::core::PluginDataClass;
use serde::Deserialize;
use serde_xml_rs::from_reader;
use std::{fs::File, path::Path};

pub fn parse_plugin_file<P>(path: P) -> PluginDataClass
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

#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
#[serde(rename_all = "PascalCase")]
struct Plugin {
    pub information: Information,
}

#[derive(Deserialize, Debug, PartialEq, Hash, Eq, Clone)]
#[serde(rename_all = "PascalCase")]
struct Information {
    pub name: String,
    #[serde(default)]
    pub description: String,
    pub author: String,
    pub version: String,
}

#[cfg(test)]
mod tests {
    use super::parse_plugin_file;

    #[test]
    fn plugin_parsing() {
        let plugin = parse_plugin_file("tests/samples/xml_files/PreciseCoords.plugin");
        assert_eq!(plugin.name, "Precise Coords");
    }
}
