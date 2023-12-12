package main

import (
	"embed"
	"github.com/mawilms/lembas/internal"
	"github.com/mawilms/lembas/internal/settings"

	"github.com/wailsapp/wails/v2"
	"github.com/wailsapp/wails/v2/pkg/options"
	"github.com/wailsapp/wails/v2/pkg/options/assetserver"
)

//go:embed all:frontend/build
var assets embed.FS

func main() {
	datastore := internal.Datastore{
		Path: "Bla", // TODO: Set home dir for database
	}
	datastore.New()

	s, _ := settings.New()

	app := NewApp(s, datastore)

	err := wails.Run(&options.App{
		Title:  "lembas",
		Width:  1024,
		Height: 768,
		AssetServer: &assetserver.Options{
			Assets: assets,
		},
		BackgroundColour: &options.RGBA{R: 27, G: 38, B: 54, A: 1},
		OnStartup:        app.startup,
		Bind: []interface{}{
			app,
		},
	})

	if err != nil {
		println("Error:", err.Error())
	}
}
