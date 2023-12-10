package internal

import (
	"github.com/mawilms/lembas/internal/models"
	"io"
	"net/http"
)

func DownloadPackageInformation() ([]models.RemotePlugin, error) {
	response, err := http.Get("https://api.lotrointerface.com/fav/plugincompendium.xml")
	if err != nil {
		return make([]models.RemotePlugin, 0), err
	}

	content, err := io.ReadAll(response.Body)
	defer response.Body.Close()

	plugins, err := ParseFeed(content)

	return plugins, err
}
