use std::collections::HashMap;

pub type PluginCollection = HashMap<String, PluginDataClass>;

#[derive(Debug, Clone)]
pub struct PluginDataClass {
    pub name: String,
    pub author: Option<String>,
    pub version: Option<String>,
    pub id: Option<i32>,
    pub description: Option<String>,
    pub download_url: Option<String>,
    pub info_url: Option<String>,
    pub category: Option<String>,
    pub latest_version: Option<String>,
    pub downloads: Option<i32>,
    pub archive_name: Option<String>,
}

impl PluginDataClass {
    pub fn new(name: &str, author: &str, version: &str) -> Self {
        Self {
            name: name.to_string(),
            author: Some(author.to_string()),
            version: Some(version.to_string()),
            id: None,
            description: None,
            download_url: None,
            info_url: None,
            category: None,
            latest_version: None,
            downloads: None,
            archive_name: None,
        }
    }

    pub fn with_id(mut self, plugin_id: i32) -> Self {
        self.id = Some(plugin_id);
        self
    }

    pub fn with_description(mut self, description: &str) -> Self {
        self.description = Some(description.to_string());
        self
    }

    pub fn with_remote_information(
        mut self,
        category: &str,
        latest_version: &str,
        downloads: i32,
        archive_name: &str,
    ) -> Self {
        self.category = Some(category.to_string());
        self.latest_version = Some(latest_version.to_string());
        self.downloads = Some(downloads);
        self.archive_name = Some(archive_name.to_string());

        self
    }

    pub fn build(mut self) -> Self {
        if self.id.is_some() {
            let base_url = "http://www.lotrointerface.com/downloads/";
            self.info_url = Some(format!("{}info{}", base_url, self.id.unwrap()));
            self.download_url = Some(format!("{}download{}", base_url, self.id.unwrap()));
        }
        self
    }
}

// #[cfg(test)]
// mod tests {
//     use super::PluginDataClass;

//     #[test]
//     fn base_class() {
//         let data_class = PluginDataClass::new("Hello World", "Marius", "0.1.0").build();

//         assert_eq!(data_class.name, "Hello World");
//         assert_eq!(data_class.author, "Marius");
//         assert_eq!(data_class.version, "0.1.0");
//     }

//     #[test]
//     fn with_id() {
//         let data_class = PluginDataClass::new("Hello World", "Marius", "0.1.0")
//             .with_id(1)
//             .build();

//         assert_eq!(data_class.name, "Hello World");
//         assert_eq!(data_class.author, "Marius");
//         assert_eq!(data_class.version, "0.1.0");
//         assert_eq!(data_class.id, Some(1));
//         assert_eq!(
//             data_class.info_url,
//             Some(String::from(
//                 "http://www.lotrointerface.com/downloads/info1"
//             ))
//         );
//         assert_eq!(
//             data_class.download_url,
//             Some(String::from(
//                 "http://www.lotrointerface.com/downloads/download1"
//             ))
//         );
//     }

//     #[test]
//     fn with_description() {
//         let data_class = PluginDataClass::new("Hello World", "Marius", "0.1.0")
//             .with_description("This is an example")
//             .build();

//         assert_eq!(data_class.name, "Hello World");
//         assert_eq!(data_class.author, "Marius");
//         assert_eq!(data_class.version, "0.1.0");
//         assert_eq!(
//             data_class.description,
//             Some(String::from("This is an example"))
//         );
//     }

//     #[test]
//     fn with_remote_information() {
//         let data_class = PluginDataClass::new("Hello World", "Marius", "0.1.0")
//             .with_description("This is an example")
//             .with_remote_information("Skills", "0.2.0", 500, "hello.zip")
//             .build();

//         assert_eq!(data_class.name, "Hello World");
//         assert_eq!(data_class.author, "Marius");
//         assert_eq!(data_class.version, "0.1.0");
//         assert_eq!(
//             data_class.description,
//             Some(String::from("This is an example"))
//         );
//         assert_eq!(data_class.category, Some(String::from("Skills")));
//         assert_eq!(data_class.latest_version, Some(String::from("0.2.0")));
//         assert_eq!(data_class.downloads, Some(500));
//         assert_eq!(data_class.archive_name, Some(String::from("hello.zip")));
//     }
// }
