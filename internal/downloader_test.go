package internal

import (
	"github.com/mawilms/lembas/internal/models"
	"net/http"
	"net/http/httptest"
	"os"
	"path/filepath"
	"reflect"
	"runtime"
	"testing"
)

var (
	_, b, _, _ = runtime.Caller(0)

	pluginZipArchivePath = filepath.Join(filepath.Dir(b), "..", "test", "samples", "AltHolic.zip")
)

func TestDownloadPackageInformation(t *testing.T) {
	plugins, err := DownloadPackageInformation()
	if err != nil {
		t.Error(err)
	}

	_ = plugins
}

func TestDownloader_DownloadPlugin(t *testing.T) {
	directory, err := os.MkdirTemp("", "lembas")
	if err != nil {
		t.Errorf("unable to create temporary directory")
	}
	defer os.Remove(directory)

	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, pluginZipArchivePath)
	}))
	defer server.Close()

	datastoreEntry, err := DownloadPlugin(server.URL, directory)
	if err != nil {

		t.Errorf("Received error during the download process: %v", err)
	}
	expectedEntry := models.DatastoreEntryModel{
		Plugin: models.LocalPluginModel{
			Id:             1126,
			Name:           "AltHolic",
			CurrentVersion: "4.40",
			LatestVersion:  "4.40",
			Author:         "Homeopatix",
			Description:    "Hello World",
			InfoUrl:        "http://www.lotrointerface.com/downloads/info1126",
			DownloadUrl:    "http://www.lotrointerface.com/downloads/download1126",
			Descriptors:    []string{"Homeopatix\\AltHolic.plugin"},
			Dependencies:   nil,
		},
		Files: []string{"Homeopatix\\AltHolic", "Homeopatix\\AltHolic.plugin", "Homeopatix\\AltHolic.plugincompendium"},
	}

	isEqual := reflect.DeepEqual(datastoreEntry.Plugin, expectedEntry.Plugin)
	if !isEqual {
		t.Errorf("stored datastore model entry differs from the expected one. Got: %v, expected: %v", datastoreEntry, expectedEntry)
	}
}
