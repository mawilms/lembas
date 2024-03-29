package settings

import (
	"encoding/json"
	"fmt"
	"os"
	"path/filepath"
)

type Settings struct {
	PluginDirectory string `json:"pluginPath"`
	DataDirectory   string `json:"dataDirectory"`
	InfoUrl         string `json:"infoUrl"`
}

func New() (Settings, error) {
	pluginDirectory, err := findPluginDirectory()
	if err != nil {
		return Settings{}, err
	}
	dataDirectory, err := findDataDirectory()
	if err != nil {
		return Settings{}, err
	}

	fmt.Println(pluginDirectory)
	fmt.Println(dataDirectory)

	settings := Settings{
		PluginDirectory: pluginDirectory,
		DataDirectory:   dataDirectory,
		InfoUrl:         "https://api.lotrointerface.com/fav/plugincompendium.xml",
	}

	_, err = os.Stat(filepath.Join(dataDirectory, "settings.json"))
	if err != nil {
		err := settings.Store()
		if err != nil {
			return Settings{}, err
		}
	} else {
		err = settings.Read()
		if err != nil {
			return Settings{}, err
		}
	}

	return settings, nil
}

func (s *Settings) Store() error {
	content, err := json.MarshalIndent(s, "", " ")
	if err != nil {
		return err
	}

	err = os.WriteFile(filepath.Join(s.DataDirectory, "settings.json"), content, 0644)
	if err != nil {
		return err
	}

	return nil
}

func (s *Settings) Read() error {
	var newSettings Settings

	settingsContent, err := os.ReadFile(filepath.Join(s.DataDirectory, "settings.json"))
	if err != nil {
		return err
	}

	err = json.Unmarshal(settingsContent, &newSettings)
	if err != nil {
		return err
	}

	*s = newSettings

	return nil
}

func findPluginDirectory() (string, error) {
	// TODO: Check Documents folder
	// TODO: Add functionality to add the install path to the settings
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}

	lotroDirectory := filepath.Join(homeDir, "Documents", "The Lord of the Rings Online", "Plugins")
	_, err = os.Stat(lotroDirectory)
	if err != nil {
		err := os.MkdirAll(lotroDirectory, os.ModePerm)
		if err != nil {
			return lotroDirectory, err
		}
	}
	// TODO: Check for steam folder

	return lotroDirectory, nil
}

func findDataDirectory() (string, error) {
	configDir, _ := os.UserConfigDir()
	dataDirectoryPath := filepath.Join(configDir, "lembas")
	err := os.MkdirAll(dataDirectoryPath, os.ModePerm)
	if err != nil {
		return "", err
	}

	return dataDirectoryPath, nil
}
