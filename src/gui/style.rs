use iced::{button, container, scrollable, Background, Color, Vector};

pub const BORDER_COLOR: Color = Color::from_rgb(0.54, 0.53, 0.31);
pub const BUTTON_COLOR_DEFAULT: Color = Color::from_rgb(0.60, 0.69, 0.32);
pub const BUTTON_COLOR_HOVER: Color = Color::from_rgb(0.54, 0.53, 0.31);
pub const BACKGROUND_COLOR: Color = Color::from_rgb(0.56, 0.32, 0.20);
pub const COLUMN_COLOR_PRIMARY: Color = Color::from_rgb(0.25, 0.18, 0.13);

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
                background: Some(Background::Color(BUTTON_COLOR_HOVER)),
                text_color: Color::WHITE,
                ..self.active()
            },
            Self::Disabled => button::Style {
                background: Some(Background::Color(Color::from_rgb8(91, 110, 117))),
                text_color: Color::from_rgb8(0xEE, 0xEE, 0xEE),
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

pub struct PluginRow;
impl container::StyleSheet for PluginRow {
    fn style(&self) -> container::Style {
        container::Style {
            background: Some(Background::Color(COLUMN_COLOR_PRIMARY)),
            text_color: Some(Color::WHITE),
            ..container::Style::default()
        }
    }
}

pub struct Scrollable;
impl scrollable::StyleSheet for Scrollable {
    fn active(&self) -> scrollable::Scrollbar {
        scrollable::Scrollbar {
            background: Some(Background::Color(Color::TRANSPARENT)),
            border_radius: 0.0,
            border_width: 0.0,
            border_color: Color::TRANSPARENT,
            scroller: scrollable::Scroller {
                color: Color::from_rgb(0.85, 0.71, 0.49),
                border_radius: 2.0,
                border_width: 0.0,
                border_color: Color::TRANSPARENT,
            },
        }
    }

    fn hovered(&self) -> scrollable::Scrollbar {
        let active = self.active();

        scrollable::Scrollbar {
            scroller: scrollable::Scroller { ..active.scroller },
            ..active
        }
    }

    fn dragging(&self) -> scrollable::Scrollbar {
        let hovered = self.hovered();
        scrollable::Scrollbar {
            scroller: scrollable::Scroller { ..hovered.scroller },
            ..hovered
        }
    }
}

pub enum InstallButton {
    Enabled,
    Disabled,
}

impl button::StyleSheet for InstallButton {
    fn active(&self) -> button::Style {
        match self {
            Self::Enabled => button::Style {
                background: Some(Background::Color(Color::TRANSPARENT)),
                text_color: BUTTON_COLOR_DEFAULT,
                ..button::Style::default()
            },
            Self::Disabled => button::Style {
                background: Some(Background::Color(Color::TRANSPARENT)),
                text_color: BACKGROUND_COLOR,
                ..button::Style::default()
            },
        }
    }

    fn hovered(&self) -> button::Style {
        match self {
            Self::Enabled => button::Style { ..self.active() },
            Self::Disabled => button::Style { ..self.active() },
        }
    }
}
