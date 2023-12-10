package models

type RemotePluginModel struct {
	Id               int
	Name             string
	Author           string
	Version          string
	UpdatedTimestamp int
	Downloads        int
	Category         string
	Description      string
	FileName         string
	Url              string
}
