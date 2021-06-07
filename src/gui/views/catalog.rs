use crate::core::api_connector::APIOperations;
use crate::core::{
    api_connector::APIError, APIConnector, Base as BasePlugin, Installer, Plugin as DetailPlugin,
    Synchronizer,
};
use crate::gui::style;
use iced::{
    button, scrollable, text_input, Align, Button, Column, Command, Container, Element,
    HorizontalAlignment, Length, Row, Scrollable, Text, TextInput, VerticalAlignment,
};
use std::collections::HashMap;

#[derive(Debug, Clone)]
pub enum Catalog {
    Loaded(State),
    NoInternet(State),
}

impl Default for Catalog {
    fn default() -> Self {
        Self::Loaded(State { ..State::default() })
    }
}

#[derive(Default, Debug, Clone)]
pub struct State {
    input: text_input::State,
    plugin_scrollable_state: scrollable::State,
    retry_btn_state: button::State,
    pub input_value: String,

    pub base_plugins: Vec<PluginRow>,
    pub plugins: Vec<PluginRow>,
}

#[derive(Debug, Clone)]
pub enum Message {
    CatalogInputChanged(String),
    Catalog(usize, RowMessage),
    LoadPlugins,
    LoadedPlugins(Result<HashMap<String, BasePlugin>, crate::gui::views::catalog::APIError>),
    RetryPressed,
}

impl Catalog {
    pub fn update(&mut self, message: Message) -> Command<Message> {
        match self {
            Catalog::Loaded(state) => match message {
                Message::CatalogInputChanged(letter) => {
                    let mut filerted_plugins = Vec::new();
                    state.input_value = letter;

                    for element in &state.base_plugins {
                        if element
                            .title
                            .to_lowercase()
                            .contains(&state.input_value.to_lowercase())
                        {
                            filerted_plugins.push(element.clone());
                        }
                    }
                    filerted_plugins
                        .sort_by(|a, b| a.title.to_lowercase().cmp(&b.title.to_lowercase()));
                    state.plugins = filerted_plugins;
                    Command::none()
                }
                Message::Catalog(index, msg) => {
                    state.plugins[index].update(msg);
                    Command::none()
                }
                Message::LoadPlugins => {
                    Command::perform(APIConnector::fetch_plugins(), Message::LoadedPlugins)
                }
                Message::LoadedPlugins(fetched_plugins) => {
                    if fetched_plugins.is_ok() {
                        let mut plugins = Vec::new();
                        let installed_plugins = Synchronizer::get_plugins();
                        for (_, plugin) in fetched_plugins.unwrap() {
                            let mut plugin_row = PluginRow::new(
                                plugin.plugin_id,
                                &plugin.title,
                                &plugin.category,
                                "",
                                &plugin.latest_version,
                            );
                            match installed_plugins.get(&plugin.title) {
                                Some(value) => {
                                    plugin_row.current_version = value.current_version.clone();
                                    if value.current_version == plugin.latest_version {
                                        plugin_row.status = String::from("Installed");
                                    } else {
                                        plugin_row.status = String::from("Update");
                                    }
                                }
                                None => {
                                    plugin_row.status = String::from("Install");
                                }
                            }
                            plugins.push(plugin_row);
                        }
                        plugins.sort_by(|a, b| a.title.to_lowercase().cmp(&b.title.to_lowercase()));
                        *self = Catalog::Loaded(State {
                            plugins: plugins.clone(),
                            base_plugins: plugins,
                            ..state.clone()
                        });

                        Command::none()
                    } else {
                        *self = Catalog::NoInternet(State::default());
                        Command::none()
                    }
                }
                Message::RetryPressed => Command::none(),
            },
            Catalog::NoInternet(state) => match message {
                Message::RetryPressed => {
                    Command::perform(APIConnector::fetch_plugins(), Message::LoadedPlugins)
                }
                Message::LoadedPlugins(fetched_plugins) => {
                    if fetched_plugins.is_ok() {
                        let mut plugins = Vec::new();
                        let installed_plugins = Synchronizer::get_plugins();
                        for (_, plugin) in fetched_plugins.unwrap() {
                            let mut plugin_row = PluginRow::new(
                                plugin.plugin_id,
                                &plugin.title,
                                &plugin.category,
                                "",
                                &plugin.latest_version,
                            );
                            match installed_plugins.get(&plugin.title) {
                                Some(value) => {
                                    plugin_row.current_version = value.current_version.clone();
                                    if value.current_version == plugin.latest_version {
                                        plugin_row.status = String::from("Installed");
                                    } else {
                                        plugin_row.status = String::from("Update");
                                    }
                                }
                                None => {
                                    plugin_row.status = String::from("Install");
                                }
                            }
                            plugins.push(plugin_row);
                        }
                        plugins.sort_by(|a, b| a.title.to_lowercase().cmp(&b.title.to_lowercase()));
                        *self = Catalog::Loaded(State {
                            plugins: plugins.clone(),
                            base_plugins: plugins,
                            ..state.clone()
                        });

                        Command::none()
                    } else {
                        *self = Catalog::NoInternet(State::default());
                        Command::none()
                    }
                }
                _ => Command::none(),
            },
        }
    }

