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

use super::Plugin;

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
    use super::*;
    use std::fs;

    #[test]
    fn parse_response() {
        let xml_content: String =
            fs::read_to_string("tests/samples/xml_files/feed_url.xml").unwrap();

        let feed_url = FeedUrlParser::parse_response_xml(&xml_content);

        assert_eq!(feed_url.len(), 2);
    }
}
