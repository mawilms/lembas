use async_trait::async_trait;
use log::debug;

#[async_trait]
pub trait Downloader {
    async fn fetch_feed_content(url: &str) -> Result<String, String>;
}

pub struct FeedDownloader;

#[async_trait]
impl Downloader for FeedDownloader {
    async fn fetch_feed_content(url: &str) -> Result<String, String> {
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
