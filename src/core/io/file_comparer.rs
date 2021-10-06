use std::{
    collections::HashSet,
    path::{Path, PathBuf},
};

use itertools::Itertools;

pub fn compare_files(compendium_files: &[PathBuf], plugin_files: &[PathBuf]) -> Vec<PathBuf> {
    let compendium = compendium_files
        .iter()
        .map(|element| extract_file_stem(element))
        .collect::<HashSet<&str>>();

    plugin_files
        .iter()
        .cloned()
        .filter(|plugin_file| {
            let splitted_plugin_file_name = extract_file_stem(plugin_file).to_string();
            for comp in &compendium {
                if splitted_plugin_file_name.starts_with(comp) {
                    return false;
                }
            }
            true
        })
        .unique()
        .collect()
}

fn extract_file_stem(file_name: &Path) -> &str {
    file_name.file_stem().unwrap().to_str().unwrap()
}

#[cfg(test)]
mod tests {
    use super::*;

    mod compare_files_tests {
        use super::*;

        #[test]
        fn positive() {
            let compendium_files = vec![
                Path::new("Bunny/AltWallet/AltWallet.plugincompendium").to_path_buf(),
                Path::new("HabnaPlugins/HugeBag.plugincompendium").to_path_buf(),
                Path::new("HabnaPlugins/TitanBar.plugincompendium").to_path_buf(),
                Path::new("Homeopatix/Animalerie.plugincompendium").to_path_buf(),
                Path::new("Homeopatix/BurglarHelper.plugincompendium").to_path_buf(),
                Path::new("Homeopatix/Voyage.plugincompendium").to_path_buf(),
            ];

            let plugin_files = vec![
                Path::new("HabnaPlugins/CraftTimer.plugin").to_path_buf(),
                Path::new("HabnaPlugins/HugeBagReloader.plugin").to_path_buf(),
                Path::new("HabnaPlugins/HugeBagUnloader.plugin").to_path_buf(),
                Path::new("HabnaPlugins/HugeBagUtility.plugin").to_path_buf(),
                Path::new("HabnaPlugins/TitanBarReloader.plugin").to_path_buf(),
                Path::new("HabnaPlugins/TitanBarUnloader.plugin").to_path_buf(),
            ];

            let result = compare_files(&compendium_files, &plugin_files);

            assert_eq!(result.len(), 1);
            assert_eq!(
                result,
                vec![Path::new("HabnaPlugins/CraftTimer.plugin").to_path_buf()]
            );
        }
    }
}
