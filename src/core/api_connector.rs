use crate::core::{Base as BasePlugin, Plugin as DetailsPlugin};
use async_trait::async_trait;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[async_trait]
pub trait APIOperations {
    async fn fetch_plugins() -> Result<HashMap<String, BasePlugin>, APIError>;

    fn fetch_details(title: &str) -> DetailsPlugin;
}

pub struct APIConnector {}

#[async_trait]
impl APIOperations for APIConnector {
    async fn fetch_plugins() -> Result<HashMap<String, BasePlugin>, APIError> {
        match reqwest::get("https://young-hamlet-23901.herokuapp.com/plugins").await {
            Ok(response) => match response.json::<HashMap<String, BasePlugin>>().await {
                Ok(plugins) => Ok(plugins),
                Err(_) => Err(APIError::FetchError),
            },
            Err(_) => Err(APIError::FetchError),
        }
    }

    fn fetch_details(title: &str) -> DetailsPlugin {
        let response = reqwest::blocking::get(format!(
            "https://young-hamlet-23901.herokuapp.com/plugins/{}",
            title.to_lowercase()
        ))
        .expect("Failed to connect with API")
        .json::<JSONResponse>()
        .expect("Failed to parse response");

        DetailsPlugin::new(
            response.plugin_id,
            &response.title,
            "",
            &response.category,
            &response.current_version,
            &response.latest_version,
            &response.folders,
            &response.files,
        )
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
