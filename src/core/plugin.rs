use crate::gui::main_window::Message;
use crate::gui::style;
use iced::{button, Button, Container, Element, Length};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize, Debug, Clone, Default)]
pub struct Plugin {
    #[serde(skip)]
    pub install_btn_state: button::State,
    pub plugin_id: i32,
    pub title: String,
    #[serde(default)]
    pub current_version: String,
    pub latest_version: String,
}

impl Plugin {
    pub fn view(&mut self) -> Element<Message> {
        use iced::{Row, Text};

        if self.current_version == self.latest_version {
            let row = Row::new()
                .push(Text::new(&self.title).width(Length::FillPortion(5)))
                .push(Text::new(&self.current_version).width(Length::FillPortion(3)))
                .push(Text::new(&self.latest_version).width(Length::FillPortion(3)))
                .push(Text::new("Update").width(Length::FillPortion(2)));
            Container::new(row)
                .width(Length::Fill)
                .padding(5)
                .style(style::PluginRow)
                .into()
        } else {
            let row = Row::new()
                .push(Text::new(&self.title).width(Length::FillPortion(5)))
                .push(Text::new(&self.current_version).width(Length::FillPortion(3)))
                .push(Text::new(&self.latest_version).width(Length::FillPortion(3)))
                .push(Text::new("").width(Length::FillPortion(2)));
            Container::new(row)
                .width(Length::Fill)
                .padding(5)
                .style(style::PluginRow)
                .into()
        }
    }

    pub fn catalog_view(&mut self) -> Element<Message> {
        use iced::{Row, Text};
        let plugin = self.clone();

        let row = Row::new()
            .push(Text::new(&self.title).width(Length::FillPortion(5)))
            .push(Text::new(&self.current_version).width(Length::FillPortion(3)))
            .push(Text::new(&self.latest_version).width(Length::FillPortion(3)))
            .push(
                Button::new(&mut self.install_btn_state, Text::new("Install"))
                    .on_press(Message::InstallPressed(plugin))
                    .width(Length::FillPortion(2)),
            );

        Container::new(row)
            .width(Length::Fill)
            .padding(5)
            .style(style::PluginRow)
            .into()
    }
}
