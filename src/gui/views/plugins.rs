use crate::core::{Installer, Plugin, Synchronizer};
use crate::gui::style;
use iced::{
    button, scrollable, text_input, Align, Button, Column, Container, Element, HorizontalAlignment,
    Length, Row, Scrollable, Space, Text, TextInput,
};
use serde::{Deserialize, Serialize};

#[derive(Debug, Clone)]
pub enum Plugins {
    Loaded(State),
}

impl Default for Plugins {
    fn default() -> Self {
        let mut installed_plugins: Vec<Plugin> = Synchronizer::get_installed_plugins()
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
                &plugin.current_version,
                &plugin.latest_version,
                &plugin.folder_name,
                &plugin.files,
            ));
        }

        Self::Loaded(State {
            plugins,
            ..State::default()
        })
    }
}

#[derive(Default, Debug, Clone)]
pub struct State {
    plugin_scrollable_state: scrollable::State,
    input_value: String,
    pub plugins: Vec<PluginRow>,
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

    // Plugin View
    Plugin(usize, RowMessage),
}

impl Plugins {
    fn refresh_db() -> Result<(), ApplicationError> {
        match Synchronizer::update_local_plugins() {
            Ok(_) => Ok(()),
            Err(error) => {
                println!("{:?}", &error);
                Err(ApplicationError::Synchronize)
            }
        }
    }

    pub fn update(&mut self, message: PluginMessage) {
        match self {
            Plugins::Loaded(state) => match message {
                PluginMessage::Plugin(index, msg) => {
                    if let Event::Synchronize = state.plugins[index].update(msg) {
                        let mut plugins: Vec<PluginRow> = Vec::new();
                        let mut all_plugins: Vec<Plugin> = Synchronizer::get_installed_plugins()
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
                                &plugin.current_version,
                                &plugin.latest_version,
                                &plugin.folder_name,
                                &plugin.files,
                            ))
                        }
                        state.plugins = plugins;
                    }
                }

                PluginMessage::RefreshPressed => {
                    Self::refresh_db();
                }
                PluginMessage::UpdateAllPressed => {
                    for i in 1..state.plugins.len() {
                        if state.plugins[i].current_version != state.plugins[i].latest_version {
                            println!("{:?}", state.plugins[i]);
                            let test = state.plugins[i].clone();
                            state.plugins[i].update(RowMessage::UpdatePressed(test));
                        }
                    }
                }
                PluginMessage::LoadPlugins => {
                    let mut plugins: Vec<PluginRow> = Vec::new();
                    let installed_plugins = Synchronizer::get_installed_plugins();
                    for (_, plugin) in installed_plugins {
                        plugins.push(PluginRow::new(
                            plugin.plugin_id,
                            &plugin.title,
                            &plugin.description,
                            &plugin.current_version,
                            &plugin.latest_version,
                            &plugin.folder_name,
                            &plugin.files,
                        ));
                    }
                    state.plugins = plugins;
                }
                PluginMessage::PluginInputChanged(_) => {}
            },
        }
    }

    pub fn view(&mut self) -> Element<PluginMessage> {
        match self {
            Plugins::Loaded(State {
                plugin_scrollable_state,
                input_value,
                plugins,
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
                    &input_value,
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
    pub current_version: String,
    pub latest_version: String,
    pub status: String,
    pub folder_name: String,
    pub files: Vec<String>,

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
        current_version: &str,
        latest_version: &str,
        folder_name: &str,
        files: &[String],
    ) -> Self {
        if current_version == latest_version {
            Self {
                id,
                title: title.to_string(),
                description: description.to_string(),
                current_version: current_version.to_string(),
                latest_version: latest_version.to_string(),
                status: "".to_string(),
                folder_name: folder_name.to_string(),
                files: files.to_vec(),
                update_btn_state: button::State::default(),
                delete_btn_state: button::State::default(),
                website_btn_state: button::State::default(),
                toggle_view_btn: button::State::new(),
                opened: false,
            }
        } else {
            Self {
                id,
                title: title.to_string(),
                description: description.to_string(),
                current_version: current_version.to_string(),
                latest_version: latest_version.to_string(),
                status: "Update".to_string(),
                folder_name: folder_name.to_string(),
                files: files.to_vec(),
                update_btn_state: button::State::default(),
                delete_btn_state: button::State::default(),
                website_btn_state: button::State::default(),
                toggle_view_btn: button::State::new(),
                opened: false,
            }
        }
    }

    pub fn update(&mut self, message: RowMessage) -> Event {
        match message {
            RowMessage::ToggleView => {
                self.opened = !self.opened;
                Event::Nothing
            }
            RowMessage::UpdatePressed(mut plugin) => {
                let install_plugin = Plugin::new(
                    plugin.id,
                    &plugin.title,
                    &plugin.description,
                    &plugin.current_version,
                    &plugin.latest_version,
                    &plugin.folder_name,
                    &plugin.files,
                );
                if Installer::download(&install_plugin).is_ok() {
                    plugin.status = "Downloaded".to_string();
                    if Installer::delete(&install_plugin.folder_name, &install_plugin.files).is_ok()
                    {
                        if Installer::extract(&install_plugin).is_ok() {
                            plugin.status = "Unpacked".to_string();
                            if Installer::delete_cache_folder(&install_plugin).is_ok() {
                                if Synchronizer::insert_plugin(&install_plugin).is_ok() {
                                    plugin.status = "Installed".to_string();
                                    Event::Synchronize
                                } else {
                                    plugin.status = "Install failed".to_string();
                                    Event::Nothing
                                }
                            } else {
                                plugin.status = "Installation failed".to_string();
                                Event::Nothing
                            }
                        } else {
                            plugin.status = "Unpacking failed".to_string();
                            Event::Nothing
                        }
                    } else {
                        plugin.status = "Installation failed".to_string();
                        Event::Nothing
                    }
                } else {
                    plugin.status = "Download failed".to_string();
                    Event::Nothing
                }
            }
            RowMessage::DeletePressed(mut row) => {
                if let Ok(()) = Installer::delete(&row.folder_name, &row.files) {
                    if Synchronizer::delete_plugin(&row.title).is_ok() {
                        row.status = "Deleted".to_string();
                        Event::Nothing
                    } else {
                        row.status = "Delete failed".to_string();
                        Event::Nothing
                    }
                } else {
                    row.status = "Delete failed".to_string();
                    Event::Nothing
                }
            }
            RowMessage::WebsitePressed(id, title) => {
                webbrowser::open(&format!(
                    "https://www.lotrointerface.com/downloads/info{}-{}.html",
                    id, title,
                ))
                .unwrap();
                Event::Nothing
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
enum ApplicationError {
    Synchronize,
}
