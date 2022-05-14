use async_trait::async_trait;
use log::debug;

#[async_trait]
pub trait Downloader {
    async fn fetch_feed_content(url: String) -> Result<String, String>;
}

pub struct FeedDownloader;

#[async_trait]
impl Downloader for FeedDownloader {
    async fn fetch_feed_content(url: String) -> Result<String, String> {
        match reqwest::get(url).await {
            Ok(response) => match response.text().await {
                Ok(content) => Ok(content),
                Err(err) => {
                    debug!("{}", err);
                    Err(String::new())
                }
            },
            Err(err) => {
                debug!("{}", err);
                Err(String::new())
            }
        }
    }
}

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

#[derive(Default, Debug, Clone)]
pub struct Plugin {
    pub name: String,
    pub installed: i32,
    pub id: i32,
    pub author: String,
    pub current_version: String,
    pub latest_version: String,
    pub updated: i32,
    pub downloads: i32,
    pub category: String,
    pub description: String,
    pub archive_name: String,
    pub hash: String,
    pub download_url: String,
    pub info_url: String,
}

impl Plugin {
    pub fn new(name: &str) -> Self {
        Self {
            name: name.to_string(),
            installed: 0,
            ..Default::default()
        }
    }

    pub fn with_id(mut self, plugin_id: i32) -> Self {
        self.id = plugin_id;
        self
    }

    pub fn with_author(mut self, author: &str) -> Self {
        self.author = author.to_string();
        self
    }

    pub fn with_description(mut self, description: &str) -> Self {
        self.description = description.to_string();
        self
    }

    pub fn with_current_version(mut self, version: &str) -> Self {
        self.current_version = version.to_string();
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
        self.category = category.to_string();
        self.latest_version = latest_version.to_string();
        self.downloads = downloads;
        self.archive_name = archive_name.to_string();
        self.updated = updated;
        self.hash = hash.to_string();

        self
    }

    pub fn build(mut self) -> Self {
        if self.id != 0 {
            let base_url = "http://www.lotrointerface.com/downloads/";
            self.info_url = format!("{}info{}", base_url, self.id);
            self.download_url = format!("{}download{}", base_url, self.id);
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
