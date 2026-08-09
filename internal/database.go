package internal

import (
	"database/sql"
	"fmt"
	"strings"

	_ "github.com/ncruces/go-sqlite3/driver"
)

type Row struct {
	Id          int
	Name        string
	Author      string
	Version     string
	Files       string
	Downloads   int
	UpdatedAt   string
	ArchiveName string
	ArchiveSize string
	Category    string
}

type Database struct {
	DbUrl string
}

type DatabaseInterface interface {
	SetupDb() error
	Get() ([]Addon, error)
	Insert(addon Addon, files string) error
	Delete(id int) error
	GetFiles(id int) ([]string, error)
}

func (d *Database) SetupDb() error {
	db, err := sql.Open("sqlite3", fmt.Sprintf("file:%s?cache=shared", d.DbUrl))
	if err != nil {
		return err
	}

	_, err = db.Exec(`
CREATE TABLE IF NOT EXISTS addons
(
    id                     INTEGER not null
        constraint addons_pk
            primary key AUTOINCREMENT,
    name                   TEXT    not null,
    author                 TEXT    not null,
    version                TEXT    not null,
    files                  TEXT    not null,
    addon_id              INTEGER,
    downloads              INTEGER not null,
    updated_at             INTEGER not null,
    archive_name           TEXT    not null,
    archive_size           TEXT    not null,
    category               TEXT    not null
);
`)

	if err != nil {
		return err
	}
	defer db.Close()

	_, err = db.Exec(`
CREATE VIEW addons_view AS
SELECT name, author, version, files, addon_id, downloads, updated_at, archive_name, archive_size, category 
FROM addons;
`)

	return nil
}

func (d *Database) Insert(addon Addon, files string) error {
	db, err := sql.Open("sqlite3", fmt.Sprintf("file:%s?cache=shared", d.DbUrl))
	if err != nil {
		return err
	}
	defer db.Close()

	row := Row{
		Id:          addon.Id,
		Name:        addon.Name,
		Author:      addon.Author,
		Version:     addon.Version,
		Files:       files,
		Downloads:   addon.Downloads,
		UpdatedAt:   addon.UpdatedAt,
		ArchiveName: addon.ArchiveName,
		ArchiveSize: addon.ArchiveSize,
		Category:    addon.Category,
	}

	stmt := `INSERT INTO addons (name, author, version, files, addon_id, downloads, updated_at, archive_name, archive_size, category) 
VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?);`

	_, err = db.Exec(stmt, row.Name, row.Author, row.Version, row.Files, row.Id, row.Downloads,
		row.UpdatedAt, row.ArchiveName, row.ArchiveSize, row.Category)
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

	query := `SELECT * FROM addons_view;`

	rows, err := db.Query(query)
	if err != nil {
		// Add Log here
		return nil, err
	}
	defer rows.Close()

	var addons []Addon

	for rows.Next() {
		var p Row

		if err := rows.Scan(&p.Name, &p.Author, &p.Version, &p.Files, &p.Id, &p.Downloads, &p.UpdatedAt,
			&p.ArchiveName, &p.ArchiveSize, &p.Category); err != nil {
			return nil, err
		}

		addons = append(addons, Addon{
			Id:          p.Id,
			Type:        "local",
			Name:        p.Name,
			Author:      p.Author,
			Description: "",
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

func (d *Database) Delete(id int) error {
	db, err := sql.Open("sqlite3", fmt.Sprintf("file:%s?cache=shared", d.DbUrl))
	if err != nil {
		return err
	}
	defer db.Close()

	stmt := `DELETE FROM addons WHERE addon_id = ?`
	_, err = db.Exec(stmt, id)
	if err != nil {
		return err
	}

	return nil
}

func (d *Database) GetFiles(id int) ([]string, error) {
	var files []string

	db, err := sql.Open("sqlite3", fmt.Sprintf("file:%s?cache=shared", d.DbUrl))
	if err != nil {
		return files, err
	}
	defer db.Close()

	stmt := `SELECT files FROM addons_view WHERE addon_id = ?`
	rows, err := db.Query(stmt, id)
	if err != nil {
		return files, err
	}
	defer rows.Close()

	for rows.Next() {
		fetchedFiles := ""
		if err := rows.Scan(&fetchedFiles); err != nil {
			return nil, err
		}

		files = strings.Split(fetchedFiles, ",")
	}

	return files, nil
}
