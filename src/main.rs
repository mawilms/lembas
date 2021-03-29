#![warn(clippy::all, clippy::pedantic)]
mod core;
mod gui;

fn main() {
    let mut config = core::config::Config::default();
    config.get_settings();
    println!("{}", config.settings);
    let result = core::synchronizer::Synchronizer::synchronize_plugins();
    println!("{:?}", result);
    // gui::main_window::MainWindow::start();
}
