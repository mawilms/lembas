package processes

import (
	"fmt"
	"github.com/mawilms/lembas/internal"
	"github.com/mawilms/lembas/internal/entities"
	"github.com/mawilms/lembas/internal/models"
	"log/slog"
	"sort"
	"strings"
)

type Process struct {
	Logger *slog.Logger
}

func BuildPluginIndex(name, author string) string {
	return fmt.Sprintf("%v-%v", strings.Replace(strings.ToLower(name), " ", "", -1), strings.Replace(strings.ToLower(author), " ", "", -1))
}

func (p Process) SearchLocal(input string, plugins []entities.LocalPluginEntity) []entities.LocalPluginEntity {
	input = strings.ToLower(input)
	if input == "" {
		return plugins
	}

	filteredPlugins := make([]entities.LocalPluginEntity, 0)
	for _, plugin := range plugins {
		if strings.Contains(strings.ToLower(plugin.Base.Name), input) {
			filteredPlugins = append(filteredPlugins, plugin)
		}
	}

	return filteredPlugins
}

func (p Process) SearchRemote(input string, plugins []entities.RemotePluginEntity) []entities.RemotePluginEntity {
	input = strings.ToLower(input)
	if input == "" {
		return plugins
	}

	filteredPlugins := make([]entities.RemotePluginEntity, 0)
	for _, plugin := range plugins {
		if strings.Contains(strings.ToLower(plugin.Base.Name), input) {
			filteredPlugins = append(filteredPlugins, plugin)
		}
	}

	return filteredPlugins
}

func (p Process) InstallPlugin(datastore models.DatastoreInterface, url, pluginDirectory string, remotePlugins []entities.RemotePluginEntity) ([]entities.RemotePluginEntity, error) {
	entry, _ := internal.DownloadPlugin(url, pluginDirectory)
	id := BuildPluginIndex(entry.Plugin.Name, entry.Plugin.Author)
	err := datastore.Store(id, entry)
	if err != nil {
		p.Logger.Error("failed to store plugin in local datastore", slog.String("id", id), slog.String("url", url))
		return nil, err
	}

	for _, dependency := range entry.Plugin.Dependencies {
		url := fmt.Sprintf("https://www.lotrointerface.com/downloads/download%v", dependency)
		entry, _ = internal.DownloadPlugin(url, pluginDirectory)
		identifier := BuildPluginIndex(entry.Plugin.Name, entry.Plugin.Author)
		err = datastore.Store(identifier, entry)
		if err != nil {
			p.Logger.Error("failed to store plugin in local datastore", slog.String("id", id), slog.String("url", url))
			return nil, err
		}
	}

	storedPlugins, err := datastore.Get()
	if err != nil {
		p.Logger.Error("failed to retrieve plugins from the local datastore", slog.String("error", err.Error()))
		return remotePlugins, err
	}

	installedPlugins := make(map[string]string)
	for _, storedPlugin := range storedPlugins {
		installedPlugins[BuildPluginIndex(storedPlugin.Name, storedPlugin.Author)] = storedPlugin.LatestVersion
	}

	for i, remotePlugin := range remotePlugins {
		installedVersion, ok := installedPlugins[BuildPluginIndex(remotePlugin.Base.Name, remotePlugin.Base.Author)]
		if ok {
			remotePlugins[i].IsInstalled = true
			remotePlugins[i].Base.CurrentVersion = installedVersion
		}
	}

	sort.Slice(remotePlugins, func(i, j int) bool {
		return remotePlugins[i].Base.Name < remotePlugins[j].Base.Name
	})

	return remotePlugins, nil
}

func (p Process) GetRemotePlugins(url string, localPlugins []entities.LocalPluginEntity) ([]entities.RemotePluginEntity, error) {
	remotePlugins, err := internal.DownloadPackageInformation(url)
	if err != nil {
		p.Logger.Error("failure in the plugin downloading process", slog.String("url", url), slog.String("error", err.Error()))
		return make([]entities.RemotePluginEntity, 0), err
	}

	localPluginNames := make(map[string]string)
	for _, localPlugin := range localPlugins {
		index := BuildPluginIndex(localPlugin.Base.Name, localPlugin.Base.Author)
		_, ok := localPluginNames[index]
		if !ok {
			localPluginNames[index] = localPlugin.Base.CurrentVersion
		}
	}

	for index, remotePlugin := range remotePlugins {
		pluginIndex := BuildPluginIndex(remotePlugin.Base.Name, remotePlugin.Base.Author)
		_, ok := localPluginNames[pluginIndex]
		if ok {
			remotePlugins[index].IsInstalled = true
			remotePlugins[index].Base.CurrentVersion = localPluginNames[pluginIndex]
		}
	}

	sort.Slice(remotePlugins, func(i, j int) bool {
		return remotePlugins[i].Base.Name < remotePlugins[j].Base.Name
	})

	return remotePlugins, nil
}

func (p Process) GetInstalledPlugins(datastore models.DatastoreInterface) ([]entities.LocalPluginEntity, error) {
	localPlugins := make([]entities.LocalPluginEntity, 0)

	storedPlugins, err := datastore.Get()
	if err != nil {
		p.Logger.Error("failed to retrieve plugins from the local datastore", slog.String("error", err.Error()))
		return localPlugins, err
	}

	for _, plugin := range storedPlugins {
		localPlugins = append(localPlugins, entities.LocalPluginEntity{
			Base:         models.NewBasePlugin(plugin.Id, plugin.Name, plugin.Description, plugin.Author, plugin.CurrentVersion, plugin.LatestVersion),
			Descriptors:  plugin.Descriptors,
			Dependencies: plugin.Dependencies,
		})
	}

	sort.Slice(localPlugins, func(i, j int) bool {
		return localPlugins[i].Base.Name < localPlugins[j].Base.Name
	})

	return localPlugins, nil
}

func (p Process) DeletePlugin(datastore models.DatastoreInterface, name, author, pluginDirectory string) ([]entities.LocalPluginEntity, error) {
	plugins := make([]entities.LocalPluginEntity, 0)
	id := BuildPluginIndex(name, author)

	pluginDatastore, err := datastore.Open()
	plugin := pluginDatastore[id]

	err = internal.DeletePlugin(plugin, pluginDirectory)
	if err == nil {
		p.Logger.Error("failed to delete plugin", slog.String("name", name), slog.String("author", author), slog.String("error", err.Error()))
		err = datastore.DeleteById(id)
		if err != nil {
			p.Logger.Error("failed to delete entry from datastore", slog.String("id", id))
			return plugins, err
		}
	}

	localPlugins, err := datastore.Get()
	if err != nil {
		p.Logger.Error("failed to retrieve plugins from the local datastore", slog.String("error", err.Error()))
		return plugins, err
	}

	for _, plugin := range localPlugins {
		plugins = append(plugins, entities.LocalPluginEntity{
			Base:         models.NewBasePlugin(plugin.Id, plugin.Name, plugin.Description, plugin.Author, plugin.CurrentVersion, plugin.LatestVersion),
			Descriptors:  plugin.Descriptors,
			Dependencies: plugin.Dependencies,
		})
	}

	sort.Slice(localPlugins, func(i, j int) bool {
		return plugins[i].Base.Name < plugins[j].Base.Name
	})

	return plugins, nil
}
