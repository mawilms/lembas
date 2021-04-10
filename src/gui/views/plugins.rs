use crate::core::{installer::Installer, Plugin, Synchronizer};
use crate::gui::style;
use iced::{
    button, scrollable, text_input, Align, Button, Column, Container, Element, Length, Row,
    Scrollable, Text, TextInput,
};

#[derive(Debug, Clone)]
pub enum Plugins {
    Loaded(State),
}

impl Default for Plugins {
    fn default() -> Self {
        let installed_plugins = Synchronizer::get_installed_plugins();
        let mut plugins: Vec<PluginRow> = Vec::new();
        for plugin in installed_plugins {
            plugins.push(PluginRow::new(
                plugin.plugin_id,
                &plugin.title,
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
    plugin_scrollable_state: scrollable::State,
    input_value: String,
    pub plugins: Vec<PluginRow>,
    input: text_input::State,
    refresh_button: button::State,
    update_all_button: button::State,
}

#[derive(Debug, Clone)]
pub enum PluginMessage {
    InstalledPluginsLoaded(Vec<Plugin>),
    AllPluginsLoaded(Vec<Plugin>),
    PluginsSynchronized(Result<(), ApplicationError>),

    // Navigation View
    PluginInputChanged(String),
    RefreshPressed,
    UpdateAllPressed,

    // Plugin View
    Plugin(usize, RowMessage),
}

impl Plugins {
    fn install_plugin(plugin: PluginRow) -> Vec<Plugin> {
        let plugin = Plugin::new(
            plugin.id,
            &plugin.title,
            &plugin.current_version,
            &plugin.latest_version,
        );
        let result: Vec<Plugin> = Vec::new();
        result
    }

    fn update_plugins(plugins: Vec<PluginRow>) -> Vec<Plugin> {
        // TODO Implement here
        let result: Vec<Plugin> = Vec::new();
        result
    }

    fn load_installed_plugins() -> Vec<Plugin> {
        Synchronizer::get_installed_plugins()
    }

    fn load_plugins() -> Vec<Plugin> {
        Synchronizer::get_plugins()
    }

    fn get_catalog_plugin(name: String) -> Vec<Plugin> {
        Synchronizer::get_plugin(&name)
    }

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
                PluginMessage::Plugin(index, msg) => match msg {
                    RowMessage::UpdatePressed(plugin) => {
                        Self::install_plugin(plugin);
                    }
                    RowMessage::InstallPressed(_) => println!("Install"),
                    RowMessage::ToggleView => {
                        state.plugins[index].update(msg);
                    }
                    RowMessage::PluginDownloaded(_) => {}
                    RowMessage::PluginExtracted(_) => {}
                    RowMessage::DeletePressed(_) => {}
                    RowMessage::WebsitePressed(_) => {}
                },

                PluginMessage::AllPluginsLoaded(state)
                | PluginMessage::InstalledPluginsLoaded(state) => {
                    let mut states: Vec<PluginRow> = Vec::new();
                    for plugin in state {
                        states.push(PluginRow::new(
                            plugin.plugin_id,
                            &plugin.title,
                            &plugin.current_version,
                            &plugin.latest_version,
                        ));
                    }
                    *self = Plugins::Loaded(State {
                        plugins: states,
                        ..State::default()
                    });
                }
                PluginMessage::RefreshPressed => {
                    println!("Refreshed");
                    Self::refresh_db();
                }
                PluginMessage::UpdateAllPressed => {
                    println!("Update all");
                }
                _ => {}
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
                );

                let control_panel = Row::new()
                    .width(Length::Fill)
                    .align_items(Align::Center)
                    .spacing(10)
                    .push(refresh_button)
                    .push(update_all_button)
                    .push(installed_plugins)
                    .push(search_plugins);

                let plugin_name = Text::new("Plugin").width(Length::FillPortion(5));
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
#[derive(Clone, Debug)]
pub struct PluginRow {
    pub id: i32,
    pub title: String,
    pub current_version: String,
    pub latest_version: String,

    install_btn_state: button::State,
    delete_btn_state: button::State,
    website_btn_state: button::State,
    opened: bool,
    toggle_view_btn: button::State,
}

#[derive(Clone, Debug)]
pub enum RowMessage {
    ToggleView,

    UpdatePressed(PluginRow),
    InstallPressed(PluginRow),
    PluginDownloaded(Result<(String, PluginRow), String>),
    PluginExtracted(Result<String, String>),
    DeletePressed(PluginRow),
    WebsitePressed(PluginRow),
}

impl PluginRow {
    pub fn new(id: i32, title: &str, current_version: &str, latest_version: &str) -> Self {
        Self {
            id,
            title: title.to_string(),
            current_version: current_version.to_string(),
            latest_version: latest_version.to_string(),
            install_btn_state: button::State::default(),
            delete_btn_state: button::State::default(),
            website_btn_state: button::State::default(),
            toggle_view_btn: button::State::new(),
            opened: false,
        }
    }

    pub fn update(&mut self, message: RowMessage) {
        match message {
            RowMessage::ToggleView => {
                if self.opened {
                    self.opened = false;
                } else {
                    self.opened = true;
                }
            }
            RowMessage::UpdatePressed(plugin) => {
                let plugin = Plugin::new(
                    plugin.id,
                    &plugin.title,
                    &plugin.current_version,
                    &plugin.latest_version,
                );
                //Installer::update(&plugin);
                println!("Pressed");
            }
            RowMessage::InstallPressed(_) => {}
            RowMessage::PluginDownloaded(_) => {}
            RowMessage::PluginExtracted(_) => {}
            RowMessage::DeletePressed(_) => {
                println!("Delete pressed")
            }
            RowMessage::WebsitePressed(_) => {
                println!("Website pressed")
            }
        }
    }

    pub fn view(&mut self) -> Element<RowMessage> {
        let plugin = self.clone();
        let description_label = Text::new("Description");
        let description = Text::new("Hallo Welt");
        let description_section = Column::new()
            .push(description_label)
            .push(description)
            .width(Length::Fill);

        let website_btn = Button::new(&mut self.website_btn_state, Text::new("Website"))
            .padding(2)
            .on_press(RowMessage::ToggleView)
            .style(style::PluginRow::Enabled);

        let delete_btn = Button::new(&mut self.delete_btn_state, Text::new("Delete"))
            .padding(2)
            .on_press(RowMessage::ToggleView)
            .style(style::PluginRow::Enabled);

        let button_row = Row::new()
            .push(website_btn)
            .push(delete_btn)
            .width(Length::Fill)
            .align_items(Align::End);

        let toggle_section = Column::new().push(description_section).push(button_row);

        let container = Container::new(toggle_section)
            .width(Length::Fill)
            .padding(15);

        if self.opened {
            if self.current_version == self.latest_version {
                Column::new()
                    .push(
                        Button::new(
                            &mut self.toggle_view_btn,
                            Row::new()
                                .align_items(Align::Center)
                                .push(Text::new(&self.title).width(Length::FillPortion(5)))
                                .push(
                                    Text::new(&self.current_version).width(Length::FillPortion(3)),
                                )
                                .push(Text::new(&self.latest_version).width(Length::FillPortion(3)))
                                .push(Text::new("").width(Length::FillPortion(2))),
                        )
                        .padding(10)
                        .width(Length::Fill)
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
                                .push(Text::new(&self.title).width(Length::FillPortion(5)))
                                .push(
                                    Text::new(&self.current_version).width(Length::FillPortion(3)),
                                )
                                .push(Text::new(&self.latest_version).width(Length::FillPortion(3)))
                                .push(
                                    Button::new(&mut self.install_btn_state, Text::new("Update"))
                                        .on_press(RowMessage::UpdatePressed(plugin))
                                        .style(style::PrimaryButton::Enabled)
                                        .width(Length::FillPortion(2)),
                                ),
                        )
                        .padding(10)
                        .width(Length::Fill)
                        .on_press(RowMessage::ToggleView)
                        .style(style::PluginRow::Enabled),
                    )
                    .push(container)
                    .into()
            }
        } else if self.current_version == self.latest_version {
            Column::new()
                .push(
                    Button::new(
                        &mut self.toggle_view_btn,
                        Row::new()
                            .align_items(Align::Center)
                            .push(Text::new(&self.title).width(Length::FillPortion(5)))
                            .push(Text::new(&self.current_version).width(Length::FillPortion(3)))
                            .push(Text::new(&self.latest_version).width(Length::FillPortion(3)))
                            .push(Text::new("").width(Length::FillPortion(2))),
                    )
                    .padding(10)
                    .width(Length::Fill)
                    .on_press(RowMessage::ToggleView)
                    .style(style::PluginRow::Enabled),
                )
                .into()
        } else {
            Column::new()
                .push(
                    Button::new(
                        &mut self.toggle_view_btn,
                        Row::new()
                            .align_items(Align::Center)
                            .push(Text::new(&self.title).width(Length::FillPortion(5)))
                            .push(Text::new(&self.current_version).width(Length::FillPortion(3)))
                            .push(Text::new(&self.latest_version).width(Length::FillPortion(3)))
                            .push(
                                Button::new(&mut self.install_btn_state, Text::new("Update"))
                                    .on_press(RowMessage::UpdatePressed(plugin))
                                    .width(Length::FillPortion(2))
                                    .style(style::PrimaryButton::Enabled)
                                    .width(Length::FillPortion(2)),
                            ),
                    )
                    .padding(10)
                    .width(Length::Fill)
                    .on_press(RowMessage::ToggleView)
                    .style(style::PluginRow::Enabled),
                )
                .into()
        }
    }
}

#[derive(Debug, Clone)]
enum ApplicationError {
    Load,
    Install,
    Synchronize,
}
