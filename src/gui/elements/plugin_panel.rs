use crate::gui::main_window::Message;
use iced::{scrollable, Align, Column, Element, Length, Row, Scrollable, Text};

#[derive(Default, Debug, Clone)]
pub struct PluginPanel {
    plugin_scrollable_state: scrollable::State,
}

impl PluginPanel {
    pub fn view(&mut self) -> Element<Message> {
        let plugin_name = Text::new("Plugin").width(Length::FillPortion(5));
        let current_version = Text::new("Current Version").width(Length::FillPortion(3));
        let latest_version = Text::new("Latest version").width(Length::FillPortion(3));
        let upgrade = Text::new("Upgrade").width(Length::FillPortion(2));

        let header = Row::new()
            .width(Length::Fill)
            .align_items(Align::Center)
            .spacing(10)
            .push(plugin_name)
            .push(current_version)
            .push(latest_version)
            .push(upgrade);

        let plugin_name = Text::new("TitanBar").width(Length::FillPortion(5));
        let current_version = Text::new("v1.20.00").width(Length::FillPortion(3));
        let latest_version = Text::new("v1.24.45").width(Length::FillPortion(3));
        let upgrade = Text::new("Upgrade").width(Length::FillPortion(2));

        let item = Row::new()
            .width(Length::Fill)
            .align_items(Align::Center)
            .spacing(10)
            .push(plugin_name)
            .push(current_version)
            .push(latest_version)
            .push(upgrade);

        let content = Column::new()
            .width(Length::Fill)
            .spacing(10)
            .align_items(Align::Center)
            .push(header)
            .push(item);

        Scrollable::new(&mut self.plugin_scrollable_state)
            .width(Length::Fill)
            .height(Length::Fill)
            .padding(10)
            .push(content)
            .into()
    }
}
