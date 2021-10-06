const BLACKLIST: [&str; 3] = ["Demo", "AutoLoader", "Examples"];

pub fn is_not_existing_in_blacklist(plugin_name: &str) -> bool {
    for element in BLACKLIST {
        if plugin_name.contains(element) {
            return false;
        }
    }
    true
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn not_existing_in_blacklist_positive() {
        let result = is_not_existing_in_blacklist("TitanBar");
        assert!(result);
    }

    #[test]
    fn not_existing_in_blacklist_negative() {
        let result = is_not_existing_in_blacklist("DragBarDemoTwo");
        assert!(!result);
    }
}
