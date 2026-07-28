package internal

import (
	"database/sql"
	"fmt"

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

type Database struct{}

type DatabaseInterface interface {
	Get(dbPath string) ([]Addon, error)
	Insert(dbPath string, addon Addon, info ArchiveInfo) error
}

func (d *Database) Insert(dbPath string, addon Addon, info ArchiveInfo) error {
	db, err := sql.Open("sqlite3", fmt.Sprintf("file:%s?cache=shared", dbPath))
	if err != nil {
		return err
	}
	defer db.Close()

	row := Row{
		Id:               addon.Id,
		Name:             addon.Name,
		Author:           addon.Author,
		Version:          addon.CurrentVersion,
		Description:      addon.Description,
		IsManaged:        true,
		Plugin:           info.PluginFile,
		PluginCompendium: info.PluginCompendiumFile,
		RootFolder:       info.RootFolder,
		PluginFolder:     info.PluginFolder,
		Downloads:        addon.Downloads,
		UpdatedAt:        addon.UpdatedAt,
		ArchiveName:      addon.ArchiveName,
		ArchiveSize:      addon.ArchiveSize,
		Category:         addon.Category,
	}

	stmt := `INSERT INTO plugins (name, author, version, is_managed, plugin_file, plugin_compendium_file, root_folder, plugin_folder, plugin_id, downloads, updated_at, archive_name, archive_size, category, description) 
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?);`

	_, err = db.Exec(stmt, row.Name, row.Author, row.Version, row.IsManaged, row.Plugin, row.PluginCompendium,
		row.RootFolder, row.PluginFolder, row.Id, row.Downloads, row.UpdatedAt, row.ArchiveName, row.ArchiveSize,
		row.Category, row.Description)
	if err != nil {
		return err
	}

	return nil
}

func (d *Database) Get(dbPath string) ([]Addon, error) {
	db, err := sql.Open("sqlite3", fmt.Sprintf("file:%s?cache=shared", dbPath))
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

	var addons []Addon

	for rows.Next() {
		var p Row

		if err := rows.Scan(&p.Name, &p.Author, &p.Version, &p.Description, &p.IsManaged, &p.Plugin,
			&p.PluginCompendium, &p.RootFolder, &p.PluginFolder, &p.Id, &p.Downloads, &p.UpdatedAt,
			&p.ArchiveName, &p.ArchiveSize, &p.Category); err != nil {
			return nil, err
		}

		addons = append(addons, Addon{
			Id:             p.Id,
			Type:           "local",
			Name:           p.Name,
			Author:         p.Author,
			Description:    p.Description,
			CurrentVersion: p.Version,
			LatestVersion:  "",
			Category:       p.Category,
			Downloads:      p.Downloads,
			UpdatedAt:      p.UpdatedAt,
			ArchiveName:    p.ArchiveName,
			ArchiveSize:    p.ArchiveSize,
			HasUpdate:      false,
			IsInstalled:    true,
		})
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return addons, nil

}
