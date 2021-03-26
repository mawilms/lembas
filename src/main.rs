#![warn(clippy::all, clippy::pedantic)]
mod core;

fn main() {
    core::config::initialize_plugin_folder();
    core::installer::install("1125", "Voyage");
}
