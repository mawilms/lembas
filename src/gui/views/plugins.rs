use crate::gui::main_window::Message;
use crate::gui::style;
use iced::{
    button, scrollable, text_input, Align, Button, Column, Container, Element, HorizontalAlignment,
    Length, Row, Scrollable, Text, TextInput,
};

#[derive(Debug, Clone)]
pub enum Plugins {
    Loading,
    Loaded(State),
}

impl Default for Plugins {
    fn default() -> Self {
        Self::Loading
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

impl Plugins {
    pub fn view(&mut self) -> Element<Message> {
        match self {
            Plugins::Loading => loading_message(),
            Plugins::Loaded(State {
                plugin_scrollable_state,
                input_value,
                plugins,
                input,
                refresh_button,
                update_all_button,
            }) => {
                let refresh_button = Button::new(&mut refresh_button, Text::new("Refresh"))
                    .on_press(Message::RefreshPressed)
                    .padding(5)
                    .style(style::PrimaryButton::Enabled);
                let update_all_button =
                    Button::new(&mut update_all_button, Text::new("Update all"))
                        .on_press(Message::UpdateAllPressed)
                        .padding(5)
                        .style(style::PrimaryButton::Enabled);
                let installed_plugins = Text::new(format!("{} plugins installed", plugins.len()));
                let search_plugins = TextInput::new(
                    &mut input,
                    "Search plugins...",
                    &input_value,
                    Message::PluginInputChanged,
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

                let mut plugins_scrollable = Scrollable::new(&mut plugin_scrollable_state)
                    .spacing(5)
                    .width(Length::Fill)
                    .align_items(Align::Center)
                    .style(style::Scrollable);

                for plugin in plugins {
                    plugins_scrollable =
                        plugins_scrollable.push(plugin.view().map(Message::Plugin));
                }

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

fn loading_message<'a>() -> Element<'a, Message> {
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
