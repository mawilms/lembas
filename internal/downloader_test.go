package internal

import "testing"

func TestDownloadPackageInformation(t *testing.T) {
	plugins, err := DownloadPackageInformation()
	if err != nil {
		t.Error(err)
	}

	_ = plugins
}

func TestDownloader_DownloadPlugin(t *testing.T) {
	downloader := downloader{
		"output",
	}

	datastoreEntry, err := downloader.DownloadPlugin("http://www.lotrointerface.com/downloads/download1022")
	if err != nil {
		t.Errorf("Received error during the download process: %v", err)
	}

	_ = datastoreEntry
}
