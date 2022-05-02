pub mod about;
pub mod catalog;
pub mod configuration;
pub mod plugins;

use std::env;
use std::path::PathBuf;

use super::views::plugins::PluginMessage;
use crate::core::io::cache::create_cache_db;
use crate::core::io::Synchronizer;
use crate::core::Config;
use crate::gui::style;
pub use about::About as AboutView;
pub use catalog::{Catalog as CatalogView, Message as CatalogMessage};
pub use configuration::{Configuration as ConfigView, Message as ConfigMessage};

use iced::pure::{button, column, container, image, row, text, Application, Element};
use iced::{
    alignment::{Horizontal, Vertical},
    window::Settings as Window,
    Alignment, Command, Length, Settings, Space,
};
pub use plugins::Plugins as PluginsView;

const VERSION: &str = env!("CARGO_PKG_VERSION");

#[derive(Debug, Clone)]
pub enum View {
    Plugins,
    Catalog,
    About,
    Configuration,
}

impl Default for View {
    fn default() -> Self {
        Self::Plugins
    }
}

#[derive(Debug, Clone)]
pub enum Lembas {
    Loading,
    Loaded(State),
}

#[derive(Debug, Clone)]
pub struct State {
    config: Config,
    view: View,
    plugins_view: PluginsView,
    catalog_view: CatalogView,
    about_view: AboutView,
    config_view: ConfigView,
}

#[derive(Debug, Clone)]
pub enum Message {
    Loaded(State),

    // Navigation Panel
    PluginsPressed,
    CatalogPressed,
    AboutPressed,
    SettingsPressed,

    CatalogAction(CatalogMessage),
    PluginAction(PluginMessage),
    ConfigAction(ConfigMessage),
}

impl State {
    pub fn new(config: &Config) -> Self {
        Self {
            config: config.clone(),
            view: View::default(),
            plugins_view: PluginsView::new(config.clone()),
            catalog_view: CatalogView::new(config.clone()),
            about_view: AboutView::default(),
            config_view: ConfigView::new(config),
        }
    }
}

impl Application for Lembas {
    type Executor = iced::executor::Default;
    type Message = Message;
    type Flags = ();

    fn new(_flags: ()) -> (Self, Command<Message>) {
        (
            Self::Loading,
            Command::perform(Self::init_application(), Message::Loaded),
        )
    }

    fn title(&self) -> String {
        format!("Lembas {}", VERSION)
    }

    fn update(&mut self, message: Self::Message) -> Command<Message> {
        match self {
            Lembas::Loading => {
                if let Message::Loaded(state) = message {
                    *self = Lembas::Loaded(state);
                }
                Command::none()
            }
            Lembas::Loaded(state) => match message {
                Message::PluginsPressed => {
                    state.plugins_view.update(PluginMessage::LoadPlugins);
                    state.view = View::Plugins;
                    Command::none()
                }
                Message::CatalogPressed => {
                    state.view = View::Catalog;
                    state
                        .catalog_view
                        .update(CatalogMessage::LoadPlugins)
                        .map(Message::CatalogAction)
                }
                Message::AboutPressed => {
                    state.view = View::About;
                    Command::none()
                }
                Message::SettingsPressed => {
                    state.view = View::Configuration;
                    Command::none()
                }
                Message::PluginAction(msg) => {
                    state.plugins_view.update(msg).map(Message::PluginAction)
                }
                Message::CatalogAction(msg) => {
                    state.catalog_view.update(msg).map(Message::CatalogAction)
                }
                Message::Loaded(_) => Command::none(),
                Message::ConfigAction(msg) => {
                    state.config_view.update(msg);
                    Command::none()
                }
            },
        }
    }

    fn view(&self) -> Element<Message> {
        match self {
            Lembas::Loading => loading_data(),
            Lembas::Loaded(State {
                config: _,
                view,
                plugins_view,
                catalog_view,
                about_view,
                config_view,
            }) => {
                let plugins_btn =
                    button(text("My Plugins").horizontal_alignment(Horizontal::Center))
                        .on_press(Message::PluginsPressed)
                        .width(Length::Units(100))
                        .padding(5)
                        .style(style::PrimaryButton::Enabled);
                let catalog_btn = button(text("Catalog").horizontal_alignment(Horizontal::Center))
                    .on_press(Message::CatalogPressed)
                    .width(Length::Units(100))
                    .padding(5)
                    .style(style::PrimaryButton::Enabled);
                let about_btn = button(text("About").horizontal_alignment(Horizontal::Center))
                    .on_press(Message::AboutPressed)
                    .width(Length::Units(100))
                    .padding(5)
                    .style(style::PrimaryButton::Enabled);
                let settings_btn =
                    button(text("Settings").horizontal_alignment(Horizontal::Center))
                        .on_press(Message::SettingsPressed)
                        .width(Length::Units(100))
                        .padding(5)
                        .style(style::PrimaryButton::Enabled);

                let mut image_path = PathBuf::from(env!("CARGO_MANIFEST_DIR"));
                image_path.push("resources/assets/bread_light.png");

                let row_bla = column()
                    .spacing(20)
                    .align_items(Alignment::Center)
                    .push(
                        image(image_path)
                            .width(Length::Units(85))
                            .height(Length::Units(85)),
                    )
                    .push(plugins_btn)
                    .push(catalog_btn)
                    .push(Space::new(Length::Shrink, Length::Fill))
                    .push(about_btn)
                    .push(settings_btn);

                let navigation_container = container(row_bla)
                    .width(Length::Shrink)
                    .height(Length::Fill)
                    .padding(25)
                    .style(style::NavigationContainer);

                match view {
                    View::Plugins => {
                        let main_container = plugins_view.view().map(Message::PluginAction);
                        row().push(navigation_container).push(main_container).into()
                    }
                    View::Catalog => {
                        let main_container = catalog_view.view().map(Message::CatalogAction);
                        row().push(navigation_container).push(main_container).into()
                    }
                    View::About => {
                        let main_container = about_view.view();
                        row().push(navigation_container).push(main_container).into()
                    }
                    View::Configuration => {
                        let main_container = config_view.view().map(Message::ConfigAction);
                        row().push(navigation_container).push(main_container).into()
                    }
                }
            }
        }
    }
}

impl Lembas {
    pub fn start() {
        let icon: &[u8] = include_bytes!("../../../resources/assets/icon.ico");

        let image = image::load_from_memory(icon)
            .expect("loading icon")
            .to_rgba8();
        let (width, height) = image.dimensions();
        let icon = iced::window::Icon::from_rgba(image.into_raw(), width, height);

        let settings: Settings<()> = Settings {
            window: Window {
                size: (900, 620),
                resizable: true,
                decorations: true,
                icon: Some(icon.unwrap()),
                ..iced::window::Settings::default()
            },
            default_text_size: 17,
            ..iced::Settings::default()
        };
        Lembas::run(settings).unwrap_err();
    }

    pub async fn init_application() -> State {
        let config = Config::new();

        create_cache_db(&config.database_path).expect("Unable to create cache db");
        Synchronizer::synchronize_application(
            &config.plugins_dir,
            &config.database_path,
            &config.application_settings.feed_url,
        )
        .await
        .unwrap();

        State::new(&config)
    }
}

fn loading_data<'a>() -> Element<'a, Message> {
    container(
        text("Plugins loading...")
            .horizontal_alignment(Horizontal::Center)
            .vertical_alignment(Vertical::Center)
            .size(20),
    )
    .width(Length::Fill)
    .height(Length::Fill)
    .center_y()
    .center_x()
    .style(style::Content)
    .into()
}
