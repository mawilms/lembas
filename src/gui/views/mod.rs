pub mod about;
pub mod catalog;
pub mod configuration;
pub mod plugins;

use super::views::plugins::PluginMessage;
use crate::core::Synchronizer;
use crate::gui::style;
pub use about::About as AboutView;
pub use catalog::{Catalog as CatalogView, Message as CatalogMessage};
pub use configuration::{Configuration as ConfigView, Message as ConfigMessage};
use iced::{
    button, window::Settings as Window, Align, Application, Button, Clipboard, Column, Command,
    Container, Element, HorizontalAlignment, Length, Row, Settings, Space, Text, VerticalAlignment,
};
pub use plugins::Plugins as PluginsView;

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
    view: View,
    plugins_view: PluginsView,
    catalog_view: CatalogView,
    about_view: AboutView,
    config_view: ConfigView,

    input_value: String,
    plugins_btn: button::State,
    catalog_btn: button::State,
    about_btn: button::State,
    settings_btn: button::State,
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

impl Default for State {
    fn default() -> Self {
        Self {
            view: View::default(),
            plugins_view: PluginsView::default(),
            catalog_view: CatalogView::default(),
            about_view: AboutView::default(),
            config_view: ConfigView::default(),
            input_value: "".to_string(),
            plugins_btn: button::State::default(),
            catalog_btn: button::State::default(),
            about_btn: button::State::default(),
            settings_btn: button::State::default(),
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
        String::from("Lembas")
    }

    fn update(&mut self, message: Message, _clipboard: &mut Clipboard) -> Command<Message> {
        match self {
            Lembas::Loading => {
                if let Message::Loaded(_state) = message {
                    *self = Lembas::Loaded(State { ..State::default() })
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
                    state.plugins_view.update(msg);
                    Command::none()
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

    fn view(&mut self) -> Element<Message> {
        match self {
            Lembas::Loading => loading_data(),
            Lembas::Loaded(State {
                view,
                plugins_view,
                catalog_view,
                about_view,
                config_view,
                input_value: _,
                plugins_btn,
                catalog_btn,
                about_btn,
                settings_btn,
            }) => {
                let plugins_btn = Button::new(plugins_btn, Text::new("My Plugins"))
                    .on_press(Message::PluginsPressed)
                    .padding(5)
                    .style(style::PrimaryButton::Enabled);
                let catalog_btn = Button::new(catalog_btn, Text::new("Catalog"))
                    .on_press(Message::CatalogPressed)
                    .padding(5)
                    .style(style::PrimaryButton::Enabled);
                let divider = Space::new(Length::Fill, Length::Shrink);
                let about_btn = Button::new(about_btn, Text::new("About"))
                    .on_press(Message::AboutPressed)
                    .padding(5)
                    .style(style::PrimaryButton::Enabled);
                let settings_btn = Button::new(settings_btn, Text::new("Settings"))
                    .on_press(Message::SettingsPressed)
                    .padding(5)
                    .style(style::PrimaryButton::Enabled);

                let row = Row::new()
                    .width(Length::Fill)
                    .align_items(Align::Center)
                    .spacing(10)
                    .push(plugins_btn)
                    .push(catalog_btn)
                    .push(divider)
                    .push(about_btn)
                    .push(settings_btn);

                let navigation_container = Container::new(row)
                    .width(Length::Fill)
                    .padding(10)
                    .style(style::NavigationContainer);

                match view {
                    View::Plugins => {
                        //plugins_view.update(PluginMessage::LoadPlugins);
                        let main_container = plugins_view.view().map(Message::PluginAction);
                        Column::new()
                            .width(Length::Fill)
                            .push(navigation_container)
                            .push(main_container)
                            .into()
                    }
                    View::Catalog => {
                        let main_container = catalog_view.view().map(Message::CatalogAction);
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
                    View::Configuration => {
                        let main_container = config_view.view().map(Message::ConfigAction);
                        Column::new()
                            .width(Length::Fill)
                            .push(navigation_container)
                            .push(main_container)
                            .into()
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
        Synchronizer::create_plugins_db();
        //Synchronizer::update_local_plugins();
        Synchronizer::synchronize_application();

        State::default()
    }
}

fn loading_data<'a>() -> Element<'a, Message> {
    Container::new(
        Text::new("Plugins loading...")
            .horizontal_alignment(HorizontalAlignment::Center)
            .vertical_alignment(VerticalAlignment::Center)
            .size(20),
    )
    .width(Length::Fill)
    .height(Length::Fill)
    .center_y()
    .center_x()
    .style(style::Content)
    .into()
}
