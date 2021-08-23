#![warn(clippy::all, clippy::pedantic)]
#![allow(clippy::too_many_lines)]
#![windows_subsystem = "windows"]


mod core;
mod gui;

use log::{debug, info, warn};

fn main() {
    env_logger::init();

    warn!("warn");
    info!("info");
    debug!("debug");

    gui::views::Lembas::start();
}
