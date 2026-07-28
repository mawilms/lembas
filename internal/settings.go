package internal

import (
	"encoding/json"
	"errors"
	"os"
	"path/filepath"
)

type Settings struct {
	FavoritesUrl  string `json:"favoritesUrl"`
	BaseUrl       string `json:"baseUrl"`
	DownloadPath  string `json:"downloadPath"`
	DataDirectory string
}

func WriteSettings(settings Settings, path string) error {
	content, err := json.MarshalIndent(settings, "", "  ")
	if err != nil {
		return err
	}

	settingsPath := filepath.Join(path, "settings.json")

	if _, err := os.Stat(settingsPath); err != nil {
		if errors.Is(err, os.ErrNotExist) {
			if err = os.WriteFile(settingsPath, content, os.ModePerm); err != nil {
				return err
			}
		}
	}

	return nil
}

type UserDirectoryInterface interface {
	GetDocumentsDir() (string, error)
	CreateLotroDir() (string, error)
	CreatePluginsDir() error
}

type UserDirectory struct{}

func (u *UserDirectory) CreateLotroDir() (string, error) {
	docDir, err := u.GetDocumentsDir()
	if err != nil {
		return "", err
	}

	lotroDir := filepath.Join(docDir, "The Lord of the Rings Online")
	err = os.MkdirAll(lotroDir, os.ModePerm)
	if err != nil {
		return "", err
	}

	return lotroDir, nil
}

func (u *UserDirectory) CreatePluginsDir() error {
	lotroDir, err := u.CreateLotroDir()
	if err != nil {
		return err
	}

	return os.MkdirAll(filepath.Join(lotroDir, "Plugins"), os.ModePerm)
}

func (u *UserDirectory) GetDocumentsDir() (string, error) {
	home, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}

	return filepath.Join(home, "Documents"), nil // TODO: Prüfen ob dies auch für deutsche Installationen gilt
}

type AppDataInterface interface {
	GetLembasDir() (string, error)
	CreateLembasDir() error
}

type AppDataDirectory struct {
}

func (a *AppDataDirectory) GetLembasDir() (string, error) {
	configDir, err := os.UserConfigDir()
	if err != nil {
		return "", err
	}

	return filepath.Join(configDir, "lembas"), nil
}

func (a *AppDataDirectory) CreateLembasDir() error {
	configDir, err := a.GetLembasDir()
	if err != nil {
		return err
	}

	return os.MkdirAll(configDir, os.ModePerm)
}
