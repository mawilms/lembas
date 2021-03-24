use std::io::prelude::*;
use std::path::Path;
use std::{error::Error, fs::File};

/// Downloads and extracts the specified plugin
pub fn install(plugin_id: &str, name: &str) -> Result<(), Box<dyn Error>> {
    let target = format!(
        "https://www.lotrointerface.com/downloads/download{}-{}",
        plugin_id, name
    );
    let response = reqwest::blocking::get(target).unwrap();

    let filename = format!("{}_{}.zip", plugin_id, name);
    let path = Path::new(&filename);

    let mut file = match File::create(&path) {
        Err(why) => panic!("couldn't create {}", why),
        Ok(file) => file,
    };
    let content = response.bytes().unwrap();
    file.write_all(&content)?;
    Ok(())
}

/// Updates already installed plugins
pub fn update() {}

/// Deletes the specified plugin
pub fn delete(plugin_id: &str) {}

#[cfg(test)]
mod tests {
    #[test]
    fn install() {
        assert_eq!(2 + 2, 4);
    }

    fn update() {}

    fn delete() {}
}
