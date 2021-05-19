use crate::core::config::CONFIGURATION;
use crate::gui::style;
use iced::{Checkbox, Column, Container, Element, Length, Text};

#[derive(Debug, Clone)]
pub struct Configuration {
    description: String,
    backup: bool,
}

impl Default for Configuration {
    fn default() -> Self {
        Self {
            description: "Enable Backup".to_string(),
            backup: CONFIGURATION
                .lock()
                .unwrap()
                .application_settings
                .backup_enabled,
        }
    }
}

#[derive(Debug, Clone)]
pub enum Message {
    BackupTriggered(bool),
}

impl Configuration {
    pub fn update(&mut self, msg: Message) {
        match msg {
            Message::BackupTriggered(toggled) => {
                self.backup = toggled;
                CONFIGURATION
                    .lock()
                    .unwrap()
                    .application_settings
                    .backup_enabled = self.backup;
                println!(
                    "{:?}",
                    CONFIGURATION
                        .lock()
                        .unwrap()
                        .application_settings
                        .backup_enabled
                );
            }
        }
    }

    pub fn view(&self) -> Element<Message> {
        let about_text = Text::new("General");

        let checkbox = Checkbox::new(self.backup, &self.description, Message::BackupTriggered);

        let content = Column::new()
            .width(Length::Fill)
            .spacing(10)
            .push(about_text)
            .push(checkbox);

        Container::new(content)
            .padding(10)
            .width(Length::Fill)
            .height(Length::Fill)
            .style(style::Content)
            .into()
    }
}
