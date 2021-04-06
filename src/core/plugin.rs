use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct Plugin {
    pub plugin_id: i32,
    pub title: String,
    #[serde(default)]
    pub current_version: String,
    pub latest_version: String,
}
