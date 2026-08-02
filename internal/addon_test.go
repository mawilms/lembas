package internal

import (
	"reflect"
	"testing"
)

func TestNormalizeVersion(t *testing.T) {
	tests := []struct {
		name    string
		version string
		want    []int
	}{
		{"two components", "1.3", []int{1, 3}},
		{"plain", "1.3.0", []int{1, 3, 0}},
		{"letter directly after digit", "1.0a", []int{1, 0}},
		{"v-prefix", "v1.3.0", []int{1, 3, 0}},
		{"trailing v", "1.3.0v", []int{1, 3, 0}},
		{"v-prefix and trailing v", "v1.3.0v", []int{1, 3, 0}},
		{"v-prefix and trailing letter", "v1.3.0a", []int{1, 3, 0}},
		{"trailing space and letter", "1.3.0 a", []int{1, 3, 0}},
		{"trailing word", "5.9.0 beta", []int{5, 9, 0}},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := normalizeVersion(tt.version)
			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("normalizeVersion(%q) = %v, want %v", tt.version, got, tt.want)
			}
		})
	}
}

func TestCompareVersions(t *testing.T) {
	tests := []struct {
		name   string
		remote string
		local  string
		want   int
	}{
		{"remote patch newer", "v1.3.1", "v1.3.0", 1},
		{"remote patch older", "v1.3.0", "v1.3.1", -1},
		{"recognize suffix", "1.3.0 b", "1.3.0 a", 1},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := compareVersions(tt.remote, tt.local)
			if got != tt.want {
				t.Errorf("compareVersions(%q, %q) = %d, want %d", tt.remote, tt.local, got, tt.want)
			}
		})
	}
}

func TestHasUpdate(t *testing.T) {
	tests := []struct {
		name   string
		local  Addon
		remote Addon
		want   bool
	}{
		{"remote is newer", Addon{CurrentVersion: "v1.3.0"}, Addon{CurrentVersion: "v1.3.1"}, true},
		{"remote is older", Addon{CurrentVersion: "v1.3.1"}, Addon{CurrentVersion: "v1.3.0"}, false},
		{"versions are equal", Addon{CurrentVersion: "v1.3.0"}, Addon{CurrentVersion: "v1.3.0"}, false},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := hasUpdate(tt.local, tt.remote)
			if got != tt.want {
				t.Errorf("hasUpdate(%+v, %+v) = %v, want %v", tt.local, tt.remote, got, tt.want)
			}
		})
	}
}

func TestVersionSuffix(t *testing.T) {
	tests := []struct {
		name    string
		version string
		want    string
	}{
		{"no suffix", "1.3.0", ""},
		{"letter directly after digit", "1.3.0b", "b"},
		{"letter after space", "1.3.0 a", "a"},
		{"word after space", "5.9.0 beta", "beta"},
		{"v-prefix ignored, suffix kept", "v1.3.0a", "a"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			got := versionSuffix(tt.version)
			if got != tt.want {
				t.Errorf("versionSuffix(%q) = %q, want %q", tt.version, got, tt.want)
			}
		})
	}
}

