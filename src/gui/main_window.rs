use crate::gui::elements::control_panel::ControlPanel;
use crate::gui::{assets::RING_BEARER, style};
use iced::{Align, Column, Container, Element, Length, Row, Sandbox, Settings, Text};

#[derive(Default)]
pub struct MainWindow {
    control_panel: ControlPanel,

    input_value: String,
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

    fn update(&mut self, message: Self::Message) {
        match message {
            Message::RefreshPressed => {
                println!("Refresh");
            }
            Message::UpdateAllPressed => {
                println!("Update");
            }
            Message::InputChanged(state) => {
                self.input_value = state;
                println!("Changed");
            }
        }
    }

    fn view(&mut self) -> Element<Message> {
        let Self { control_panel, .. } = self;

        let plugin_name = Text::new("Plugin").width(Length::Fill);
        let current_version = Text::new("Current Version");
        let latest_version = Text::new("Latest version");
        let upgrade = Text::new("Upgrade");

        let header_column = Row::new()
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
            .push(control_panel.view())
            .push(header_column);

        Container::new(content)
            .width(Length::Fill)
            .height(Length::Fill)
            .padding(10)
            .style(style::Content)
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
        settings.default_font = Some(RING_BEARER);
        MainWindow::run(settings).unwrap_err();
    }
}
