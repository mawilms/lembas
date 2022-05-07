use serde::Deserialize;
use serde_xml_rs::from_str;

#[derive(Debug, Default)]
pub struct FeedUrlParser;

impl FeedUrlParser {
    pub fn parse_response_xml(content: &str) -> Vec<Plugin> {
        let favorites: Favorites = from_str(&content.replace('&', "&amp;")).unwrap();
        convert_ui_to_plugin(&favorites.Ui)
    }
}

fn convert_ui_to_plugin(ui_collection: &[Ui]) -> Vec<Plugin> {
    let mut plugins = Vec::new();

    for element in ui_collection {
        plugins.push(Plugin::new(
            element.UID,
            &element.UIName,
            &element.UIAuthorName,
            &element.UIVersion,
            element.UIUpdated,
            element.UIDownloads,
            &element.UICategory,
            &element.UIDescription,
            &element.UIFile,
            &element.UIMD5,
            element.UISize,
            &element.UIFileURL,
        ));
    }

    plugins
}

pub struct Plugin {
    id: i32,
    name: String,
    author: String,
    version: String,
    updated: i32,
    downloads: i32,
    category: String,
    description: String,
    file_name: String,
    hash: String,
    size: i32,
    url: String,
}

impl Plugin {
    pub fn new(
        id: i32,
        name: &str,
        author: &str,
        version: &str,
        updated: i32,
        downloads: i32,
        category: &str,
        description: &str,
        file_name: &str,
        hash: &str,
        size: i32,
        url: &str,
    ) -> Self {
        Self {
            id,
            name: name.to_string(),
            author: author.to_string(),
            version: version.to_string(),
            updated,
            downloads,
            category: category.to_string(),
            description: description.to_string(),
            file_name: file_name.to_string(),
            hash: hash.to_string(),
            size,
            url: url.to_string(),
        }
    }
}

#[allow(non_snake_case)]
#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
struct Favorites {
    pub Ui: Vec<Ui>,
}

#[allow(non_snake_case)]
#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
struct Ui {
    pub UID: i32,
    pub UIName: String,
    pub UIAuthorName: String,
    pub UIVersion: String,
    pub UIUpdated: i32,
    pub UIDownloads: i32,
    pub UICategory: String,
    pub UIDescription: String,
    pub UIFile: String,
    #[serde(default)]
    UIMD5: String,
    UISize: i32,
    pub UIFileURL: String,
}

#[cfg(test)]
mod tests {
    use std::fs;

    use crate::core::io::FeedUrlParser;

    #[test]
    fn parse_response() {
        let xml_content: String =
            fs::read_to_string("tests/samples/xml_files/feed_url.xml").unwrap();

        let feed_url = FeedUrlParser::parse_response_xml(&xml_content);

        assert_eq!(feed_url.len(), 2);
    }
}
