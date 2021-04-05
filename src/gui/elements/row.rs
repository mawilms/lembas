use crate::gui::main_window::Message;
use iced::{button, Button, Column, Element, Length, Row, Text};

#[derive(Clone, Debug)]
pub struct Plugin {
    pub id: i32,
    pub title: String,
    pub current_version: String,
    pub latest_version: String,
    opened: bool,
    toggle_view_btn: button::State,
}

impl Plugin {
    pub fn new(id: i32, title: String, current_version: String, latest_version: String) -> Self {
        Self {
            id,
            title,
            current_version,
            latest_version,
            toggle_view_btn: button::State::new(),
            opened: false,
        }
    }

    fn update(&mut self, message: Message) {}

    pub fn view(&mut self) -> Element<'_, Message> {
        match self.opened {
            true => Column::new()
                .push(
                    Button::new(
                        &mut self.toggle_view_btn,
                        Row::new().push(Text::new(&self.title)),
                    )
                    .padding(10)
                    .width(Length::Fill)
                    .on_press(Message::ToggleView),
                )
                .push(
                    Row::new()
                        .push(Text::new("Hallo").width(Length::Fill))
                        .padding(20),
                )
                .into(),

            false => Column::new()
                .spacing(5)
                .push(
                    Button::new(
                        &mut self.toggle_view_btn,
                        Row::new().push(Text::new(&self.title)),
                    )
                    .padding(10)
                    .width(Length::Fill)
                    .on_press(Message::ToggleView),
                )
                .into(),
        }
    }
}
