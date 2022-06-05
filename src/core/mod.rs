pub mod config;
pub mod installer;
pub mod io;
pub mod lotro_compendium;
pub mod plugin;

//pub use lotro_compendium::{Downloader, FeedDownloader};
pub use installer::Installer;
pub use plugin::Plugin;
