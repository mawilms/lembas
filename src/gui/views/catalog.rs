use crate::core::Plugin;
use crate::gui::elements::{ControlPanel, PluginPanel};
use crate::gui::main_window::Message;
use crate::gui::style;
use iced::{scrollable, Align, Column, Container, Element, Length, Scrollable};

#[derive(Default, Debug, Clone)]
pub struct Catalog {
    control_panel: ControlPanel,
    plugin_panel: PluginPanel,
    plugin_scrollable_state: scrollable::State,
    input_value: String,
    pub plugins: Vec<Plugin>,
}

impl Catalog {
    pub fn view(&mut self) -> Element<Message> {
        let Self {
            control_panel,
            plugin_panel,
            ..
        } = self;

        let mut plugins_scrollable = Scrollable::new(&mut self.plugin_scrollable_state)
            .spacing(5)
            .width(Length::Fill)
            .align_items(Align::Center)
            .style(style::Scrollable);

        for plugin in &mut self.plugins {
            plugins_scrollable = plugins_scrollable.push(plugin.view());
        }

        let content = Column::new()
            .width(Length::Fill)
            .spacing(10)
            .align_items(Align::Center)
            .push(control_panel.view())
            .push(plugin_panel.view())
            .push(plugins_scrollable);

        Container::new(content)
            .width(Length::Fill)
            .height(Length::Fill)
            .padding(10)
            .style(style::Content)
            .into()
    }
}
