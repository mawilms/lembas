#![warn(clippy::all, clippy::pedantic)]
mod gui;

use crate::gui::main_window::MainWindow;

pub fn main() {
    MainWindow::start();
}