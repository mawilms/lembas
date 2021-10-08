#![warn(clippy::all, clippy::pedantic)]
#![allow(clippy::too_many_lines, clippy::module_name_repetitions)]

mod core;
mod gui;

use env_logger::Env;

fn main() {
    let env = Env::default().filter_or("RUST_LOG", "lembas=debug");
    env_logger::init_from_env(env);

    gui::views::Lembas::start();
}