    pub fn view(&mut self) -> Element<Message> {
        match self {
            Catalog::Loaded(State {
                input,
                plugin_scrollable_state,
                plugins,
                input_value,
                base_plugins: _,
                retry_btn_state: _,
            }) => {
                let search_plugins = TextInput::new(
                    input,
                    "Search plugins...",
                    input_value,
                    Message::CatalogInputChanged,
                )
                .padding(5);

                let plugin_amount = Text::new(format!("{} plugins found", plugins.len()));

                let search_row = Row::new()
                    .width(Length::Fill)
                    .align_items(Align::Center)
                    .spacing(10)
                    .push(search_plugins)
                    .push(plugin_amount);

                let plugin_name = Text::new("Plugin").width(Length::FillPortion(6));
                let current_version = Text::new("Current Version").width(Length::FillPortion(3));
                let latest_version = Text::new("Latest version").width(Length::FillPortion(3));
                let upgrade = Text::new("").width(Length::FillPortion(2));

                let plugin_panel = Row::new()
                    .width(Length::Fill)
                    .align_items(Align::Center)
                    .push(plugin_name)
                    .push(current_version)
                    .push(latest_version)
                    .push(upgrade);

                let plugins = plugins
                    .iter_mut()
                    .enumerate()
                    .fold(Column::new().spacing(5), |col, (i, p)| {
                        col.push(p.view().map(move |msg| Message::Catalog(i, msg)))
                    });

                let plugins_scrollable = Scrollable::new(plugin_scrollable_state)
                    .push(plugins)
                    .spacing(5)
                    .align_items(Align::Center)
                    .style(style::Scrollable);

                let content = Column::new()
                    .width(Length::Fill)
                    .spacing(10)
                    .align_items(Align::Center)
                    .push(search_row)
                    .push(plugin_panel)
                    .push(plugins_scrollable);

                Container::new(content)
                    .height(Length::Fill)
                    .padding(10)
                    .style(style::Content)
                    .into()
            }
            Catalog::NoInternet(State {
                retry_btn_state,
                input: _,
                plugin_scrollable_state: _,
                plugins: _,
                input_value: _,
                base_plugins: _,
            }) => {
                let retry_button = Button::new(retry_btn_state, Text::new("Retry"))
                    .on_press(Message::RetryPressed)
                    .padding(5)
                    .style(style::PrimaryButton::Enabled);

                let content = Column::new()
                    .push(
                        Text::new("No Lembas server connection")
                            .horizontal_alignment(HorizontalAlignment::Center)
                            .vertical_alignment(VerticalAlignment::Center)
                            .size(20),
                    )
                    .align_items(Align::Center)
                    .spacing(10)
                    .push(retry_button);

                Container::new(content)
                    .width(Length::Fill)
                    .height(Length::Fill)
                    .center_y()
                    .center_x()
                    .style(style::Content)
                    .into()
            }
        }
    }
}
#[derive(Clone, Debug)]
pub struct PluginRow {
    pub id: i32,
    pub title: String,
    pub category: String,
    pub current_version: String,
    pub latest_version: String,
    pub status: String,

