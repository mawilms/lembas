use std::{
    error::Error,
    path::{Path, PathBuf},
};

use globset::Glob;
use walkdir::WalkDir;

pub fn collect_all_compendium_files(
    plugins_directory: &Path,
) -> Result<Vec<PathBuf>, Box<dyn Error>> {
    let compendium_glob = Glob::new("*.plugincompendium")?.compile_matcher();

    let content: Vec<PathBuf> = WalkDir::new(&plugins_directory)
        .into_iter()
        .filter(|element| compendium_glob.is_match(element.as_ref().unwrap().path()))
        .map(|element| element.unwrap().into_path())
        .collect();

    Ok(content)
}

pub fn collect_all_plugin_files(plugins_directory: &Path) -> Result<Vec<PathBuf>, Box<dyn Error>> {
    let plugin_glob = Glob::new("*.plugin")?.compile_matcher();

    let content: Vec<PathBuf> = WalkDir::new(&plugins_directory)
        .into_iter()
        .filter(|element| plugin_glob.is_match(element.as_ref().unwrap().path()))
        .map(|element| element.unwrap().into_path())
        .collect();

    Ok(content)
}

#[cfg(test)]
mod tests {
    use super::*;
    use fs_extra::dir::{copy, CopyOptions};
    use std::{
        env,
        fs::{create_dir_all, read_dir, remove_dir_all},
        path::{Path, PathBuf},
    };
    use uuid::Uuid;

    fn setup() -> PathBuf {
        // Create plugins directory and move items from the samples to this directory to test functionality
        let uuid = Uuid::new_v4().to_string();
        let plugins_dir = env::temp_dir().join(format!("lembas_test_{}", &uuid[..7]));
        let samples_path = Path::new("tests/samples/plugin_folders");
        let samples_content = read_dir(samples_path).unwrap();

        create_dir_all(&plugins_dir).unwrap();
        let options = CopyOptions::new();

        for element in samples_content {
            copy(element.unwrap().path(), &plugins_dir, &options)
                .expect("Error while running setup method");
        }

        plugins_dir
    }

    fn teardown(test_dir: &Path) {
        remove_dir_all(test_dir).expect("Error while running teardown method");
    }

    #[test]
    fn collect_all_compendium_files_positive() {
        let test_dir = setup();

        let result = collect_all_compendium_files(&test_dir).unwrap();

        assert_eq!(result.len(), 6);

        teardown(&test_dir);
    }

    #[test]
    fn collect_all_plugin_files_positive() {
        let test_dir = setup();

        let result = collect_all_plugin_files(&test_dir).unwrap();

        assert_eq!(result.len(), 12);

        teardown(&test_dir);
    }
}
