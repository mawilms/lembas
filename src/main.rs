#![warn(clippy::all, clippy::pedantic)]
use std::env;

fn main() {
    println!("{}", env::consts::OS);
}
