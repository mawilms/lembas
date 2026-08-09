package internal

import (
	"archive/zip"
	"fmt"
	"io"
	"net/http"
	"os"
	"path/filepath"
	"slices"
	"sort"
	"strings"
)

type Installer struct {
}

type InstallerInterface interface {
	Install(addon Addon, settings Settings, database DatabaseInterface) (Addon, error)
	downloadZip(downloadUrl, downloadDestination string, id int) (string, error)
	DeleteFiles(addonsFolderPath string, files []string) error
}

func (i *Installer) Install(addon Addon, settings Settings, database DatabaseInterface) (Addon, error) {
	zipPath, err := i.downloadZip(settings.BaseUrl, settings.DownloadPath, addon.Id)
	if err != nil {
		return Addon{}, err
	}
	defer os.Remove(zipPath)

	files, err := analyzeZip(zipPath)
	if err != nil {
		return Addon{}, err
	}

	if err := extractZip(zipPath, settings.AddonDirectory); err != nil {
		return Addon{}, err
	}

	if err := database.Insert(addon, files); err != nil {
		return Addon{}, err
	}

	return Addon{
		Id:          addon.Id,
		Type:        "local",
		Name:        addon.Name,
		Author:      addon.Author,
		Description: addon.Description,
		Version:     addon.Version,
		Category:    addon.Category,
		Downloads:   addon.Downloads,
		UpdatedAt:   addon.UpdatedAt,
		ArchiveName: addon.ArchiveName,
		ArchiveSize: addon.ArchiveSize,
		HasUpdate:   false,
		IsInstalled: true,
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

func ensureTrailingSlash(path string) string {
	if !strings.HasSuffix(path, "/") {
		return path + "/"
	}
	return path
}

func analyzeZip(zipPath string) (string, error) {
	r, err := zip.OpenReader(zipPath)
	if err != nil {
		return "", err
	}
	defer r.Close()

	folders := make([]string, 0)

	for _, f := range r.File {
		parts := strings.Split(f.Name, "/")

		if f.FileInfo().IsDir() && len(parts) > 2 {
			folders = append(folders, f.Name)
		} else if len(parts) == 2 && parts[1] != "" {
			folders = append(folders, f.Name)
		}
	}

	sort.Strings(folders)

	var result []string
	lastKeptPath := ""
	for _, f := range folders {
		parts := strings.Split(f, "/")
		if strings.Contains(parts[1], ".plugincompendium") ||
			lastKeptPath == "" ||
			!strings.HasPrefix(ensureTrailingSlash(parts[1]), ensureTrailingSlash(lastKeptPath)) {
			result = append(result, f)
			lastKeptPath = parts[1]
		}
	}

	return strings.Join(result, ","), nil
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

func (i *Installer) DeleteFiles(addonsFolderPath string, files []string) error {
	if len(files) == 0 {
		return nil
	}

	var rootPaths []string
	for _, f := range files {
		splitPath := strings.Split(f, "/")[0]
		if !slices.Contains(rootPaths, splitPath) {
			rootPaths = append(rootPaths, splitPath)
		}

		fullPath := filepath.Join(addonsFolderPath, f)
		if err := os.RemoveAll(fullPath); err != nil {
			return err
		}
	}

	for _, f := range rootPaths {
		isEmpty, err := isRootFolderEmpty(filepath.Join(addonsFolderPath, f))
		if err != nil {
			return err
		}

		if isEmpty {
			if err := os.RemoveAll(filepath.Join(addonsFolderPath, f)); err != nil {
				return err
			}
		}
	}

	return nil
}

func isRootFolderEmpty(path string) (bool, error) {
	f, err := os.Open(path)
	if err != nil {
		return false, err
	}
	defer f.Close()

	_, err = f.Readdirnames(1)
	if err == io.EOF {
		return true, nil
	}
	if err != nil {
		return false, err
	}
	return false, nil
}
