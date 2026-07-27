package main

import (
	"context"
	"log/slog"
	"os"

	"github.com/mawilms/lembas/internal"
	"github.com/mawilms/lembas/internal/database"
)

type App struct {
	ctx          context.Context
	logger       *slog.Logger
	pluginModel  database.IAddonModel
	localAddons  map[string]internal.ParentAddon
	remoteAddons map[string]internal.ParentAddon
}

func NewApp() *App {
	loggerHandler := slog.NewTextHandler(os.Stdout, nil)
	logger := slog.New(loggerHandler)

	userDirectory := internal.UserDirectory{}
	if err := userDirectory.CreatePluginsDir(); err != nil {
		return nil
	}

	appDataDirectory := internal.AppDataDirectory{}
	if err := appDataDirectory.CreateLembasDir(); err != nil {
		return nil
	}

	return &App{
		logger:      logger,
		pluginModel: &database.AddonModel{},
	}
}

func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}
