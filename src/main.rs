#![warn(clippy::all, clippy::pedantic)]
#![allow(clippy::too_many_lines)]
#![windows_subsystem = "windows"]

mod core;
mod gui;

use env_logger::Env;
use log::{debug, info, warn};

fn main() {
    let env = Env::default().filter_or("RUST_LOG", "lembas=debug");
    env_logger::init_from_env(env);

    warn!("warn");
    info!("info");
    debug!("debug");

    gui::views::Lembas::start();
}
