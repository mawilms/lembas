package processes

import (
	"fmt"
	"github.com/mawilms/lembas/internal/entities"
	"github.com/mawilms/lembas/internal/models"
	"io"
	"log/slog"
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

	pluginZipArchivePath = filepath.Join(filepath.Dir(b), "..", "..", "test", "samples", "AltHolic.zip")
)

func TestGetRemotePlugins(t *testing.T) {
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

	localPlugins := []entities.LocalPluginEntity{{
		Base: entities.BasePluginEntity{
			Id:             1126,
			Name:           "AltHolic",
			Description:    "Hello World",
			Author:         "homeopatix",
			CurrentVersion: "4.40",
			LatestVersion:  "4.40",
			InfoUrl:        "https://www.lotrointerface.com/downloads/info1126",
			DownloadUrl:    "https://www.lotrointerface.com/downloads/download1126",
		},
		Descriptors:  nil,
		Dependencies: nil,
	}}

	expectedPlugins := []entities.RemotePluginEntity{{
		Base: entities.BasePluginEntity{
			Id:             1126,
			Name:           "AltHolic",
			Description:    "Hello World",
			Author:         "homeopatix",
			CurrentVersion: "4.40",
			LatestVersion:  "4.40",
			InfoUrl:        "https://www.lotrointerface.com/downloads/info1126",
			DownloadUrl:    "https://www.lotrointerface.com/downloads/download1126",
		},
		UpdatedTimestamp: "2023-12-07",
		IsInstalled:      true,
		Downloads:        378268,
		Category:         "Bags Bank & Inventory",
		FileName:         "AltHolicV4.40.zip",
	}}
	logger := slog.New(slog.NewTextHandler(io.Discard, nil))
	process := Process{Logger: logger}

	remotePlugins, err := process.GetRemotePlugins(server.URL, localPlugins)
	if err != nil {
		t.Fatalf("Error: %v", err)
	}

	isEqual := reflect.DeepEqual(remotePlugins, expectedPlugins)
	if !isEqual {
		t.Fatalf("Got: %+v, expected: %+v", remotePlugins, expectedPlugins)
	}
}

type dummyDatastore struct {
}

func (d dummyDatastore) Open() (models.DatastoreModel, error) {
	model := make(models.DatastoreModel)
	model["alholic-some author"] = models.DatastoreEntryModel{
		Plugin: models.LocalPluginModel{
			Id:             366,
			Name:           "AltHolic",
			CurrentVersion: "1.0",
			LatestVersion:  "1.0",
			Author:         "Some Author",
			Description:    "Hello World",
			InfoUrl:        "https://www.lotrointerface.com/downloads/info1126",
			DownloadUrl:    "https://www.lotrointerface.com/downloads/download1126",
			Descriptors:    nil,
			Dependencies:   nil,
		},
		Files: nil,
	}

	return model, nil
}

func (d dummyDatastore) Store(string, models.DatastoreEntryModel) error {
	return nil
}

func (d dummyDatastore) Get() ([]models.LocalPluginModel, error) {
	plugins := []models.LocalPluginModel{{
		Id:             366,
		Name:           "AltHolic",
		CurrentVersion: "1.0",
		LatestVersion:  "1.0",
		Author:         "Some Author",
		Description:    "Hello World",
		InfoUrl:        "http://www.lotrointerface.com/downloads/info366",
		DownloadUrl:    "http://www.lotrointerface.com/downloads/download366",
		Descriptors:    nil,
		Dependencies:   nil,
	}}

	return plugins, nil
}

func (d dummyDatastore) DeleteById(string) error {
	return nil
}

func TestGetInstalledPlugins(t *testing.T) {
	expectedPlugins := []entities.LocalPluginEntity{{
		Base:         models.NewBasePlugin(366, "AltHolic", "Hello World", "Some Author", "1.0", "1.0"),
		Descriptors:  nil,
		Dependencies: nil,
	}}
	logger := slog.New(slog.NewTextHandler(io.Discard, nil))
	process := Process{Logger: logger}

	plugins, err := process.GetInstalledPlugins(dummyDatastore{})
	if err != nil {
		t.Fatal(err)
	}

	isEqual := reflect.DeepEqual(plugins, expectedPlugins)
	if !isEqual {
		t.Fatalf("Got: %+v, expected: %+v", plugins, expectedPlugins)
	}
}

func TestInstallPlugin(t *testing.T) {
	tmpDir, err := os.MkdirTemp("", "lembas")
	if err != nil {
		t.Fatal(err)
	}
	server := httptest.NewServer(http.HandlerFunc(func(w http.ResponseWriter, r *http.Request) {
		http.ServeFile(w, r, pluginZipArchivePath)
	}))
	defer server.Close()
	expectedPlugins := []entities.RemotePluginEntity{{
		Base:             models.NewBasePlugin(366, "AltHolic", "Hello World", "Some Author", "1.0", "1.0"),
		IsInstalled:      true,
		UpdatedTimestamp: "2023-12-28",
		Downloads:        0,
		Category:         "",
		FileName:         "",
	}}
	logger := slog.New(slog.NewTextHandler(io.Discard, nil))
	process := Process{Logger: logger}

	plugins, err := process.InstallPlugin(dummyDatastore{}, server.URL, tmpDir, []entities.RemotePluginEntity{{
		Base:             models.NewBasePlugin(366, "AltHolic", "Hello World", "Some Author", "1.0", "1.0"),
		IsInstalled:      false,
		UpdatedTimestamp: "2023-12-28",
		Downloads:        0,
		Category:         "",
		FileName:         "",
	}})
	if err != nil {
		t.Fatal(err)
	}

	isEqual := reflect.DeepEqual(plugins, expectedPlugins)
	if !isEqual {
		t.Errorf("Got: %+v, expected: %+v", plugins, expectedPlugins)
	}
}

func TestDeletePlugin(t *testing.T) {
	tmpDir, err := os.MkdirTemp("", "lembas")
	if err != nil {
		t.Fatal(err)
	}
	logger := slog.New(slog.NewTextHandler(io.Discard, nil))
	process := Process{Logger: logger}

	_, err = process.DeletePlugin(dummyDatastore{}, "AltHolic", "Some Author", tmpDir)
	if err != nil {
		t.Fatal(err)
	}
}

func TestSearch(t *testing.T) {
	expectedOutput := []entities.LocalPluginEntity{{
		Base:         models.NewBasePlugin(1, "ABC", "", "", "", ""),
		Descriptors:  nil,
		Dependencies: nil,
	}}

	inputPlugins := []entities.LocalPluginEntity{{
		Base:         models.NewBasePlugin(1, "ABC", "", "", "", ""),
		Descriptors:  nil,
		Dependencies: nil,
	}, {
		Base:         models.NewBasePlugin(2, "XYZ", "", "", "", ""),
		Descriptors:  nil,
		Dependencies: nil,
	}}
	logger := slog.New(slog.NewTextHandler(io.Discard, nil))
	process := Process{Logger: logger}

	filteredPlugins := process.SearchLocal("bc", inputPlugins)
	if len(filteredPlugins) != 1 {
		t.Fatalf("Expected: 1, got: %v", len(filteredPlugins))
	}

	isEqual := reflect.DeepEqual(filteredPlugins, expectedOutput)
	if !isEqual {
		t.Fatalf("Got: %+v, expected: %+v", filteredPlugins, expectedOutput)
	}
}
