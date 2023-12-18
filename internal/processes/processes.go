package processes

import (
	"fmt"
	"github.com/mawilms/lembas/internal"
	"github.com/mawilms/lembas/internal/entities"
	"github.com/mawilms/lembas/internal/models"
	"sort"
	"strings"
)

func BuildPluginIndex(name, author string) string {
	return fmt.Sprintf("%v-%v", strings.ToLower(name), strings.ToLower(author))
}

func SearchLocal(input string, plugins []entities.LocalPluginEntity) []entities.LocalPluginEntity {
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

func SearchRemote(input string, plugins []entities.RemotePluginEntity) []entities.RemotePluginEntity {
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

func InstallPlugin(datastore models.DatastoreInterface, url, pluginDirectory string, remotePlugins []entities.RemotePluginEntity) ([]entities.RemotePluginEntity, error) {
	entry, _ := internal.DownloadPlugin(url, pluginDirectory)
	datastore.Store(entry)

	for _, dependency := range entry.Plugin.Dependencies {
		url := fmt.Sprintf("https://www.lotrointerface.com/downloads/download%v", dependency)
		entry, _ = internal.DownloadPlugin(url, pluginDirectory)
		datastore.Store(entry)
	}

	storedPlugins, err := datastore.Get()
	if err != nil {
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

func GetRemotePlugins(url string, localPlugins []entities.LocalPluginEntity) ([]entities.RemotePluginEntity, error) {
	remotePlugins := make([]entities.RemotePluginEntity, 0)

	remotePlugins, err := internal.DownloadPackageInformation(url)
	if err != nil {
		return remotePlugins, err
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

func GetInstalledPlugins(datastore models.DatastoreInterface) ([]entities.LocalPluginEntity, error) {
	localPlugins := make([]entities.LocalPluginEntity, 0)

	storedPlugins, err := datastore.Get()
	if err != nil {
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

func DeletePlugin(datastore models.DatastoreInterface, name, author, pluginDirectory string) ([]entities.LocalPluginEntity, error) {
	plugins := make([]entities.LocalPluginEntity, 0)
	id := BuildPluginIndex(name, author)

	pluginDatastore, err := datastore.Open()
	plugin := pluginDatastore[id]

	err = internal.DeletePlugin(plugin, pluginDirectory)
	if err == nil {
		err = datastore.DeleteById(id)
		if err != nil {
			return nil, err
		}
	}

	localPlugins, err := datastore.Get()
	if err != nil {
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
