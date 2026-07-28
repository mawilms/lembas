package internal

import (
	"encoding/xml"
	"fmt"
	"io"
	"net/http"
	"regexp"
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
	GetSourceXml(url string) (string, error)
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
