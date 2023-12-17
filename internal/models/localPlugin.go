package models

import (
	"encoding/xml"
	"io"
	"strconv"
	"strings"
)

type LocalPluginModel struct {
	Id             int      `json:"Id"`
	Name           string   `json:"Name"`
	CurrentVersion string   `json:"CurrentVersion"`
	LatestVersion  string   `json:"LatestVersion"`
	Author         string   `json:"Author"`
	Description    string   `json:"Description"`
	InfoUrl        string   `json:"InfoUrl"`
	DownloadUrl    string   `json:"DownloadUrl"`
	Descriptors    []string `json:"Descriptors"`
	Dependencies   []int    `json:"Dependencies"`
}

func (v *LocalPluginModel) UnmarshalXML(d *xml.Decoder, _ xml.StartElement) error {
	var descriptors []string
	var dependencies []int

	for {
		token, err := d.Token()
		if err != nil {
			if err == io.EOF {
				if v.Id == 0 {
					v.Id = -1
				}
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
					if value < 1 {
						v.Id = -1
					} else {
						v.Id = value
					}
				} else if startElementName == "Name" {
					v.Name = string(data)
				} else if startElementName == "Version" || startElementName == "CurrentVersion" {
					v.CurrentVersion = string(data)
					v.LatestVersion = string(data)
				} else if startElementName == "Author" {
					v.Author = string(data)
				} else if startElementName == "Description" {
					v.Description = strings.Trim(strings.Trim(string(data), "\n"), "\t")
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
			v.Descriptors = descriptors
			v.Dependencies = dependencies
		}
	}
}

func ParsePluginConfig(content []byte) (LocalPluginModel, error) {
	var pluginConfig LocalPluginModel

	err := xml.Unmarshal(content, &pluginConfig)
	if err != nil {
		return LocalPluginModel{}, err
	}

	return LocalPluginModel{
		Id:             pluginConfig.Id,
		Name:           pluginConfig.Name,
		CurrentVersion: pluginConfig.CurrentVersion,
		LatestVersion:  pluginConfig.LatestVersion,
		Author:         pluginConfig.Author,
		Description:    pluginConfig.Description,
		InfoUrl:        pluginConfig.InfoUrl,
		DownloadUrl:    pluginConfig.DownloadUrl,
		Descriptors:    pluginConfig.Descriptors,
		Dependencies:   pluginConfig.Dependencies,
	}, nil
}

func ParseFallbackConfig(content []byte) (LocalPluginModel, error) {
	var fallbackConfig LocalPluginModel

	err := xml.Unmarshal(content, &fallbackConfig)
	if err != nil {
		return LocalPluginModel{}, err
	}

	return LocalPluginModel{
		Id:             fallbackConfig.Id,
		Name:           fallbackConfig.Name,
		CurrentVersion: fallbackConfig.CurrentVersion,
		LatestVersion:  fallbackConfig.LatestVersion,
		Author:         fallbackConfig.Author,
		Description:    fallbackConfig.Description,
		InfoUrl:        fallbackConfig.InfoUrl,
		DownloadUrl:    fallbackConfig.DownloadUrl,
		Descriptors:    fallbackConfig.Descriptors,
		Dependencies:   fallbackConfig.Dependencies,
	}, nil
}
