use iced::{button, container, Background, Color, Vector};

pub const BORDER_COLOR: Color = Color::from_rgb(0.54, 0.53, 0.31);
pub const BUTTON_COLOR_DEFAULT: Color = Color::from_rgb(0.60, 0.59, 0.32);
pub const BUTTON_COLOR_HOVER: Color = Color::from_rgb(0.25, 0.18, 0.13);
pub const BACKGROUND_COLOR: Color = Color::from_rgb(0.84, 0.71, 0.49);
pub const COLUMN_COLOR_PRIMARY: Color = Color::from_rgb(0.25, 0.18, 0.13);
pub const COLUMN_COLOR_SECONDARY: Color = Color::from_rgb(0.25, 0.18, 0.13);

pub enum PrimaryButton {
    Enabled,
    Disabled,
}

impl button::StyleSheet for PrimaryButton {
    fn active(&self) -> button::Style {
        match self {
            Self::Enabled => button::Style {
                background: Some(Background::Color(BUTTON_COLOR_DEFAULT)),
                border_color: BORDER_COLOR,
                border_width: 2.0,
                shadow_offset: Vector::new(1.0, 1.0),
                text_color: Color::from_rgb8(0xEE, 0xEE, 0xEE),
                ..button::Style::default()
            },
            Self::Disabled => button::Style {
                background: Some(Background::Color(Color::from_rgb(0.35, 0.43, 0.46))),
                border_color: Color::from_rgb(0.29, 0.19, 0.03),
                border_width: 2.0,
                shadow_offset: Vector::new(1.0, 1.0),
                text_color: Color::from_rgb8(0xEE, 0xEE, 0xEE),
                ..button::Style::default()
            },
        }
    }

    fn hovered(&self) -> button::Style {
        match self {
            Self::Enabled => button::Style {
                background: Some(Background::Color(Color::from_rgb(0.08, 0.61, 0.65))),
                text_color: Color::WHITE,
                shadow_offset: Vector::new(1.0, 2.0),
                ..self.active()
            },
            Self::Disabled => button::Style {
                background: Some(Background::Color(Color::from_rgb8(91, 110, 117))),
                text_color: Color::from_rgb8(0xEE, 0xEE, 0xEE),
                shadow_offset: Vector::new(1.0, 2.0),
                ..self.active()
            },
        }
    }
}

pub struct Content;
impl container::StyleSheet for Content {
    fn style(&self) -> container::Style {
        container::Style {
            background: Some(Background::Color(BACKGROUND_COLOR)),
            text_color: Some(Color::WHITE),
            ..container::Style::default()
        }
    }
}
