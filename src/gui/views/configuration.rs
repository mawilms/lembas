use crate::{core::Config, gui::style};
use iced::{text_input, Align, Checkbox, Column, Container, Element, Length, Row, Text, TextInput};

#[derive(Debug, Clone)]
pub struct Configuration {
    config: Config,
    description: String,
    backup: bool,
    feed_url: text_input::State,
    feed_url_value: String,
}

impl Configuration {
    pub fn new(config: &Config) -> Self {
        Self {
            config: config.clone(),
            description: "Enable Backup".to_string(),
            backup: config.application_settings.backup_enabled,
            feed_url: text_input::State::default(),
            feed_url_value: config.application_settings.feed_url.clone(),
        }
    }
}

#[derive(Debug, Clone)]
pub enum Message {
    BackupTriggered(bool),
    FeedUrlChanged(String),
}

impl Configuration {
    pub fn update(&mut self, msg: Message) {
        match msg {
            Message::BackupTriggered(toggled) => {
                self.backup = toggled;
                self.config.application_settings.backup_enabled = self.backup;
                self.config.save_changes();
            }
            Message::FeedUrlChanged(state) => {
                self.feed_url_value = state;
                self.config.save_changes();
            }
        }
    }

    pub fn view(&mut self) -> Element<Message> {
        let about_text = Text::new("General");

        let checkbox = Checkbox::new(self.backup, &self.description, Message::BackupTriggered);

        let feed_label = Text::new("Feed URL");

        let feed_url = TextInput::new(
            &mut self.feed_url,
            "Feed Url",
            &self.feed_url_value,
            Message::FeedUrlChanged,
        )
        .padding(5);

        let feed_row = Row::new()
            .width(Length::Shrink)
            .align_items(Align::Center)
            .spacing(10)
            .push(feed_label)
            .push(feed_url);

        let content = Column::new()
            .width(Length::Fill)
            .spacing(10)
            .push(about_text)
            .push(checkbox)
            .push(feed_row);

        Container::new(content)
            .padding(20)
            .width(Length::Fill)
            .height(Length::Fill)
            .style(style::Content)
            .into()
    }
}
