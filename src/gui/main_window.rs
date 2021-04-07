use crate::core::{create_plugins_db, update_local_plugins, Plugin};
use crate::gui::style;
use crate::gui::views::{About as AboutView, CatalogView, PluginsView, View};
use iced::{
    button, Align, Application, Button, Column, Command, Container, Element, HorizontalAlignment,
    Length, Row, Settings, Space, Text,
};

use super::views::{catalog::Amount, plugins::PluginMessage};

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
    PluginsSynchronized(Result<(), ApplicationError>),

    // Navigation Panel
    PluginsPressed,
    CatalogPressed,
    AboutPressed,
    SettingsPressed,

    // Catalog View
    CatalogInputChanged(String),
    AmountFiltered(Amount),
    PluginSearched(Vec<Plugin>),

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
            Lembas::Loading => match message {
                Message::Loaded(state) => {
                    println!("Bla1243");
                    *self = Lembas::Loaded(State { ..State::default() })
                }
                _ => {}
            },
            Lembas::Loaded(state) => {
                println!("Bla");
            }
        }
        Command::none()
    }

    // match message {
    //     Message::PluginsPressed => {
    //         //     Command::perform(
    //         //     Self::load_installed_plugins(),
    //         //     Message::InstalledPluginsLoaded,
    //         // )
    //         Command::none()
    //     }
    //     Message::CatalogPressed => {
    //         Command::perform(Self::load_plugins(), Message::AllPluginsLoaded)
    //     }
    //     Message::AboutPressed => {
    //         self.view = View::About;
    //         Command::none()
    //     }
    //     Message::SettingsPressed | Message::PluginsSynchronized(_) => Command::none(),
    //     Message::UpdateAllPressed => {
    //         let plugins = self.plugins_view.plugins.clone();
    //         Command::perform(
    //             Self::update_plugins(plugins),
    //             Message::InstalledPluginsLoaded,
    //         )
    //     }
    //     Message::AmountFiltered(_) => Command::none(),
    //     Message::CatalogInputChanged(state) => {
    //         self.catalog_view.input_value = state;
    //         Command::perform(
    //             Self::get_catalog_plugin(self.catalog_view.input_value.clone()),
    //             Message::PluginSearched,
    //         )
    //     }
    //     Message::PluginAction(msg) => {
    //         self.plugins_view.update(msg);
    //         Command::none()
    //     }
    // }

    fn view(&mut self) -> Element<Message> {
        match self {
            Lembas::Loading => loading_data(),
            Lembas::Loaded(State {
                view,
                plugins_view,
                catalog_view,
                about_view,
                input_value,
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
                        println!("Hallo");
                        let main_container = plugins_view
                            .view()
                            .map(Message::PluginAction);
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

#[derive(Debug, Clone)]
enum ApplicationError {
    Load,
    Install,
    Synchronize,
}

fn loading_data<'a>() -> Element<'a, Message> {
    Container::new(
        Text::new("Loading...")
            .horizontal_alignment(HorizontalAlignment::Center)
            .size(50),
    )
    .width(Length::Fill)
    .height(Length::Fill)
    .center_y()
    .into()
}
