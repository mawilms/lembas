package models

type InstalledPlugin struct {
	Id           int
	Name         string
	Version      string
	Author       string
	InfoUrl      string
	DownloadUrl  string
	Descriptors  []string
	Dependencies []int
}
