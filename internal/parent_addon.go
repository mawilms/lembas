package internal

import "fmt"

type ParentAddon struct {
	Id          int
	Type        string
	Name        string
	Author      string
	Description string
	Version     string
	Category    string
	Downloads   int
	UpdatedAt   string
	ArchiveName string
	ArchiveSize string
	HasUpdate   bool
	IsInstalled bool
}

func FormatArchiveSize(bytes int64) string {
	kb := bytes / 1000
	if kb > 1000 {
		return fmt.Sprintf("%v MB", kb/1000)
	}
	return fmt.Sprintf("%v KB", kb)
}
