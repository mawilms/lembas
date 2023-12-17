package entities

type BasePluginEntity struct {
	Id             int
	Name           string
	Description    string
	Author         string
	CurrentVersion string
	LatestVersion  string
	InfoUrl        string
	DownloadUrl    string
}

type LocalPluginEntity struct {
	Base         BasePluginEntity
	Descriptors  []string
	Dependencies []int
}

type RemotePluginEntity struct {
	Base        BasePluginEntity
	IsInstalled bool
	Downloads   int
	Category    string
	FileName    string
}
