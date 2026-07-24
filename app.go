package main

import (
	"context"
	"log/slog"
	"os"

	"github.com/mawilms/lembas/internal/database"
	"github.com/mawilms/lembas/internal/remote"
)

type App struct {
	ctx         context.Context
	logger      *slog.Logger
	pluginModel *database.AddonModel
}

func NewApp() *App {
	loggerHandler := slog.NewTextHandler(os.Stdout, nil)
	logger := slog.New(loggerHandler)

	return &App{logger: logger}
}

func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}

func (a *App) GetLocalAddons() []database.Addon {
	addons, err := a.pluginModel.Get()
	if err != nil {
		a.logger.Error("failed to get local plugins", err.Error())
		return nil
	}

	return addons
}

func (a *App) GetRemoteAddons() []remote.RemoteAddon {
	api := remote.Api{}
	url := "https://api.lotrointerface.com/fav/plugincompendium.xml"

	response, err := api.GetSourceXml(url)
	if err != nil {
		a.logger.Error("failed to get fetch remote plugins", slog.String("feed url", url), slog.String("error", err.Error()))
		return nil
	}

	xmlModel, err := remote.ParseXmlResponse(response)
	if err != nil {
		a.logger.Error("failed to get fetch remote plugins", slog.String("feed url", url), slog.String("error", err.Error()))
		return make([]remote.RemoteAddon, 0)
	}

	addons := make([]remote.RemoteAddon, 0)

	for _, model := range xmlModel {
		addons = append(addons, remote.New(model))
	}

	return addons
}
