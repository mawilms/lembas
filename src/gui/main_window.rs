use iced::{button, Align, Button, Element, Row, Sandbox, Settings, Text};

#[derive(Default)]
pub struct MainWindow {
    refresh_button: button::State,
    update_all_button: button::State,
}

#[derive(Debug, Clone, Copy)]
pub enum Message {
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
        Row::new()
            .padding(10)
            .align_items(Align::Center)
            .push(
                Button::new(&mut self.refresh_button, Text::new("Refresh"))
                    .on_press(Message::RefreshPressed),
            )
            .push(
                Button::new(&mut self.update_all_button, Text::new("Update all"))
                    .on_press(Message::UpdateAllPressed),
            )
            .into()
    }
}

impl MainWindow {
    pub fn start() {
        let mut settings: Settings<()> = Settings::default();
        settings.window.size = (800, 420);
        MainWindow::run(settings).unwrap_err();
    }
}
