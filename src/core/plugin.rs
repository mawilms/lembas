use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone)]
pub struct Plugin {
    pub plugin_id: i32,
    pub title: String,
    #[serde(default)]
    pub current_version: String,
    pub latest_version: String,
}

impl Default for Plugin {
    fn default() -> Self {
        Self {
            plugin_id: i32::default(),
            title: String::default(),
            current_version: String::default(),
            latest_version: String::default(),
        }
    }
}

impl Plugin {
    pub fn new(plugin_id: i32, title: &str, current_version: &str, latest_version: &str) -> Self {
        Self {
            plugin_id,
            title: title.to_string(),
            current_version: current_version.to_string(),
            latest_version: latest_version.to_string(),
        }
    }
}
