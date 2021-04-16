use crate::core::{Installer, Plugin, Synchronizer};
use crate::gui::style;
use iced::{
    button, scrollable, text_input, Align, Button, Column, Container, Element, HorizontalAlignment,
    Length, Row, Scrollable, Text, TextInput,
};

#[derive(Debug, Clone)]
pub enum Catalog {
    Loaded(State),
}

impl Default for Catalog {
    fn default() -> Self {
        let all_plugins = Synchronizer::get_plugins();
        let mut plugins: Vec<PluginRow> = Vec::new();
        for plugin in all_plugins {
            plugins.push(PluginRow::new(
                plugin.plugin_id,
                &plugin.title,
                &plugin.description,
                &plugin.current_version,
                &plugin.latest_version,
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
    input: text_input::State,
    plugin_scrollable_state: scrollable::State,
    pub input_value: String,

    pub plugins: Vec<PluginRow>,
}

#[derive(Debug, Clone)]
pub enum Message {
    CatalogInputChanged(String),
    Catalog(usize, RowMessage),
}

impl Catalog {
    pub fn update(&mut self, message: Message) {
        match self {
            Catalog::Loaded(state) => match message {
                Message::CatalogInputChanged(letter) => {
                    state.input_value = letter;
                    let mut plugins: Vec<PluginRow> = Vec::new();
                    let queried_plugins = Synchronizer::search_plugin(&state.input_value);
                    for plugin in queried_plugins {
                        plugins.push(PluginRow::new(
                            plugin.plugin_id,
                            &plugin.title,
                            &plugin.description,
                            &plugin.current_version,
                            &plugin.latest_version,
                        ))
                    }
                    state.plugins = plugins;
                }
                Message::Catalog(index, msg) => {
                    state.plugins[index].update(msg);
                }
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
            }) => {
                let search_plugins = TextInput::new(
                    input,
                    "Search plugins...",
                    &input_value,
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
        }
    }
}
#[derive(Clone, Debug)]
pub struct PluginRow {
    pub id: i32,
    pub title: String,
    pub description: String,
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
}

impl PluginRow {
    pub fn new(
        id: i32,
        title: &str,
        description: &str,
        current_version: &str,
        latest_version: &str,
    ) -> Self {
        if current_version == latest_version {
            Self {
                id,
                title: title.to_string(),
                description: description.to_string(),
                current_version: current_version.to_string(),
                latest_version: latest_version.to_string(),
                status: "Installed".to_string(),
                install_btn_state: button::State::default(),
                website_btn_state: button::State::default(),
            }
        } else if current_version.is_empty() {
            Self {
                id,
                title: title.to_string(),
                description: description.to_string(),
                current_version: current_version.to_string(),
                latest_version: latest_version.to_string(),
                status: "Install".to_string(),
                install_btn_state: button::State::default(),
                website_btn_state: button::State::default(),
            }
        } else {
            Self {
                id,
                title: title.to_string(),
                description: description.to_string(),
                current_version: current_version.to_string(),
                latest_version: latest_version.to_string(),
                status: "Update".to_string(),
                install_btn_state: button::State::default(),
                website_btn_state: button::State::default(),
            }
        }
    }

    pub fn update(&mut self, message: RowMessage) {
        match message {
            RowMessage::InstallPressed(plugin) => {
                let plugin = Plugin::new(
                    plugin.id,
                    &plugin.title,
                    &plugin.description,
                    &plugin.current_version,
                    &plugin.latest_version,
                );
                if Installer::download(&plugin).is_ok() {
                    self.status = "Downloaded".to_string();
                    if Installer::extract(&plugin).is_ok() {
                        self.status = "Unpacked".to_string();
                        if Installer::delete_cache_folder(&plugin).is_ok() {
                            if Synchronizer::insert_plugin(&plugin).is_ok() {
                                self.status = "Installed".to_string();
                            } else {
                                self.status = "Installation failed".to_string();
                            }
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

            RowMessage::WebsitePressed(row) => {
                webbrowser::open(&format!(
                    "https://www.lotrointerface.com/downloads/info{}-{}.html",
                    row.id, row.title,
                ))
                .unwrap();
            }
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
                        .push(
                            Button::new(
                                &mut self.install_btn_state,
                                Text::new(&plugin.status)
                                    .width(Length::Fill)
                                    .horizontal_alignment(HorizontalAlignment::Center),
                            )
                            .on_press(RowMessage::InstallPressed(plugin))
                            .style(style::InstallButton::Enabled)
                            .width(Length::FillPortion(2)),
                        ),
                )
                .on_press(RowMessage::WebsitePressed(website_plugin))
                .style(style::PluginRow::Enabled),
            )
            .into()
    }
}
