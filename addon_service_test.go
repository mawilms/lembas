package main

import (
	"maps"
	"testing"

	"github.com/mawilms/lembas/internal"
)

type MockAddonModel struct{}

func (p *MockAddonModel) Get() ([]internal.Row, error) {
	return []internal.Row{
		{
			Id:               12345,
			Name:             "WhereToPlay",
			Author:           "Dean",
			Version:          "1.2.3",
			Description:      "Hello World",
			IsManaged:        true,
			Plugin:           "WhereToPlay.plugin",
			PluginCompendium: "WhereToPlay.plugincompendium",
			RootFolder:       "WhereToPlay",
			PluginFolder:     "WhereToPlay",
			Downloads:        2534,
			UpdatedAt:        "07/27/2026",
			ArchiveName:      "WhereToPlay.zip",
			ArchiveSize:      "5 MB",
			Category:         "Others",
		},
	}, nil
}

func TestGetLocalAddons(t *testing.T) {
	app := App{
		pluginModel: &MockAddonModel{},
	}

	got := app.GetLocalAddons()

	expected := map[string]internal.Addon{
		"WhereToPlay_Dean": {
			Id:          12345,
			Type:        "local",
			Name:        "WhereToPlay",
			Author:      "Dean",
			Description: "Hello World",
			Version:     "1.2.3",
			Category:    "Others",
			Downloads:   2534,
			UpdatedAt:   "07/27/2026",
			ArchiveName: "WhereToPlay.zip",
			ArchiveSize: "5 MB",
			HasUpdate:   false,
			IsInstalled: true,
		},
	}

	if maps.Equal(got, expected) != true {
		t.Errorf("Result is invalid. Got %v, expected %v", got, expected)
	}
}
