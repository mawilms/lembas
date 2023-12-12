package settings

import (
	"os"
	"path/filepath"
)

type Settings struct {
	MainDirectoryPath string
}

func New() Settings {
	lotroDirectory, _ := findLotroDirectory()

	return Settings{
		MainDirectoryPath: lotroDirectory,
	}
}

func findLotroDirectory() (string, error) {
	// TODO: Check Documents folder
	// TODO: Add functionality to add the install path to the settings
	homeDir, err := os.UserHomeDir()
	if err != nil {
		return "", err
	}

	lotroDirectory := ""
	if _, err := os.Stat(filepath.Join(homeDir, "Documents", "The Lord of the Rings Online", "Plugins")); os.IsNotExist(err) {
		lotroDirectory = filepath.Join(homeDir, "Documents", "The Lord of the Rings Online", "Plugins")
	}

	// TODO: Check for steam folder

	return lotroDirectory, nil
}
