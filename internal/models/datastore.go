package models

import (
	"encoding/json"
	"errors"
	"fmt"
	"os"
	"path/filepath"
	"strings"
)

type DatastoreModel map[string]DatastoreEntryModel

type DatastoreEntryModel struct {
	Plugin LocalPluginModel
	Files  []string
}

type DatastoreInterface interface {
	Open() (DatastoreModel, error)
	Store(model DatastoreEntryModel) error
	Get() ([]LocalPluginModel, error)
	DeleteById(id string) error
}

type Datastore struct {
	Path string
}

func NewDatastore(dataDirectory string) (Datastore, error) {
	datastorePath := filepath.Join(dataDirectory, "datastore.json")

	_, err := os.Stat(datastorePath)
	if err != nil {
		file, err := os.OpenFile(datastorePath, os.O_RDONLY|os.O_CREATE, 0644)
		if err != nil {
			return Datastore{}, err
		}
		defer func(file *os.File) {
			_ = file.Close()
		}(file)

		_, err = file.Write([]byte("{}"))
		if err != nil {
			return Datastore{}, err
		}

	}

	return Datastore{
		Path: datastorePath,
	}, nil
}

func (d Datastore) Open() (DatastoreModel, error) {
	content, err := os.ReadFile(d.Path)
	if err != nil {
		return DatastoreModel{}, err
	}

	var model DatastoreModel

	err = json.Unmarshal(content, &model)
	if err != nil {
		return DatastoreModel{}, err
	}

	return model, nil
}

func (d Datastore) Store(entry DatastoreEntryModel) error {
	store, _ := d.Open()

	identifier := fmt.Sprintf("%v-%v", strings.ToLower(entry.Plugin.Name), strings.ToLower(entry.Plugin.Author))
	_, ok := store[identifier]
	if !ok {
		store[identifier] = entry
	} else {
		return errors.New("entry already exists")
	}
	file, err := json.MarshalIndent(store, "", " ")
	if err != nil {
		return err
	}

	err = os.WriteFile(d.Path, file, 0644)
	if err != nil {
		return err
	}

	return nil
}

func (d Datastore) Get() ([]LocalPluginModel, error) {
	var plugins []LocalPluginModel

	data, err := d.Open()
	if err != nil {
		return plugins, err
	}

	for _, entry := range data {
		plugins = append(plugins, entry.Plugin)
	}

	return plugins, nil
}

func (d Datastore) DeleteById(id string) error {
	data, err := d.Open()
	if err != nil {
		return err
	}

	delete(data, id)

	return nil
}
