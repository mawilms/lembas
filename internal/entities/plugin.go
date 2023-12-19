package entities

type BasePluginEntity struct {
	Id             int    `json:"id"`
	Name           string `json:"name"`
	Description    string `json:"description"`
	Author         string `json:"author"`
	CurrentVersion string `json:"currentVersion"`
	LatestVersion  string `json:"latestVersion"`
	InfoUrl        string `json:"infoUrl"`
	DownloadUrl    string `json:"downloadUrl"`
}

type LocalPluginEntity struct {
	Base         BasePluginEntity `json:"base"`
	Descriptors  []string         `json:"descriptors"`
	Dependencies []int            `json:"dependencies"`
}

type RemotePluginEntity struct {
	Base             BasePluginEntity `json:"base"`
	IsInstalled      bool             `json:"isInstalled"`
	UpdatedTimestamp int              `json:"updatedTimestamp"`
	Downloads        int              `json:"downloads"`
	Category         string           `json:"category"`
	FileName         string           `json:"file_name"`
}
