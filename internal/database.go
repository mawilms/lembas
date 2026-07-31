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

type Database struct {
	DbUrl string
}

type DatabaseInterface interface {
	SetupDb() error
	Get() ([]Addon, error)
	Insert(addon Addon, info ArchiveInfo) error
}

func (d *Database) SetupDb() error {
	db, err := sql.Open("sqlite3", fmt.Sprintf("file:%s?cache=shared", d.DbUrl))
	if err != nil {
		return err
	}

	_, err = db.Exec(`
CREATE TABLE IF NOT EXISTS plugins
(
    id                     INTEGER not null
        constraint plugins_pk
            primary key AUTOINCREMENT,
    name                   TEXT    not null,
    author                 TEXT    not null,
    version                TEXT    not null,
    is_managed             INTEGER not null,
    plugin_file            TEXT    not null,
    plugin_compendium_file TEXT    not null,
    root_folder            TEXT    not null,
    plugin_folder          TEXT    not null,
    plugin_id              INTEGER,
    downloads              INTEGER not null,
    updated_at             INTEGER not null,
    archive_name           TEXT    not null,
    archive_size           TEXT    not null,
    category               TEXT    not null,
    description            TEXT
);
`)

	if err != nil {
		return err
	}

	_, err = db.Exec(`
CREATE VIEW plugins_view AS
SELECT name, author, version, description, is_managed, plugin_file, plugin_compendium_file, root_folder, plugin_folder, plugin_id, downloads, updated_at, archive_name, archive_size, category 
FROM plugins;
`)

	return nil
}

func (d *Database) Insert(addon Addon, info ArchiveInfo) error {
	db, err := sql.Open("sqlite3", fmt.Sprintf("file:%s?cache=shared", d.DbUrl))
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

func (d *Database) Get() ([]Addon, error) {
	db, err := sql.Open("sqlite3", fmt.Sprintf("file:%s?cache=shared", d.DbUrl))
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
