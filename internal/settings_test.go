package internal

import (
	"os"
	"path/filepath"
	"testing"
)

func setupTempHome(t *testing.T) string {
	t.Helper()

	tmpHome := t.TempDir()

	t.Setenv("USERPROFILE", tmpHome) // Windows

	return tmpHome
}

func TestUserDirectory_CreatePluginsDir(t *testing.T) {
	tmpHome := setupTempHome(t)

	u := &UserDirectory{}

	if _, err := u.CreateAddonsDir(); err != nil {
		t.Fatalf("Failed to create directory: %v", err)
	}

	expected := filepath.Join(tmpHome, "Documents", "The Lord of the Rings Online", "Plugins")
	if info, err := os.Stat(expected); err != nil || !info.IsDir() {
		t.Fatalf("Directory %s wasn't created", expected)
	}
}
