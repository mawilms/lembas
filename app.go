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

func NewApp(settings settings.Settings, datastore internal.DatastoreInterface) *App {
	return &App{settings: settings, datastore: datastore}
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
	fmt.Println(url)

	entry, _ := internal.DownloadPlugin(url)

	_ = a.datastore.Store(entry)
}

func (a *App) FetchRemotePlugins() []models.RemotePluginModel {
	var plugins []models.RemotePluginModel

	plugins, err := internal.DownloadPackageInformation()
	if err != nil {
		return plugins
	}

	return plugins
}
