use crate::core::Plugin;
use crate::gui::elements::PluginPanel;
use crate::gui::main_window::Message;
use crate::gui::style;
use iced::{
    pick_list, scrollable, text_input, Align, Column, Container, Element, Length, PickList, Row,
    Scrollable, TextInput,
};

#[derive(Default, Debug, Clone)]
pub struct Catalog {
    plugin_panel: PluginPanel,

    pick_list: pick_list::State<Amount>,
    selected_amount: Amount,
    input: text_input::State,
    plugin_scrollable_state: scrollable::State,
    input_value: String,

    pub plugins: Vec<Plugin>,
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
        let Self { plugin_panel, .. } = self;

        let search_plugins = TextInput::new(
            &mut self.input,
            "Search plugins...",
            &self.input_value,
            Message::InputChanged,
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

        let mut plugins_scrollable = Scrollable::new(&mut self.plugin_scrollable_state)
            .spacing(5)
            .width(Length::Fill)
            .align_items(Align::Center)
            .style(style::Scrollable);

        for plugin in &mut self.plugins {
            plugins_scrollable = plugins_scrollable.push(plugin.view());
        }

        let content = Column::new()
            .width(Length::Fill)
            .spacing(10)
            .align_items(Align::Center)
            .push(row)
            .push(plugin_panel.view())
            .push(plugins_scrollable);

        Container::new(content)
            .width(Length::Fill)
            .height(Length::Fill)
            .padding(10)
            .style(style::Content)
            .into()
    }
}
