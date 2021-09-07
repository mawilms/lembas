use serde::{Deserialize, Serialize};

#[derive(Default, Serialize, Deserialize, Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
pub struct Plugin {
    pub plugin_id: i32,
    pub title: String,
    pub category: String,
    pub current_version: String,
    pub latest_version: String,
    pub author: String,
    pub downloads: i32,
    pub description: String,
    pub archive_name: String,
    pub download_url: String,
}

impl Plugin {
    pub fn new(
        plugin_id: i32,
        title: &str,
        category: &str,
        current_version: &str,
        latest_version: &str,
        author: &str,
        downloads: i32,
        description: &str,
        archive_name: &str,
        download_url: &str,
    ) -> Self {
        Plugin {
            plugin_id,
            title: title.to_string(),
            category: category.to_string(),
            current_version: current_version.to_string(),
            latest_version: latest_version.to_string(),
            author: author.to_string(),
            downloads,
            description: description.to_string(),
            archive_name: archive_name.to_string(),
            download_url: download_url.to_string(),
        }
    }
}

// #[derive(Default, Serialize, Deserialize, Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
// pub struct Base {
//     pub plugin_id: i32,
//     pub title: String,
//     pub category: String,
//     pub latest_version: String,
// }

// impl Base {
//     pub fn new(plugin_id: i32, title: &str, category: &str, latest_version: &str) -> Self {
//         Base {
//             plugin_id,
//             title: title.to_string(),
//             category: category.to_string(),
//             latest_version: latest_version.to_string(),
//         }
//     }
// }

// #[derive(Default, Serialize, Deserialize, Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
// pub struct Installed {
//     pub plugin_id: i32,
//     pub title: String,
//     pub description: String,
//     pub category: String,
//     #[serde(default)]
//     pub current_version: String,
//     pub latest_version: String,
//     pub folder: String,
// }

// impl AsRef<Installed> for Installed {
//     fn as_ref(&self) -> &Installed {
//         self
//     }
// }

// impl Installed {
//     pub fn new(
//         plugin_id: i32,
//         title: &str,
//         description: &str,
//         category: &str,
//         current_version: &str,
//         latest_version: &str,
//         folder: &str,
//     ) -> Self {
//         Self {
//             plugin_id,
//             title: title.to_string(),
//             description: description.to_string(),
//             category: category.to_string(),
//             current_version: current_version.to_string(),
//             latest_version: latest_version.to_string(),
//             folder: folder.to_string(),
//         }
//     }
// }

// #[derive(Default, Serialize, Deserialize, Debug, Clone, Eq, PartialEq, Hash, PartialOrd, Ord)]
// pub struct Plugin {
//     pub base_plugin: Installed,
//     pub files: Vec<String>,
// }

// impl AsRef<Installed> for Plugin {
//     fn as_ref(&self) -> &Installed {
//         &self.base_plugin
//     }
// }

// impl Plugin {
//     pub fn new(
//         plugin_id: i32,
//         title: &str,
//         description: &str,
//         category: &str,
//         current_version: &str,
//         latest_version: &str,
//         folder: &str,
//         files: &[String],
//     ) -> Self {
//         Self {
//             base_plugin: Installed::new(
//                 plugin_id,
//                 title,
//                 description,
//                 category,
//                 current_version,
//                 latest_version,
//                 folder,
//             ),
//             files: files.to_vec(),
//         }
//     }
// }
