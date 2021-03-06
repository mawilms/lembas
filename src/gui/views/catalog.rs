use crate::core::{
    io::{
        api_connector::{self, APIError},
        cache,
    },
    Config, PluginDataClass,
};
use crate::core::{Installer, PluginCollection};
use crate::gui::style;
use iced::{
    button, scrollable, text_input, Align, Button, Column, Command, Container, Element,
    HorizontalAlignment, Length, Row, Scrollable, Text, TextInput, VerticalAlignment,
};
use log::debug;

#[derive(Debug, Clone)]
pub enum Catalog {
    Loaded(State),
    NoInternet(State),
}

impl Catalog {
    pub fn new(config: Config) -> Self {
        Self::Loaded(State {
            config,
            ..State::default()
        })
    }
}

#[derive(Default, Debug, Clone)]
pub struct State {
    config: Config,
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
    LoadedPlugins(Result<PluginCollection, crate::gui::views::catalog::APIError>),
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
                Message::Catalog(index, msg) => state.plugins[index]
                    .update(msg)
                    .map(move |msg| Message::Catalog(index, msg)),
                Message::LoadPlugins => Command::perform(
                    api_connector::fetch_plugins(
                        state.config.application_settings.feed_url.clone(),
                    ),
                    Message::LoadedPlugins,
                ),
                Message::LoadedPlugins(fetched_plugins) => {
                    if fetched_plugins.is_ok() {
                        let mut plugins = Vec::new();
                        let installed_plugins = cache::get_plugins(&state.config.db_file);
                        for (_, plugin) in fetched_plugins.unwrap() {
                            let plugin_hash = PluginDataClass::calculate_hash(&plugin);

                            let mut plugin_row = PluginRow::new(
                                plugin.id.unwrap(),
                                &plugin.name,
                                &plugin.author,
                                &plugin.description.unwrap(),
                                &plugin.category.unwrap(),
                            )
                            .with_versions("", plugin.latest_version.as_ref().unwrap())
                            .with_information(
                                &plugin.download_url.unwrap(),
                                &state.config.plugins_dir,
                                &state.config.cache_dir,
                                &state.config.db_file,
                                state.config.application_settings.backup_enabled,
                            );

                            match installed_plugins.get(&plugin_hash) {
                                Some(value) => {
                                    plugin_row.current_version = value.version.clone();
                                    if value.version == plugin.latest_version.unwrap() {
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
                Message::RetryPressed => Command::perform(
                    api_connector::fetch_plugins(
                        state.config.application_settings.feed_url.clone(),
                    ),
                    Message::LoadedPlugins,
                ),
                Message::LoadedPlugins(fetched_plugins) => {
                    if fetched_plugins.is_ok() {
                        let mut plugins = Vec::new();
                        let installed_plugins = cache::get_plugins(&state.config.db_file);
                        for (_, plugin) in fetched_plugins.unwrap() {
                            let plugin_hash = PluginDataClass::calculate_hash(&plugin);

                            let mut plugin_row = PluginRow::new(
                                plugin.id.unwrap(),
                                &plugin.name,
                                &plugin.author,
                                &plugin.description.unwrap(),
                                &plugin.category.unwrap(),
                            )
                            .with_versions("", plugin.latest_version.as_ref().unwrap())
                            .with_information(
                                &plugin.download_url.unwrap(),
                                &state.config.plugins_dir,
                                &state.config.cache_dir,
                                &state.config.db_file,
                                state.config.application_settings.backup_enabled,
                            );

                            match installed_plugins.get(&plugin_hash) {
                                Some(value) => {
                                    plugin_row.current_version = value.version.clone();
                                    if value.version == plugin.latest_version.unwrap() {
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
                config: _,
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
                config: _,
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
    pub description: String,
    pub author: String,
    pub category: String,
    pub current_version: String,
    pub latest_version: String,
    pub status: String,
    pub download_url: String,
    pub plugins_dir: String,
    pub cache_dir: String,
    pub db_file: String,
    pub backup_enabled: bool,

    install_btn_state: button::State,
    website_btn_state: button::State,
}

#[derive(Clone, Debug)]
pub enum RowMessage {
    InstallPressed(PluginRow),
    WebsitePressed(PluginRow),
    NoEvent,
}

impl PluginRow {
    pub fn new(id: i32, title: &str, author: &str, description: &str, category: &str) -> Self {
        Self {
            id,
            title: title.to_string(),
            author: author.to_string(),
            description: description.to_string(),
            category: category.to_string(),
            current_version: String::new(),
            latest_version: String::new(),
            status: "Installed".to_string(),
            install_btn_state: button::State::default(),
            website_btn_state: button::State::default(),
            download_url: String::new(),
            plugins_dir: String::new(),
            cache_dir: String::new(),
            db_file: String::new(),
            backup_enabled: true,
        }
    }

    fn with_versions(mut self, current_version: &str, latest_version: &str) -> Self {
        self.current_version = current_version.to_string();
        self.latest_version = latest_version.to_string();

        self
    }

    fn with_information(
        mut self,
        download_url: &str,
        plugins_dir: &str,
        cache_dir: &str,
        db_file: &str,
        backup_enabled: bool,
    ) -> Self {
        self.download_url = download_url.to_string();
        self.plugins_dir = plugins_dir.to_string();
        self.cache_dir = cache_dir.to_string();
        self.db_file = db_file.to_string();
        self.backup_enabled = backup_enabled;

        self
    }

    pub fn update(&mut self, message: RowMessage) -> Command<RowMessage> {
        match message {
            RowMessage::InstallPressed(plugin) => {
                if Installer::download(
                    plugin.id,
                    &plugin.title,
                    &plugin.download_url,
                    &self.plugins_dir,
                    &self.cache_dir,
                    self.backup_enabled,
                )
                .is_ok()
                {
                    Installer::delete_cache_folder(plugin.id, &plugin.title, &self.cache_dir);
                    let cache_item = PluginDataClass::new(
                        &plugin.title,
                        &plugin.author,
                        &plugin.current_version,
                    )
                    .with_id(plugin.id)
                    .with_description(&plugin.description)
                    .with_remote_information(&plugin.category, &plugin.latest_version, 0, "")
                    .build();

                    if cache::insert_plugin(
                        PluginDataClass::calculate_hash(&cache_item),
                        &cache_item,
                        &self.db_file,
                    )
                    .is_ok()
                    {
                        self.status = "Installed".to_string();
                        self.current_version = plugin.latest_version;
                    } else {
                        self.status = "Installation failed".to_string();
                    }
                } else {
                    debug!("Download failed");
                    self.status = "Download failed".to_string();
                }
                Command::none()
            }

            RowMessage::WebsitePressed(row) => {
                webbrowser::open(&format!(
                    "https://www.lotrointerface.com/downloads/info{}-{}.html",
                    row.id, row.title,
                ))
                .unwrap();
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
