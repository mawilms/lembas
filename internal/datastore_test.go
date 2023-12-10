package internal

import (
	"github.com/mawilms/lembas/internal/models"
	"os"
	"reflect"
	"testing"
)

func setupTestCase(t *testing.T) (string, func(t *testing.T)) {
	jsonContent := []byte(`{
  "altholic-homeopatix": {
    "information": {
      "id": 1,
      "name": "AltHolic",
      "currentVersion": "1.2",
      "latestVersion": "1.5",
      "author": "Homeopatix",
      "description": "Hello World",
      "infoUrl": "example.com",
      "downloadUrl": "example.com",
      "descriptors": [],
      "dependencies": []
    },
    "files": [
      "PengorosPlugins\\Utils\\Class.lua",
      "PengorosPlugins\\Utils\\FontMetrics.lua"
    ]
  }
}`)
	file, err := os.CreateTemp("", "lembas")
	if err != nil {
		t.Fatal("Failed to create the temporary test directory")
	}

	err = os.WriteFile(file.Name(), jsonContent, 0644)
	if err != nil {
		t.Fatal("Failed to create an example structure JSON testing file")
	}

	return file.Name(), func(t *testing.T) {
		err = file.Close()
		if err != nil {
			t.Fatalf("Failed to close tmp file under %s", file.Name())
		}
		err = os.Remove(file.Name())
		if err != nil {
			t.Fatalf("Unable to delete tmp file under %s", file.Name())
		}
	}
}

func TestDatastore_Open(t *testing.T) {
	filename, teardownTestCase := setupTestCase(t)
	defer teardownTestCase(t)

	expecedModel := models.DatastoreEntryModel{
		Plugin: models.LocalPluginModel{
			Id:             1,
			Name:           "AltHolic",
			CurrentVersion: "1.2",
			LatestVersion:  "1.5",
			Author:         "Homeopatix",
			Description:    "Hello World",
			InfoUrl:        "example.com",
			DownloadUrl:    "example.com",
			Descriptors:    []string{},
			Dependencies:   []int{},
		},
		Files: []string{
			"PengorosPlugins\\Utils\\Class.lua",
			"PengorosPlugins\\Utils\\FontMetrics.lua",
		},
	}

	store := Datastore{
		Path: filename,
	}

	content, err := store.Open()
	if err != nil {
		t.Errorf("Unable to read JSON file. Error: %v", err)
	}

	entry, ok := content["altholic-homeopatix"]
	if !ok {
		t.Errorf("Key doesn't exist")
	}

	isEqual := reflect.DeepEqual(entry, expecedModel)
	if !isEqual {
		t.Errorf("Input datastore model is different from the expected struct. Got: %v, expected: %v", entry, expecedModel)
	}
}

func TestDatastore_Store(t *testing.T) {
}

func TestDatastore_Get(t *testing.T) {
	filename, teardownTestCase := setupTestCase(t)
	defer teardownTestCase(t)

	expectedPlugin := models.LocalPluginModel{
		Id:             1,
		Name:           "AltHolic",
		CurrentVersion: "1.2",
		LatestVersion:  "1.5",
		Author:         "Homeopatix",
		Description:    "Hello World",
		InfoUrl:        "example.com",
		DownloadUrl:    "example.com",
		Descriptors:    []string{},
		Dependencies:   []int{},
	}

	store := Datastore{
		Path: filename,
	}

	plugins, err := store.Get()
	if err != nil {
		t.Error("Unable to get the plugins from the datastore")
	}

	if len(plugins) != 1 {
		t.Errorf("Got %v plugins, expected 1", len(plugins))
	}
	isEqual := reflect.DeepEqual(plugins[0], expectedPlugin)
	if !isEqual {
		t.Errorf("Retrieved plugin differs from the expected one. Got %v, expected %v", plugins[0], expectedPlugin)
	}
}

func TestDatastore_GetById(t *testing.T) {
	filename, teardownTestCase := setupTestCase(t)
	defer teardownTestCase(t)

	expectedPlugin := models.LocalPluginModel{
		Id:             1,
		Name:           "AltHolic",
		CurrentVersion: "1.2",
		LatestVersion:  "1.5",
		Author:         "Homeopatix",
		Description:    "Hello World",
		InfoUrl:        "example.com",
		DownloadUrl:    "example.com",
		Descriptors:    []string{},
		Dependencies:   []int{},
	}

	store := Datastore{
		Path: filename,
	}

	plugin, err := store.GetById("altholic-homeopatix")
	if err != nil {
		t.Error("Unable to get the plugin with the id `altholic-homeopatix` from the datastore")
	}

	isEqual := reflect.DeepEqual(plugin, expectedPlugin)
	if !isEqual {
		t.Errorf("Retrieved struct differs from the expected one. Got %v, expected %v", plugin, expectedPlugin)
	}
}

func TestDatastore_DeleteById(t *testing.T) {
	filename, teardownTestCase := setupTestCase(t)
	defer teardownTestCase(t)

	store := Datastore{
		Path: filename,
	}

	err := store.DeleteById("altholic-homeopatix")
	if err != nil {
		t.Error("Unable to delete the plugin from the datastore")
	}
}
