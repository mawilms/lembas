#![warn(clippy::all, clippy::pedantic)]
mod core;
mod gui;

fn main() {
    gui::main_window::Lembas::start();
}
