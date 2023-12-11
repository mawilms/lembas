package internal

import (
	"bytes"
	"encoding/xml"
	"github.com/mawilms/lembas/internal/models"
	"strings"
)

type favorite struct {
	Ui []struct {
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
	} `xml:"Ui"`
}

func ParseFeed(content []byte) ([]models.RemotePluginModel, error) {
	var favorite favorite

	decoder := xml.NewDecoder(bytes.NewReader(content))
	decoder.Strict = false

	err := decoder.Decode(&favorite)
	if err != nil {
		return make([]models.RemotePluginModel, 0), err
	}

	plugins := mapFavoritesToRemotePlugins(&favorite)
	return plugins, nil
}

func mapFavoritesToRemotePlugins(favorite *favorite) []models.RemotePluginModel {
	var plugins []models.RemotePluginModel

	for _, plugin := range favorite.Ui {
		plugins = append(plugins, models.RemotePluginModel{
			Id: plugin.Id, Name: plugin.Name, Author: plugin.Author, Version: plugin.Version,
			UpdatedTimestamp: plugin.UpdatedTimestamp, Downloads: plugin.Downloads,
			Category: plugin.Category, Description: strings.Trim(plugin.Description, "\n\t"), FileName: plugin.FileName, Url: strings.Trim(plugin.Url, "\n\t"),
		})
	}

	return plugins
}

type pluginConfig struct {
	Id          int    `xml:"Id"`
	Name        string `xml:"Name"`
	Version     string `xml:"CurrentVersion"`
	Author      string `xml:"Author"`
	Description string `xml:"Description"`
	InfoUrl     string `xml:"InfoUrl"`
	DownloadUrl string `xml:"DownloadUrl"`
	Descriptors struct {
		Descriptor []string `xml:"descriptor"`
	} `xml:"descriptors"`
	Dependencies struct {
		Id []int `xml:"dependency"`
	} `xml:"dependencies"`
}

func ParsePluginConfig(content []byte) (models.LocalPluginModel, error) {
	var pluginConfig pluginConfig

	err := xml.Unmarshal(content, &pluginConfig)
	if err != nil {
		return models.LocalPluginModel{}, err
	}

	return mapPluginConfigToLocalPlugin(&pluginConfig), nil
}

func mapPluginConfigToLocalPlugin(config *pluginConfig) models.LocalPluginModel {
	var descriptors []string
	var dependencies []int

	for _, descriptor := range config.Descriptors.Descriptor {
		descriptors = append(descriptors, descriptor)
	}

	for _, id := range config.Dependencies.Id {
		dependencies = append(dependencies, id)
	}

	return models.LocalPluginModel{
		Id:             config.Id,
		Name:           config.Name,
		CurrentVersion: config.Version,
		Author:         config.Author,
		Description:    strings.Trim(strings.Trim(config.Description, "\n"), "\t"),
		InfoUrl:        config.InfoUrl,
		DownloadUrl:    config.DownloadUrl,
		Descriptors:    descriptors,
		Dependencies:   dependencies,
	}
}

type fallbackConfig struct {
	Information struct {
		Name        string `xml:"Name"`
		Author      string `xml:"Author"`
		Version     string `xml:"CurrentVersion"`
		Description string `xml:"Description"`
	} `xml:"Information"`
}

func ParseFallbackConfig(content []byte) (models.LocalPluginModel, error) {
	var fallbackConfig fallbackConfig

	err := xml.Unmarshal(content, &fallbackConfig)
	if err != nil {
		return models.LocalPluginModel{}, err
	}

	return mapFallbackConfigToLocalPlugin(&fallbackConfig), nil
}

func mapFallbackConfigToLocalPlugin(config *fallbackConfig) models.LocalPluginModel {
	return models.LocalPluginModel{
		Id:             -1,
		Name:           config.Information.Name,
		CurrentVersion: config.Information.Version,
		Author:         config.Information.Author,
		Description:    strings.Trim(strings.Trim(config.Information.Description, "\n"), "\t"),
		InfoUrl:        "",
		DownloadUrl:    "",
		Descriptors:    nil,
		Dependencies:   nil,
	}
}
