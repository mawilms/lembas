#![warn(clippy::all, clippy::pedantic)]
mod core;
use std::env;

fn main() {
    let os = env::consts::OS;
    if os == "linux" {
        println!("Linux");
    } else if os == "windows" {
        println!("Windows");
    } else if os == "macos" {
        println!("Mac");
    }
}
