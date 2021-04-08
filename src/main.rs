#![warn(clippy::all, clippy::pedantic)]
#![allow(clippy::too_many_lines)]
mod core;
mod gui;

fn main() {
    gui::main_window::Lembas::start();
}
