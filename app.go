package main

import (
	"context"
	"log/slog"
	"os"

	"github.com/mawilms/lembas/internal"
)

type App struct {
	ctx          context.Context
	logger       *slog.Logger
	settings     *internal.Settings
	addonModel   internal.DatabaseInterface
	localAddons  map[int]internal.Addon
	remoteAddons map[int]internal.Addon
}

func NewApp() *App {
	loggerHandler := slog.NewTextHandler(os.Stdout, nil)
	logger := slog.New(loggerHandler)

	userDirectory := internal.UserDirectory{}
	addonsDirecotry, err := userDirectory.CreateAddonsDir()
	if err != nil {
		return nil
	}

	appDataDirectory := internal.AppDataDirectory{}
	if err := appDataDirectory.CreateLembasDir(); err != nil {
		return nil
	}

	lembasDirectory, err := appDataDirectory.GetLembasDir()
	if err != nil {
		return nil
	}

	settings := internal.Settings{
		FavoritesUrl:   "https://api.lotrointerface.com/fav/plugincompendium.xml",
		BaseUrl:        "https://www.lotrointerface.com/downloads",
		DownloadPath:   os.TempDir(),
		DataDirectory:  lembasDirectory,
		AddonDirectory: addonsDirecotry}
	if err = internal.WriteSettings(settings, lembasDirectory); err != nil {
		return nil
	}

	return &App{
		logger:     logger,
		settings:   &settings,
		addonModel: &internal.Database{},
	}
}

func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}
