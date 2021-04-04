pub mod config;
pub mod plugin;
//pub mod installer;
pub mod synchronizer;

pub use config::Config;
pub use plugin::Plugin;
pub use synchronizer::{
    create_plugins_db, get_installed_plugins, get_plugin, get_plugins, update_local_plugins,
};
