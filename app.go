package main

import (
	"context"
	"log/slog"
	"os"
	"path/filepath"

	"github.com/mawilms/lembas/internal"
)

type App struct {
	ctx          context.Context
	logger       *slog.Logger
	settings     *internal.Settings
	addonModel   internal.DatabaseInterface
	installer    internal.InstallerInterface
	localAddons  map[int]internal.Addon
	remoteAddons map[int]internal.Addon
}

func NewApp() *App {
	loggerHandler := slog.NewTextHandler(os.Stdout, nil)
	logger := slog.New(loggerHandler)

	userDirectory := internal.UserDirectory{}
	addonsDirectory, err := userDirectory.CreateAddonsDir()
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
		AddonDirectory: addonsDirectory}
	if err = internal.WriteSettings(settings, lembasDirectory); err != nil {
		return nil
	}

	database := &internal.Database{DbUrl: filepath.Join(lembasDirectory, "db.sqlite")}
	if err = database.SetupDb(); err != nil {
		return nil
	}

	installer := &internal.Installer{}

	return &App{
		logger:     logger,
		settings:   &settings,
		addonModel: database,
		installer:  installer,
	}
}

func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}
