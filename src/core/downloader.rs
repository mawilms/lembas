use std::io::prelude::*;
use std::path::Path;
use std::{error::Error, fs::File};

#[derive(Default)]
pub struct Downloader {}

impl Downloader {
    pub fn install() -> Result<(), Box<dyn Error>> {
        let target = "https://www.lotrointerface.com/downloads/download1125-Voyage";
        let response = reqwest::blocking::get(target).unwrap();

        let path = Path::new("./download.zip");

        let mut file = match File::create(&path) {
            Err(why) => panic!("couldn't create {}", why),
            Ok(file) => file,
        };
        let content = response.bytes().unwrap();
        file.write_all(&content)?;
        Ok(())
    }
}
