package internal

import (
	"archive/zip"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"strings"
)

type ArchiveInfo struct {
	RootFolder           string
	PluginFolder         string
	PluginFile           string
	PluginCompendiumFile string
}

type Installer struct {
}

type InstallerInterface interface {
	Install(addon Addon, settings Settings, database DatabaseInterface) (Addon, error)
	downloadZip(downloadUrl, downloadDestination string, id int) (string, error)
}

func (i *Installer) Install(addon Addon, settings Settings, database DatabaseInterface) (Addon, error) {
	zipPath, err := i.downloadZip(settings.BaseUrl, settings.DownloadPath, addon.Id)
	if err != nil {
		return Addon{}, err
	}
	defer os.Remove(zipPath)

	info, err := analyzeZip(zipPath)
	if err != nil {
		return Addon{}, err
	}

	//if err := extractZip(zipPath, settings.AddonDirectory); err != nil {
	//	return err
	//}

	if err := database.Insert(addon, *info); err != nil {
		return Addon{}, err
	}

	return Addon{
		Id:             addon.Id,
		Type:           "local",
		Name:           addon.Name,
		Author:         addon.Author,
		Description:    addon.Description,
		CurrentVersion: addon.LatestVersion,
		LatestVersion:  addon.LatestVersion,
		Category:       addon.Category,
		Downloads:      addon.Downloads,
		UpdatedAt:      addon.UpdatedAt,
		ArchiveName:    addon.ArchiveName,
		ArchiveSize:    addon.ArchiveSize,
		HasUpdate:      false,
		IsInstalled:    true,
	}, nil
}

func (i *Installer) downloadZip(downloadUrl, downloadDestination string, id int) (string, error) {
	url := fmt.Sprintf("%s/download%d", downloadUrl, id)

	resp, err := http.Get(url)
	if err != nil {
		return "", err
	}
	defer resp.Body.Close()

	if resp.StatusCode != http.StatusOK {
		return "", fmt.Errorf("unerwarteter Status-Code: %d", resp.StatusCode)
	}

	tmpFile, err := os.CreateTemp(downloadDestination, "addon.zip")
	if err != nil {
		return "", err
	}
	defer tmpFile.Close()

	if _, err := io.Copy(tmpFile, resp.Body); err != nil {
		return "", err
	}

	return tmpFile.Name(), nil
}

func analyzeZip(zipPath string) (*ArchiveInfo, error) {
	r, err := zip.OpenReader(zipPath)
	if err != nil {
		return nil, err
	}
	defer r.Close()

	info := &ArchiveInfo{}

	for _, f := range r.File {
		parts := strings.Split(f.Name, "/")

		if len(parts) == 2 && info.RootFolder == "" {
			info.RootFolder = parts[0]
		}

		if strings.Contains(f.Name, ".plugincompendium") {
			entry := strings.Split(f.Name, "/")

			info.PluginCompendiumFile = entry[len(entry)-1]
		}

	}

	if info.PluginCompendiumFile != "" {
		info.PluginFolder = strings.Split(info.PluginCompendiumFile, ".")[0]
		info.PluginFile = strings.TrimSuffix(info.PluginCompendiumFile, "compendium")
	}

	return info, nil
}

func isWithinDir(base, target string) bool {
	rel, err := filepath.Rel(base, target)
	if err != nil {
		return false
	}
	return !filepath.IsAbs(rel) && !strings.HasPrefix(rel, "..")
}

// extractZip entpackt das komplette Archiv in destDir (z.B. den Dokumente-Ordner).
// Der im ZIP enthaltene RootFolder wird dabei automatisch als Unterordner angelegt,
// z.B. destDir\Bla\example.file
func extractZip(zipPath string, destDir string) error {
	r, err := zip.OpenReader(zipPath)
	if err != nil {
		return err
	}
	defer r.Close()

	for _, f := range r.File {
		fpath := filepath.Join(destDir, filepath.FromSlash(f.Name))

		// Schutz gegen Zip-Slip (Pfade, die aus dem Zielordner ausbrechen)
		if !isWithinDir(destDir, fpath) {
			return fmt.Errorf("unsicherer Pfad im Archiv: %s", f.Name)
		}

		if f.FileInfo().IsDir() {
			if err := os.MkdirAll(fpath, os.ModePerm); err != nil {
				return err
			}
			continue
		}

		if err := os.MkdirAll(filepath.Dir(fpath), os.ModePerm); err != nil {
			return err
		}

		outFile, err := os.OpenFile(fpath, os.O_WRONLY|os.O_CREATE|os.O_TRUNC, f.Mode())
		if err != nil {
			return err
		}

		rc, err := f.Open()
		if err != nil {
			outFile.Close()
			return err
		}

		_, copyErr := io.Copy(outFile, rc)
		outFile.Close()
		rc.Close()
		if copyErr != nil {
			return copyErr
		}
	}

	return nil
}
