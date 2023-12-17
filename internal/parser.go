package internal

import (
	"bytes"
	"encoding/xml"
	"github.com/mawilms/lembas/internal/entities"
	"github.com/mawilms/lembas/internal/models"
	"io"
	"strconv"
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

func ParseFeed(content []byte) ([]entities.RemotePluginEntity, error) {
	var favorite favorite

	decoder := xml.NewDecoder(bytes.NewReader(content))
	decoder.Strict = false

	err := decoder.Decode(&favorite)
	if err != nil {
		return make([]entities.RemotePluginEntity, 0), err
	}

	plugins := mapFavoritesToRemotePlugins(&favorite)
	return plugins, nil
}

func mapFavoritesToRemotePlugins(favorite *favorite) []entities.RemotePluginEntity {
	var plugins []entities.RemotePluginEntity

	for _, plugin := range favorite.Ui {
		plugins = append(plugins, entities.RemotePluginEntity{
			Id: plugin.Id, Name: plugin.Name, Author: plugin.Author, Version: plugin.Version,
			UpdatedTimestamp: plugin.UpdatedTimestamp, Downloads: plugin.Downloads,
			Category: plugin.Category, Description: strings.Trim(plugin.Description, "\n\t"), FileName: plugin.FileName, Url: strings.Trim(plugin.Url, "\n\t"),
		})
	}

	return plugins
}

type pluginConfig struct {
	Id          int
	Name        string
	Version     string
	Author      string
	Description string
	InfoUrl     string
	DownloadUrl string
	Descriptors struct {
		Descriptor []string
	}
	Dependencies struct {
		Id []int
	}
}

func (v *pluginConfig) UnmarshalXML(d *xml.Decoder, _ xml.StartElement) error {
	var descriptors []string
	var dependencies []int

	for {
		token, err := d.Token()
		if err != nil {
			if err == io.EOF {
				return nil
			}
			return err
		}

		if se, ok := token.(xml.StartElement); ok {
			token, err = d.Token()
			if err != nil {
				if err == io.EOF {
					return nil
				}
				return err
			}
			if data, ok := token.(xml.CharData); ok {
				startElementName := se.Name.Local
				if startElementName == "Id" {
					value, _ := strconv.Atoi(string(data))
					v.Id = value
				} else if startElementName == "Name" {
					v.Name = string(data)
				} else if startElementName == "Version" || startElementName == "CurrentVersion" {
					v.Version = string(data)
				} else if startElementName == "Author" {
					v.Author = string(data)
				} else if startElementName == "Description" {
					v.Description = string(data)
				} else if startElementName == "InfoUrl" {
					v.InfoUrl = string(data)
				} else if startElementName == "DownloadUrl" {
					v.DownloadUrl = string(data)
				} else if startElementName == "descriptor" {
					descriptors = append(descriptors, string(data))
				} else if startElementName == "dependency" {
					value, _ := strconv.Atoi(string(data))
					dependencies = append(dependencies, value)
				}
			}
			v.Descriptors = struct{ Descriptor []string }{Descriptor: descriptors}
			v.Dependencies = struct{ Id []int }{Id: dependencies}
		}
	}
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
		LatestVersion:  config.Version,
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
