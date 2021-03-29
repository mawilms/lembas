#![warn(clippy::all, clippy::pedantic)]
mod core;
mod gui;

fn main() {
    let mut config = core::config::Config::default();
    config.init_settings();
    let synchronizer = core::synchronizer::Synchronizer::new(config);
    let result = synchronizer.synchronize_plugins();
    //synchronizer.read_plugins();
    match result {
        Ok(_) => gui::main_window::MainWindow::start(),
        Err(error) => panic!("{}", error),
    }
}
