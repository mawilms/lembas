package internal

import (
	"os"
	"testing"
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

	datastoreEntry, err := DownloadPlugin("http://www.lotrointerface.com/downloads/download1022", directory)
	if err != nil {
		t.Errorf("Received error during the download process: %v", err)
	}

	_ = datastoreEntry
}
