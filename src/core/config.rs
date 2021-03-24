use std::fs;

/// Reads the given plugin.json that is basically the database to keep the user based information centralised
pub fn read_plugins() {
    let data = fs::read_to_string("plugins.json").unwrap();
    let json: serde_json::Value = serde_json::from_str(&data).unwrap();
    println!("{}", json);
}
