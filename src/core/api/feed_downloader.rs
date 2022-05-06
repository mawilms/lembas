

pub trait Downloader {
    fn fetch_feed_content(&self) -> Result<String, String>;
}

pub struct FeedDownloader;

impl Downloader for FeedDownloader {
    fn fetch_feed_content(&self) -> Result<String, String> {
        todo!()
    }
}