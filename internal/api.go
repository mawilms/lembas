package internal

import (
	"encoding/xml"
	"fmt"
	"io"
	"net/http"
	"regexp"
	"time"
)

type Favorites struct {
	Ui []ApiXmlModel `xml:"Ui"`
}

type ApiXmlModel struct {
	Uid         int    `xml:"UID"`
	Name        string `xml:"UIName"`
	Author      string `xml:"UIAuthorName"`
	Version     string `xml:"UIVersion"`
	Updated     int64  `xml:"UIUpdated"`
	Downloads   int    `xml:"UIDownloads"`
	Category    string `xml:"UICategory"`
	Description string `xml:"UIDescription"`
	File        string `xml:"UIFile"`
	Size        int64  `xml:"UISize"`
	FileURL     string `xml:"UIFileURL"`
}

// This is a special case. The XML can contain & which is not escaped and this leads to an error while parsing the XML
func sanitizeXML(data []byte) []byte {
	invalidAmpRe := regexp.MustCompile(`&(amp;)?`)

	return invalidAmpRe.ReplaceAll(data, []byte("&amp;"))
}

func ParseXmlResponse(response []byte) ([]ApiXmlModel, error) {
	var favorites Favorites

	response = sanitizeXML(response)

	if err := xml.Unmarshal(response, &favorites); err != nil {
		return nil, fmt.Errorf("error while parsing the xml response: %w", err)
	}

	return favorites.Ui, nil
}

type ApiInterface interface {
	GetSourceXml() ([]byte, error)
	Get() ([]Addon, error)
}

type Api struct {
	Url string
}

func (a *Api) GetSourceXml() ([]byte, error) {
	resp, err := http.Get(a.Url)
	if err != nil {
		return nil, fmt.Errorf("failed to fetch xml payload from %s: %w", a.Url, err)
	}
	defer resp.Body.Close()

	data, err := io.ReadAll(resp.Body)
	if err != nil {
		return nil, fmt.Errorf("fehler beim lesen des response body: %w", err)
	}
	return data, nil
}

func (a *Api) Get() ([]Addon, error) {
	response, err := a.GetSourceXml()
	if err != nil {
		//a.logger.Error("failed to get fetch remote plugins", slog.String("feed url", api.Url), slog.String("error", err.Error()))
		return nil, nil
	}

	xmlModel, err := ParseXmlResponse(response)
	if err != nil {
		//a.logger.Error("failed to get fetch remote plugins", slog.String("feed url", api.Url), slog.String("error", err.Error()))
		return nil, nil
	}

	addons := make([]Addon, 0)

	for _, e := range xmlModel {
		addons = append(addons, Addon{
			Id:            e.Uid,
			Type:          "remote",
			Name:          e.Name,
			Author:        e.Author,
			Description:   e.Description,
			LocalVersion:  e.Version,
			RemoteVersion: e.Version,
			Category:      e.Category,
			Downloads:     e.Downloads,
			UpdatedAt:     time.Unix(e.Updated, 0).Local().Format("01/02/2006"),
			ArchiveName:   e.File,
			ArchiveSize:   formatArchiveSize(e.Size),
			HasUpdate:     false,
			IsInstalled:   false,
		})
	}

	return addons, nil
}

func formatArchiveSize(bytes int64) string {
	kb := bytes / 1000
	if kb > 1000 {
		return fmt.Sprintf("%v MB", kb/1000)
	}
	return fmt.Sprintf("%v KB", kb)
}
