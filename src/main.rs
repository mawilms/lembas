#![warn(clippy::all, clippy::pedantic)]
#![allow(clippy::too_many_lines)]
//#![windows_subsystem = "windows"]

mod core;
mod gui;

//use std::fs::File;

fn main() {
    gui::views::Lembas::start();

    // let file = File::open("./tests/samples/archives/VoyageV3.13.zip").unwrap();
    // let mut zip_archive = zip::ZipArchive::new(file).unwrap();

    // // let item = zip_archive.by_index(0).unwrap();
    // // println!("{:?}", item.name());

    // for element in zip_archive.file_names() {
    //     println!("{}", element);
    // }
}
