package internal

import "maps"

import "fmt"

type ParentAddon struct {
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

func MergeAddons(installed, remote map[string]ParentAddon) map[string]ParentAddon {
	merged := make(map[string]ParentAddon, len(remote))

	maps.Copy(merged, remote)

	for key, localAddon := range installed {
		if remoteAddon, exists := merged[key]; exists {
			remoteAddon.IsInstalled = true
			remoteAddon.HasUpdate = remoteAddon.Version != localAddon.Version
			merged[key] = remoteAddon
		} else {
			localAddon.IsInstalled = true
			localAddon.HasUpdate = false
			merged[key] = localAddon
		}
	}

	return merged
}
