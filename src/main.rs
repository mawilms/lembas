#![warn(clippy::all, clippy::pedantic)]
#![allow(clippy::too_many_lines)]
//#![windows_subsystem = "windows"]

mod core;
mod gui;

use chrono::Local;
use env_logger::Builder;
use std::io::Write;

fn main() {
    Builder::new()
        .format(|buf, record| {
            writeln!(
                buf,
                "{} [{}] - {}",
                Local::now().format("%Y-%m-%dT%H:%M:%S"),
                record.level(),
                record.args()
            )
        })
        .init();

    log::warn!("warn");
    log::info!("info");
    log::debug!("debug");

    gui::views::Lembas::start();
}
