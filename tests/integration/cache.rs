#[cfg(test)]
mod tests {
    use lembas::core::{io::cache::DatabaseHandler, lotro_compendium::Plugin};

    use crate::database_fixtures;

    #[test]
    fn insert_plugin() {
        let (cache, test_dir) = database_fixtures::setup();

        let data_class = Plugin::new("PetStable")
            .with_id(1)
            .with_author("Marius")
            .with_current_version("0.1.0")
            .with_description("Lorem ipsum")
            .build();
        cache.insert_plugin(&data_class, 0).unwrap();

        database_fixtures::teardown(cache, test_dir);
    }

    #[test]
    fn test_delete_plugin() {
        let (cache, test_dir) = database_fixtures::setup_with_items();

        cache.delete_plugin("PetStable").unwrap();

        database_fixtures::teardown(cache, test_dir);
    }

    #[test]
    fn get_one_plugin() {
        let (cache, test_dir) = database_fixtures::setup_with_items();

        let plugin = cache.get_plugin("PetStable").unwrap().unwrap();

        assert_eq!(plugin.name, "PetStable");

        database_fixtures::teardown(cache, test_dir);
    }

    #[test]
    fn test_get_plugins() {
        let (cache, test_dir) = database_fixtures::setup_with_items();

        let plugins = cache.get_plugins();

        assert_eq!(plugins.keys().len(), 2);
        assert!(plugins.contains_key("PetStable"));
        assert!(plugins.contains_key("Hello World"));

        database_fixtures::teardown(cache, test_dir);
    }
}
