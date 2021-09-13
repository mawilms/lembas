#[derive(Debug, PartialEq, Eq)]
pub struct PluginDataClass {
    pub name: String,
    pub author: String,
    pub version: String,
    pub id: Option<i32>,
    pub description: Option<String>,
    pub download_url: Option<String>,
    pub info_url: Option<String>,
}

impl PluginDataClass {
    pub fn new(name: &str, author: &str, version: &str) -> Self {
        Self {
            name: name.to_string(),
            author: author.to_string(),
            version: version.to_string(),
            id: None,
            description: None,
            download_url: None,
            info_url: None,
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

    pub fn build(mut self) -> Self {
        if self.id.is_some() {
            let base_url = "http://www.lotrointerface.com/downloads/";
            self.info_url = Some(format!("{}info{}", base_url, self.id.unwrap()));
            self.download_url = Some(format!("{}download{}", base_url, self.id.unwrap()));
        }
        self
    }
}

#[cfg(test)]
mod tests {
    use super::PluginDataClass;

    #[test]
    fn base_class() {
        let data_class = PluginDataClass::new("Hello World", "Marius", "0.1.0").build();

        assert_eq!(data_class.name, "Hello World");
        assert_eq!(data_class.author, "Marius");
        assert_eq!(data_class.version, "0.1.0");
    }

    #[test]
    fn with_id() {
        let data_class = PluginDataClass::new("Hello World", "Marius", "0.1.0")
            .with_id(1)
            .build();

        assert_eq!(data_class.name, "Hello World");
        assert_eq!(data_class.author, "Marius");
        assert_eq!(data_class.version, "0.1.0");
        assert_eq!(data_class.id, Some(1));
        assert_eq!(
            data_class.info_url,
            Some(String::from(
                "http://www.lotrointerface.com/downloads/info1"
            ))
        );
        assert_eq!(
            data_class.download_url,
            Some(String::from(
                "http://www.lotrointerface.com/downloads/download1"
            ))
        );
    }

    #[test]
    fn with_description() {
        let data_class = PluginDataClass::new("Hello World", "Marius", "0.1.0")
            .with_description("This is an example")
            .build();

        assert_eq!(data_class.name, "Hello World");
        assert_eq!(data_class.author, "Marius");
        assert_eq!(data_class.version, "0.1.0");
        assert_eq!(
            data_class.description,
            Some(String::from("This is an example"))
        );
    }
}
