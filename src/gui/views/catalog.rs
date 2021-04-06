use crate::gui::main_window::Message;
use crate::gui::style;
use iced::{
    pick_list, scrollable, text_input, Align, Column, Container, Element, Length, PickList, Row,
    Scrollable, Text, TextInput,
};

use super::plugins::PluginState;

#[derive(Default, Debug, Clone)]
pub struct Catalog {
    pick_list: pick_list::State<Amount>,
    selected_amount: Amount,
    input: text_input::State,
    plugin_scrollable_state: scrollable::State,
    pub input_value: String,

    pub plugins: Vec<PluginState>,
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
        let search_plugins = TextInput::new(
            &mut self.input,
            "Search plugins...",
            &self.input_value,
            Message::CatalogInputChanged,
        );

        let pick_list = PickList::new(
            &mut self.pick_list,
            &Amount::ALL[..],
            Some(self.selected_amount),
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

        let mut plugins_scrollable = Scrollable::new(&mut self.plugin_scrollable_state)
            .spacing(5)
            .width(Length::Fill)
            .align_items(Align::Center)
            .style(style::Scrollable);

        for plugin in &mut self.plugins {
            plugins_scrollable = plugins_scrollable.push(
                plugin
                    .catalog_view()
                    .map(move |message| Message::Plugin(message)),
            );
        }

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
