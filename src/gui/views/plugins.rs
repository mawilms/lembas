use std::sync::Arc;

use crate::core::config::{
    get_database_file_path, get_plugins_dir, get_tmp_dir, read_existing_settings_file,
};
use crate::core::io::cache;
use crate::core::io::feed_url_parser::Plugin;
use crate::core::{Installer, PluginDataClass};
use crate::gui::style;
use cache::Cache;
use iced::pure::{button, column, container, row, scrollable, text, text_input, Element};
use iced::{alignment::Horizontal, Alignment, Command, Length, Space};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone)]
pub enum Plugins {
    Loaded(State),
}

#[derive(Debug, Clone)]
pub struct State {
    cache: Arc<Cache>,
    input_value: String,
    pub plugins: Vec<PluginRow>,
}

#[derive(Debug, Clone)]
pub enum PluginMessage {
    LoadPlugins,

    // Navigation View
    PluginInputChanged(String),
    RefreshPressed,
    UpdateAllPressed,
    DbRefreshed(Result<(), ApplicationError>),

    // Plugin View
    Plugin(usize, RowMessage),
}

impl Plugins {
    pub fn new(cache: Arc<Cache>) -> Self {
        let mut state = State {
            cache,
            plugins: Vec::new(),
            input_value: String::new(),
        };

        state.plugins = Plugins::populate_plugin_rows(&state);

        Self::Loaded(state)
    }

    async fn refresh_db() -> Result<(), ApplicationError> {
        let plugins_dir = get_plugins_dir();
        // let local_plugins =
        //     Synchronizer::search_local(&plugins_dir).map_err(|_| ApplicationError::Synchronize);

        let database_path = get_database_file_path();
        let settings = read_existing_settings_file();
        // Synchronizer::compare_local_state(
        //     &local_plugins.unwrap(),
        //     &database_path,
        //     &settings.feed_url,
        // )
        // .await;

        Ok(())
    }

    fn populate_plugin_rows(state: &State) -> Vec<PluginRow> {
        let mut plugins: Vec<PluginRow> = Vec::new();

        let mut tmp_plugins: Vec<Plugin> = state
            .cache
            .get_installed_plugins()
            .values()
            .cloned()
            .collect();
        tmp_plugins.sort_by(|a, b| a.name.to_lowercase().cmp(&b.name.to_lowercase()));
        for plugin in tmp_plugins {
            plugins.push(PluginRow::new(
                plugin.id,
                &plugin.name,
                &plugin.author,
                &plugin.description,
                &plugin.current_version,
                &plugin.latest_version,
                &plugin.download_url,
            ));
        }
        plugins
    }

    pub fn update(&mut self, message: PluginMessage) -> Command<PluginMessage> {
        match self {
            Plugins::Loaded(state) => match message {
                PluginMessage::Plugin(index, msg) => {
                    let update_event = state.plugins[index].update(msg, &*state.cache);
                    if let Event::Synchronize = update_event.0 {
                        state.plugins = Plugins::populate_plugin_rows(state);
                    }
                    update_event
                        .1
                        .map(move |msg| PluginMessage::Plugin(index, msg))
                }

                PluginMessage::RefreshPressed => {
                    Command::perform(Self::refresh_db(), PluginMessage::DbRefreshed)
                }
                PluginMessage::UpdateAllPressed => {
                    for i in 0..=state.plugins.len() {
                        if state.plugins[i].current_version != state.plugins[i].latest_version
                            && !state.plugins[i].latest_version.is_empty()
                        {
                            let test = state.plugins[i].clone();
                            state.plugins[i].update(RowMessage::UpdatePressed(test), &*state.cache);
                        }
                    }
                    Command::none()
                }
                PluginMessage::LoadPlugins => {
                    state.plugins = Plugins::populate_plugin_rows(state);
                    Command::none()
                }
                PluginMessage::PluginInputChanged(letter) => {
                    let mut filerted_plugins = Vec::new();
                    state.input_value = letter;

                    for element in &state.plugins {
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
                PluginMessage::DbRefreshed(result) => {
                    if result.is_ok() {
                        state.plugins = Plugins::populate_plugin_rows(state);
                    }
                    Command::none()
                }
            },
        }
    }

    fn build_header(input_value: &str, plugins_amount: usize) -> Element<'static, PluginMessage> {
        let refresh_button = button(text("Refresh"))
            .on_press(PluginMessage::RefreshPressed)
            .padding(5)
            .style(style::PrimaryButton::Enabled);
        let update_all_button = button(text("Update all"))
            .on_press(PluginMessage::UpdateAllPressed)
            .padding(5)
            .style(style::PrimaryButton::Enabled);
        let installed_plugins = text(format!("{} plugins installed", plugins_amount));
        let search_plugins = text_input(
            "Search plugins...",
            input_value,
            PluginMessage::PluginInputChanged,
        )
        .padding(5);

        row()
            .width(Length::Fill)
            .align_items(Alignment::Center)
            .spacing(10)
            .push(refresh_button)
            .push(update_all_button)
            .push(installed_plugins)
            .push(search_plugins)
            .into()
    }

    pub fn view(&self) -> Element<PluginMessage> {
        match self {
            Plugins::Loaded(State {
                cache: _,
                input_value,
                plugins,
            }) => {
                let header = Plugins::build_header(input_value, plugins.len());

                let plugin_name = text("Plugin").width(Length::FillPortion(6));
                let current_version = text("Current Version").width(Length::FillPortion(3));
                let latest_version = text("Latest version").width(Length::FillPortion(3));
                let update = text("Update").width(Length::FillPortion(2));

                let plugin_panel = row()
                    .width(Length::Fill)
                    .align_items(Alignment::Center)
                    .push(plugin_name)
                    .push(current_version)
                    .push(latest_version)
                    .push(update);

                let plugins = plugins
                    .iter()
                    .enumerate()
                    .fold(column().padding([0, 13, 0, 0]).spacing(5), |col, (i, p)| {
                        col.push(p.view().map(move |msg| PluginMessage::Plugin(i, msg)))
                    });

                let plugins_scrollable = scrollable(plugins)
                    .scrollbar_width(10)
                    .style(style::Scrollable);

                let content = column()
                    .width(Length::Fill)
                    .spacing(10)
                    .align_items(Alignment::Center)
                    .push(header)
                    .push(plugin_panel)
                    .push(plugins_scrollable);

                container(content)
                    .width(Length::Fill)
                    .height(Length::Fill)
                    .padding(20)
                    .style(style::Content)
                    .into()
            }
        }
    }
}

// Single row that has a toggle effect to show additional data
#[derive(Serialize, Deserialize, Clone, Debug)]
pub struct PluginRow {
    pub id: i32,
    pub title: String,
    pub author: String,
    pub description: String,
    #[serde(default)]
    pub current_version: String,
    pub latest_version: String,
    pub status: String,
    pub download_url: String,

