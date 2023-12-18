package internal

import (
	"fmt"
	"net/http"
	"net/http/httptest"
	"path/filepath"
	"runtime"
	"testing"
)

var (
	_, b, _, _ = runtime.Caller(0)

	pluginZipArchivePath = filepath.Join(filepath.Dir(b), "..", "test", "samples", "AltHolic.zip")
)

func TestDownloadPackageInformation(t *testing.T) {
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		_, _ = fmt.Fprintf(w, `<Favorites>
	<Ui>
		<UID>1126</UID>
		<UIName>AltHolic</UIName>
		<UIAuthorName>homeopatix</UIAuthorName>
		<UIVersion>4.40</UIVersion>
		<UIUpdated>1701967106</UIUpdated>
		<UIDownloads>378268</UIDownloads>
		<UICategory>Bags Bank &amp; Inventory</UICategory>
		<UIDescription>Hello World</UIDescription>
		<UIFile>AltHolicV4.40.zip</UIFile>
		<UIMD5></UIMD5>
		<UISize>839424</UISize>
		<UIFileURL>http://www.lotrointerface.com/downloads/download1126</UIFileURL>
	</Ui>
</Favorites>`)
	}))
	defer server.Close()

	plugins, err := DownloadPackageInformation(server.URL)
	if err != nil {
		t.Error(err)
	}

	_ = plugins
}

//func TestDownloader_DownloadPlugin(t *testing.T) {
//	directory, err := os.MkdirTemp("", "lembas")
//	if err != nil {
//		t.Errorf("unable to create temporary directory")
//	}
//	defer os.Remove(directory)
//
//	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
//		http.ServeFile(w, r, pluginZipArchivePath)
//	}))
//	defer server.Close()
//
//	datastoreEntry, err := DownloadPlugin(server.URL, directory)
//	if err != nil {
//
//		t.Errorf("Received error during the download process: %v", err)
//	}
//	expectedEntry := models.DatastoreEntryModel{
//		Plugin: entities.LocalPluginEntity{
//			Base: entities.BasePluginEntity{
//				Id:            1126,
//				Name:          "AltHolic",
//				LatestVersion: "4.40",
//				Author:        "Homeopatix",
//				Description:   "Hello World",
//				InfoUrl:       "https://www.lotrointerface.com/downloads/info1126",
//				DownloadUrl:   "https://www.lotrointerface.com/downloads/download1126",
//			},
//			CurrentVersion: "4.40",
//			Descriptors:    []string{"Homeopatix\\AltHolic.plugin"},
//			Dependencies:   nil,
//		},
//		Files: []string{"Homeopatix\\AltHolic", "Homeopatix\\AltHolic.plugin", "Homeopatix\\AltHolic.plugincompendium"},
//	}
//
//	isEqual := reflect.DeepEqual(datastoreEntry.Plugin, expectedEntry.Plugin)
//	if !isEqual {
//		t.Errorf("Got: %v, expected: %v", datastoreEntry.Plugin, expectedEntry.Plugin)
//	}
//}
