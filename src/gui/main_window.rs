use crate::core::{create_plugins_db, update_local_plugins};
use crate::gui::style;
use crate::gui::views::{About as AboutView, CatalogMessage, CatalogView, PluginsView, View};
use iced::{
    button, Align, Application, Button, Column, Command, Container, Element, HorizontalAlignment,
    Length, Row, Settings, Space, Text, VerticalAlignment,
};

use super::views::{
    catalog::Amount,
    plugins::{PluginMessage, RowMessage},
};

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

    // Catalog View
    CatalogInputChanged(String),
    AmountFiltered(Amount),
    //PluginSearched(Vec<Plugin>),
    CatalogAction(CatalogMessage),

    PluginAction(PluginMessage),
}

impl Default for State {
    fn default() -> Self {
        create_plugins_db();
        update_local_plugins();

        Self {
            view: View::default(),
            plugins_view: PluginsView::default(),
            catalog_view: CatalogView::default(),
            about_view: AboutView::default(),
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

    fn update(&mut self, message: Message) -> Command<Message> {
        match self {
            Lembas::Loading => {
                if let Message::Loaded(_state) = message {
                    *self = Lembas::Loaded(State { ..State::default() })
                }
            }
            Lembas::Loaded(state) => match message {
                Message::PluginsPressed => {
                    state.view = View::Plugins;
                }
                Message::CatalogPressed => {
                    state.view = View::Catalog;
                }
                Message::AboutPressed => {
                    state.view = View::About;
                }
                Message::PluginAction(msg) => state.plugins_view.update(msg),
                _ => {}
            },
        }
        Command::none()
    }

    fn view(&mut self) -> Element<Message> {
        match self {
            Lembas::Loading => loading_data(),
            Lembas::Loaded(State {
                view,
                plugins_view,
                catalog_view,
                about_view,
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
                }
            }
        }
    }
}

impl Lembas {
    pub fn start() {
        let mut settings: Settings<()> = Settings::default();
        settings.window.size = (900, 620);
        //settings.default_font = Some(RING_BEARER);
        Lembas::run(settings).unwrap_err();
    }

    pub async fn init_application() -> State {
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
