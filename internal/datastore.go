package internal

import (
	"encoding/json"
	"errors"
	"fmt"
	"github.com/mawilms/lembas/internal/models"
	"os"
)

type DatastoreInterface interface {
	Store() error
	Get() ([]models.LocalPluginModel, error)
	GetById(id string) (models.LocalPluginModel, error)
	DeleteById(id string) error
}

type jsonDatastore map[string]jsonDatastoreEntry

type jsonDatastoreEntry struct {
	Information struct {
		Id             int      `json:"id"`
		Name           string   `json:"name"`
		CurrentVersion string   `json:"currentVersion"`
		LatestVersion  string   `json:"latestVersion"`
		Author         string   `json:"author"`
		Description    string   `json:"description"`
		InfoUrl        string   `json:"infoUrl"`
		DownloadUrl    string   `json:"downloadUrl"`
		Descriptors    []string `json:"descriptors"`
		Dependencies   []int    `json:"dependencies"`
	} `json:"information"`
	Files []string `json:"files"`
}

type Datastore struct {
	Path string
}

func (d Datastore) New() {

}

func (d Datastore) Open() (models.DatastoreModel, error) {
	content, err := os.ReadFile(d.Path)
	if err != nil {
		return models.DatastoreModel{}, err
	}

	var jsonStore jsonDatastore
	model := make(models.DatastoreModel)

	err = json.Unmarshal(content, &jsonStore)
	if err != nil {
		return models.DatastoreModel{}, err
	}

	for key, entry := range jsonStore {
		model[key] = models.DatastoreEntryModel{
			Plugin: models.LocalPluginModel{
				Id:             entry.Information.Id,
				Name:           entry.Information.Name,
				CurrentVersion: entry.Information.CurrentVersion,
				LatestVersion:  entry.Information.LatestVersion,
				Author:         entry.Information.Author,
				Description:    entry.Information.Description,
				InfoUrl:        entry.Information.InfoUrl,
				DownloadUrl:    entry.Information.DownloadUrl,
				Descriptors:    entry.Information.Descriptors,
				Dependencies:   entry.Information.Dependencies,
			},
			Files: entry.Files,
		}
	}

	return model, nil
}

func (d Datastore) Store() error {
	return nil
}

func (d Datastore) Get() ([]models.LocalPluginModel, error) {
	var plugins []models.LocalPluginModel

	data, err := d.Open()
	if err != nil {
		return plugins, err
	}

	for _, entry := range data {
		plugins = append(plugins, entry.Plugin)
	}

	return plugins, nil
}

func (d Datastore) GetById(id string) (models.LocalPluginModel, error) {
	data, err := d.Open()
	if err != nil {
		return models.LocalPluginModel{}, err
	}
	entry, isOk := data[id]
	if !isOk {
		return models.LocalPluginModel{}, errors.New(fmt.Sprintf("Model with given id %v doesn't exist", id))
	}

	return entry.Plugin, nil
}

func (d Datastore) DeleteById(id string) error {
	data, err := d.Open()
	if err != nil {
		return err
	}

	delete(data, id)

	return nil
}
