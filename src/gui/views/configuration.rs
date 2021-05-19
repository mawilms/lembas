use crate::core::config::CONFIGURATION;
use crate::gui::style;
use iced::{Align, Checkbox, Column, Container, Element, Length, Row, Text};

#[derive(Debug, Clone)]
pub struct Configuration {
    description: String,
    backup: bool,
}

impl Default for Configuration {
    fn default() -> Self {
        Self {
            description: "Enable Backup".to_string(),
            backup: CONFIGURATION.application_settings.backup_enabled,
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
                //CONFIGURATION.application_settings.backup_enabled = self.backup;
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
