package internal

import "encoding/xml"

type Descriptor struct {
	Descriptor string `xml:"descriptor"`
}

type Dependency struct {
	Id int `xml:"dependency"`
}

type PluginConfig struct {
	Id           int          `xml:"Id"`
	Name         string       `xml:"Name"`
	Version      string       `xml:"Version"`
	Author       string       `xml:"Author"`
	InfoUrl      string       `xml:"InfoUrl"`
	DownloadUrl  string       `xml:"DownloadUrl"`
	Descriptors  []Descriptor `xml:"Descriptors"`
	Dependencies []Dependency `xml:"Dependencies"`
}

func Parse(content string) (PluginConfig, error) {
	var pluginConfig PluginConfig

	err := xml.Unmarshal([]byte(content), &pluginConfig)
	if err != nil {
		return PluginConfig{}, err
	}

	return pluginConfig, nil
}
