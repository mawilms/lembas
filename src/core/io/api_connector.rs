use crate::core::{Base as BasePlugin, Plugin as DetailsPlugin};
use async_trait::async_trait;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

use super::{feed_url_parser::Favorites, FeedUrlParser};

#[async_trait]
pub trait APIOperations {
    async fn fetch_plugins(url: String) -> Result<HashMap<String, BasePlugin>, APIError>;

    async fn fetch_details(plugin_id: i32) -> Result<DetailsPlugin, APIError>;
}

pub struct APIConnector {}

#[async_trait]
impl APIOperations for APIConnector {
    async fn fetch_plugins(url: String) -> Result<HashMap<String, BasePlugin>, APIError> {
        match reqwest::get(url).await {
            Ok(response) => match response.text().await {
                Ok(content) => {
                    let mut plugins: HashMap<String, BasePlugin> = HashMap::new();
                    let xml_content = FeedUrlParser::parse_response(&content);
                    for ui in xml_content.Ui {
                        plugins.insert(
                            ui.UIName.clone(),
                            BasePlugin::new(ui.UID, &ui.UIName, &ui.UICategory, &ui.UIVersion),
                        );
                    }
                    Ok(plugins)
                }
                Err(_) => Err(APIError::FetchError),
            },
            Err(_) => Err(APIError::FetchError),
        }
    }

    async fn fetch_details(plugin_id: i32) -> Result<DetailsPlugin, APIError> {
        match reqwest::get(format!(
            "https://lembas-backend.herokuapp.com/plugins/{}",
            plugin_id
        ))
        .await
        {
            Ok(response) => match response.json::<JSONResponse>().await {
                Ok(plugin) => Ok(DetailsPlugin::new(
                    plugin.plugin_id,
                    &plugin.title,
                    "",
                    &plugin.category,
                    &plugin.current_version,
                    &plugin.latest_version,
                    &plugin.folders,
                    &plugin.files,
                )),
                Err(_) => Err(APIError::FetchError),
            },
            Err(_) => Err(APIError::FetchError),
        }
    }
}

#[derive(Default, Serialize, Deserialize, Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
struct JSONResponse {
    pub plugin_id: i32,
    pub title: String,
    #[serde(default)]
    pub description: String,
    pub category: String,
    #[serde(default)]
    pub current_version: String,
    pub latest_version: String,
    pub folders: String,
    pub files: Vec<String>,
}

#[derive(Debug, Clone)]
pub enum APIError {
    FetchError,
}

#[cfg(test)]
mod tests {
    use crate::core::io::{api_connector::APIOperations, APIConnector};

    #[tokio::test]
    async fn fetch_plugins() {
        let result = APIConnector::fetch_plugins(
            "https://api.lotrointerface.com/fav/plugincompendium.xml".to_string(),
        )
        .await;
        assert!(result.is_ok());
        assert!(!result.unwrap().is_empty());
    }

    #[tokio::test]
    async fn fetch_details() {
        let result = APIConnector::fetch_details(365).await;
        assert!(result.is_ok());
        assert_eq!(result.unwrap().base_plugin.title, "PetCarousel");
    }
}
