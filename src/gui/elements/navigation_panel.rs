use crate::gui::main_window::Message;
use crate::gui::style;
use iced::{button, text_input, Align, Button, Container, Element, Length, Row, Space, Text};

#[derive(Debug, Default, Clone)]
pub struct NavigationPanel {
    search_input: text_input::State,
    input_value: String,

    plugins_btn: button::State,
    catalog_btn: button::State,
    about_btn: button::State,
    settings_btn: button::State,
}

impl NavigationPanel {
    pub fn view(&mut self) -> Element<Message> {
        let plugins_btn = Button::new(&mut self.plugins_btn, Text::new("My Plugins"))
            .on_press(Message::PluginsPressed)
            .padding(5)
            .style(style::PrimaryButton::Enabled);
        let catalog_btn = Button::new(&mut self.catalog_btn, Text::new("Catalog"))
            .on_press(Message::CatalogPressed)
            .padding(5)
            .style(style::PrimaryButton::Enabled);
        let divider = Space::new(Length::Fill, Length::Shrink);
        let about_btn = Button::new(&mut self.about_btn, Text::new("About"))
            .on_press(Message::AboutPressed)
            .padding(5)
            .style(style::PrimaryButton::Enabled);
        let settings_btn = Button::new(&mut self.settings_btn, Text::new("Settings"))
            .on_press(Message::SettingsPressed)
            .padding(5)
            .style(style::PrimaryButton::Enabled);

        let row = Row::new()
            .width(Length::Fill)
            .align_items(Align::Center)
            .spacing(10)
            .push(plugins_btn)
            .push(catalog_btn)
            .push(divider)
            .push(about_btn)
            .push(settings_btn);

        Container::new(row)
            .width(Length::Fill)
            .style(style::PluginRow)
            .into()
    }
}
