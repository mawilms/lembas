#[derive(Default, Debug, Clone)]
pub struct Plugin {
    pub name: String,
    pub installed: i32,
    pub id: i32,
    pub author: String,
    pub current_version: String,
    pub latest_version: String,
    pub updated: i32,
    pub downloads: i32,
    pub category: String,
    pub description: String,
    pub archive_name: String,
    pub hash: String,
    pub download_url: String,
    pub info_url: String,
}

impl Plugin {
    pub fn new(name: &str) -> Self {
        Self {
            name: name.to_string(),
            installed: 0,
            ..Default::default()
        }
    }

    pub fn with_id(mut self, plugin_id: i32) -> Self {
        self.id = plugin_id;
        self
    }

    pub fn with_author(mut self, author: &str) -> Self {
        self.author = author.to_string();
        self
    }

    pub fn with_description(mut self, description: &str) -> Self {
        self.description = description.to_string();
        self
    }

    pub fn with_current_version(mut self, version: &str) -> Self {
        self.current_version = version.to_string();
        self
    }

    pub fn with_remote_information(
        mut self,
        category: &str,
        latest_version: &str,
        downloads: i32,
        archive_name: &str,
        updated: i32,
        hash: &str,
    ) -> Self {
        self.category = category.to_string();
        self.latest_version = latest_version.to_string();
        self.downloads = downloads;
        self.archive_name = archive_name.to_string();
        self.updated = updated;
        self.hash = hash.to_string();

        self
    }

    pub fn build(mut self) -> Self {
        if self.id != 0 {
            let base_url = "http://www.lotrointerface.com/downloads/";
            self.info_url = format!("{}info{}", base_url, self.id);
            self.download_url = format!("{}download{}", base_url, self.id);
        }
        self
    }
}