package main

import (
	"context"
	"fmt"
	"github.com/mawilms/lembas/internal/entities"
	"github.com/mawilms/lembas/internal/models"
	"github.com/mawilms/lembas/internal/processes"
	"github.com/mawilms/lembas/internal/settings"
	"log/slog"
	"os"
)

type App struct {
	ctx           context.Context
	logger        *slog.Logger
	settings      settings.Settings
	datastore     models.DatastoreInterface
	localPlugins  []entities.LocalPluginEntity
	remotePlugins []entities.RemotePluginEntity
}

func NewApp() *App {
	s, _ := settings.New()
	datastore, _ := models.NewDatastore(s.DataDirectory)

	loggerHandler := slog.NewTextHandler(os.Stdout, nil)
	logger := slog.New(loggerHandler)

	return &App{logger: logger, settings: s, datastore: datastore}
}

func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}

func (a *App) SearchLocal(input string) []entities.LocalPluginEntity {
	plugins := processes.SearchLocal(input, a.localPlugins)

	return plugins
}

func (a *App) SearchRemote(input string) []entities.RemotePluginEntity {
	plugins := processes.SearchRemote(input, a.remotePlugins)

	return plugins
}

func (a *App) SaveSettings(input map[string]string) {
	newSettings := settings.Settings{
		PluginDirectory: input["pluginPath"],
		DataDirectory:   input["dataDirectory"],
		InfoUrl:         input["infoUrl"],
	}

	err := newSettings.Store()
	if err != nil {
		a.settings = newSettings
	}
}

func (a *App) GetSettings() settings.Settings {
	return a.settings
}

func (a *App) InstallPlugin(url string) []entities.RemotePluginEntity {
	plugins, err := processes.InstallPlugin(a.datastore, url, a.settings.PluginDirectory, a.remotePlugins)
	if err != nil {
		return make([]entities.RemotePluginEntity, 0)
	}

	a.remotePlugins = plugins

	return plugins
}

func (a *App) DeletePlugin(name, author string) []entities.LocalPluginEntity {
	plugins, err := processes.DeletePlugin(a.datastore, name, author, a.settings.PluginDirectory)
	if err != nil {
		return make([]entities.LocalPluginEntity, 0)
	}

	a.localPlugins = plugins

	return plugins
}

func (a *App) UpdatePlugins(plugins any) {
	fmt.Println(plugins)
	// TODO: Run  internal.DownloadPlugin(url, a.settings.PluginDirectory) in a loop
}

func (a *App) GetInstalledPlugins() []entities.LocalPluginEntity {
	a.logger.Info("loading installed plugins")

	plugins, err := processes.GetInstalledPlugins(a.datastore)
	if err != nil {
		a.logger.Error(err.Error())
		return make([]entities.LocalPluginEntity, 0)
	}

	a.localPlugins = plugins

	a.logger.Info("local plugins successfully loaded")
	return plugins
}

func (a *App) GetRemotePlugins() []entities.RemotePluginEntity {
	a.logger.Info("loading remote plugins")

	plugins, err := processes.GetRemotePlugins(a.settings.InfoUrl, a.localPlugins)
	if err != nil {
		return make([]entities.RemotePluginEntity, 0)
	}

	a.remotePlugins = plugins

	a.logger.Info("remote plugins successfully loaded")
	return plugins
}
