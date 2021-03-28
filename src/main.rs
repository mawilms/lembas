#![warn(clippy::all, clippy::pedantic)]
mod core;
mod gui;

fn main() {
    let mut config = core::config::Config::default();
    config.get_settings();
    gui::main_window::MainWindow::start();
}
