package internal

import "github.com/mawilms/lembas/internal/models"

type DatastoreInterface interface {
	Store() error
	Get() ([]models.InstalledPlugin, error)
	GetById(id int) (models.InstalledPlugin, error)
	DeleteById(id int) error
}

type Datastore struct {
	Path string
}

func (d *Datastore) Open() (string, error) {
	return "", nil
}

func (d *Datastore) Store() error {
	return nil
}

func (d *Datastore) Get() ([]models.InstalledPlugin, error) {
	var plugins []models.InstalledPlugin

	return plugins, nil
}

func (d *Datastore) GetById(id int) (models.InstalledPlugin, error) {
	return models.InstalledPlugin{}, nil
}

func (d *Datastore) DeleteById(id int) error {
	return nil
}
