use crate::core::{Config, Plugin, Synchronizer};
use crate::gui::elements::NavigationPanel;
use crate::gui::style;
use crate::gui::views::{Catalog as CatalogView, Plugins as PluginsView, View};
use iced::{Application, Column, Command, Container, Element, Length, Settings};

use super::views::catalog::Amount;

#[derive(Default, Debug, Clone)]
pub struct MainWindow {
    view: View,
    navigation_panel: NavigationPanel,
    plugins_view: PluginsView,
    catalog_view: CatalogView,
    synchronizer: Synchronizer,
}

#[derive(Debug, Clone)]
pub enum Message {
    Loaded(Vec<Plugin>),

    // Navigation Panel
    PluginsPressed,
    CatalogPressed,
    AboutPressed,
    SettingsPressed,

    // Navigation View
    InputChanged(String),
    RefreshPressed,
    UpdateAllPressed,

    // Catalog View
    AmountFiltered(Amount),
}

impl MainWindow {
    pub async fn load() -> Vec<Plugin> {
        let mut config = Config::default();
        config.init_settings();
        let synchronizer = Synchronizer::new(config);
        synchronizer.create_plugins_db();
        synchronizer.get_installed_plugins()
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
        match message {
            Message::Loaded(state) => {
                self.plugins_view.installed_plugins = state;
            }
            Message::PluginsPressed => {
                self.view = View::Plugins;
            }
            Message::CatalogPressed => {
                self.view = View::Catalog;
            }
            Message::AboutPressed => {}
            Message::SettingsPressed => {}
            Message::InputChanged(_) => {}
            Message::RefreshPressed => {}
            Message::UpdateAllPressed => {}
            Message::AmountFiltered(_) => {}
        }
        Command::none()
    }

    fn view(&mut self) -> Element<Message> {
        let Self {
            view,
            navigation_panel,
            plugins_view,
            catalog_view,
            ..
        } = self;
        let navigation_container = Container::new(navigation_panel.view())
            .width(Length::Fill)
            .padding(10)
            .style(style::PluginRow);

        match view {
            View::Plugins => {
                let main_container = plugins_view.view();
                Column::new()
                    .width(Length::Fill)
                    .push(navigation_container)
                    .push(main_container)
                    .into()
            }
            View::Catalog => {
                let main_container = catalog_view.view();
                Column::new()
                    .width(Length::Fill)
                    .push(navigation_container)
                    .push(main_container)
                    .into()
            }
        }
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
