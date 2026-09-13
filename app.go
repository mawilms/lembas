package main

import (
	"context"
	"os"
	"path/filepath"

	"github.com/labstack/gommon/log"
	"github.com/mawilms/lembas/internal"
)

type App struct {
	ctx          context.Context
	settings     internal.Settings
	addonModel   internal.DatabaseInterface
	installer    internal.InstallerInterface
	api          internal.ApiInterface
	localAddons  map[int]internal.Addon
	remoteAddons map[int]internal.Addon
}

func NewApp() *App {
	userDirectory := internal.UserDirectory{}
	addonsDirectory, err := userDirectory.CreateAddonsDir()
	if err != nil {
		log.Fatalf("Got error %v", err)
		return nil
	}

	appDataDirectory := internal.AppDataDirectory{}
	if err := appDataDirectory.CreateLembasDir(); err != nil {
		log.Fatalf("Got error %v", err)
		return nil
	}

	lembasDirectory, err := appDataDirectory.GetLembasDir()
	if err != nil {
		log.Fatalf("Got error %v", err)
		return nil
	}

	settings := internal.Settings{
		FavoritesUrl:   "https://api.lotrointerface.com/fav/plugincompendium.xml",
		BaseUrl:        "https://www.lotrointerface.com/downloads",
		DownloadPath:   os.TempDir(),
		DataDirectory:  lembasDirectory,
		AddonDirectory: addonsDirectory}
	if err = internal.WriteSettings(settings, lembasDirectory); err != nil {
		log.Fatalf("Got error %v", err)
		return nil
	}

	database := &internal.Database{DbUrl: filepath.Join(lembasDirectory, "db.sqlite")}
	if err = database.SetupDb(); err != nil {
		log.Fatalf("Got error %v", err)
		return nil
	}

	return &App{
		settings:   settings,
		addonModel: database,
		installer:  &internal.Installer{},
		api: &internal.Api{
			Url: settings.FavoritesUrl,
		},
	}
}

func (a *App) startup(ctx context.Context) {
	a.ctx = ctx
}