func TestUpdateVersions(t *testing.T) {
	localAddons := map[int]Addon{
		1138: {
			Id:             1138,
			Type:           "local",
			Name:           "WhereToPlay",
			Author:         "homeopatix",
			Description:    "hello world",
			CurrentVersion: "1.33",
			LatestVersion:  "",
			Category:       "Others",
			Downloads:      154896,
			UpdatedAt:      "07/28/2026",
			ArchiveName:    "WhereToPlayV1.34.zip",
			ArchiveSize:    "5 MB",
			HasUpdate:      false,
			IsInstalled:    true,
		},
	}

	remoteAddons := map[int]Addon{
		1138: {
			Id:             1138,
			Type:           "remote",
			Name:           "WhereToPlay",
			Author:         "homeopatix",
			Description:    "hello world",
			CurrentVersion: "1.34",
			LatestVersion:  "1.34",
			Category:       "Others",
			Downloads:      154896,
			UpdatedAt:      "07/28/2026",
			ArchiveName:    "WhereToPlayV1.34.zip",
			ArchiveSize:    "5 MB",
			HasUpdate:      false,
			IsInstalled:    false,
		},
		1238: {
			Id:             1238,
			Type:           "remote",
			Name:           "Fishing Lot",
			Author:         "Vinny",
			Description:    "hello world",
			CurrentVersion: "1.3",
			LatestVersion:  "1.3",
			Category:       "Others",
			Downloads:      564,
			UpdatedAt:      "05/25/2026",
			ArchiveName:    "FishingLog_1.3.zip",
			ArchiveSize:    "125 KB",
			HasUpdate:      false,
			IsInstalled:    false,
		},
	}

	expected := map[int]Addon{
		1138: {
			Id:             1138,
			Type:           "remote",
			Name:           "WhereToPlay",
			Author:         "homeopatix",
			Description:    "hello world",
			CurrentVersion: "1.33",
			LatestVersion:  "1.34",
			Category:       "Others",
			Downloads:      154896,
			UpdatedAt:      "07/28/2026",
			ArchiveName:    "WhereToPlayV1.34.zip",
			ArchiveSize:    "5 MB",
			HasUpdate:      true,
			IsInstalled:    true,
		},
		1238: {
			Id:             1238,
			Type:           "remote",
			Name:           "Fishing Lot",
			Author:         "Vinny",
			Description:    "hello world",
			CurrentVersion: "1.3",
			LatestVersion:  "1.3",
			Category:       "Others",
			Downloads:      564,
			UpdatedAt:      "05/25/2026",
			ArchiveName:    "FishingLog_1.3.zip",
			ArchiveSize:    "125 KB",
			HasUpdate:      false,
			IsInstalled:    false,
		},
	}

	got := UpdateVersions(localAddons, remoteAddons)
	if !reflect.DeepEqual(got, expected) {
		t.Fatalf("version comparison has failed; got %v, expected %v", got, expected)
	}
}

func TestUpdateLocalAddons(t *testing.T) {
	mergedAddons := map[int]Addon{
		1138: {
			Id:             1138,
			Type:           "local",
			Name:           "WhereToPlay",
			Author:         "homeopatix",
			Description:    "hello world",
			CurrentVersion: "1.33",
			LatestVersion:  "1.34",
			Category:       "Others",
			Downloads:      154896,
			UpdatedAt:      "07/28/2026",
			ArchiveName:    "WhereToPlayV1.34.zip",
			ArchiveSize:    "5 MB",
			HasUpdate:      true,
			IsInstalled:    true,
		},
		1238: {
			Id:             1238,
			Type:           "local",
			Name:           "Fishing Lot",
			Author:         "Vinny",
			Description:    "hello world",
			CurrentVersion: "1.3",
			LatestVersion:  "1.3",
			Category:       "Others",
			Downloads:      564,
			UpdatedAt:      "05/25/2026",
			ArchiveName:    "FishingLog_1.3.zip",
			ArchiveSize:    "125 KB",
			HasUpdate:      false,
			IsInstalled:    false,
		},
	}

	expected := map[int]Addon{
		1138: {
			Id:             1138,
			Type:           "local",
			Name:           "WhereToPlay",
			Author:         "homeopatix",
			Description:    "hello world",
			CurrentVersion: "1.33",
			LatestVersion:  "1.34",
			Category:       "Others",
			Downloads:      154896,
			UpdatedAt:      "07/28/2026",
			ArchiveName:    "WhereToPlayV1.34.zip",
			ArchiveSize:    "5 MB",
			HasUpdate:      true,
			IsInstalled:    true,
		},
	}

	got := UpdateLocalAddons(mergedAddons)
	if !reflect.DeepEqual(got, expected) {
		t.Fatalf("Couldn't remove remote only addons: got %v, expected %v", got, expected)
	}
}
