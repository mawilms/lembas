use crate::gui::main_window::Message;
use iced::{Align, Element, Length, Row, Text};

#[derive(Default)]
pub struct PluginPanel {}

impl PluginPanel {
    pub fn view(&self) -> Element<Message> {
        let plugin_name = Text::new("Plugin").width(Length::Fill);
        let current_version = Text::new("Current Version");
        let latest_version = Text::new("Latest version");
        let upgrade = Text::new("Upgrade");

        Row::new()
            .width(Length::Fill)
            .align_items(Align::Center)
            .spacing(10)
            .push(plugin_name)
            .push(current_version)
            .push(latest_version)
            .push(upgrade)
            .into()
    }
}
