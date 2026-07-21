package models

import (
	"reflect"
	"testing"
)

func TestParsePluginConfig(t *testing.T) {
	xmlContent := []byte(`<pluginConfig xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <Id>366</Id>
  <Name>Bevy o Bars</Name>
  <CurrentVersion>2.321</CurrentVersion>
  <Author>MrJackdaw</Author>
  <InfoUrl>http://www.lotrointerface.com/downloads/info366</InfoUrl>
  <DownloadUrl>http://www.lotrointerface.com/downloads/download366</DownloadUrl>
  <descriptors>
    <descriptor>JackdawPlugins\BevyOBars2.plugin</descriptor>
    <descriptor>JackdawPlugins\BevyOBars2AutoLoader.plugin</descriptor>
  </descriptors>
  <dependencies>
    <dependency>0</dependency>
    <dependency>367</dependency>
    <dependency>575</dependency>
  </dependencies>
</pluginConfig>`)

	config, err := ParsePluginConfig(xmlContent)
	if err != nil {
		t.Error(err)
	}

	expectedConfig := LocalPluginModel{
		Id:             366,
		Name:           "Bevy o Bars",
		CurrentVersion: "2.321",
		LatestVersion:  "2.321",
		Author:         "MrJackdaw",
		InfoUrl:        "http://www.lotrointerface.com/downloads/info366",
		DownloadUrl:    "http://www.lotrointerface.com/downloads/download366",
		Descriptors:    []string{"JackdawPlugins\\BevyOBars2.plugin", "JackdawPlugins\\BevyOBars2AutoLoader.plugin"},
		Dependencies:   []int{0, 367, 575},
	}
	isEqual := reflect.DeepEqual(config, expectedConfig)
	if isEqual == false {
		t.Errorf("Input pluginConfig is different from the expected struct. Got: %v, expected: %v", config, expectedConfig)
	}
}

func TestParseFallbackConfig(t *testing.T) {
	content := []byte(`<?xml version="1.0"?>
<Plugin>
	<Information>
		<Name>AltHolic</Name>
		<Author>Homeopatix</Author>
		<CurrentVersion>4.40</CurrentVersion>
		<Description>
Hello World
</Description>
<Image>Homeopatix/AltHolic/Resources/pluginmanager_icon.tga</Image>
	</Information>
	<Package>Homeopatix.AltHolic.Main</Package>
<Configuration Apartment="AltHolic" />
</Plugin>`)

	config, err := ParseFallbackConfig(content)
	if err != nil {
		t.Error(err)
	}

	expectedConfig := LocalPluginModel{
		Id:             -1,
		Name:           "AltHolic",
		CurrentVersion: "4.40",
		LatestVersion:  "4.40",
		Author:         "Homeopatix",
		Description:    "Hello World",
		InfoUrl:        "",
		DownloadUrl:    "",
		Descriptors:    nil,
		Dependencies:   nil,
	}
	isEqual := reflect.DeepEqual(config, expectedConfig)
	if isEqual == false {
		t.Errorf("Input pluginConfig is different from the expected struct. Got: %v, expected: %v", config, expectedConfig)
	}
}
