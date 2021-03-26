#![warn(clippy::all, clippy::pedantic)]
mod core;

fn main() {
    let mut config = core::config::Config::default();
    config.get_settings();
}
