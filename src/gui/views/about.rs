use crate::gui::style;
use crate::gui::views::Message;
use iced::{Align, Column, Container, Element, Length, Text};

#[derive(Default, Debug, Clone)]
pub struct About {}

impl About {
    pub fn view(&self) -> Element<Message> {
        let about_text = Text::new(
            "Welcome to Lembas

Lembas is a completely free project that tries to make the plugin install process in LotRO as easy as possible.
It's open source and shouldn't be used commercially in any way.
        ",
        );

        let content = Column::new()
            .align_items(Align::Center)
            .push(about_text);

        Container::new(content)
            .width(Length::Fill)
            .height(Length::Fill)
            .padding(20)
            .style(style::Content)
            .into()
    }
}
