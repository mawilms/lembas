use crate::core::config::CONFIGURATION;
use crate::core::{
    create_plugins_db, get_installed_plugins, get_plugin, get_plugins, installer,
    synchronizer::install_plugin, update_local_plugins, Plugin,
};
use crate::gui::elements::NavigationPanel;
use crate::gui::style;
use crate::gui::views::{About as AboutView, Catalog as CatalogView, Plugins as PluginsView, View};
use iced::{Application, Column, Command, Container, Element, Length, Settings};
use std::path::Path;

use super::views::catalog::Amount;

#[derive(Debug, Clone)]
pub struct MainWindow {
    view: View,
    navigation_panel: NavigationPanel,
    plugins_view: PluginsView,
    catalog_view: CatalogView,
    about_view: AboutView,
}

#[derive(Debug, Clone)]
pub enum Message {
    InstalledPluginsLoaded(Vec<Plugin>),
    AllPluginsLoaded(Vec<Plugin>),
    PluginsSynchronized(Result<(), ApplicationError>),

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
    InstallPressed(Plugin),

    // Plugin View
    UpgradePressed(Plugin),
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
            about_view: AboutView::default(),
        }
    }
}

impl MainWindow {
    async fn install_plugin(plugin: Plugin) -> Vec<Plugin> {
        println!("Install pressed");
        let filename = format!("{}_{}.zip", &plugin.plugin_id, &plugin.title);
        let path = Path::new(&CONFIGURATION.plugins).join(&filename);
        let target = format!(
            "https://www.lotrointerface.com/downloads/download{}-{}",
            &plugin.plugin_id, &plugin.title
        );

        match installer::install(&path, &target).await {
            Ok(_) => {
                installer::zip_operation(path.as_path());
                install_plugin(&plugin);
                get_installed_plugins()
            }
            Err(_) => {
                // TODO: Implement proper error handling
                let result: Vec<Plugin> = Vec::new();
                result
            }
        }
    }

    async fn update_plugins(plugins: Vec<Plugin>) -> Vec<Plugin> {
        // TODO Implement here
        let result: Vec<Plugin> = Vec::new();
        result
    }

    async fn load_installed_plugins() -> Vec<Plugin> {
        get_installed_plugins()
    }

    async fn load_plugins() -> Vec<Plugin> {
        get_plugins()
    }

    async fn get_catalog_plugin(name: String) -> Vec<Plugin> {
        get_plugin(&name)
    }

    async fn refresh_db() -> Result<(), ApplicationError> {
        match update_local_plugins().await {
            Ok(_) => Ok(()),
            Err(_) => Err(ApplicationError::SynchronizeError),
        }
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
            Message::AboutPressed => {
                self.view = View::About;
                Command::none()
            }
            Message::SettingsPressed => Command::none(),
            Message::PluginInputChanged(_) => Command::none(),
            Message::RefreshPressed => {
                Command::perform(Self::refresh_db(), Message::PluginsSynchronized)
            }
            Message::UpdateAllPressed => {
                let plugins = self.plugins_view.plugins.clone();
                Command::perform(
                    Self::update_plugins(plugins),
                    Message::InstalledPluginsLoaded,
                )
            }
            Message::AmountFiltered(_) => Command::none(),
            Message::CatalogInputChanged(state) => {
                self.catalog_view.input_value = state;
                Command::perform(
                    Self::get_catalog_plugin(self.catalog_view.input_value.clone()),
                    Message::PluginSearched,
                )
            }
            Message::InstallPressed(plugin) => {
                let plugin = plugin.clone();
                Command::perform(
                    Self::install_plugin(plugin),
                    Message::InstalledPluginsLoaded,
                )
            }
            Message::PluginsSynchronized(result) => match result {
                Ok(_) => {
                    println!("Synchronized");
                    Command::none()
                }
                Err(_) => {
                    println!("Boom");
                    Command::none()
                }
            },
            Message::UpgradePressed(_) => {
                println!("Upgrade");
                Command::none()
            }
        }
    }

    fn view(&mut self) -> Element<Message> {
        let Self {
            view,
            navigation_panel,
            plugins_view,
            catalog_view,
            about_view,
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
            View::About => {
                let main_container = about_view.view();
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

#[derive(Debug, Clone)]
enum ApplicationError {
    LoadError,
    InstallError,
    SynchronizeError,
}
