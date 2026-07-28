package internal

import (
	"maps"
	"regexp"
	"strconv"
	"strings"
)

import "fmt"

var leadingDigits = regexp.MustCompile(`^\d+`)

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
			remoteAddon.HasUpdate = hasUpdate(localAddon, remoteAddon)
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

// hasUpdate reports whether remote has a newer version than local.
func hasUpdate(local, remote Addon) bool {
	return compareVersions(remote.Version, local.Version) > 0
}
