package remote

import (
	"fmt"
	"time"
)

type RemoteAddon struct {
	Id          int
	Name        string
	Author      string
	Version     string
	Updated     string
	Downloads   int
	Category    string
	Description string
	File        string
	Size        string
	FileURL     string
}

func New(apiModel ApiXmlModel) RemoteAddon {
	addonSize := apiModel.Size / 1000

	var convertedSize string
	if addonSize > 1000 {
		convertedSize = fmt.Sprintf("%v MB", addonSize/1000)
	} else {
		convertedSize = fmt.Sprintf("%v KB", addonSize)
	}

	return RemoteAddon{
		Id:          apiModel.Uid,
		Name:        apiModel.Name,
		Author:      apiModel.Author,
		Version:     apiModel.Version,
		Updated:     time.Unix(apiModel.Updated, 0).Local().Format("01/02/2006"),
		Downloads:   apiModel.Downloads,
		Category:    apiModel.Category,
		Description: apiModel.Description,
		File:        apiModel.File,
		Size:        convertedSize,
		FileURL:     apiModel.FileURL,
	}
}
