package models

import (
	"bytes"
	"encoding/xml"
	"github.com/mawilms/lembas/internal/entities"
	"time"
)

type RemotePluginModel struct {
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

type favorite struct {
	Plugins []RemotePluginModel `xml:"Ui"`
}

func ParseFeed(content []byte) ([]entities.RemotePluginEntity, error) {
	var favorite favorite

	decoder := xml.NewDecoder(bytes.NewReader(content))
	decoder.Strict = false

	err := decoder.Decode(&favorite)
	if err != nil {
		return make([]entities.RemotePluginEntity, 0), err
	}

	plugins := make([]entities.RemotePluginEntity, 0)
	for _, plugin := range favorite.Plugins {
		remotePlugin := entities.RemotePluginEntity{
			Base:             NewBasePlugin(plugin.Id, plugin.Name, plugin.Description, plugin.Author, "", plugin.Version),
			Downloads:        plugin.Downloads,
			Category:         plugin.Category,
			FileName:         plugin.FileName,
			UpdatedTimestamp: time.Unix(int64(plugin.UpdatedTimestamp), 0).Format("2006-01-02"),
		}

		plugins = append(plugins, remotePlugin)
	}

	return plugins, nil
}
