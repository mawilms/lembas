use crate::core::{Config, Plugin, Synchronizer};
use crate::gui::elements::{ControlPanel, PluginPanel};
use crate::gui::{assets::RING_BEARER, style};
use iced::{
    scrollable, Align, Application, Column, Command, Container, Element, Length, Row, Scrollable,
    Settings, Text,
};

#[derive(Default, Debug, Clone)]
pub struct MainWindow {
    control_panel: ControlPanel,
    plugin_panel: PluginPanel,
    synchronizer: Synchronizer,
    plugin_scrollable_state: scrollable::State,
    input_value: String,
    all_plugins: Vec<Plugin>,
}

#[derive(Debug, Clone)]
pub enum Message {
    InputChanged(String),
    RefreshPressed,
    UpdateAllPressed,
    Loaded(MainWindow),
}

impl MainWindow {
    pub fn new(synchronizer: Synchronizer) -> Self {
        Self {
            control_panel: ControlPanel::default(),
            plugin_panel: PluginPanel::default(),
            synchronizer,
            plugin_scrollable_state: scrollable::State::default(),
            input_value: String::default(),
            all_plugins: Vec::default(),
        }
    }

    pub async fn load() -> Self {
        // TODO: Ka was genau hier passiert und warum ich das mit einem perform aufrufe. Eigentlich erstelle ich ja gerade zweimal die gleichen Objekte
        let mut config = Config::default();
        config.init_settings();
        let synchronizer = Synchronizer::new(config);
        synchronizer.create_plugins_db();

        Self::new(synchronizer)
    }
}

impl Application for MainWindow {
    type Executor = iced::executor::Default;
    type Message = Message;
    type Flags = ();

    fn new(_flags: ()) -> (Self, Command<Message>) {
        let mut config = Config::default();
        config.init_settings();
        let synchronizer = Synchronizer::new(config);
        synchronizer.create_plugins_db();

        (
            Self::new(synchronizer),
            Command::perform(Self::load(), Message::Loaded),
        )
    }

    fn title(&self) -> String {
        String::from("Lembas")
    }

    fn update(&mut self, message: Message) -> Command<Message> {
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
            Message::Loaded(state) => {
                self.all_plugins = state.synchronizer.get_plugins();
            }
        }
        Command::none()
    }

    fn view(&mut self) -> Element<Message> {
        let Self {
            control_panel,
            plugin_panel,
            ..
        } = self;

        let mut plugins_scrollable = Scrollable::new(&mut self.plugin_scrollable_state);

        for plugin in &mut self.all_plugins {
            plugins_scrollable = plugins_scrollable.push(plugin.view());
        }

        let content = Column::new()
            .width(Length::Fill)
            .spacing(10)
            .align_items(Align::Center)
            .push(control_panel.view())
            .push(plugin_panel.view())
            .push(plugins_scrollable);

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
