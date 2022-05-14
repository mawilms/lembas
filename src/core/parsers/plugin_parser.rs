use serde::Deserialize;
use serde_xml_rs::from_reader;
use std::{fs::File, path::Path};

// When .plugin file, check all folders if there is a .compendium file with the same name. If not,
// return the .plugin content with an unmaintained name
pub fn parse_plugin_file(path: &Path) -> PluginDataClass {
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
    use super::*;

    #[test]
    fn plugin_parsing() {
        let plugin = parse_plugin_file(Path::new("tests/samples/xml_files/PreciseCoords.plugin"));
        assert_eq!(plugin.name, "Precise Coords");
    }
}
