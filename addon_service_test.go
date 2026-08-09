package main

import (
	"reflect"
	"testing"

	"github.com/mawilms/lembas/internal"
)

type MockDatabaseModel struct{}

func (m *MockDatabaseModel) Delete(id int) error {
	//TODO implement me
	panic("implement me")
}

func (m *MockDatabaseModel) GetFiles(id int) ([]string, error) {
	//TODO implement me
	panic("implement me")
}

func (m *MockDatabaseModel) SetupDb() error {
	return nil
}

func (m *MockDatabaseModel) Get() ([]internal.Addon, error) {
	return []internal.Addon{
		{
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
	}, nil
}

func (m *MockDatabaseModel) Insert(addon internal.Addon, files string) error {
	return nil
}

// TODO: Test case with and without remote addons
func TestGetLocalAddons(t *testing.T) {
	tests := []struct {
		name         string
		localAddons  map[int]internal.Addon
		remoteAddons map[int]internal.Addon
		want         AddonMap
	}{
		{"without remote addons",
			map[int]internal.Addon{
				12345: {
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
			},
			make(map[int]internal.Addon),
			AddonMap{
				LocalAddons: map[int]internal.Addon{
					12345: {
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
				},
				RemoteAddons: make(map[int]internal.Addon),
			}},
		{"with remote addons",
			map[int]internal.Addon{
				12345: {
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
			},
			map[int]internal.Addon{
				12345: {
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
			},
			AddonMap{
				LocalAddons: map[int]internal.Addon{
					12345: {
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
				},
				RemoteAddons: map[int]internal.Addon{
					12345: {
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
				},
			}},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			app := App{
				addonModel:   &MockDatabaseModel{},
				localAddons:  tt.localAddons,
				remoteAddons: tt.remoteAddons,
				settings:     &internal.Settings{DataDirectory: ""},
			}

			got := app.GetLocalAddons(true)

			if !reflect.DeepEqual(got, tt.want) {
				t.Errorf("unable to fetch local addons. Got %v, expected %v", got, tt.want)
			}
		})
	}
}

//func TestGetRemoteAddons(t *testing.T) {
//	app := App{
//		addonModel:   &MockDatabaseModel{},
//		localAddons:  make(map[int]internal.Addon),
//		remoteAddons: make(map[int]internal.Addon),
//		settings:     &internal.Settings{DataDirectory: ""},
//	}
//
//	got := app.GetRemoteAddons(false)
//
//	expected := AddonMap{
//		LocalAddons: map[int]internal.Addon{
//			12345: {
//				Id:            12345,
//				Type:          "local",
//				Name:          "WhereToPlay",
//				Author:        "Dean",
//				Description:   "Hello World",
//				LocalVersion:  "1.2.3",
//				RemoteVersion: "",
//				Category:      "Others",
//				Downloads:     2534,
//				UpdatedAt:     "07/27/2026",
//				ArchiveName:   "WhereToPlay.zip",
//				ArchiveSize:   "5 MB",
//				HasUpdate:     false,
//				IsInstalled:   true,
//			},
//		},
//		RemoteAddons: map[int]internal.Addon{
//			12345: {
//				Id:            12345,
//				Type:          "local",
//				Name:          "WhereToPlay",
//				Author:        "Dean",
//				Description:   "Hello World",
//				LocalVersion:  "1.2.3",
//				RemoteVersion: "1.2.4",
//				Category:      "Others",
//				Downloads:     2534,
//				UpdatedAt:     "07/27/2026",
//				ArchiveName:   "WhereToPlay.zip",
//				ArchiveSize:   "5 MB",
//				HasUpdate:     false,
//				IsInstalled:   true,
//			},
//		},
//	}
//
//	if !reflect.DeepEqual(got, expected) {
//		t.Errorf("unable to fetch local addons. Got %v, expected %v", got, expected)
//	}
//}