    #[serde(skip)]
    opened: bool,
}

#[derive(Clone, Debug)]
pub enum RowMessage {
    ToggleView,

    UpdatePressed(PluginRow),
    DeletePressed(PluginRow),
    WebsitePressed(i32, String),
}

pub enum Event {
    Nothing,
    Synchronize,
}

impl PluginRow {
    pub fn new(
        id: i32,
        title: &str,
        author: &str,
        description: &str,
        current_version: &str,
        latest_version: &str,
        download_url: &str,
    ) -> Self {
        if current_version == latest_version {
            Self {
                id,
                title: title.to_string(),
                author: author.to_string(),
                description: description.to_string(),
                current_version: current_version.to_string(),
                latest_version: latest_version.to_string(),
                status: "".to_string(),
                download_url: download_url.to_string(),
                opened: false,
            }
        } else {
            Self {
                id,
                title: title.to_string(),
                author: author.to_string(),
                description: description.to_string(),
                current_version: current_version.to_string(),
                latest_version: latest_version.to_string(),
                status: "Update".to_string(),
                download_url: download_url.to_string(),
                opened: false,
            }
        }
    }

    pub fn update(&mut self, message: RowMessage, cache: &Cache) -> (Event, Command<RowMessage>) {
        match message {
            RowMessage::ToggleView => {
                self.opened = !self.opened;
                (Event::Nothing, Command::none())
            }
            RowMessage::UpdatePressed(plugin) => {
                // if let Ok(files) =
                //     Installer::download(plugin.id, &plugin.title, &plugin.download_url)
                // {
                //     let plugins_dir = get_plugins_dir();
                //     let tmp_dir = get_tmp_dir();
                //     if Installer::delete(&files, &plugins_dir).is_ok() {
                //         Installer::delete_cache_folder(plugin.id, &plugin.title, &tmp_dir);
                //         let cache_item = PluginDataClass::new(
                //             &plugin.title,
                //             &plugin.author,
                //             &plugin.current_version,
                //         )
                //         .with_id(plugin.id)
                //         .with_description(&plugin.description)
                //         .with_remote_information("", &plugin.latest_version, 0, "")
                //         .build();

                //         let database_path = get_database_file_path();
                //         if cache.insert_plugin(&cache_item).is_ok() {
                //             self.status = "Updated".to_string();
                //             (Event::Synchronize, Command::none())
                //         } else {
                //             self.status = "Update failed".to_string();
                //             (Event::Nothing, Command::none())
                //         }
                //     } else {
                //         self.status = "Installation failed".to_string();
                //         (Event::Nothing, Command::none())
                //     }
                // } else {
                //     self.status = "Download failed".to_string();
                //     (Event::Nothing, Command::none())
                // }
                (Event::Nothing, Command::none())
            }
            RowMessage::DeletePressed(plugin) => {
                if let Ok(files) =
                    Installer::download(plugin.id, &plugin.title, &plugin.download_url)
                {
                    let plugins_dir = get_plugins_dir();
                    let tmp_dir = get_tmp_dir();
                    let database_path = get_database_file_path();
                    if let Ok(()) = Installer::delete(&files, &plugins_dir) {
                        Installer::delete_cache_folder(plugin.id, &plugin.title, &tmp_dir);
                        if cache.delete_plugin(&plugin.title).is_ok() {
                            self.status = "Deleted".to_string();
                            (Event::Synchronize, Command::none())
                        } else {
                            self.status = "Delete failed".to_string();
                            (Event::Nothing, Command::none())
                        }
                    } else {
                        self.status = "Delete failed".to_string();
                        (Event::Nothing, Command::none())
                    }
                } else {
                    self.status = "Delete failed".to_string();
                    (Event::Nothing, Command::none())
                }
            }
            RowMessage::WebsitePressed(id, title) => {
                webbrowser::open(&format!(
                    "https://www.lotrointerface.com/downloads/info{}-{}.html",
                    id, title,
                ))
                .unwrap();
                (Event::Nothing, Command::none())
            }
        }
    }

