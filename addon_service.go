package main

import (
	"github.com/labstack/gommon/log"
	"github.com/mawilms/lembas/internal"
)

func (a *App) GetLocalAddons(forceReload bool) internal.AddonMap {
	if len(a.localAddons) > 0 && !forceReload {
		return internal.AddonMap{LocalAddons: a.localAddons, RemoteAddons: a.remoteAddons}
	}

	// TODO: Hier erstmal alle RemoteAddons auf installed = false setzen

	dbAddons, err := a.addonModel.Get()
	if err != nil {
		return internal.AddonMap{}
	}

	var addons = make(map[int]internal.Addon)

	for _, e := range dbAddons {
		if remoteAddon, exists := a.remoteAddons[e.Id]; exists {
			e.HasUpdate = internal.HasUpdate(e, remoteAddon)

			remoteAddon.HasUpdate = internal.HasUpdate(e, remoteAddon)
			a.remoteAddons[e.Id] = remoteAddon
		}
		addons[e.Id] = e
	}

	a.localAddons = addons

	return internal.AddonMap{
		LocalAddons:  a.localAddons,
		RemoteAddons: a.remoteAddons,
	}
}

func (a *App) GetRemoteAddons(forceReload bool) internal.AddonMap {
	if len(a.remoteAddons) > 0 && !forceReload {
		return internal.AddonMap{RemoteAddons: a.remoteAddons, LocalAddons: a.localAddons}
	}

	remoteAddons, err := a.api.Get()
	if err != nil {
		return internal.AddonMap{}
	}

	addons := make(map[int]internal.Addon)

	for _, e := range remoteAddons {
		if localAddon, exists := a.localAddons[e.Id]; exists {
			e.IsInstalled = true
			e.HasUpdate = internal.HasUpdate(localAddon, e)
		}
		addons[e.Id] = e
	}

	a.remoteAddons = addons

	return internal.AddonMap{RemoteAddons: addons, LocalAddons: a.localAddons}
}

func (a *App) GetAddons() internal.AddonMap {
	localAddons := a.GetLocalAddons(false)
	remoteAddons := a.GetRemoteAddons(false)

	finalizedAddons := internal.InitialLoading(localAddons.LocalAddons, remoteAddons.RemoteAddons)

	a.localAddons = finalizedAddons.LocalAddons
	a.remoteAddons = remoteAddons.RemoteAddons

	return finalizedAddons
}

func (a *App) InstallAddon(id int, force bool) internal.AddonMap {
	addon := a.remoteAddons[id]

	newAddon, err := a.installer.Install(addon, *a.settings, a.addonModel)
	if err != nil {
		log.Infof("%v", err)
		return internal.AddonMap{}
	}

	a.localAddons[id] = newAddon
	a.remoteAddons[id] = internal.Addon{
		Id:             a.remoteAddons[id].Id,
		Type:           a.remoteAddons[id].Type,
		Name:           a.remoteAddons[id].Name,
		Author:         a.remoteAddons[id].Author,
		Description:    a.remoteAddons[id].Description,
		CurrentVersion: a.remoteAddons[id].LatestVersion,
		LatestVersion:  a.remoteAddons[id].CurrentVersion,
		Category:       a.remoteAddons[id].Category,
		Downloads:      a.remoteAddons[id].Downloads,
		UpdatedAt:      a.remoteAddons[id].UpdatedAt,
		ArchiveName:    a.remoteAddons[id].ArchiveSize,
		ArchiveSize:    a.remoteAddons[id].ArchiveSize,
		HasUpdate:      false,
		IsInstalled:    true,
	}

	return internal.AddonMap{LocalAddons: a.localAddons, RemoteAddons: a.remoteAddons}
}

func (a *App) UpdateAddon(id int) {
	log.Infof("%v", id)
}

func (a *App) DeleteAddon(id int) {
	log.Infof("%v", id)
}
