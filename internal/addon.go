package internal

import (
	"regexp"
	"strconv"
	"strings"
)

var leadingDigits = regexp.MustCompile(`^\d+`)

type Addon struct {
	Id          int    `json:"id"`
	Type        string `json:"type"`
	Name        string `json:"name"`
	Author      string `json:"author"`
	Description string `json:"description"`
	Version     string `json:"version"`
	Category    string `json:"category"`
	Downloads   int    `json:"downloads"`
	UpdatedAt   string `json:"updatedAt"`
	ArchiveName string `json:"archiveName"`
	ArchiveSize string `json:"archiveSize"`
	HasUpdate   bool   `json:"hasUpdate"`
	IsInstalled bool   `json:"isInstalled"`
}

func UpdateLocalAddons(mergedAddons map[int]Addon) map[int]Addon {
	updatedAddons := make(map[int]Addon)

	for _, addon := range mergedAddons {
		if addon.IsInstalled {
			addon.Type = "local"
			updatedAddons[addon.Id] = addon
		}
	}

	return updatedAddons
}

func UpdateVersions(localAddons, remoteAddons map[int]Addon) map[int]Addon {
	mergedAddons := make(map[int]Addon, len(remoteAddons))

	for key, remoteAddon := range remoteAddons {
		remoteAddon.IsInstalled = false
		mergedAddons[key] = remoteAddon
	}

	for key, localAddon := range localAddons {
		if remoteAddon, exists := mergedAddons[key]; exists {
			remoteAddon.IsInstalled = true
			remoteAddon.HasUpdate = HasUpdate(localAddon, remoteAddon)
			remoteAddon.Version = localAddon.Version
			mergedAddons[key] = remoteAddon
		}
	}

	return mergedAddons
}

func normalizeVersion(version string) []int {
	trimmed := strings.TrimPrefix(strings.TrimSpace(version), "v")
	trimmed = strings.TrimPrefix(trimmed, "V")
	parts := strings.Split(trimmed, ".")

	normalized := make([]int, 0, len(parts))
	for _, part := range parts {
		digits := leadingDigits.FindString(strings.TrimSpace(part))
		if digits == "" {
			continue
		}

		number, err := strconv.Atoi(digits)
		if err != nil {
			continue
		}

		normalized = append(normalized, number)
	}

	return normalized
}

func versionSuffix(version string) string {
	trimmed := strings.TrimPrefix(strings.TrimSpace(version), "v")
	trimmed = strings.TrimPrefix(trimmed, "V")
	parts := strings.Split(trimmed, ".")

	last := strings.TrimSpace(parts[len(parts)-1])
	digits := leadingDigits.FindString(last)

	return strings.TrimSpace(strings.TrimPrefix(last, digits))
}

func compareVersions(remoteVersion, localVersion string) int {
	normRemote := normalizeVersion(remoteVersion)
	normLocal := normalizeVersion(localVersion)

	length := max(len(normLocal), len(normRemote))

	for i := range length {
		var versionRemote, versionLocal int
		if i < len(normRemote) {
			versionRemote = normRemote[i]
		}
		if i < len(normLocal) {
			versionLocal = normLocal[i]
		}

		switch {
		case versionRemote > versionLocal:
			return 1
		case versionRemote < versionLocal:
			return -1
		}
	}

	suffixRemote := versionSuffix(remoteVersion)
	suffixLocal := versionSuffix(localVersion)

	switch {
	case suffixRemote > suffixLocal:
		return 1
	case suffixRemote < suffixLocal:
		return -1
	}

	return 0
}

func HasUpdate(local, remote Addon) bool {
	return compareVersions(remote.Version, local.Version) > 0
}
