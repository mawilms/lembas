use super::FeedUrlParser;
use crate::core::{PluginCollection, PluginDataClass};
use log::debug;
use std::collections::HashMap;

pub async fn fetch_plugins(url: String) -> Result<PluginCollection, APIError> {
    match reqwest::get(url).await {
        Ok(response) => match response.text().await {
            Ok(content) => {
                let mut plugins: PluginCollection = HashMap::new();
                let xml_content = FeedUrlParser::parse_response(&content);
                for ui in xml_content.Ui {
                    let data_class =
                        PluginDataClass::new(&ui.UIName, &ui.UIAuthorName, &ui.UIVersion)
                            .with_id(ui.UID)
                            .with_description(&ui.UIDescription)
                            .with_remote_information(
                                &ui.UICategory,
                                &ui.UIVersion,
                                ui.UIDownloads,
                                &ui.UIFileURL,
                            )
                            .build();

                    plugins.insert(PluginDataClass::calculate_hash(&data_class), data_class);
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

#[derive(Debug, Clone)]
pub enum APIError {
    FetchError,
}

#[cfg(test)]
mod tests {

    #[test]
    fn test_plugin_retrieving() {
        // TODO: Implement here a test with httpmock to test the xml api

        assert_eq!(1 + 1, 2);
    }
}
