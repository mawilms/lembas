package settings

import (
	"encoding/json"
	"os"
	"path/filepath"
	"testing"
)

func TestSettings_store(t *testing.T) {
	tmpDir, err := os.MkdirTemp("", "lembas")

	settings := Settings{
		PluginDirectory: "Not Important",
		DataDirectory:   tmpDir,
	}

	err = settings.Store()
	if err != nil {
		t.Errorf("unable to write settings file to disk. %v", err)
	}

	var readSettings Settings

	settingsFilePath := filepath.Join(tmpDir, "settings.json")
	settingsFile, err := os.ReadFile(settingsFilePath)
	if err != nil {
		t.Errorf("unable to read written settings.json file. %v", err)
	}

	_ = json.Unmarshal(settingsFile, &readSettings)

	if readSettings.DataDirectory == settingsFilePath {
		t.Errorf("Expected path is %v, got %v", settingsFilePath, readSettings.DataDirectory)
	}

	os.Remove(tmpDir)
}

func TestSettings_read(t *testing.T) {
	tmpDir, err := os.MkdirTemp("", "lembas")

	settings := Settings{
		PluginDirectory: "Not Important",
		DataDirectory:   tmpDir,
	}

	err = settings.Store()
	if err != nil {
		t.Errorf("unable to write settings file to disk. %v", err)
	}

	err = settings.Read()
	if err != nil {
		t.Errorf("error while reading settings.json. %v", err)
	}

	os.Remove(tmpDir)
}

func TestFindPluginDirectory(t *testing.T) {
	_, err := findPluginDirectory()
	if err != nil {
		t.Error("unable to locate lotro directory")
	}
}

func TestFindDataDirectory(t *testing.T) {
	_, err := findDataDirectory()
	if err != nil {
		t.Error("unable to locate data directory")
	}
}
