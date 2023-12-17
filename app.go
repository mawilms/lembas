package main

import (
	"context"
	"fmt"
	"github.com/mawilms/lembas/internal"
	"github.com/mawilms/lembas/internal/entities"
	"github.com/mawilms/lembas/internal/models"
	"github.com/mawilms/lembas/internal/settings"
	"strings"
)

type App struct {
	ctx       context.Context
	settings  settings.Settings
	datastore models.DatastoreInterface
}

func NewApp() *App {
	s, _ := settings.New()
	datastore, _ := models.NewDatastore(s.DataDirectory)

	return &App{settings: s, datastore: datastore}
}

func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}

func (a *App) SaveSettings(pluginDirectory string) {
	fmt.Println(pluginDirectory)
}

func (a *App) InstallPlugin(url string) []models.LocalPluginModel {
	entry, _ := internal.DownloadPlugin(url, a.settings.PluginDirectory)

	a.datastore.Store(entry)

	plugins, _ := a.datastore.Get()

	return plugins
}

func (a *App) DeletePlugin(name, author string) []models.LocalPluginModel {
	id := fmt.Sprintf("%v-%v", strings.ToLower(name), strings.ToLower(author))

	pluginDatastore, err := a.datastore.Open()
	plugin := pluginDatastore[id]

	err = internal.DeletePlugin(plugin, a.settings.PluginDirectory)
	if err == nil {
		a.datastore.DeleteById(id)
	}

	plugins, _ := a.datastore.Get()

	return plugins
}

func (a *App) UpdatePlugins(plugins any) {
	fmt.Println(plugins)
	// TODO: Run  internal.DownloadPlugin(url, a.settings.PluginDirectory) in a loop
}

func (a *App) GetInstalledPlugins() []models.LocalPluginModel {
	plugins, _ := a.datastore.Get()

	return plugins
}

func (a *App) FetchRemotePlugins() []entities.RemotePluginEntity {
	var plugins []entities.RemotePluginEntity

	plugins, err := internal.DownloadPackageInformation(a.settings.InformationUrl)
	if err != nil {
		return plugins
	}

	return plugins
}
