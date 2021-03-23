#![warn(clippy::all, clippy::pedantic)]
mod core;

fn main() {
    core::downloader::Downloader::install().unwrap();
}
