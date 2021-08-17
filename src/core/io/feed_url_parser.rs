use serde::Deserialize;
use serde_xml_rs::from_str;

#[derive(Debug, Default)]
pub struct FeedUrlParser {}

impl FeedUrlParser {
    pub fn parse_response(xml_content: &str) -> Favorites {
        let favorites: Favorites = from_str(&xml_content.replace("&", "&amp;")).unwrap();
        favorites
    }
}

#[allow(non_snake_case)]
#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
pub struct Favorites {
    pub Ui: Vec<Ui>,
}

#[allow(non_snake_case)]
#[derive(Deserialize, Debug, PartialEq, Hash, Eq)]
pub struct Ui {
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

        let feed_url = FeedUrlParser::parse_response(&xml_content);

        assert_eq!(feed_url.Ui.len(), 2);
    }
}
