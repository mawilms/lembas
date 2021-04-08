use crate::core::{Installer, Plugin, Synchronizer};
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
    pub fn update(&mut self, message: Message) {
        match self {
            Catalog::Loaded(state) => match message {
                Message::CatalogInputChanged(_) => {}
                Message::AmountFiltered(_) => {}
                Message::Catalog(index, msg) => match msg {
                    RowMessage::ToggleView => {}
                    RowMessage::InstallPressed(plugin) => {
                        let plugin = Plugin::new(
                            plugin.id,
                            &plugin.title,
                            &plugin.current_version,
                            &plugin.latest_version,
                        );
                        match Installer::download(&plugin) {
                            // TODO: Version wird noch nicht automatisch eingetragen. Kein async
                            Ok(_) => {
                                state.plugins[index].status = "Downloaded".to_string();
                                match Installer::extract(&plugin) {
                                    Ok(_) => {
                                        state.plugins[index].status = "Unpacked".to_string();
                                        match Installer::delete_archive(&plugin) {
                                            Ok(_) => match Synchronizer::insert_plugin(&plugin) {
                                                Ok(_) => {
                                                    state.plugins[index].status =
                                                        "Installed".to_string();
                                                }
                                                Err(_) => {
                                                    state.plugins[index].status =
                                                        "Installation failed".to_string()
                                                }
                                            },
                                            Err(_) => {
                                                state.plugins[index].status =
                                                    "Installation failed".to_string()
                                            }
                                        }
                                    }
                                    Err(_) => {
                                        state.plugins[index].status = "Unpacking failed".to_string()
                                    }
                                }
                            }
                            Err(_) => state.plugins[index].status = "Download failed".to_string(),
                        }
                    }
                },
            },
        }
    }

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
                    .style(style::Scrollable);

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
    pub status: String,

    install_btn_state: button::State,
    website_btn_state: button::State,
    opened: bool,
    toggle_view_btn: button::State,
}

#[derive(Clone, Debug)]
pub enum RowMessage {
    ToggleView,

    InstallPressed(PluginRow),
}

impl PluginRow {
    pub fn new(id: i32, title: &str, current_version: &str, latest_version: &str) -> Self {
        if current_version == latest_version {
            Self {
                id,
                title: title.to_string(),
                current_version: current_version.to_string(),
                latest_version: latest_version.to_string(),
                status: "Installed".to_string(),
                install_btn_state: button::State::default(),
                toggle_view_btn: button::State::new(),
                website_btn_state: button::State::default(),
                opened: false,
            }
        } else if !current_version.is_empty() {
            Self {
                id,
                title: title.to_string(),
                current_version: current_version.to_string(),
                latest_version: latest_version.to_string(),
                status: "Update".to_string(),
                install_btn_state: button::State::default(),
                toggle_view_btn: button::State::new(),
                website_btn_state: button::State::default(),
                opened: false,
            }
        } else {
            Self {
                id,
                title: title.to_string(),
                current_version: current_version.to_string(),
                latest_version: latest_version.to_string(),
                status: "Install".to_string(),
                install_btn_state: button::State::default(),
                toggle_view_btn: button::State::new(),
                website_btn_state: button::State::default(),
                opened: false,
            }
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
            RowMessage::InstallPressed(state) => {
                let plugin = Plugin::new(
                    state.id,
                    &state.title,
                    &state.current_version,
                    &state.latest_version,
                );
                match Installer::download(&plugin) {
                    Ok(_) => println!("Hallo"),
                    Err(_) => println!("Fail"),
                }
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

        let button_row = Row::new()
            .push(website_btn)
            .width(Length::Fill)
            .align_items(Align::End);

        let toggle_section = Column::new().push(description_section).push(button_row);

        let container = Container::new(toggle_section)
            .width(Length::Fill)
            .padding(15);

        if self.opened {
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
                                Button::new(&mut self.install_btn_state, Text::new(&plugin.status))
                                    .on_press(RowMessage::InstallPressed(plugin))
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
                                Button::new(&mut self.install_btn_state, Text::new(&plugin.status))
                                    .width(Length::FillPortion(2))
                                    .style(style::InstallButton::Enabled)
                                    .width(Length::FillPortion(2)),
                            ),
                    )
                    .padding(10)
                    .width(Length::Fill)
                    .on_press(RowMessage::InstallPressed(plugin)) // TODO: Toggle methode wieder einbinden. Aus Testzwecken zurzeit Install Message
                    .style(style::PluginRow::Enabled),
                )
                .into()
        }
    }
}
