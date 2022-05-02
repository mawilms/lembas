use crate::{core::Config, gui::style};
use iced::{
    text_input, Alignment, Length
};
use iced::pure::{checkbox, column, text, Element, row, text_input, container};

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

    pub fn view(&self) -> Element<Message> {
        let about_text = text("General");

        let checkbox = checkbox(&self.description,self.backup , Message::BackupTriggered);

        let feed_label = text("Feed URL");

        let feed_url = text_input(
            "Feed Url",
            &self.feed_url_value,
            Message::FeedUrlChanged,
        )
        .padding(5);

        let feed_row = row()
            .width(Length::Shrink)
            .align_items(Alignment::Center)
            .spacing(10)
            .push(feed_label)
            .push(feed_url);

        let content = column()
            .width(Length::Fill)
            .spacing(10)
            .push(about_text)
            .push(checkbox)
            .push(feed_row);

        container(content)
            .padding(20)
            .width(Length::Fill)
            .height(Length::Fill)
            .style(style::Content)
            .into()
    }
}
