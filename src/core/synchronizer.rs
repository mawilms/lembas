use serde::{Deserialize, Serialize};

pub struct Synchronizer {}

impl Synchronizer {
    pub fn synchronize_plugins() -> Result<(), Box<dyn std::error::Error>> {
        let response =
            reqwest::blocking::get("http://localhost:8000/plugins")?.json::<Vec<Package>>()?;
        println!("{:?}", response);
        Ok(())
    }
}

#[derive(Serialize, Deserialize, Debug)]
struct Package {
    plugin_id: i32,
    title: String,
}
