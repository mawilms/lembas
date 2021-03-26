pub struct Plugin {
    id: String,
    name: String,
    version: String,
    latest_version: String,
}

impl Plugin {
    pub fn new(id: &str, name: &str) -> Self {
        Self {
            id: id.to_string(),
            name: name.to_string(),
            version: String::new(),
            latest_version: String::new(),
        }
    }

    pub fn update_version(&mut self, version: &str) {
        self.version = version.to_string();
    }

    pub fn update_latest(&mut self, version: &str) {
        self.latest_version = version.to_string();
    }
}