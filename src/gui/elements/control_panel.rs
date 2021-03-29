use crate::gui::main_window::Message;
use crate::gui::{style};
use iced::{
    button, text_input, Align, Button, Element, Font, Length, Row, Text, TextInput,
};

const FONT: Font = Font::External {
    name: "RingBearer",
    bytes: include_bytes!("../assets/RingBearer.ttf"),
};

#[derive(Default, Debug, Clone)]
pub struct ControlPanel {
    search_input: text_input::State,
    input_value: String,

    refresh_button: button::State,
    update_all_button: button::State,
}

impl ControlPanel {
    pub fn view(&mut self) -> Element<Message> {
        let refresh_button = Button::new(&mut self.refresh_button, Text::new("Refresh"))
            .on_press(Message::RefreshPressed)
            .padding(5)
            .style(style::PrimaryButton::Enabled);
        let update_all_button = Button::new(&mut self.update_all_button, Text::new("Update all"))
            .on_press(Message::UpdateAllPressed)
            .padding(5)
            .style(style::PrimaryButton::Enabled);
        let installed_plugins = Text::new("5 plugins installed").font(FONT);
        let search_plugins = TextInput::new(
            &mut self.search_input,
            "Search plugins...",
            &self.input_value,
            Message::InputChanged,
        );

        Row::new()
            .width(Length::Fill)
            .align_items(Align::Center)
            .spacing(10)
            .push(refresh_button)
            .push(update_all_button)
            .push(installed_plugins)
            .push(search_plugins)
            .into()
    }
}
