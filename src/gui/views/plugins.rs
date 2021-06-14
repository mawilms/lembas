use crate::core::io::api_connector::{APIError, APIOperations};
use crate::core::io::{APIConnector, Synchronizer};
use crate::core::{Config, Installed as InstalledPlugin, Installer, Plugin as DetailPlugin};
use crate::gui::style;
use iced::{
    button, scrollable, text_input, Align, Button, Column, Command, Container, Element,
    HorizontalAlignment, Length, Row, Scrollable, Space, Text, TextInput,
};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone)]
pub enum Plugins {
    Loaded(State),
}

impl Plugins {
    pub fn new(config: Config) -> Self {
        let mut installed_plugins: Vec<InstalledPlugin> =
            Synchronizer::get_plugins(&config.db_file)
                .values()
                .cloned()
                .collect();
        installed_plugins.sort_by(|a, b| a.title.to_lowercase().cmp(&b.title.to_lowercase()));
        let mut plugins: Vec<PluginRow> = Vec::new();
        for plugin in installed_plugins {
            plugins.push(PluginRow::new(
                plugin.plugin_id,
                &plugin.title,
                &plugin.description,
                &plugin.category,
                &plugin.current_version,
                &plugin.latest_version,
                &plugin.folder,
                &config.plugins_dir,
                &config.cache_dir,
                &config.db_file,
                config.application_settings.backup_enabled,
            ));
        }

        Self::Loaded(State {
            config,
            base_plugins: plugins.clone(),
            plugins,
            ..State::default()
        })
    }
}

#[derive(Default, Debug, Clone)]
pub struct State {
    config: Config,
    plugin_scrollable_state: scrollable::State,
    input_value: String,
    pub plugins: Vec<PluginRow>,
    base_plugins: Vec<PluginRow>,
    input: text_input::State,
    refresh_button: button::State,
    update_all_button: button::State,
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
    async fn refresh_db(config: Config) -> Result<(), ApplicationError> {
        let local_plugins = Synchronizer::search_local(&config.plugins_dir)
            .map_err(|_| ApplicationError::Synchronize);
        let local_db_plugins = Synchronizer::get_plugins(&config.db_file);

        Synchronizer::compare_local_state(
            &local_plugins.unwrap(),
            &local_db_plugins,
            &config.plugins_dir,
            &config.db_file,
        )
        .await;

        Ok(())
    }

