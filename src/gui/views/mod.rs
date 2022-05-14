pub mod about;
pub mod catalog;
pub mod configuration;
pub mod plugins;

use std::path::PathBuf;
use std::sync::Arc;
use std::{env, thread};

use super::views::plugins::PluginMessage;
use crate::core::config::{
    get_database_file_path, get_plugins_dir, initialize_directories, read_existing_settings_file,
};
use crate::core::io::{Cache, FeedUrlParser};
use crate::core::{Downloader, FeedDownloader};
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
use r2d2_sqlite::SqliteConnectionManager;
use tokio::task;

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
    Loaded(Box<State>),
}

#[derive(Debug, Clone)]
pub struct State {
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
    pub fn new(cache: &Arc<Cache>) -> Self {
        Self {
            view: View::default(),
            plugins_view: PluginsView::new(cache.clone()),
            catalog_view: CatalogView::new(cache.clone()),
            about_view: AboutView::default(),
            config_view: ConfigView::new(),
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
                    *self = Lembas::Loaded(Box::new(state));
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
            Lembas::Loaded(state) => {
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

                match state.view {
                    View::Plugins => {
                        let main_container = state.plugins_view.view().map(Message::PluginAction);
                        row().push(navigation_container).push(main_container).into()
                    }
                    View::Catalog => {
                        let main_container = state.catalog_view.view().map(Message::CatalogAction);
                        row().push(navigation_container).push(main_container).into()
                    }
                    View::About => {
                        let main_container = state.about_view.view();
                        row().push(navigation_container).push(main_container).into()
                    }
                    View::Configuration => {
                        let main_container = state.config_view.view().map(Message::ConfigAction);
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
        let database_path = get_database_file_path();
        // let plugins_dir = get_plugins_dir();
        let settings = read_existing_settings_file();
        initialize_directories();

        let manager = SqliteConnectionManager::file(&database_path);
        let pool = r2d2::Pool::new(manager).expect("Error while creating a database pool");

        let cache = Cache::new(pool.clone());

        cache.create_cache_db().expect("Unable to create cache db");
        // Synchronizer::synchronize_application(&plugins_dir, &database_path, &settings.feed_url)
        //     .await
        //     .unwrap();

        task::spawn(async {
            let cache = Cache::new(pool);
            let result = FeedDownloader::fetch_feed_content(settings.feed_url).await;
            if let Ok(content) = result {
                let plugins = FeedUrlParser::parse_response_xml(&content);
                if let Err(err) = cache.sync_plugins(&plugins) {
                    log::debug!("Error while syncing the plugins during startup. {}", err);
                }
            }
        });

        State::new(&Arc::new(cache))
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
