pub mod database_fixtures {
    use lembas::core::{
        io::{cache::DatabaseHandler, Cache},
        lotro_compendium::Plugin,
    };
    use r2d2_sqlite::SqliteConnectionManager;
    use std::{
        env,
        fs::{create_dir_all, remove_dir_all},
        path::PathBuf,
    };
    use uuid::Uuid;

    pub fn setup() -> (Cache, PathBuf) {
        let uuid = Uuid::new_v4().to_string();
        let test_dir = env::temp_dir().join(format!("lembas_test_{}", &uuid[..7]));
        let db_path = test_dir.join("db.sqlite3");

        create_dir_all(&test_dir).unwrap();

        let manager = SqliteConnectionManager::file(&db_path);
        let pool = r2d2::Pool::new(manager).expect("Error while creating a database pool");

        let cache = Cache::new(pool);
        cache
            .create_cache_db()
            .expect("Failed to create a temporary db");

        (cache, test_dir)
    }

    pub fn setup_with_items() -> (Cache, PathBuf) {
        let uuid = Uuid::new_v4().to_string();
        let test_dir = env::temp_dir().join(format!("lembas_test_{}", &uuid[..7]));
        let db_path = test_dir.join("db.sqlite3");

        create_dir_all(&test_dir).expect("Error while running test setup");

        let manager = SqliteConnectionManager::file(&db_path);
        let pool = r2d2::Pool::new(manager).expect("Error while creating a database pool");

        let cache = Cache::new(pool);
        cache
            .create_cache_db()
            .expect("Failed to create a temporary db");

        let data_class = Plugin::new("Hello World")
            .with_id(1)
            .with_author("Marius")
            .with_current_version("0.1.0")
            .with_description("Lorem ipsum")
            .build();
        cache
            .insert_plugin(&data_class, 0)
            .expect("Error while running test setup");

        let data_class = Plugin::new("PetStable")
            .with_author("Marius")
            .with_current_version("0.1.0")
            .with_id(2)
            .with_description("Lorem ipsum")
            .with_remote_information("", "1.1", 0, "", 0, "")
            .build();
        cache
            .insert_plugin(&data_class, 1)
            .expect("Error while running test setup");

        (cache, test_dir)
    }

    pub fn teardown(cache: Cache, test_dir: PathBuf) {
        drop(cache);
        remove_dir_all(test_dir).expect("Error while running test teardown");
    }
}

pub mod installer_fixtures {
    use std::{env, fs::create_dir_all, path::PathBuf};

    use lembas::core::Installer;
    use uuid::Uuid;

    pub fn setup_dirs() -> PathBuf {
        let uuid = Uuid::new_v4().to_string();
        let test_dir = env::temp_dir().join(format!("lembas_test_{}", &uuid[..7]));

        create_dir_all(&test_dir).unwrap();

        test_dir
    }

    pub fn installer_fixture() -> Installer {
        let test_dir = self::setup_dirs();
        let tmp_dir = test_dir.join("tmp");
        let plugins_dir = test_dir.join("plugins");
        create_dir_all(&tmp_dir).unwrap();
        create_dir_all(&plugins_dir).unwrap();

        Installer::new(&tmp_dir, &plugins_dir, 1, "Hello World")
    }
}
