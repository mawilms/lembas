#![warn(clippy::all, clippy::pedantic)]
use crate::core::config::CONFIGURATION;
mod core;
mod gui;

// To setup the global config settings consider using https://doc.rust-lang.org/std/macro.env.html for builda rguments or a static + Mutex struct for global variables

fn main() {
    gui::main_window::MainWindow::start();
}
