pub mod catalog;
pub mod plugins;

pub use catalog::Catalog;
pub use plugins::Plugins;

#[derive(Debug, Clone)]
pub enum View {
    Plugins,
    Catalog,
}

impl Default for View {
    fn default() -> Self {
        Self::Plugins
    }
}