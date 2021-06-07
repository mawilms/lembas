use crate::core::{Base as BasePlugin, Plugin as DetailsPlugin};
use async_trait::async_trait;
use serde::{Deserialize, Serialize};
use std::collections::HashMap;

#[async_trait]
pub trait APIOperations {
    async fn fetch_plugins() -> Result<HashMap<String, BasePlugin>, APIError>;

    async fn fetch_details(plugin_id: i32) -> Result<DetailsPlugin, APIError>;
}

pub struct APIConnector {}

#[async_trait]
impl APIOperations for APIConnector {
    async fn fetch_plugins() -> Result<HashMap<String, BasePlugin>, APIError> {
        match reqwest::get("https://lembas-backend.herokuapp.com/plugins").await {
            Ok(response) => match response.json::<HashMap<String, BasePlugin>>().await {
                Ok(plugins) => Ok(plugins),
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
