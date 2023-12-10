package models

type LocalPluginModel struct {
	Id             int
	Name           string
	CurrentVersion string
	LatestVersion  string
	Author         string
	Description    string
	InfoUrl        string
	DownloadUrl    string
	Descriptors    []string
	Dependencies   []int
}
