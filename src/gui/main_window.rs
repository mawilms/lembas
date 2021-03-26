use iced::{button, text_input, Align, Button, Element, Row, Sandbox, Settings, Text, TextInput};

#[derive(Default)]
pub struct MainWindow {
    search_input: text_input::State,
    input_value: String,

    refresh_button: button::State,
    update_all_button: button::State,
}

#[derive(Debug, Clone)]
pub enum Message {
    InputChanged(String),
    RefreshPressed,
    UpdateAllPressed,
}

impl Sandbox for MainWindow {
    type Message = Message;

    fn new() -> Self {
        Self::default()
    }

    fn title(&self) -> String {
        String::from("Lembas")
    }

    fn update(&mut self, _message: Self::Message) {
        // This application has no interactions
    }

    fn view(&mut self) -> Element<Message> {
        let top_panel = Row::new();

        let refresh_button = Button::new(&mut self.refresh_button, Text::new("Refresh"))
            .on_press(Message::RefreshPressed);
        let update_all_button = Button::new(&mut self.update_all_button, Text::new("Update all"))
            .on_press(Message::UpdateAllPressed);
        let installed_plugins = Text::new("5 plugins installed");
        let search_plugins = TextInput::new(
            &mut self.search_input,
            "Search plugins...",
            &self.input_value,
            Message::InputChanged,
        );

        top_panel
            .push(refresh_button)
            .push(update_all_button)
            .push(installed_plugins)
            .push(search_plugins)
            .into()
    }

    fn background_color(&self) -> iced::Color {
        iced::Color::WHITE
    }

    fn scale_factor(&self) -> f64 {
        1.0
    }
}

impl MainWindow {
    pub fn start() {
        let mut settings: Settings<()> = Settings::default();
        settings.window.size = (800, 420);
        MainWindow::run(settings).unwrap_err();
    }
}
