use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
pub struct Plugin {
    pub plugin_id: i32,
    pub title: String,
    #[serde(default)]
    pub description: String,
    #[serde(default)]
    pub current_version: String,
    pub latest_version: String,
    pub folder_name: String,
    pub files: Vec<String>,
}

impl Default for Plugin {
    fn default() -> Self {
        Self {
            plugin_id: i32::default(),
            title: String::default(),
            description: String::default(),
            current_version: String::default(),
            latest_version: String::default(),
            folder_name: String::default(),
            files: Vec::new(),
        }
    }
}

impl Plugin {
    pub fn new(
        plugin_id: i32,
        title: &str,
        description: &str,
        current_version: &str,
        latest_version: &str,
        folder_name: &str,
        files: &[String],
    ) -> Self {
        Self {
            plugin_id,
            title: title.to_string(),
            description: description.to_string(),
            current_version: current_version.to_string(),
            latest_version: latest_version.to_string(),
            folder_name: folder_name.to_string(),
            files: files.to_vec(),
        }
    }
}
