use crate::{core::Config, gui::style};
use iced::{Checkbox, Column, Container, Element, Length, Text};

#[derive(Debug, Clone)]
pub struct Configuration {
    description: String,
    backup: bool,
}

impl Configuration {
    pub fn new(config: Config) -> Self {
        Self {
            description: "Enable Backup".to_string(),
            backup: config.application_settings.backup_enabled,
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
                CONFIGURATION.lock().unwrap().save_changes();
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
