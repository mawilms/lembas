package internal

import (
	"archive/zip"
	"bytes"
	"github.com/mawilms/lembas/internal/entities"
	"github.com/mawilms/lembas/internal/models"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

func DownloadPackageInformation(url string) ([]entities.RemotePluginEntity, error) {
	response, err := http.Get("https://api.lotrointerface.com/fav/plugincompendium.xml")
	if err != nil {
		return make([]entities.RemotePluginEntity, 0), err
	}

	content, err := io.ReadAll(response.Body)
	defer response.Body.Close()

	plugins, err := ParseFeed(content)

	return plugins, err
}

func DownloadPlugin(url, pluginDirectory string) (models.DatastoreEntryModel, error) {
	response, err := http.Get(url)
	if err != nil {
		return models.DatastoreEntryModel{}, err
	}

	body, _ := io.ReadAll(response.Body)

	archive, _ := zip.NewReader(bytes.NewReader(body), int64(len(body)))

	pluginsMap := make(map[string]struct{})

	var pluginCompendiumFileContent []byte
	var pluginFileContent []byte
	for _, file := range archive.File {
		path := filepath.Join(pluginDirectory, file.Name)

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
		archiveFileContent, _ := io.ReadAll(archiveFile)
		dstFile.Write(archiveFileContent)

		_, err = io.Copy(dstFile, archiveFile)
		if err != nil {
			return models.DatastoreEntryModel{
				Plugin: models.LocalPluginModel{},
				Files:  nil,
			}, err
		}

		if strings.Contains(file.Name, ".plugincompendium") {
			pluginCompendiumFileContent = archiveFileContent
			pluginsMap[strings.Replace(file.Name, "/", string(os.PathSeparator), -1)] = struct{}{}
		}
		if strings.Contains(file.Name, ".plugin") {
			pluginFileContent = archiveFileContent
			pluginsMap[strings.Replace(file.Name, "/", string(os.PathSeparator), -1)] = struct{}{}
		}

		splitPath := strings.Split(file.Name, "/")
		if len(splitPath) > 1 && (!strings.Contains(file.Name, ".plugincompendium") && !strings.Contains(file.Name, ".plugin")) {
			_, ok := pluginsMap[filepath.Join(splitPath[0], splitPath[1])]
			if !ok {
				pluginsMap[filepath.Join(splitPath[0], splitPath[1])] = struct{}{}
			}
		}
	}

	model := models.LocalPluginModel{}
	if len(pluginCompendiumFileContent) != 0 {
		model, _ = ParsePluginConfig(pluginCompendiumFileContent)
	} else {
		model, _ = ParseFallbackConfig(pluginFileContent)
	}

	var files []string

	for key, _ := range pluginsMap {
		files = append(files, key)
	}

	return models.DatastoreEntryModel{
		Plugin: model,
		Files:  files,
	}, nil
}

func DeletePlugin(entry models.DatastoreEntryModel, pluginDirectory string) error {
	for _, file := range entry.Files {
		file = filepath.Join(pluginDirectory, file)

		err := os.RemoveAll(file)
		if err != nil {
			return err
		}
	}

	return nil
}
