use serde::Deserialize;
use serde_xml_rs::from_str;

use crate::gui::views::catalog::PluginRow as CatalogRow;

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
        let plugin = Plugin::new(&element.UIName)
            .with_id(element.UID)
            .with_author(&element.UIAuthorName)
            .with_description(&element.UIDescription)
            .with_remote_information(
                &element.UICategory,
                &element.UIVersion,
                element.UIDownloads,
                &element.UIFile,
                element.UIUpdated,
                &element.UIMD5,
            )
            .build();

        plugins.push(plugin);
    }

    plugins
}

#[derive(Debug, Clone)]
pub struct Plugin {
    pub name: String,
    pub id: Option<i32>,
    pub author: Option<String>,
    pub current_version: Option<String>,
    pub latest_version: Option<String>,
    pub updated: Option<i32>,
    pub downloads: Option<i32>,
    pub category: Option<String>,
    pub description: Option<String>,
    pub archive_name: Option<String>,
    pub hash: Option<String>,
    pub download_url: Option<String>,
    pub info_url: Option<String>,
}

impl Plugin {
    pub fn new(name: &str) -> Self {
        Self {
            name: name.to_string(),
            id: None,
            author: None,
            current_version: None,
            latest_version: None,
            updated: None,
            downloads: None,
            category: None,
            description: None,
            archive_name: None,
            hash: None,
            download_url: None,
            info_url: None,
        }
    }

    pub fn with_id(mut self, plugin_id: i32) -> Self {
        self.id = Some(plugin_id);
        self
    }

    pub fn with_author(mut self, author: &str) -> Self {
        self.author = Some(author.to_string());
        self
    }

    pub fn with_description(mut self, description: &str) -> Self {
        self.description = Some(description.to_string());
        self
    }

    pub fn with_current_version(mut self, version: &str) -> Self {
        self.current_version = Some(version.to_string());
        self
    }

    pub fn with_remote_information(
        mut self,
        category: &str,
        latest_version: &str,
        downloads: i32,
        archive_name: &str,
        updated: i32,
        hash: &str,
    ) -> Self {
        self.category = Some(category.to_string());
        self.latest_version = Some(latest_version.to_string());
        self.downloads = Some(downloads);
        self.archive_name = Some(archive_name.to_string());
        self.updated = Some(updated);
        self.hash = Some(hash.to_string());

        self
    }

    pub fn build(mut self) -> Self {
        if self.id.is_some() {
            let base_url = "http://www.lotrointerface.com/downloads/";
            self.info_url = Some(format!("{}info{}", base_url, self.id.unwrap()));
            self.download_url = Some(format!("{}download{}", base_url, self.id.unwrap()));
        }
        self
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
