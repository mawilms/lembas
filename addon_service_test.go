package main

import (
	"reflect"
	"testing"

	"github.com/mawilms/lembas/internal"
)

type MockDatabaseModel struct{}

func (m *MockDatabaseModel) SetupDb() error {
	return nil
}

func (m *MockDatabaseModel) Get() ([]internal.Addon, error) {
	return []internal.Addon{
		{
			Id:             12345,
			Type:           "local",
			Name:           "WhereToPlay",
			Author:         "Dean",
			Description:    "Hello World",
			CurrentVersion: "1.2.3",
			LatestVersion:  "1.2.3",
			Category:       "Others",
			Downloads:      2534,
			UpdatedAt:      "07/27/2026",
			ArchiveName:    "WhereToPlay.zip",
			ArchiveSize:    "5 MB",
			HasUpdate:      false,
			IsInstalled:    true,
		},
	}, nil
}

func (m *MockDatabaseModel) Insert(addon internal.Addon, info internal.ArchiveInfo) error {
	return nil
}

func TestGetLocalAddons(t *testing.T) {
	app := App{
		addonModel:   &MockDatabaseModel{},
		localAddons:  make(map[int]internal.Addon),
		remoteAddons: make(map[int]internal.Addon),
		settings:     &internal.Settings{DataDirectory: ""},
	}

	got := app.GetLocalAddons(false)

	expected := AddonMap{
		LocalAddons: map[int]internal.Addon{
			12345: {
				Id:             12345,
				Type:           "local",
				Name:           "WhereToPlay",
				Author:         "Dean",
				Description:    "Hello World",
				CurrentVersion: "1.2.3",
				LatestVersion:  "1.2.3",
				Category:       "Others",
				Downloads:      2534,
				UpdatedAt:      "07/27/2026",
				ArchiveName:    "WhereToPlay.zip",
				ArchiveSize:    "5 MB",
				HasUpdate:      false,
				IsInstalled:    true,
			},
		},
		RemoteAddons: make(map[int]internal.Addon),
	}

	if !reflect.DeepEqual(got, expected) {
		t.Errorf("unable to fetch local addons. Got %v, expected %v", got, expected)
	}
}

func TestGetRemoteAddons(t *testing.T) {
	app := App{
		addonModel:   &MockDatabaseModel{},
		localAddons:  make(map[int]internal.Addon),
		remoteAddons: make(map[int]internal.Addon),
		settings:     &internal.Settings{DataDirectory: ""},
	}

	got := app.GetRemoteAddons(false)

	expected := AddonMap{
		LocalAddons: map[int]internal.Addon{
			12345: {
				Id:             12345,
				Type:           "local",
				Name:           "WhereToPlay",
				Author:         "Dean",
				Description:    "Hello World",
				CurrentVersion: "1.2.3",
				LatestVersion:  "",
				Category:       "Others",
				Downloads:      2534,
				UpdatedAt:      "07/27/2026",
				ArchiveName:    "WhereToPlay.zip",
				ArchiveSize:    "5 MB",
				HasUpdate:      false,
				IsInstalled:    true,
			},
		},
		RemoteAddons: map[int]internal.Addon{
			12345: {
				Id:             12345,
				Type:           "local",
				Name:           "WhereToPlay",
				Author:         "Dean",
				Description:    "Hello World",
				CurrentVersion: "1.2.3",
				LatestVersion:  "1.2.4",
				Category:       "Others",
				Downloads:      2534,
				UpdatedAt:      "07/27/2026",
				ArchiveName:    "WhereToPlay.zip",
				ArchiveSize:    "5 MB",
				HasUpdate:      false,
				IsInstalled:    true,
			},
		},
	}

	if !reflect.DeepEqual(got, expected) {
		t.Errorf("unable to fetch local addons. Got %v, expected %v", got, expected)
	}
}
