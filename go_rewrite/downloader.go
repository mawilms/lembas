package go_rewrite

import (
	"archive/zip"
	"bytes"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"

	"github.com/mawilms/lembas/go_rewrite/entities"
	models2 "github.com/mawilms/lembas/go_rewrite/models"
)

func DownloadPackageInformation(url string) ([]entities.RemotePluginEntity, error) {
	response, err := http.Get(url)
	if err != nil {
		return make([]entities.RemotePluginEntity, 0), err
	}

	content, err := io.ReadAll(response.Body)
	defer response.Body.Close()

	plugins, err := models2.ParseFeed(content)

	return plugins, err
}

func DownloadPlugin(url, pluginDirectory string) (models2.DatastoreEntryModel, error) {
	response, err := http.Get(url)
	if err != nil {
		return models2.DatastoreEntryModel{}, err
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
			return models2.DatastoreEntryModel{
				Plugin: models2.LocalPluginModel{},
				Files:  nil,
			}, err
		}

		dstFile, _ := os.OpenFile(path, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, file.Mode())

		archiveFile, err := file.Open()
		archiveFileContent, _ := io.ReadAll(archiveFile)
		dstFile.Write(archiveFileContent)

		_, err = io.Copy(dstFile, archiveFile)
		if err != nil {
			return models2.DatastoreEntryModel{
				Plugin: models2.LocalPluginModel{},
				Files:  nil,
			}, err
		}

		if strings.Contains(file.Name, ".plugincompendium") {
			pluginCompendiumFileContent = archiveFileContent
			pluginsMap[strings.Replace(file.Name, "/", string(os.PathSeparator), -1)] = struct{}{}
		} else if strings.Contains(file.Name, ".plugin") {
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

		dstFile.Close()
	}

	model := models2.LocalPluginModel{}
	if len(pluginCompendiumFileContent) != 0 {
		model, _ = models2.ParsePluginConfig(pluginCompendiumFileContent)
	} else {
		model, _ = models2.ParseFallbackConfig(pluginFileContent)
	}

	var files []string

	for key := range pluginsMap {
		files = append(files, key)
	}

	return models2.DatastoreEntryModel{
		Plugin: model,
		Files:  files,
	}, nil
}

func DeletePlugin(entry models2.DatastoreEntryModel, pluginDirectory string) error {
	rootDirectory := ""

	for _, file := range entry.Files {
		rootDirectory = strings.Split(file, string(os.PathSeparator))[0]
		file = filepath.Join(pluginDirectory, file)

		err := os.RemoveAll(file)
		if err != nil {
			return err
		}
	}

	content, err := os.ReadDir(filepath.Join(pluginDirectory, rootDirectory))
	if err != nil {
		return err
	}

	if len(content) == 0 {
		err = os.RemoveAll(filepath.Join(pluginDirectory, rootDirectory))
	}

	return nil
}
