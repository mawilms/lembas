package main

import (
	"github.com/labstack/gommon/log"
	"github.com/mawilms/lembas/internal"
	"github.com/wailsapp/wails/v2/pkg/runtime"
)

type AddonMap struct {
	LocalAddons  map[int]internal.Addon `json:"localAddons"`
	RemoteAddons map[int]internal.Addon `json:"remoteAddons"`
}

func (a *App) GetLocalAddons(forceReload bool) AddonMap {
	if len(a.localAddons) > 0 && !forceReload {
		return AddonMap{LocalAddons: a.localAddons, RemoteAddons: a.remoteAddons}
	}

	dbAddons, err := a.addonModel.Get()
	if err != nil {
		return AddonMap{}
	}

	var addons = make(map[int]internal.Addon)

	for _, e := range dbAddons {
		addons[e.Id] = e
	}

	// TODO: Currently bugged. local addons don't have a latestVersion entry after reloading
	if len(a.remoteAddons) > 0 {
		a.localAddons = internal.UpdateLocalAddons(internal.UpdateVersions(addons, a.remoteAddons))
	} else {
		a.localAddons = addons
	}

	a.localAddons = addons

	return AddonMap{
		LocalAddons:  a.localAddons,
		RemoteAddons: a.remoteAddons,
	}
}

func (a *App) GetRemoteAddons(forceReload bool) AddonMap {
	if len(a.remoteAddons) > 0 && !forceReload {
		return AddonMap{RemoteAddons: a.remoteAddons, LocalAddons: a.localAddons}
	}

	remoteAddons, err := a.api.Get()
	if err != nil {
		return AddonMap{}
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

	return AddonMap{RemoteAddons: addons, LocalAddons: a.localAddons}
}

func (a *App) GetAddons(forceReload bool) AddonMap {
	localAddons := a.GetLocalAddons(forceReload)
	remoteAddons := a.GetRemoteAddons(false)

	mergedAddons := internal.UpdateVersions(localAddons.LocalAddons, remoteAddons.RemoteAddons)

	a.localAddons = internal.UpdateLocalAddons(mergedAddons)
	a.remoteAddons = mergedAddons

	return AddonMap{
		LocalAddons:  a.localAddons,
		RemoteAddons: a.remoteAddons,
	}
}

func (a *App) InstallAddon(id int, force bool) error {
	addon := a.remoteAddons[id]

	newAddon, err := a.installer.Install(addon, *a.settings, a.addonModel)
	if err != nil {
		log.Errorf("%v", err)
		return err
	}

	a.localAddons[id] = newAddon
	a.remoteAddons[id] = internal.Addon{
		Id:            a.remoteAddons[id].Id,
		Type:          a.remoteAddons[id].Type,
		Name:          a.remoteAddons[id].Name,
		Author:        a.remoteAddons[id].Author,
		Description:   a.remoteAddons[id].Description,
		LocalVersion:  a.remoteAddons[id].RemoteVersion,
		RemoteVersion: a.remoteAddons[id].LocalVersion,
		Category:      a.remoteAddons[id].Category,
		Downloads:     a.remoteAddons[id].Downloads,
		UpdatedAt:     a.remoteAddons[id].UpdatedAt,
		ArchiveName:   a.remoteAddons[id].ArchiveSize,
		ArchiveSize:   a.remoteAddons[id].ArchiveSize,
		HasUpdate:     false,
		IsInstalled:   true,
	}

	runtime.EventsEmit(a.ctx, "install:success", AddonMap{
		LocalAddons:  a.localAddons,
		RemoteAddons: a.remoteAddons,
	})

	return nil
}

func (a *App) UpdateAddon(id int) {
	log.Infof("%v", id)
}

func (a *App) DeleteAddon(id int) error {
	files, err := a.addonModel.GetFiles(id)
	if err != nil {
		log.Errorf("%v", err)
		return nil
	}

	if err := a.installer.DeleteFiles(a.settings.AddonDirectory, files); err != nil {
		return nil
	}

	err = a.addonModel.Delete(id)
	if err != nil {
		return nil
	}

	remoteAddon := a.remoteAddons[id]
	remoteAddon.IsInstalled = false

	a.remoteAddons[id] = remoteAddon
	delete(a.localAddons, id)

	runtime.EventsEmit(a.ctx, "delete:success", AddonMap{
		LocalAddons:  a.localAddons,
		RemoteAddons: a.remoteAddons,
	})

	return nil
}
