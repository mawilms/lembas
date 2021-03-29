use crate::gui::elements::{ControlPanel, PluginPanel};
use crate::gui::{assets::RING_BEARER, style};
use iced::{Align, Column, Container, Element, Length, Sandbox, Settings};

#[derive(Default)]
pub struct MainWindow {
    control_panel: ControlPanel,
    plugin_panel: PluginPanel,

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
        let Self {
            control_panel,
            plugin_panel,
            ..
        } = self;

        let content = Column::new()
            .width(Length::Fill)
            .spacing(10)
            .align_items(Align::Center)
            .push(control_panel.view())
            .push(plugin_panel.view());

        Container::new(content)
            .width(Length::Fill)
            .height(Length::Fill)
            .padding(10)
            .style(style::Content)
            .into()
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
