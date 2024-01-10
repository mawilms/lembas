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
	process       processes.Process
	localPlugins  []entities.LocalPluginEntity
	remotePlugins []entities.RemotePluginEntity
}

func NewApp() *App {
	loggerHandler := slog.NewTextHandler(os.Stdout, nil)
	logger := slog.New(loggerHandler)

	s, err := settings.New()
	if err != nil {
		logger.Error("Error while initializing settings", slog.String("err", err.Error()))
		os.Exit(1)
	}

	datastore, err := models.NewDatastore(s.DataDirectory)
	if err != nil {
		logger.Error("Error while initializing datastore", slog.String("err", err.Error()))
		os.Exit(1)
	}
	process := processes.Process{Logger: logger}

	return &App{logger: logger, settings: s, datastore: datastore, process: process}
}

func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}

func (a *App) SearchLocal(input string) []entities.LocalPluginEntity {
	plugins := a.process.SearchLocal(input, a.localPlugins)

	return plugins
}

func (a *App) SearchRemote(input string) []entities.RemotePluginEntity {
	plugins := a.process.SearchRemote(input, a.remotePlugins)

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
	a.logger.Info("trying to install plugin", slog.String("url", url))

	plugins, err := a.process.InstallPlugin(a.datastore, url, a.settings.PluginDirectory, a.remotePlugins)
	if err != nil {
		a.logger.Error("failed to install plugin", slog.String("url", url), slog.String("error", err.Error()))
		return make([]entities.RemotePluginEntity, 0)
	}
	a.logger.Info("successfully installed plugin", slog.String("url", url))

	a.remotePlugins = plugins

	return plugins
}

func (a *App) DeletePlugin(name, author string) []entities.LocalPluginEntity {
	a.logger.Info("trying to delete plugin", slog.String("name", name), slog.String("author", author))

	plugins, err := a.process.DeletePlugin(a.datastore, name, author, a.settings.PluginDirectory)
	if err != nil {
		a.logger.Error("failed to delete plugin", slog.String("name", name), slog.String("author", author), slog.String("error", err.Error()))
		return make([]entities.LocalPluginEntity, 0)
	}
	a.logger.Info("successfully deleted plugin", slog.String("name", name), slog.String("author", author))

	a.localPlugins = plugins

	return plugins
}

func (a *App) UpdatePlugins(plugins any) {
	fmt.Println(plugins)
	// TODO: Run  internal.DownloadPlugin(url, a.settings.PluginDirectory) in a loop
}

func (a *App) GetInstalledPlugins() []entities.LocalPluginEntity {
	a.logger.Info("loading installed plugins")

	plugins, err := a.process.GetInstalledPlugins(a.datastore)
	if err != nil {
		a.logger.Error("failed to get installed plugins", slog.String("error", err.Error()))
		return make([]entities.LocalPluginEntity, 0)
	}

	a.localPlugins = plugins

	a.logger.Info("local plugins successfully loaded", slog.Int("amount plugins", len(a.localPlugins)))
	return plugins
}

func (a *App) GetRemotePlugins() []entities.RemotePluginEntity {
	a.logger.Info("loading remote plugins")

	plugins, err := a.process.GetRemotePlugins(a.settings.InfoUrl, a.localPlugins)
	if err != nil {
		a.logger.Error("failed to get fetch remote plugins", slog.String("feed url", a.settings.InfoUrl), slog.String("error", err.Error()))
		return make([]entities.RemotePluginEntity, 0)
	}

	a.remotePlugins = plugins

	a.logger.Info("remote plugins successfully loaded", slog.Int("amount plugins", len(a.remotePlugins)))
	return plugins
}
