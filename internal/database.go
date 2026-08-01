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
	Plugin           string
	PluginCompendium string
	RootFolder       string
	PluginFolder     string
	ArchiveName      string
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
    plugin_file            TEXT    not null,
    plugin_compendium_file TEXT    not null,
    root_folder            TEXT    not null,
    plugin_folder          TEXT    not null,
    plugin_id              INTEGER,
    archive_name           TEXT    not null
);
`)

	if err != nil {
		return err
	}

	_, err = db.Exec(`
CREATE VIEW plugins_view AS
SELECT name, author, version, plugin_file, plugin_compendium_file, root_folder, plugin_folder, plugin_id, archive_name 
FROM plugins;
`)
	db.Close()

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
		Plugin:           info.PluginFile,
		PluginCompendium: info.PluginCompendiumFile,
		RootFolder:       info.RootFolder,
		PluginFolder:     info.PluginFolder,
		ArchiveName:      addon.ArchiveName,
	}

	stmt := `INSERT INTO plugins (name, author, plugin_file, plugin_compendium_file, root_folder, plugin_folder, plugin_id, archive_name) 
VALUES (?, ?, ?, ?, ?, ?, ?, ?);`

	_, err = db.Exec(stmt, row.Name, row.Author, row.Version, row.Plugin, row.PluginCompendium,
		row.RootFolder, row.PluginFolder, row.Id, row.ArchiveName)
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

	query := `SELECT name, author, version, plugin_file, plugin_compendium_file, root_folder, 
       plugin_folder, plugin_id, archive_name FROM plugins_view;`

	rows, err := db.Query(query)
	if err != nil {
		// Add Log here
		return nil, err
	}
	defer rows.Close()

	var addons []Addon

	for rows.Next() {
		var p Row

		if err := rows.Scan(&p.Name, &p.Author, &p.Version, &p.Plugin, &p.PluginCompendium, &p.RootFolder,
			&p.PluginFolder, &p.Id, &p.ArchiveName); err != nil {
			return nil, err
		}

		addons = append(addons, Addon{
			Id:             p.Id,
			Type:           "local",
			Name:           p.Name,
			Author:         p.Author,
			CurrentVersion: p.Version,
			LatestVersion:  "",
			ArchiveName:    p.ArchiveName,
			HasUpdate:      false,
			IsInstalled:    true,
		})
	}

	if err = rows.Err(); err != nil {
		return nil, err
	}

	return addons, nil

}
