use crate::core::config::CONFIGURATION;
use crate::core::{
    get_installed_plugins, get_plugin, get_plugins, installer, synchronizer::install_plugin,
    update_local_plugins, Plugin,
};
use crate::gui::style;
use iced::{
    button, scrollable, text_input, Align, Button, Column, Command, Container, Element, Length,
    Row, Scrollable, Text, TextInput,
};
use std::path::Path;

#[derive(Debug, Clone)]
pub enum Plugins {
    Loaded(State),
}

impl Default for Plugins {
    fn default() -> Self {
        let installed_plugins = get_installed_plugins();
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
    Loading,
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
    async fn install_plugin(plugin: PluginRow) -> Vec<Plugin> {
        let plugin = Plugin::new(
            plugin.id,
            &plugin.title,
            &plugin.current_version,
            &plugin.latest_version,
        );
        let filename = format!("{}_{}.zip", &plugin.plugin_id, &plugin.title);
        let path = Path::new(&CONFIGURATION.plugins).join(&filename);
        let target = format!(
            "https://www.lotrointerface.com/downloads/download{}-{}",
            &plugin.plugin_id, &plugin.title
        );

        if installer::install(&path, &target).is_ok() {
            installer::zip_operation(path.as_path());
            install_plugin(&plugin);
            get_installed_plugins()
        } else {
            // TODO: Implement proper error handling
            let result: Vec<Plugin> = Vec::new();
            result
        }
    }

    async fn update_plugins(plugins: Vec<PluginRow>) -> Vec<Plugin> {
        // TODO Implement here
        let result: Vec<Plugin> = Vec::new();
        result
    }

    fn load_installed_plugins() -> Vec<Plugin> {
        get_installed_plugins()
    }

    async fn load_plugins() -> Vec<Plugin> {
        get_plugins()
    }

    async fn get_catalog_plugin(name: String) -> Vec<Plugin> {
        get_plugin(&name)
    }

    async fn refresh_db() -> Result<(), ApplicationError> {
        match update_local_plugins() {
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
                    RowMessage::UpgradePressed(plugin) => {
                        let plugin = plugin.clone();
                        Command::perform(
                            Self::install_plugin(plugin),
                            PluginMessage::InstalledPluginsLoaded,
                        );
                    }
                    RowMessage::InstallPressed(_) => println!("Install"),
                    RowMessage::ToggleView => {
                        state.plugins[index].update(msg);
                    }
                    RowMessage::PluginDownloaded(_) => {}
                    RowMessage::PluginExtracted(_) => {}
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
                let upgrade = Text::new("Upgrade").width(Length::FillPortion(2));

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
    opened: bool,
    toggle_view_btn: button::State,
}

#[derive(Clone, Debug)]
pub enum RowMessage {
    ToggleView,

    UpgradePressed(PluginRow),
    InstallPressed(PluginRow),
    PluginDownloaded(Result<(String, PluginRow), String>),
    PluginExtracted(Result<String, String>),
}

impl PluginRow {
    pub fn new(id: i32, title: &str, current_version: &str, latest_version: &str) -> Self {
        Self {
            id,
            title: title.to_string(),
            current_version: current_version.to_string(),
            latest_version: latest_version.to_string(),
            install_btn_state: button::State::default(),
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
            RowMessage::UpgradePressed(_) => {}
            RowMessage::InstallPressed(_) => {}
            RowMessage::PluginDownloaded(_) => {}
            RowMessage::PluginExtracted(_) => {}
        }
    }

    pub fn view(&mut self) -> Element<RowMessage> {
        let container = Container::new(Text::new("Hallo"))
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
                let plugin = self.clone();

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
                                    Button::new(&mut self.install_btn_state, Text::new("Upgrade"))
                                        .on_press(RowMessage::UpgradePressed(plugin))
                                        .width(Length::FillPortion(2))
                                        .style(style::InstallButton::Enabled)
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
            let plugin = self.clone();

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
                                Button::new(&mut self.install_btn_state, Text::new("Upgrade"))
                                    .on_press(RowMessage::UpgradePressed(plugin))
                                    .width(Length::FillPortion(2))
                                    .style(style::InstallButton::Enabled)
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
