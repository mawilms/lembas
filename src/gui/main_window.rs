use crate::core::{
    create_plugins_db, get_installed_plugins, get_plugin, get_plugins, update_local_plugins, Plugin,
};
use crate::gui::elements::NavigationPanel;
use crate::gui::style;
use crate::gui::views::{Catalog as CatalogView, Plugins as PluginsView, View};
use iced::{Application, Column, Command, Container, Element, Length, Settings};

use super::views::catalog::Amount;

#[derive(Debug, Clone)]
pub struct MainWindow {
    view: View,
    navigation_panel: NavigationPanel,
    plugins_view: PluginsView,
    catalog_view: CatalogView,
}

#[derive(Debug, Clone)]
pub enum Message {
    InstalledPluginsLoaded(Vec<Plugin>),
    AllPluginsLoaded(Vec<Plugin>),

    // Navigation Panel
    PluginsPressed,
    CatalogPressed,
    AboutPressed,
    SettingsPressed,

    // Navigation View
    PluginInputChanged(String),
    RefreshPressed,
    UpdateAllPressed,

    // Catalog View
    CatalogInputChanged(String),
    AmountFiltered(Amount),
    PluginSearched(Vec<Plugin>),
}

impl Default for MainWindow {
    fn default() -> Self {
        create_plugins_db();
        update_local_plugins();

        Self {
            view: View::default(),
            navigation_panel: NavigationPanel::default(),
            plugins_view: PluginsView::default(),
            catalog_view: CatalogView::default(),
        }
    }
}

impl MainWindow {
    async fn load_installed_plugins() -> Vec<Plugin> {
        get_installed_plugins()
    }

    async fn load_plugins() -> Vec<Plugin> {
        get_plugins()
    }

    async fn get_catalog_plugin(name: String) -> Vec<Plugin> {
        get_plugin(&name)
    }
}

impl Application for MainWindow {
    type Executor = iced::executor::Default;
    type Message = Message;
    type Flags = ();

    fn new(_flags: ()) -> (Self, Command<Message>) {
        (
            Self::default(),
            Command::perform(
                Self::load_installed_plugins(),
                Message::InstalledPluginsLoaded,
            ),
        )
    }

    fn title(&self) -> String {
        String::from("Lembas")
    }

    fn update(&mut self, message: Message) -> Command<Message> {
        match message {
            Message::AllPluginsLoaded(state) | Message::PluginSearched(state) => {
                self.catalog_view.plugins = state;
                self.view = View::Catalog;
                Command::none()
            }
            Message::InstalledPluginsLoaded(state) => {
                self.plugins_view.plugins = state;
                self.view = View::Plugins;
                Command::none()
            }
            Message::PluginsPressed => Command::perform(
                Self::load_installed_plugins(),
                Message::InstalledPluginsLoaded,
            ),
            Message::CatalogPressed => {
                Command::perform(Self::load_plugins(), Message::AllPluginsLoaded)
            }
            Message::AboutPressed => Command::none(),
            Message::SettingsPressed => Command::none(),
            Message::PluginInputChanged(_) => Command::none(),
            Message::RefreshPressed => Command::none(),
            Message::UpdateAllPressed => Command::none(),
            Message::AmountFiltered(_) => Command::none(),
            Message::CatalogInputChanged(state) => {
                self.catalog_view.input_value = state;
                Command::perform(
                    Self::get_catalog_plugin(self.catalog_view.input_value.clone()),
                    Message::PluginSearched,
                )
            }
        }
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
