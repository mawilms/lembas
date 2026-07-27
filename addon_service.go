package main

import (
	"fmt"
	"log/slog"
	"time"

	"github.com/labstack/gommon/log"
	"github.com/mawilms/lembas/internal"
	"github.com/mawilms/lembas/internal/remote"
)

type ParentAddonMap struct {
	Items map[string]internal.ParentAddon `json:"items"`
}

func (a *App) GetLocalAddons() ParentAddonMap {
	if len(a.localAddons) > 0 {
		return ParentAddonMap{Items: a.localAddons}
	}

	dbAddons, err := a.pluginModel.Get()
	if err != nil {
		return ParentAddonMap{}
	}

	var addons = make(map[string]internal.ParentAddon)

	for _, e := range dbAddons {
		addons[fmt.Sprintf("%s_%s", e.Name, e.Author)] = internal.ParentAddon{
			Id:          e.Id,
			Type:        "local",
			Name:        e.Name,
			Author:      e.Author,
			Description: e.Description,
			Version:     e.Version,
			Category:    e.Category,
			Downloads:   e.Downloads,
			UpdatedAt:   e.UpdatedAt,
			ArchiveName: e.ArchiveName,
			ArchiveSize: e.ArchiveSize,
			HasUpdate:   false, // Check before
			IsInstalled: true,
		}
	}

	a.localAddons = addons

	return ParentAddonMap{Items: addons}
}

func (a *App) GetRemoteAddons() ParentAddonMap {
	if len(a.remoteAddons) > 0 {
		return ParentAddonMap{Items: a.remoteAddons}
	}

	api := remote.Api{
		Url: "https://api.lotrointerface.com/fav/plugincompendium.xml",
	}

	response, err := api.GetSourceXml()
	if err != nil {
		a.logger.Error("failed to get fetch remote plugins", slog.String("feed url", api.Url), slog.String("error", err.Error()))
		return ParentAddonMap{}
	}

	xmlModel, err := remote.ParseXmlResponse(response)
	if err != nil {
		a.logger.Error("failed to get fetch remote plugins", slog.String("feed url", api.Url), slog.String("error", err.Error()))
		return ParentAddonMap{}
	}

	addons := make(map[string]internal.ParentAddon)

	for _, e := range xmlModel {
		addons[fmt.Sprintf("%s_%s", e.Name, e.Author)] = internal.ParentAddon{
			Id:          e.Uid,
			Type:        "remote",
			Name:        e.Name,
			Author:      e.Author,
			Description: e.Description,
			Version:     e.Version,
			Category:    e.Category,
			Downloads:   e.Downloads,
			UpdatedAt:   time.Unix(e.Updated, 0).Local().Format("01/02/2006"),
			ArchiveName: e.File,
			ArchiveSize: internal.FormatArchiveSize(e.Size),
			HasUpdate:   false,
			IsInstalled: false,
		}
	}

	a.remoteAddons = addons

	return ParentAddonMap{Items: addons}
}

func (a *App) GetAddons() ParentAddonMap {
	localAddons := a.GetLocalAddons()
	remoteAddons := a.GetRemoteAddons()

	return ParentAddonMap{
		Items: internal.MergeAddons(localAddons.Items, remoteAddons.Items),
	}
}

func (a *App) InstallAddon(id int, force bool) {
	log.Infof("%v", id)
}

func (a *App) UpdateAddon(id int) {
	log.Infof("%v", id)
}

func (a *App) DeleteAddon(id int) {
	log.Infof("%v", id)
}
