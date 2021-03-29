#![warn(clippy::all, clippy::pedantic)]
mod core;
mod gui;

fn main() {
    let mut config = core::config::Config::default();
    config.get_settings();
    let synchronizer = core::synchronizer::Synchronizer::new(config);
    let result = synchronizer.synchronize_plugins();
    // gui::main_window::MainWindow::start();
}
