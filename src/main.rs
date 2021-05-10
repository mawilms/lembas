#![warn(clippy::all, clippy::pedantic)]
#![allow(clippy::too_many_lines)]
#![windows_subsystem = "windows"]

mod core;
mod gui;

fn main() {
    gui::views::Lembas::start();
}
