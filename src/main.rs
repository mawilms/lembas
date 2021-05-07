#![warn(clippy::all, clippy::pedantic)]
#![allow(clippy::too_many_lines)]
#![windows_subsystem = "windows"]

mod core;
mod gui;

// TODO: SCrolling Combat Text plugin: Beschreibung parsen funktioniert bspw. noch nicht richtig
// TODO: Plugins Anzeige in Echtzeit aktualsieren
fn main() {
    gui::views::Lembas::start();
}
