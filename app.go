package main

import (
	"context"
	"fmt"
	"github.com/mawilms/lembas/internal"
	"github.com/mawilms/lembas/internal/models"
)

type App struct {
	ctx       context.Context
	datastore internal.DatastoreInterface
}

func NewApp(datastore internal.DatastoreInterface) *App {
	return &App{datastore: datastore}
}

func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}

func (a *App) Greet(name string) string {
	return fmt.Sprintf("Hello %s, It's show time!", name)
}

func (a *App) InstallPlugin(url string) {
	fmt.Println(url)
}

func (a *App) FetchRemotePlugins() []models.RemotePluginModel {
	var plugins []models.RemotePluginModel

	plugins, err := internal.DownloadPackageInformation()
	if err != nil {
		return plugins
	}

	return plugins
}
