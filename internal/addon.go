package internal

import "maps"

import "fmt"

type Addon struct {
	Id          int
	Type        string
	Name        string
	Author      string
	Description string
	Version     string
	Category    string
	Downloads   int
	UpdatedAt   string
	ArchiveName string
	ArchiveSize string
	HasUpdate   bool
	IsInstalled bool
}

func FormatArchiveSize(bytes int64) string {
	kb := bytes / 1000
	if kb > 1000 {
		return fmt.Sprintf("%v MB", kb/1000)
	}
	return fmt.Sprintf("%v KB", kb)
}

func UpdateVersions(installed, remote map[string]Addon) map[string]Addon {
	mergedAddons := make(map[string]Addon, len(remote))

	maps.Copy(mergedAddons, remote)

	for key, localAddon := range installed {
		if remoteAddon, exists := mergedAddons[key]; exists {
			remoteAddon.IsInstalled = true
			remoteAddon.HasUpdate = remoteAddon.Version != localAddon.Version
			mergedAddons[key] = remoteAddon
		}
	}

	return mergedAddons
}
