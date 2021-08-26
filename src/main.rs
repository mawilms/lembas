#![warn(clippy::all, clippy::pedantic)]
#![allow(clippy::too_many_lines)]
#![windows_subsystem = "windows"]

mod core;
mod gui;

use env_logger::Env;

fn main() {
    let env = Env::default().filter_or("RUST_LOG", "lembas=debug");
    env_logger::init_from_env(env);

    gui::views::Lembas::start();
}
