use crate::core::Plugin;
use crate::gui::elements::{ControlPanel, PluginPanel};
use crate::gui::{assets::RING_BEARER, style};
use iced::{Align, Application, Column, Command, Container, Element, Length, Sandbox, Settings};

#[derive(Default, Debug, Clone)]
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
    Loaded(MainWindow),
}

impl MainWindow {
    pub async fn load() -> Self {
        Self::default()
    }
}

impl Application for MainWindow {
    type Executor = iced::executor::Default;
    type Message = Message;
    type Flags = ();

    fn new(_flags: ()) -> (Self, Command<Message>) {
        (
            Self::default(),
            Command::perform(Self::load(), Message::Loaded),
        )
    }

    fn title(&self) -> String {
        String::from("Lembas")
    }

    fn update(&mut self, message: Message) -> Command<Message> {
        // match message {
        //     Message::RefreshPressed => {
        //         println!("Refresh");
        //     }
        //     Message::UpdateAllPressed => {
        //         println!("Update");
        //     }
        //     Message::InputChanged(state) => {
        //         self.input_value = state;
        //         println!("Changed");
        //     }
        //     Message::Loaded => {}
        // }
        Command::none()
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
