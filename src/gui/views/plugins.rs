use crate::gui::elements::{ControlPanel, PluginPanel};

#[derive(Default, Debug, Clone)]
pub struct Plugins {
    control_panel: ControlPanel,
    plugin_panel: PluginPanel,
}

enum Message {
    InputChanged(String),
    RefreshPressed,
    UpdateAllPressed,
}

impl Plugins {
    pub fn view(&mut self) {}
}
