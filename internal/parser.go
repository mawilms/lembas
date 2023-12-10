package internal

import (
	"bytes"
	"encoding/xml"
	"strings"

	"github.com/mawilms/lembas/internal/models"
)

type descriptors struct {
	Descriptor []string `xml:"descriptor"`
}

type dependencies struct {
	Id []int `xml:"dependency"`
}

type pluginConfig struct {
	Id           int          `xml:"Id"`
	Name         string       `xml:"Name"`
	Version      string       `xml:"Version"`
	Author       string       `xml:"Author"`
	InfoUrl      string       `xml:"InfoUrl"`
	DownloadUrl  string       `xml:"DownloadUrl"`
	Descriptors  descriptors  `xml:"descriptors"`
	Dependencies dependencies `xml:"dependencies"`
}

func ParseConfig(content []byte) (models.InstalledPlugin, error) {
	var pluginConfig pluginConfig

	err := xml.Unmarshal(content, &pluginConfig)
	if err != nil {
		return models.InstalledPlugin{}, err
	}

	return mapPluginConfigToInstalledPlugin(&pluginConfig), nil
}

func mapPluginConfigToInstalledPlugin(config *pluginConfig) models.InstalledPlugin {
	var descriptors []string
	var dependencies []int

	for _, descriptor := range config.Descriptors.Descriptor {
		descriptors = append(descriptors, descriptor)
	}

	for _, id := range config.Dependencies.Id {
		dependencies = append(dependencies, id)
	}

	return models.InstalledPlugin{
		Id:           config.Id,
		Name:         config.Name,
		Version:      config.Version,
		Author:       config.Author,
		InfoUrl:      config.InfoUrl,
		DownloadUrl:  config.DownloadUrl,
		Descriptors:  descriptors,
		Dependencies: dependencies,
	}
}

type favorite struct {
	Ui []ui `xml:"ui"`
}

type ui struct {
	Id               int    `xml:"UID"`
	Name             string `xml:"UIName"`
	Author           string `xml:"UIAuthorName"`
	Version          string `xml:"UIVersion"`
	UpdatedTimestamp int    `xml:"UIUpdated"`
	Downloads        int    `xml:"UIDownloads"`
	Category         string `xml:"UICategory"`
	Description      string `xml:"UIDescription"`
	FileName         string `xml:"UIFile"`
	Url              string `xml:"UIFileURL"`
}

func ParseFeed(content []byte) ([]models.RemotePlugin, error) {
	var favorite favorite

	decoder := xml.NewDecoder(bytes.NewReader(content))
	decoder.Strict = false

	err := decoder.Decode(&favorite)
	if err != nil {
		return make([]models.RemotePlugin, 0), err
	}

	plugins := mapFavoritesToRemotePlugins(&favorite)
	return plugins, nil
}

func mapFavoritesToRemotePlugins(favorite *favorite) []models.RemotePlugin {
	var plugins []models.RemotePlugin

	for _, plugin := range favorite.Ui {
		plugins = append(plugins, models.RemotePlugin{
			Id: plugin.Id, Name: plugin.Name, Author: plugin.Author, Version: plugin.Version,
			UpdatedTimestamp: plugin.UpdatedTimestamp, Downloads: plugin.Downloads,
			Category: plugin.Category, Description: strings.Trim(plugin.Description, "\n\t"), FileName: plugin.FileName, Url: strings.Trim(plugin.Url, "\n\t"),
		})
	}

	return plugins
}
