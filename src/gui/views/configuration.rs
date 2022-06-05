use crate::core::config::{read_existing_settings_file, save_settings_changes, SettingsFile};
use crate::gui::style;
use iced::pure::{checkbox, column, container, row, text, text_input, Element};
use iced::{Alignment, Length};

#[derive(Debug, Clone)]
pub struct Configuration {
    description: String,
    settings: SettingsFile,
}

impl Default for Configuration {
    fn default() -> Self {
        Self {
            description: "Enable Backup".to_string(),
            settings: read_existing_settings_file(),
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
                self.settings.backup_enabled = toggled;

                save_settings_changes(&self.settings);
            }
            Message::FeedUrlChanged(state) => {
                self.settings.feed_url = state;

                save_settings_changes(&self.settings);
            }
        }
    }

    pub fn view(&self) -> Element<Message> {
        let about_text = text("General");

        let checkbox = checkbox(
            &self.description,
            self.settings.backup_enabled,
            Message::BackupTriggered,
        );

        let feed_label = text("Feed URL");

        let feed_url =
            text_input("Feed Url", &self.settings.feed_url, Message::FeedUrlChanged).padding(5);

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
