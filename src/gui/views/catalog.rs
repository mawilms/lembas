use crate::core::Synchronizer;
use crate::gui::style;
use iced::{
    button, pick_list, scrollable, text_input, Align, Button, Column, Container, Element, Length,
    PickList, Row, Scrollable, Text, TextInput,
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
    pick_list: pick_list::State<Amount>,
    selected_amount: Amount,
    input: text_input::State,
    plugin_scrollable_state: scrollable::State,
    pub input_value: String,

    pub plugins: Vec<PluginRow>,
}

#[derive(Debug, Clone)]
pub enum Message {
    CatalogInputChanged(String),
    AmountFiltered(Amount),
    //PluginSearched(Vec<Plugin>),
    Catalog(usize, RowMessage),
}

#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum Amount {
    TwentyFive,
    Fifty,
    All,
}

impl Default for Amount {
    fn default() -> Self {
        Amount::TwentyFive
    }
}

impl Amount {
    const ALL: [Amount; 3] = [Amount::TwentyFive, Amount::Fifty, Amount::All];
}

impl std::fmt::Display for Amount {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(
            f,
            "{}",
            match self {
                Amount::TwentyFive => "15",
                Amount::Fifty => "25",
                Amount::All => "All",
            }
        )
    }
}

impl Catalog {
    pub fn view(&mut self) -> Element<Message> {
        match self {
            Catalog::Loaded(State {
                pick_list,
                input,
                selected_amount,
                plugin_scrollable_state,
                plugins,
                input_value,
            }) => {
                let search_plugins = TextInput::new(
                    input,
                    "Search plugins...",
                    &input_value,
                    Message::CatalogInputChanged,
                );

                let pick_list = PickList::new(
                    pick_list,
                    &Amount::ALL[..],
                    Some(*selected_amount),
                    Message::AmountFiltered,
                );

                let row = Row::new()
                    .width(Length::Fill)
                    .align_items(Align::Center)
                    .spacing(10)
                    .push(search_plugins)
                    .push(pick_list);

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
                        col.push(p.view().map(move |msg| Message::Catalog(i, msg)))
                    });

                let plugins_scrollable = Scrollable::new(plugin_scrollable_state)
                    .push(plugins)
                    .spacing(5)
                    .width(Length::Fill)
                    .align_items(Align::Center)
                    .style(style::Scrollable); //TODO: Scrollable funzt nicht mehr

                let content = Column::new()
                    .width(Length::Fill)
                    .spacing(10)
                    .align_items(Align::Center)
                    .push(row)
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
