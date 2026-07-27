package database

import (
	"database/sql"
	"time"

	"github.com/mawilms/lembas/internal"
	_ "github.com/ncruces/go-sqlite3/driver"
)

type Row struct {
	Id               int
	Name             string
	Author           string
	Version          string
	Description      string
	IsManaged        bool
	Plugin           string
	PluginCompendium string
	RootFolder       string
	PluginFolder     string
	Downloads        int
	UpdatedAt        string
	ArchiveName      string
	ArchiveSize      string
	Category         string
}

type AddonModel struct{}

type IAddonModel interface {
	Get() ([]internal.Addon, error)
}

func (a *AddonModel) Get() ([]internal.Addon, error) {
	db, err := sql.Open("sqlite3", "file:C:\\Users\\mariu\\Documents\\Programmierung\\lembas\\internal\\database\\example.sqlite?cache=shared")
	if err != nil {
		return nil, err
	}
	defer db.Close()

	query := `SELECT name, author, version, description, is_managed, plugin_file, plugin_compendium_file, root_folder, 
       plugin_folder, plugin_id, downloads, updated_at, archive_name, archive_size, category FROM plugins_view;`

	rows, err := db.Query(query)
	if err != nil {
		// Add Log here
		return nil, err
	}
	defer rows.Close()

	var addons []internal.Addon

	for rows.Next() {
		var p Row
		var archiveSize int64
		var updatedTimestamp int64

		if err := rows.Scan(&p.Name, &p.Author, &p.Version, &p.Description, &p.IsManaged, &p.Plugin,
			&p.PluginCompendium, &p.RootFolder, &p.PluginFolder, &p.Id, &p.Downloads, &updatedTimestamp,
			&p.ArchiveName, &archiveSize, &p.Category); err != nil {
			return nil, err
		}

		p.ArchiveSize = internal.FormatArchiveSize(archiveSize)
		p.UpdatedAt = time.Unix(updatedTimestamp, 0).Local().Format("01/02/2006")

		addons = append(addons, internal.Addon{
			Id:          p.Id,
			Type:        "local",
			Name:        p.Name,
			Author:      p.Author,
			Description: p.Description,
			Version:     p.Version,
			Category:    p.Category,
			Downloads:   p.Downloads,
			UpdatedAt:   p.UpdatedAt,
			ArchiveName: p.ArchiveName,
			ArchiveSize: p.ArchiveSize,
			HasUpdate:   false,
			IsInstalled: true,
		})
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return addons, nil

}
