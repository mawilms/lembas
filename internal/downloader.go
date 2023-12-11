package internal

import (
	"archive/zip"
	"bytes"
	"github.com/mawilms/lembas/internal/models"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

func DownloadPackageInformation() ([]models.RemotePluginModel, error) {
	response, err := http.Get("https://api.lotrointerface.com/fav/plugincompendium.xml")
	if err != nil {
		return make([]models.RemotePluginModel, 0), err
	}

	content, err := io.ReadAll(response.Body)
	defer response.Body.Close()

	plugins, err := ParseFeed(content)

	return plugins, err
}

type downloader struct {
	Path string
}

func (d downloader) DownloadPlugin(url string) (models.DatastoreEntryModel, error) {
	response, err := http.Get(url)
	if err != nil {
		return models.DatastoreEntryModel{}, err
	}

	body, _ := io.ReadAll(response.Body)

	archive, _ := zip.NewReader(bytes.NewReader(body), int64(len(body)))

	var files []string
	hasPluginCompendiumFile := false
	model := models.LocalPluginModel{}
	for _, file := range archive.File {
		path := filepath.Join(d.Path, file.Name)

		if file.FileInfo().IsDir() {
			os.MkdirAll(path, os.ModePerm)
			continue
		}

		err := os.MkdirAll(filepath.Dir(path), os.ModePerm)
		if err != nil {
			return models.DatastoreEntryModel{
				Plugin: models.LocalPluginModel{},
				Files:  nil,
			}, err
		}

		dstFile, _ := os.OpenFile(path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, file.Mode())
		defer dstFile.Close()

		archiveFile, err := file.Open()
		//if err != nil {
		//	return models.DatastoreEntryModel{
		//		Plugin: models.LocalPluginModel{},
		//		Files:  nil,
		//	}, err
		//}
		//defer archiveFile.Close()

		archiveFileContent, _ := io.ReadAll(archiveFile)
		dstFile.Write(archiveFileContent)

		_, err = io.Copy(dstFile, archiveFile)
		if err != nil {
			return models.DatastoreEntryModel{
				Plugin: models.LocalPluginModel{},
				Files:  nil,
			}, err
		}

		//archiveFileContent, _ := io.ReadAll(archiveFile)
		if strings.Contains(file.Name, ".plugincompendium") {
			hasPluginCompendiumFile = true
			model, _ = ParsePluginConfig(archiveFileContent)
		}

		if strings.Contains(file.Name, ".plugin") && !hasPluginCompendiumFile {
			model, _ = ParseFallbackConfig(archiveFileContent)
		}

		files = append(files, file.Name)
	}

	return models.DatastoreEntryModel{
		Plugin: model,
		Files:  files,
	}, nil
}

func containsFile(files []string, pattern string) (bool, string) {
	for _, file := range files {
		if strings.Contains(file, pattern) {
			return true, file
		}
	}

	return false, ""
}
