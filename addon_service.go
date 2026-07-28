package main

import (
	"log/slog"
	"path/filepath"
	"time"

	"github.com/labstack/gommon/log"
	"github.com/mawilms/lembas/internal"
)

type AddonMap struct {
	LocalAddons  map[int]internal.Addon `json:"localAddons"`
	RemoteAddons map[int]internal.Addon `json:"remoteAddons"`
}

func (a *App) GetLocalAddons(forceReload bool) AddonMap {
	if len(a.localAddons) > 0 && !forceReload {
		return AddonMap{LocalAddons: a.localAddons, RemoteAddons: a.remoteAddons}
	}

	dbPath := filepath.Join(a.settings.DataDirectory, "db.sqlite")

	dbAddons, err := a.addonModel.Get(dbPath)
	if err != nil {
		return AddonMap{}
	}

	var addons = make(map[int]internal.Addon)

	for _, e := range dbAddons {
		addons[e.Id] = e
	}

	a.localAddons = addons

	return AddonMap{LocalAddons: addons, RemoteAddons: a.remoteAddons}
}

func (a *App) GetRemoteAddons(force bool) AddonMap {
	if len(a.remoteAddons) > 0 && !force {
		return AddonMap{RemoteAddons: a.remoteAddons, LocalAddons: a.localAddons}
	}

	api := internal.Api{
		Url: a.settings.FavoritesUrl,
	}

	response, err := api.GetSourceXml()
	if err != nil {
		a.logger.Error("failed to get fetch remote plugins", slog.String("feed url", api.Url), slog.String("error", err.Error()))
		return AddonMap{}
	}

	xmlModel, err := internal.ParseXmlResponse(response)
	if err != nil {
		a.logger.Error("failed to get fetch remote plugins", slog.String("feed url", api.Url), slog.String("error", err.Error()))
		return AddonMap{}
	}

	addons := make(map[int]internal.Addon)

	for _, e := range xmlModel {
		addons[e.Uid] = internal.Addon{
			Id:             e.Uid,
			Type:           "remote",
			Name:           e.Name,
			Author:         e.Author,
			Description:    e.Description,
			CurrentVersion: e.Version,
			LatestVersion:  e.Version,
			Category:       e.Category,
			Downloads:      e.Downloads,
			UpdatedAt:      time.Unix(e.Updated, 0).Local().Format("01/02/2006"),
			ArchiveName:    e.File,
			ArchiveSize:    internal.FormatArchiveSize(e.Size),
			HasUpdate:      false,
			IsInstalled:    false,
		}
	}

	a.remoteAddons = addons

	return AddonMap{RemoteAddons: addons, LocalAddons: a.localAddons}
}

func (a *App) GetAddons() AddonMap {
	localAddons := a.GetLocalAddons(false)
	remoteAddons := a.GetRemoteAddons(false)

	mergedAddons := internal.UpdateVersions(localAddons.LocalAddons, remoteAddons.RemoteAddons)

	a.localAddons = internal.UpdateLocalAddons(mergedAddons)
	a.remoteAddons = mergedAddons

	return AddonMap{
		LocalAddons:  a.localAddons,
		RemoteAddons: a.remoteAddons,
	}
}

func (a *App) InstallAddon(id int, force bool) AddonMap {
	addon := a.remoteAddons[id]

	newAddon, err := internal.Install(addon, *a.settings, a.addonModel)
	if err != nil {
		log.Infof("%v", err)
		return AddonMap{}
	}

	a.localAddons[id] = newAddon

	return AddonMap{LocalAddons: a.localAddons, RemoteAddons: a.remoteAddons}
}

func (a *App) UpdateAddon(id int) {
	log.Infof("%v", id)
}

func (a *App) DeleteAddon(id int) {
	log.Infof("%v", id)
}
