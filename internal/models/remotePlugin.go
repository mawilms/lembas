package models

type RemotePlugin struct {
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
