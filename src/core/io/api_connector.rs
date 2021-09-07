use super::FeedUrlParser;
use crate::core::Plugin;
use async_trait::async_trait;
use log::debug;
use std::collections::HashMap;

#[async_trait]
pub trait APIOperations {
    async fn fetch_plugins(url: String) -> Result<HashMap<String, Plugin>, APIError>;
}

pub struct APIConnector {}

#[async_trait]
impl APIOperations for APIConnector {
    async fn fetch_plugins(url: String) -> Result<HashMap<String, Plugin>, APIError> {
        match reqwest::get(url).await {
            Ok(response) => match response.text().await {
                Ok(content) => {
                    let mut plugins: HashMap<String, Plugin> = HashMap::new();
                    let xml_content = FeedUrlParser::parse_response(&content);
                    for ui in xml_content.Ui {
                        plugins.insert(
                            ui.UIName.clone(),
                            Plugin::new(
                                ui.UID,
                                &ui.UIName,
                                &ui.UICategory,
                                "",
                                &ui.UIVersion,
                                &ui.UIAuthorName,
                                ui.UIDownloads,
                                &ui.UIDescription,
                                &ui.UIFile,
                                &ui.UIFileURL,
                            ),
                        );
                    }
                    Ok(plugins)
                }
                Err(err) => {
                    debug!("{}", err);
                    Err(APIError::FetchError)
                }
            },
            Err(err) => {
                debug!("{}", err);
                Err(APIError::FetchError)
            }
        }
    }
}

#[derive(Debug, Clone)]
pub enum APIError {
    FetchError,
}

#[cfg(test)]
mod tests {
    use crate::core::io::{api_connector::APIOperations, APIConnector};

    // #[tokio::test]
    // async fn fetch_plugins() {
    //     let result = APIConnector::fetch_plugins(
    //         "https://api.lotrointerface.com/fav/plugincompendium.xml".to_string(),
    //     )
    //     .await;
    //     assert!(result.is_ok());
    //     assert!(!result.unwrap().is_empty())
    // }
}
