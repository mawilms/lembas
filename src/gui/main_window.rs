use crate::core::{Config, Synchronizer};
use crate::gui::elements::NavigationPanel;
use crate::gui::style;
use crate::gui::views::Plugins as PluginsView;
use iced::{
    scrollable, Align, Application, Column, Command, Container, Element, Length, Scrollable,
    Settings,
};

#[derive(Default, Debug, Clone)]
pub struct MainWindow {
    navigation_panel: NavigationPanel,
    plugins_view: PluginsView,
    synchronizer: Synchronizer,
}

#[derive(Debug, Clone)]
pub enum Message {
    Loaded(MainWindow),
    PluginsPressed,
    CatalogPressed,
    AboutPressed,
    SettingsPressed,

    InputChanged(String),
    RefreshPressed,
    UpdateAllPressed,
}

impl MainWindow {
    pub fn new(synchronizer: Synchronizer) -> Self {
        Self {
            navigation_panel: NavigationPanel::default(),
            plugins_view: PluginsView::default(),
            synchronizer,
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
        // let mut config = Config::default();
        // config.init_settings();
        // let synchronizer = Synchronizer::new(config);
        // synchronizer.create_plugins_db();

        (
            Self::default(),
            Command::perform(Self::load(), Message::Loaded),
        )
    }

    fn title(&self) -> String {
        String::from("Lembas")
    }

    fn update(&mut self, message: Message) -> Command<Message> {
        match message {
            Message::Loaded(state) => {
                println!("Loaded")
            }
            Message::PluginsPressed => {}
            Message::CatalogPressed => {}
            Message::AboutPressed => {}
            Message::SettingsPressed => {}
            Message::InputChanged(_) => {}
            Message::RefreshPressed => {}
            Message::UpdateAllPressed => {}
        }
        Command::none()
    }

    fn view(&mut self) -> Element<Message> {
        let Self {
            navigation_panel,
            plugins_view,
            ..
        } = self;
        let navigation_container = Container::new(navigation_panel.view())
            .width(Length::Fill)
            .padding(10)
            .style(style::PluginRow);

        let main_container = plugins_view.view();

        Column::new()
            .width(Length::Fill)
            .push(navigation_container)
            .push(main_container)
            .into()
    }
}

impl MainWindow {
    pub fn start() {
        let mut settings: Settings<()> = Settings::default();
        settings.window.size = (900, 620);
        //settings.default_font = Some(RING_BEARER);
        MainWindow::run(settings).unwrap_err();
    }
}
