use crate::core::{
    config::{get_database_file_path, get_tmp_dir},
    io::{
        api_connector::{self, APIError},
        cache,
    },
    PluginDataClass,
};
use crate::core::{Installer, PluginCollection};
use crate::gui::style;
use iced::pure::{button, column, container, row, scrollable, text, text_input, Element};
use iced::{
    alignment::{Horizontal, Vertical},
    Alignment, Command, Length,
};
use log::debug;

#[derive(Debug, Clone)]
pub enum Catalog {
    Loaded(State),
    NoInternet(State),
}

impl Catalog {
    pub fn new() -> Self {
        Self::Loaded(State { ..State::default() })
    }
}

#[derive(Default, Debug, Clone)]
pub struct State {
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
                Message::LoadPlugins => {
                    Command::perform(api_connector::fetch_plugins(), Message::LoadedPlugins)
                }
                Message::LoadedPlugins(fetched_plugins) => {
                    if fetched_plugins.is_ok() {
                        let mut plugins = Vec::new();
                        let database_path = get_database_file_path();
                        let installed_plugins = cache::get_plugins(&database_path);
                        for (_, plugin) in fetched_plugins.unwrap() {
                            let mut plugin_row = PluginRow::new(
                                plugin.id.unwrap(),
                                &plugin.name,
                                &plugin.author,
                                &plugin.description.unwrap(),
                                &plugin.category.unwrap(),
                            )
                            .with_versions("", plugin.latest_version.as_ref().unwrap())
                            .with_information(&plugin.download_url.unwrap());

                            match installed_plugins.get(&plugin.name) {
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
                Message::RetryPressed => {
                    Command::perform(api_connector::fetch_plugins(), Message::LoadedPlugins)
                }
                Message::LoadedPlugins(fetched_plugins) => {
                    if fetched_plugins.is_ok() {
                        let mut plugins = Vec::new();
                        let database_path = get_database_file_path();
                        let installed_plugins = cache::get_plugins(&database_path);
                        for (_, plugin) in fetched_plugins.unwrap() {
                            let mut plugin_row = PluginRow::new(
                                plugin.id.unwrap(),
                                &plugin.name,
                                &plugin.author,
                                &plugin.description.unwrap(),
                                &plugin.category.unwrap(),
                            )
                            .with_versions("", plugin.latest_version.as_ref().unwrap())
                            .with_information(&plugin.download_url.unwrap());

                            match installed_plugins.get(&plugin.name) {
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

    pub fn view(&self) -> Element<Message> {
        match self {
            Catalog::Loaded(State {
                plugins,
                input_value,
                base_plugins: _,
            }) => {
                let search_plugins = text_input(
                    "Search plugins...",
                    input_value,
                    Message::CatalogInputChanged,
                )
                .padding(5);

                let plugin_amount = text(format!("{} plugins found", plugins.len()));

                let search_row = row()
                    .width(Length::Fill)
                    .align_items(Alignment::Center)
                    .spacing(10)
                    .push(search_plugins)
                    .push(plugin_amount);

                let plugin_name = text("Plugin").width(Length::FillPortion(6));
                let current_version = text("Current Version").width(Length::FillPortion(3));
                let latest_version = text("Latest version").width(Length::FillPortion(3));
                let upgrade = text("").width(Length::FillPortion(2));

                let plugin_panel = row()
                    .width(Length::Fill)
                    .align_items(Alignment::Center)
                    .push(plugin_name)
                    .push(current_version)
                    .push(latest_version)
                    .push(upgrade);

                let plugins = plugins
                    .iter()
                    .enumerate()
                    .fold(column().spacing(5), |col, (i, p)| {
                        col.push(p.view().map(move |msg| Message::Catalog(i, msg)))
                    });

                let plugins_scrollable = scrollable(plugins)
                    .scrollbar_width(10)
                    .style(style::Scrollable);

                let content = column()
                    .width(Length::Fill)
                    .spacing(10)
                    .align_items(Alignment::Center)
                    .push(search_row)
                    .push(plugin_panel)
                    .push(plugins_scrollable);

                container(content)
                    .height(Length::Fill)
                    .padding(20)
                    .style(style::Content)
                    .into()
            }
            Catalog::NoInternet(State {
                plugins: _,
                input_value: _,
                base_plugins: _,
            }) => {
                let retry_button = button(text("Retry"))
                    .on_press(Message::RetryPressed)
                    .padding(5)
                    .style(style::PrimaryButton::Enabled);

                let content = column()
                    .push(
                        text("No Lembas server connection")
                            .horizontal_alignment(Horizontal::Center)
                            .vertical_alignment(Vertical::Center)
                            .size(20),
                    )
                    .align_items(Alignment::Center)
                    .spacing(10)
                    .push(retry_button);

                container(content)
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
            download_url: String::new(),
        }
    }

    fn with_versions(mut self, current_version: &str, latest_version: &str) -> Self {
        self.current_version = current_version.to_string();
        self.latest_version = latest_version.to_string();

        self
    }

    fn with_information(mut self, download_url: &str) -> Self {
        self.download_url = download_url.to_string();

        self
    }

    pub fn update(&mut self, message: RowMessage) -> Command<RowMessage> {
        match message {
            RowMessage::InstallPressed(plugin) => {
                if Installer::download(plugin.id, &plugin.title, &plugin.download_url).is_ok() {
                    let tmp_dir = get_tmp_dir();
                    Installer::delete_cache_folder(plugin.id, &plugin.title, &tmp_dir);
                    let cache_item =
                        PluginDataClass::new(&plugin.title, &plugin.author, &plugin.latest_version)
                            .with_id(plugin.id)
                            .with_description(&plugin.description)
                            .with_remote_information(
                                &plugin.category,
                                &plugin.latest_version,
                                0,
                                "",
                            )
                            .build();

                    let database_path = get_database_file_path();
                    if cache::insert_plugin(&cache_item, &database_path).is_ok() {
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

    pub fn view(&self) -> Element<RowMessage> {
        let plugin = self.clone();
        let website_plugin = self.clone();

        column()
            .push(
                button(
                    row()
                        .align_items(Alignment::Center)
                        .push(text(&self.title).width(Length::FillPortion(6)))
                        .push(text(&self.current_version).width(Length::FillPortion(3)))
                        .push(text(&self.latest_version).width(Length::FillPortion(3)))
                        .push(if &plugin.status == "Installed" {
                            button(
                                text(&plugin.status)
                                    .width(Length::Fill)
                                    .horizontal_alignment(Horizontal::Center),
                            )
                            .on_press(RowMessage::NoEvent)
                            .style(style::InstallButton::Enabled)
                            .width(Length::FillPortion(2))
                        } else {
                            button(
                                text(&plugin.status)
                                    .width(Length::Fill)
                                    .horizontal_alignment(Horizontal::Center),
                            )
                            .on_press(RowMessage::InstallPressed(plugin))
                            .style(style::PrimaryButton::Enabled)
                            .width(Length::FillPortion(2))
                        }),
                )
                .on_press(RowMessage::WebsitePressed(website_plugin))
                .style(style::PluginRow::Enabled),
            )
            .into()
    }
}
