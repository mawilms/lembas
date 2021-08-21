use rusqlite::{params, Connection, Statement};
use std::{collections::HashMap, error::Error};

#[derive(Debug, Clone)]
pub struct CacheItem {
    pub id: i32,
    pub title: String,
    pub description: String,
    pub current_version: String,
    pub latest_version: String,
    pub download_url: String,
}

impl CacheItem {
    pub fn new(
        id: i32,
        title: &str,
        description: &str,
        current_version: &str,
        latest_version: &str,
        download_url: &str,
    ) -> Self {
        CacheItem {
            id,
            title: title.to_string(),
            description: description.to_string(),
            current_version: current_version.to_string(),
            latest_version: latest_version.to_string(),
            download_url: download_url.to_string(),
        }
    }
}

pub fn create_cache_db(db_file: &str) {
    let conn = Connection::open(db_file).unwrap();
    conn.execute(
        "
            CREATE TABLE IF NOT EXISTS plugin (
                id INTEGER PRIMARY KEY,
                plugin_id INTEGER UNIQUE,
                title TEXT,
                description TEXT,
                current_version TEXT,
                latest_version TEXT,
                download_url TEXT
            );
    ",
        [],
    )
    .unwrap();
}

pub fn insert_plugin(cache_item: &CacheItem, db_file: &str) -> Result<(), Box<dyn Error>> {
    let conn = Connection::open(db_file)?;

    conn.execute(
        "INSERT INTO plugin (plugin_id, title, description, current_version, latest_version, download_url) VALUES (?1, ?2, ?3, ?4, ?5, ?6) ON CONFLICT (plugin_id) DO UPDATE SET plugin_id=?1, title=?2, description=?3, current_version=?4, latest_version=?5, download_url=?6;",
    params![cache_item.id, cache_item.title, cache_item.description, cache_item.latest_version, cache_item.latest_version, cache_item.download_url])?;

    Ok(())
}

pub fn update_plugin(plugin_id: i32, version: &str, db_file: &str) -> Result<(), Box<dyn Error>> {
    let conn = Connection::open(db_file)?;
    conn.execute(
        "UPDATE plugin SET latest_version=?2 WHERE plugin_id=?1;",
        params![plugin_id, version],
    )?;
    Ok(())
}

pub fn delete_plugin(plugin_id: i32, db_file: &str) -> Result<(), Box<dyn Error>> {
    let conn = Connection::open(db_file)?;
    conn.execute("DELETE FROM plugin WHERE plugin_id=?1;", params![plugin_id])?;
    Ok(())
}

fn execute_stmt(stmt: &mut Statement, params: &str) -> Vec<CacheItem> {
    let mut all_plugins = Vec::new();

    let empty_params = params![];
    let has_params = params![params];
    let mut query_params = empty_params;

    if !params.is_empty() {
        query_params = has_params;
    }

    let plugin_iter = stmt
        .query_map(query_params, |row| {
            Ok(CacheItem {
                id: row.get(0).unwrap(),
                title: row.get(1).unwrap(),
                description: row.get(2).unwrap(),
                current_version: row.get(3).unwrap(),
                latest_version: row.get(4).unwrap(),
                download_url: row.get(5).unwrap(),
            })
        })
        .unwrap();

    for plugin in plugin_iter {
        all_plugins.push(plugin.unwrap());
    }
    all_plugins
}

pub fn get_plugins(db_file: &str) -> HashMap<String, CacheItem> {
    let mut plugins = HashMap::new();

    let conn = Connection::open(db_file).unwrap();
    let mut stmt = conn
        .prepare("SELECT plugin_id, title, description, category, current_version, latest_version, download_url FROM plugin ORDER BY title;")
        .unwrap();

    for element in execute_stmt(&mut stmt, "") {
        plugins.insert(element.title.clone(), element);
    }
    plugins
}

#[cfg(test)]
mod tests {}
