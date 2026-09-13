package internal

import (
	"database/sql"
	"fmt"
	"path/filepath"
	"testing"
)

func TestDatabase_SetupDb(t *testing.T) {
	dbUrl := filepath.Join(setupTempHome(t), "table.db")

	db := Database{
		DbUrl: dbUrl,
	}

	err := db.SetupDb()
	if err != nil {
		t.Fatalf("Unable to setup database: %v", err)
	}

	testConnection, err := sql.Open("sqlite3", fmt.Sprintf("file:%s?cache=shared", ""))
	if err != nil {
		t.Fatalf("Unable to create test connection to created database: %v", err)
	}

	// Check if table exists
	rows, err := testConnection.Query(`SELECT name from sqlite_master WHERE type = 'table' AND name = 'addons';`)
	if err != nil {
		t.Fatalf("Unable to query table name: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var name string
		if err := rows.Scan(&name); err != nil {
			t.Fatalf("Error while scanning: %v", err)
		}

		if name != "addons" {
			t.Fatalf("Table addons doesn't exist")
		}
	}

	// Check if view exists
	rows, err = testConnection.Query(`SELECT name from sqlite_master WHERE type = 'view' and name = 'addons_view';`)
	if err != nil {
		t.Fatalf("Unable to query view name: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var name string
		if err := rows.Scan(&name); err != nil {
			t.Fatalf("Error while scanning: %v", err)
		}

		if name != "addons_view" {
			t.Fatalf("View doesn't exist")
		}
	}

	// Check if index exists
	rows, err = testConnection.Query(`SELECT name from sqlite_master WHERE type = 'index' and name = 'addons_id_name_author_addon_id_uindex';`)
	if err != nil {
		t.Fatalf("Unable to query index name: %v", err)
	}
	defer rows.Close()

	for rows.Next() {
		var name string
		if err := rows.Scan(&name); err != nil {
			t.Fatalf("Error while scanning: %v", err)
		}

		if name != "addons_id_name_author_addon_id_uindex" {
			t.Fatalf("Index addons doesn't exist")
		}
	}
}