    pub fn view(&self) -> Element<'_, RowMessage> {
        let plugin = self.clone();
        let bla = self.clone();

        let description_label = text("Description");
        let description = text(&self.description.to_string());
        let description_section = column()
            .push(description_label)
            .push(description)
            .spacing(10)
            .width(Length::Fill);

        let website_btn = button(text("Website"))
            .padding(5)
            .on_press(RowMessage::WebsitePressed(self.id, self.title.clone()))
            .style(style::PrimaryButton::Enabled);

        let delete_btn = button(text("Delete"))
            .padding(5)
            .on_press(RowMessage::DeletePressed(bla))
            .style(style::PrimaryButton::Enabled);

        let button_row = row()
            .push(Space::new(Length::Fill, Length::Shrink))
            .push(website_btn)
            .push(delete_btn)
            .width(Length::Fill)
            .spacing(10)
            .align_items(Alignment::End);

        let toggle_section = column().push(description_section).push(button_row);

        let container = container(toggle_section)
            .width(Length::Fill)
            .padding(15)
            .style(style::NavigationContainer);

        if self.opened {
            column()
                .push(
                    button(
                        row()
                            .align_items(Alignment::Center)
                            .push(if self.latest_version.is_empty() {
                                text(&format!("{} (unmanaged)", self.title))
                                    .width(Length::FillPortion(6))
                            } else {
                                text(&self.title).width(Length::FillPortion(6))
                            })
                            .push(text(&self.current_version).width(Length::FillPortion(3)))
                            .push(text(&self.latest_version).width(Length::FillPortion(3)))
                            .push(if self.latest_version == self.current_version {
                                button(text("."))
                                    .style(style::TransparentButton::Enabled)
                                    .width(Length::FillPortion(2))
                            } else {
                                button(text(&self.status))
                                    .on_press(RowMessage::UpdatePressed(plugin))
                                    .style(style::PrimaryButton::Enabled)
                                    .width(Length::FillPortion(2))
                            }),
                    )
                    .on_press(RowMessage::ToggleView)
                    .style(style::PluginRow::Enabled),
                )
                .push(container)
                .into()
        } else {
            column()
                .push(
                    button(
                        row()
                            .align_items(Alignment::Center)
                            .push(if self.latest_version.is_empty() {
                                text(&format!("{} (unmanaged)", self.title))
                                    .width(Length::FillPortion(6))
                            } else {
                                text(&self.title).width(Length::FillPortion(6))
                            })
                            .push(text(&self.current_version).width(Length::FillPortion(3)))
                            .push(text(&self.latest_version).width(Length::FillPortion(3)))
                            .push(
                                if self.latest_version == self.current_version
                                    || self.latest_version.is_empty()
                                {
                                    button(
                                        text(".")
                                            .width(Length::Fill)
                                            .horizontal_alignment(Horizontal::Center),
                                    )
                                    .style(style::TransparentButton::Enabled)
                                    .width(Length::FillPortion(2))
                                } else {
                                    button(
                                        text("Update")
                                            .width(Length::Fill)
                                            .horizontal_alignment(Horizontal::Center),
                                    )
                                    .style(style::PrimaryButton::Enabled)
                                    .on_press(RowMessage::UpdatePressed(plugin))
                                    .width(Length::FillPortion(2))
                                },
                            ),
                    )
                    .on_press(RowMessage::ToggleView)
                    .style(style::PluginRow::Enabled),
                )
                .into()
        }
    }
}

#[derive(Debug, Clone)]
pub enum ApplicationError {
    Synchronize,
}