    pub fn update(&mut self, message: PluginMessage) -> Command<PluginMessage> {
        match self {
            Plugins::Loaded(state) => match message {
                PluginMessage::Plugin(index, msg) => {
                    let update_event = state.plugins[index].update(msg);
                    if let Event::Synchronize = update_event.0 {
                        let mut plugins: Vec<PluginRow> = Vec::new();
                        let mut all_plugins: Vec<InstalledPlugin> =
                            Synchronizer::get_plugins(&state.config.db_file)
                                .values()
                                .cloned()
                                .collect();
                        all_plugins
                            .sort_by(|a, b| a.title.to_lowercase().cmp(&b.title.to_lowercase()));
                        for plugin in all_plugins {
                            plugins.push(PluginRow::new(
                                plugin.plugin_id,
                                &plugin.title,
                                &plugin.description,
                                &plugin.category,
                                &plugin.current_version,
                                &plugin.latest_version,
                                &plugin.folder,
                                &state.config.plugins_dir,
                                &state.config.cache_dir,
                                &state.config.db_file,
                                state.config.application_settings.backup_enabled,
                            ));
                        }
                        state.plugins = plugins;
                    }
                    update_event
                        .1
                        .map(move |msg| PluginMessage::Plugin(index, msg))
                }

                PluginMessage::RefreshPressed => Command::perform(
                    Self::refresh_db(state.config.clone()),
                    PluginMessage::DbRefreshed,
                ),
                PluginMessage::UpdateAllPressed => {
                    for i in 1..state.plugins.len() {
                        if state.plugins[i].current_version != state.plugins[i].latest_version {
                            let test = state.plugins[i].clone();
                            state.plugins[i].update(RowMessage::UpdatePressed(test));
                        }
                    }
                    Command::none()
                }
                PluginMessage::LoadPlugins => {
                    let mut plugins: Vec<PluginRow> = Vec::new();
                    let installed_plugins: Vec<InstalledPlugin> =
                        Synchronizer::get_plugins(&state.config.db_file)
                            .values()
                            .cloned()
                            .collect();
                    for plugin in installed_plugins {
                        plugins.push(PluginRow::new(
                            plugin.plugin_id,
                            &plugin.title,
                            &plugin.description,
                            &plugin.category,
                            &plugin.current_version,
                            &plugin.latest_version,
                            &plugin.folder,
                            &state.config.plugins_dir,
                            &state.config.cache_dir,
                            &state.config.db_file,
                            state.config.application_settings.backup_enabled,
                        ));
                        plugins.sort_by(|a, b| a.title.to_lowercase().cmp(&b.title.to_lowercase()));
                    }
                    state.plugins = plugins;
                    Command::none()
                }
                PluginMessage::PluginInputChanged(letter) => {
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
                PluginMessage::DbRefreshed(result) => {
                    if result.is_ok() {
                        let mut plugins: Vec<PluginRow> = Vec::new();
                        let mut all_plugins: Vec<InstalledPlugin> =
                            Synchronizer::get_plugins(&state.config.db_file)
                                .values()
                                .cloned()
                                .collect();
                        all_plugins
                            .sort_by(|a, b| a.title.to_lowercase().cmp(&b.title.to_lowercase()));
                        for plugin in all_plugins {
                            plugins.push(PluginRow::new(
                                plugin.plugin_id,
                                &plugin.title,
                                &plugin.description,
                                &plugin.category,
                                &plugin.current_version,
                                &plugin.latest_version,
                                &plugin.folder,
                                &state.config.plugins_dir,
                                &state.config.cache_dir,
                                &state.config.db_file,
                                state.config.application_settings.backup_enabled,
                            ));
                        }
                        state.plugins = plugins;
                    }
                    Command::none()
                }
            },
        }
    }

    pub fn view(&mut self) -> Element<PluginMessage> {
        match self {
            Plugins::Loaded(State {
                config: _,
                plugin_scrollable_state,
                input_value,
                plugins,
                base_plugins: _,
                input,
                refresh_button,
                update_all_button,
            }) => {
                let refresh_button = Button::new(refresh_button, Text::new("Refresh"))
                    .on_press(PluginMessage::RefreshPressed)
                    .padding(5)
                    .style(style::PrimaryButton::Enabled);
                let update_all_button = Button::new(update_all_button, Text::new("Update all"))
                    .on_press(PluginMessage::UpdateAllPressed)
                    .padding(5)
                    .style(style::PrimaryButton::Enabled);
                let installed_plugins = Text::new(format!("{} plugins installed", plugins.len()));
                let search_plugins = TextInput::new(
                    input,
                    "Search plugins...",
                    input_value,
                    PluginMessage::PluginInputChanged,
                )
                .padding(5);

                let control_panel = Row::new()
                    .width(Length::Fill)
                    .align_items(Align::Center)
                    .spacing(10)
                    .push(refresh_button)
                    .push(update_all_button)
                    .push(installed_plugins)
                    .push(search_plugins);

                let plugin_name = Text::new("Plugin").width(Length::FillPortion(6));
                let current_version = Text::new("Current Version").width(Length::FillPortion(3));
                let latest_version = Text::new("Latest version").width(Length::FillPortion(3));
                let update = Text::new("Update").width(Length::FillPortion(2));

                let plugin_panel = Row::new()
                    .width(Length::Fill)
                    .align_items(Align::Center)
                    .push(plugin_name)
                    .push(current_version)
                    .push(latest_version)
                    .push(update);

                let plugins = plugins
                    .iter_mut()
                    .enumerate()
                    .fold(Column::new().spacing(5), |col, (i, p)| {
                        col.push(p.view().map(move |msg| PluginMessage::Plugin(i, msg)))
                    });

                let plugins_scrollable = Scrollable::new(plugin_scrollable_state)
                    .push(plugins)
                    .spacing(5)
                    .width(Length::Fill)
                    .align_items(Align::Center)
                    .style(style::Scrollable);

                let content = Column::new()
                    .width(Length::Fill)
                    .spacing(10)
                    .align_items(Align::Center)
                    .push(control_panel)
                    .push(plugin_panel)
                    .push(plugins_scrollable);

                Container::new(content)
                    .width(Length::Fill)
                    .height(Length::Fill)
                    .padding(10)
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
    #[serde(default)]
    pub description: String,
    #[serde(default)]
    pub category: String,
    #[serde(default)]
    pub current_version: String,
    pub latest_version: String,
    pub status: String,
    pub folder_name: String,
    pub plugins_dir: String,
    pub cache_dir: String,
    pub db_file: String,
    pub backup_enabled: bool,

    #[serde(skip)]
    update_btn_state: button::State,
    #[serde(skip)]
    delete_btn_state: button::State,
    #[serde(skip)]
    website_btn_state: button::State,
    #[serde(skip)]
    opened: bool,
    #[serde(skip)]
    toggle_view_btn: button::State,
}

#[derive(Clone, Debug)]
pub enum RowMessage {
    ToggleView,

    UpdatePressed(PluginRow),
    DeletePressed(PluginRow),
    WebsitePressed(i32, String),
    Updating(Result<DetailPlugin, APIError>),
    Deleting(Result<DetailPlugin, APIError>),
}

pub enum Event {
    Nothing,
    Synchronize,
}

impl PluginRow {
    pub fn new(
        id: i32,
        title: &str,
        description: &str,
        category: &str,
        current_version: &str,
        latest_version: &str,
        folder_name: &str,
        plugins_dir: &str,
        cache_dir: &str,
        db_file: &str,
        backup_enabled: bool,
    ) -> Self {
        if current_version == latest_version {
            Self {
                id,
                title: title.to_string(),
                description: description.to_string(),
                category: category.to_string(),
                current_version: current_version.to_string(),
                latest_version: latest_version.to_string(),
                status: "".to_string(),
                folder_name: folder_name.to_string(),
                update_btn_state: button::State::default(),
                delete_btn_state: button::State::default(),
                website_btn_state: button::State::default(),
                toggle_view_btn: button::State::new(),
                opened: false,
                plugins_dir: plugins_dir.to_string(),
                cache_dir: cache_dir.to_string(),
                db_file: db_file.to_string(),
                backup_enabled,
            }
        } else {
            Self {
                id,
                title: title.to_string(),
                description: description.to_string(),
                category: category.to_string(),
                current_version: current_version.to_string(),
                latest_version: latest_version.to_string(),
                status: "Update".to_string(),
                folder_name: folder_name.to_string(),
                update_btn_state: button::State::default(),
                delete_btn_state: button::State::default(),
                website_btn_state: button::State::default(),
                toggle_view_btn: button::State::new(),
                opened: false,
                plugins_dir: plugins_dir.to_string(),
                cache_dir: cache_dir.to_string(),
                db_file: db_file.to_string(),
                backup_enabled,
            }
        }
    }

    pub fn update(&mut self, message: RowMessage) -> (Event, Command<RowMessage>) {
        match message {
            RowMessage::ToggleView => {
                self.opened = !self.opened;
                (Event::Nothing, Command::none())
            }
            RowMessage::UpdatePressed(plugin) => (
                Event::Nothing,
                Command::perform(APIConnector::fetch_details(plugin.id), RowMessage::Updating),
            ),
            RowMessage::DeletePressed(row) => (
                Event::Nothing,
                Command::perform(APIConnector::fetch_details(row.id), RowMessage::Deleting),
            ),
            RowMessage::WebsitePressed(id, title) => {
                webbrowser::open(&format!(
                    "https://www.lotrointerface.com/downloads/info{}-{}.html",
                    id, title,
                ))
                .unwrap();
                (Event::Nothing, Command::none())
            }
            RowMessage::Updating(fetched_plugin) => {
                if let Ok(fetched_plugin) = fetched_plugin {
                    if Installer::download(
                        &fetched_plugin,
                        &self.plugins_dir,
                        &self.cache_dir,
                        self.backup_enabled,
                    )
                    .is_ok()
                    {
                        if Installer::delete(
                            &fetched_plugin.base_plugin.folder,
                            &fetched_plugin.files,
                            &self.plugins_dir,
                        )
                        .is_ok()
                        {
                            if Installer::extract(
                                &fetched_plugin,
                                &self.plugins_dir,
                                &self.cache_dir,
                            )
                            .is_ok()
                            {
                                Installer::delete_cache_folder(&fetched_plugin, &self.cache_dir);
                                if Synchronizer::insert_plugin(
                                    &fetched_plugin,
                                    &self.plugins_dir,
                                    &self.db_file,
                                )
                                .is_ok()
                                {
                                    self.status = "Updated".to_string();
                                    (Event::Synchronize, Command::none())
                                } else {
                                    self.status = "Update failed".to_string();
                                    (Event::Nothing, Command::none())
                                }
                            } else {
                                self.status = "Unpacking failed".to_string();
                                (Event::Nothing, Command::none())
                            }
                        } else {
                            self.status = "Installation failed".to_string();
                            (Event::Nothing, Command::none())
                        }
                    } else {
                        self.status = "Download failed".to_string();
                        (Event::Nothing, Command::none())
                    }
                } else {
                    self.status = "Update failed".to_string();
                    (Event::Nothing, Command::none())
                }
            }
            RowMessage::Deleting(fetched_plugin) => {
                if let Ok(fetched_plugin) = fetched_plugin {
                    if let Ok(()) = Installer::delete(
                        &fetched_plugin.base_plugin.folder,
                        &fetched_plugin.files,
                        &self.plugins_dir,
                    ) {
                        if Synchronizer::delete_plugin(
                            &fetched_plugin.base_plugin.title,
                            &self.db_file,
                        )
                        .is_ok()
                        {
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
        }
    }

    pub fn view(&mut self) -> Element<'_, RowMessage> {
        let plugin = self.clone();
        let bla = self.clone();

        let description_label = Text::new("Description");
        let description = Text::new(&self.description.to_string());
        let description_section = Column::new()
            .push(description_label)
            .push(description)
            .spacing(10)
            .width(Length::Fill);

        let website_btn = Button::new(&mut self.website_btn_state, Text::new("Website"))
            .padding(5)
            .on_press(RowMessage::WebsitePressed(self.id, self.title.clone()))
            .style(style::PrimaryButton::Enabled);

        let delete_btn = Button::new(&mut self.delete_btn_state, Text::new("Delete"))
            .padding(5)
            .on_press(RowMessage::DeletePressed(bla))
            .style(style::PrimaryButton::Enabled);

        let button_row = Row::new()
            .push(Space::new(Length::Fill, Length::Shrink))
            .push(website_btn)
            .push(delete_btn)
            .width(Length::Fill)
            .spacing(10)
            .align_items(Align::End);

        let toggle_section = Column::new().push(description_section).push(button_row);

        let container = Container::new(toggle_section)
            .width(Length::Fill)
            .padding(15)
            .style(style::NavigationContainer);

        if self.opened {
            Column::new()
                .push(
                    Button::new(
                        &mut self.toggle_view_btn,
                        Row::new()
                            .align_items(Align::Center)
                            .align_items(Align::Center)
                            .push(Text::new(&self.title).width(Length::FillPortion(6)))
                            .push(Text::new(&self.current_version).width(Length::FillPortion(3)))
                            .push(Text::new(&self.latest_version).width(Length::FillPortion(3)))
                            .push(if self.latest_version == self.current_version {
                                Button::new(&mut self.update_btn_state, Text::new("."))
                                    .style(style::TransparentButton::Enabled)
                                    .width(Length::FillPortion(2))
                            } else {
                                Button::new(&mut self.update_btn_state, Text::new(&self.status))
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
            Column::new()
                .push(
                    Button::new(
                        &mut self.toggle_view_btn,
                        Row::new()
                            .align_items(Align::Center)
                            .push(Text::new(&self.title).width(Length::FillPortion(6)))
                            .push(Text::new(&self.current_version).width(Length::FillPortion(3)))
                            .push(Text::new(&self.latest_version).width(Length::FillPortion(3)))
                            .push(if self.latest_version == self.current_version {
                                Button::new(
                                    &mut self.update_btn_state,
                                    Text::new(".")
                                        .width(Length::Fill)
                                        .horizontal_alignment(HorizontalAlignment::Center),
                                )
                                .style(style::TransparentButton::Enabled)
                                .width(Length::FillPortion(2))
                            } else {
                                Button::new(
                                    &mut self.update_btn_state,
                                    Text::new("Update")
                                        .width(Length::Fill)
                                        .horizontal_alignment(HorizontalAlignment::Center),
                                )
                                .style(style::PrimaryButton::Enabled)
                                .on_press(RowMessage::UpdatePressed(plugin))
                                .width(Length::FillPortion(2))
                            }),
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
