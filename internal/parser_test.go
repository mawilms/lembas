package internal

import (
	"testing"
)

func TestParser(t *testing.T) {
	xmlContent := `<PluginConfig xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema">
  <Id>366</Id>
  <Name>Bevy o Bars</Name>
  <Version>2.321</Version>
  <Author>MrJackdaw</Author>
  <InfoUrl>http://www.lotrointerface.com/downloads/info366</InfoUrl>
  <DownloadUrl>http://www.lotrointerface.com/downloads/download366</DownloadUrl>
  <Descriptors>
    <descriptor>JackdawPlugins\BevyOBars2.plugin</descriptor>
    <descriptor>JackdawPlugins\BevyOBars2AutoLoader.plugin</descriptor>
  </Descriptors>
  <Dependencies>
    <dependency>0</dependency>
    <dependency>367</dependency>
    <dependency>575</dependency>
  </Dependencies>
</PluginConfig>`

	config, err := Parse(xmlContent)
	if err != nil {
		t.Error(err)
	}

	_ = config
}
