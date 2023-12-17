package models

import (
	"fmt"
	"github.com/mawilms/lembas/internal/entities"
)

func NewBasePlugin(id int, name, description, author, currentVersion, latestVersion string) entities.BasePluginEntity {
	infoUrl := ""
	downloadUrl := ""

	if id > 1 {
		infoUrl = fmt.Sprintf("https://www.lotrointerface.com/downloads/info%v", id)
		downloadUrl = fmt.Sprintf("https://www.lotrointerface.com/downloads/download%v", id)
	}

	return entities.BasePluginEntity{
		Id:             id,
		Name:           name,
		Description:    description,
		Author:         author,
		CurrentVersion: currentVersion,
		LatestVersion:  latestVersion,
		InfoUrl:        infoUrl,
		DownloadUrl:    downloadUrl,
	}
}

func MarkRemotePluginsAsInstalled() ([]entities.RemotePluginEntity, error) {
	plugins := make([]entities.RemotePluginEntity, 0)

	return plugins, nil

}
