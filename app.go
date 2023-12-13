package main

import (
	"context"
	"fmt"
	"github.com/mawilms/lembas/internal"
	"github.com/mawilms/lembas/internal/models"
	"github.com/mawilms/lembas/internal/settings"
)

type App struct {
	ctx       context.Context
	settings  settings.Settings
	datastore internal.DatastoreInterface
}

func NewApp() *App {
	s, _ := settings.New()
	datastore, _ := internal.NewDatastore(s.DataDirectory)

	return &App{settings: s, datastore: datastore}
}

func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}

func (a *App) Greet(name string) string {
	return fmt.Sprintf("Hello %s, It's show time!", name)
}

func (a *App) SaveSettings(pluginDirectory string) {
	fmt.Println(pluginDirectory)
}

func (a *App) InstallPlugin(url string) {
	entry, _ := internal.DownloadPlugin(url, a.settings.PluginDirectory)

	a.datastore.Store(entry)
}

func (a *App) GetInstalledPlugins() []models.LocalPluginModel {
	plugins, _ := a.datastore.Get()

	return plugins
}

func (a *App) FetchRemotePlugins() []models.RemotePluginModel {
	var plugins []models.RemotePluginModel

	plugins, err := internal.DownloadPackageInformation()
	if err != nil {
		return plugins
	}

	return plugins
}
