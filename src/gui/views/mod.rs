pub mod about;
pub mod catalog;
pub mod plugins;

pub use about::About;
pub use catalog::{Catalog as CatalogView, Message as CatalogMessage};
pub use plugins::Plugins as PluginsView;

#[derive(Debug, Clone)]
pub enum View {
    Plugins,
    Catalog,
    About,
}

impl Default for View {
    fn default() -> Self {
        Self::Plugins
    }
}