    install_btn_state: button::State,
    website_btn_state: button::State,
}

#[derive(Clone, Debug)]
pub enum RowMessage {
    InstallPressed(PluginRow),
    WebsitePressed(PluginRow),
    DetailsFetched(Result<DetailPlugin, APIError>),
    NoEvent,
}

impl PluginRow {
    pub fn new(
        id: i32,
        title: &str,
        category: &str,
        current_version: &str,
        latest_version: &str,
    ) -> Self {
        Self {
            id,
            title: title.to_string(),
            category: category.to_string(),
            current_version: current_version.to_string(),
            latest_version: latest_version.to_string(),
            status: "Installed".to_string(),
            install_btn_state: button::State::default(),
            website_btn_state: button::State::default(),
        }
    }

    pub fn update(&mut self, message: RowMessage) -> Command<RowMessage> {
        match message {
            RowMessage::InstallPressed(plugin) => Command::perform(
                APIConnector::fetch_details(plugin.title),
                RowMessage::DetailsFetched,
            ),

            RowMessage::WebsitePressed(row) => {
                webbrowser::open(&format!(
                    "https://www.lotrointerface.com/downloads/info{}-{}.html",
                    row.id, row.title,
                ))
                .unwrap();
                Command::none()
            }
            RowMessage::DetailsFetched(fetched_plugin) => {
                if let Ok(fetched_plugin) = fetched_plugin {
                    if Installer::download(&fetched_plugin).is_ok() {
                        self.status = "Downloaded".to_string();
                        if Installer::extract(&fetched_plugin).is_ok() {
                            self.status = "Unpacked".to_string();
                            Installer::delete_cache_folder(&fetched_plugin);
                            if Synchronizer::insert_plugin(&fetched_plugin).is_ok() {
                                self.status = "Installed".to_string();
                                self.latest_version = fetched_plugin.base_plugin.latest_version;
                            } else {
                                self.status = "Installation failed".to_string();
                            }
                        } else {
                            self.status = "Unpacking failed".to_string();
                        }
                    } else {
                        self.status = "Download failed".to_string();
                    }
                }
                Command::none()
            }
            RowMessage::NoEvent => Command::none(),
        }
    }

    pub fn view(&mut self) -> Element<RowMessage> {
        let plugin = self.clone();
        let website_plugin = self.clone();

        Column::new()
            .push(
                Button::new(
                    &mut self.website_btn_state,
                    Row::new()
                        .align_items(Align::Center)
                        .push(Text::new(&self.title).width(Length::FillPortion(6)))
                        .push(Text::new(&self.current_version).width(Length::FillPortion(3)))
                        .push(Text::new(&self.latest_version).width(Length::FillPortion(3)))
                        .push(if &plugin.status == "Installed" {
                            Button::new(
                                &mut self.install_btn_state,
                                Text::new(&plugin.status)
                                    .width(Length::Fill)
                                    .horizontal_alignment(HorizontalAlignment::Center),
                            )
                            .on_press(RowMessage::NoEvent)
                            .style(style::InstallButton::Enabled)
                            .width(Length::FillPortion(2))
                        } else {
                            Button::new(
                                &mut self.install_btn_state,
                                Text::new(&plugin.status)
                                    .width(Length::Fill)
                                    .horizontal_alignment(HorizontalAlignment::Center),
                            )
                            .on_press(RowMessage::InstallPressed(plugin))
                            .style(style::InstallButton::Enabled)
                            .width(Length::FillPortion(2))
                        }),
                )
                .on_press(RowMessage::WebsitePressed(website_plugin))
                .style(style::PluginRow::Enabled),
            )
            .into()
    }
}
