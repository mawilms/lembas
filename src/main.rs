#![warn(clippy::all, clippy::pedantic)]
mod core;

fn main() {
    core::config::read_plugins();
}
