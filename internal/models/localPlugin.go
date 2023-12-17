package models

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
