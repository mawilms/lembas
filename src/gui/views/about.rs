use crate::gui::main_window::Message;
use crate::gui::style;
use iced::{Align, Column, Container, Element, Length, Text};

#[derive(Default, Debug, Clone)]
pub struct About {}

impl About {
    pub fn view(&self) -> Element<Message> {
        let about_text = Text::new("Hallo Welt");

        let content = Column::new()
            .width(Length::Fill)
            .spacing(10)
            .align_items(Align::Center)
            .push(about_text);

        Container::new(content)
            .width(Length::Fill)
            .height(Length::Fill)
            .padding(10)
            .style(style::Content)
            .into()
    }
}
