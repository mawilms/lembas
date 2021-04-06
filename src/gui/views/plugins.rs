use crate::core::Plugin;
use crate::gui::main_window::Message;
use crate::gui::style;
use iced::{
    button, scrollable, text_input, Align, Button, Column, Container, Element, Length, Row,
    Scrollable, Text, TextInput,
};

#[derive(Default, Debug, Clone)]
pub struct Plugins {
    plugin_scrollable_state: scrollable::State,
    input_value: String,
    pub plugins: Vec<Plugin>,
    input: text_input::State,
    refresh_button: button::State,
    update_all_button: button::State,
}

impl Plugins {
    pub fn view(&mut self) -> Element<Message> {
        let Self { plugins, .. } = self;

        let refresh_button = Button::new(&mut self.refresh_button, Text::new("Refresh"))
            .on_press(Message::RefreshPressed)
            .padding(5)
            .style(style::PrimaryButton::Enabled);
        let update_all_button = Button::new(&mut self.update_all_button, Text::new("Update all"))
            .on_press(Message::UpdateAllPressed)
            .padding(5)
            .style(style::PrimaryButton::Enabled);
        let installed_plugins = Text::new(format!("{} plugins installed", plugins.len()));
        let search_plugins = TextInput::new(
            &mut self.input,
            "Search plugins...",
            &self.input_value,
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

        let mut plugins_scrollable = Scrollable::new(&mut self.plugin_scrollable_state)
            .spacing(5)
            .width(Length::Fill)
            .align_items(Align::Center)
            .style(style::Scrollable);

        let mut plugin_row: PluginRow;
        // for plugin in plugins {
        //     plugins_scrollable = plugins_scrollable.push(
        //         PluginRow::new(
        //             plugin.plugin_id,
        //             plugin.title.clone(),
        //             plugin.current_version.clone(),
        //             plugin.latest_version.clone(),
        //         )
        //         .view(),
        //     );
        // }
        // for plugin in plugins {
        //     let pla = plugin.clone();
        //     let mut plugin_row = PluginRow::new(
        //         pla.plugin_id,
        //         pla.title,
        //         pla.current_version,
        //         pla.latest_version,
        //     );
        //     plugins_scrollable = plugins_scrollable.push(plugin_row.view());
        // }

        let bla = plugins.into_iter().map(|plugin| {
            plugins_scrollable.push(
                PluginRow::new(
                    plugin.plugin_id,
                    plugin.title.clone(),
                    plugin.current_version.clone(),
                    plugin.latest_version.clone(),
                )
                .view(),
            )
        });

        // for plugin in &mut self.plugins {
        //     plugins_scrollable = plugins_scrollable.push(plugin.view());
        // }

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

#[derive(Clone, Debug)]
pub struct PluginRow {
    pub id: i32,
    pub title: String,
    pub current_version: String,
    pub latest_version: String,
    opened: bool,
    toggle_view_btn: button::State,
}

impl PluginRow {
    pub fn new(id: i32, title: String, current_version: String, latest_version: String) -> Self {
        Self {
            id,
            title,
            current_version,
            latest_version,
            toggle_view_btn: button::State::new(),
            opened: false,
        }
    }

    fn update(&mut self, message: Message) {}

    pub fn view(&mut self) -> Element<'_, Message> {
        if self.opened {
            Column::new()
                .push(
                    Button::new(
                        &mut self.toggle_view_btn,
                        Row::new().push(Text::new(&self.title)),
                    )
                    .padding(10)
                    .on_press(Message::ToggleView),
                )
                .push(
                    Row::new()
                        .push(Text::new("Hallo").width(Length::Fill))
                        .padding(20),
                )
                .into()
        } else {
            Column::new()
                .spacing(5)
                .push(
                    Button::new(
                        &mut self.toggle_view_btn,
                        Row::new().push(Text::new(&self.title)),
                    )
                    .padding(10)
                    .width(Length::Fill)
                    .on_press(Message::ToggleView),
                )
                .into()
        }
    }
}
