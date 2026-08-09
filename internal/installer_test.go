package internal

import (
	"os"
	"path/filepath"
	"runtime"
	"testing"
)

func setupSamplesPath(t *testing.T) string {
	t.Helper()

	_, file, _, _ := runtime.Caller(0)

	return filepath.Join(filepath.Dir(file), "..", "test", "samples")
}

func TestAnalyzeZip(t *testing.T) {
	tests := []struct {
		name        string
		archiveName string
		expect      string
	}{
		{"same root and plugin folder", "LUI-v2.3.0.zip", "LUI/ATTRIBUTIONS.md,LUI/LICENSE,LUI/LICENSES/,LUI/LUI.plugin,LUI/LUI.plugincompendium,LUI/LUIReloader.plugin,LUI/README.md,LUI/api/,LUI/assets/,LUI/reloader/,LUI/src/"},
		{"different root and plugin folder", "Altholic.zip", "Homeopatix/AltHolic.plugin,Homeopatix/AltHolic.plugincompendium,Homeopatix/AltHolic/"},
		{"doesn't contain a plugincompendium file", "AH_Buyout_Calculator_0.5.zip", "Munkey/Ah.plugin,Munkey/Ah/"},
		{"contains multiple folders after installation", "ExoPlugins.zip", "ExoPlugins/Acumen.plugin,ExoPlugins/Acumen/,ExoPlugins/AcumenReloader.plugin,ExoPlugins/AcumenReloader/"},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			samplesPath := setupSamplesPath(t)

			got, err := analyzeZip(filepath.Join(samplesPath, tt.archiveName))
			if err != nil {
				t.Fatalf("unable to process ZIP file; %v", err)
			}

			if got != tt.expect {
				t.Fatalf("infos are different; got %v, expected %v", got, tt.expect)
			}
		})
	}
}

func mustMkdirAll(t *testing.T, path string) {
	t.Helper()
	if err := os.MkdirAll(path, os.ModePerm); err != nil {
		t.Fatalf("couldn't create subdirectory %q, got err; %v", path, err)
	}
}

func mustWriteFile(t *testing.T, path string) {
	t.Helper()
	if err := os.WriteFile(path, []byte("test"), os.ModePerm); err != nil {
		t.Fatalf("couldn't write file %q, got err; %v", path, err)
	}
}

func assertNotExists(t *testing.T, path string) {
	t.Helper()
	if _, err := os.Stat(path); !os.IsNotExist(err) {
		t.Fatalf("path %q exists, got err; %v", path, err)
	}
}

func assertExists(t *testing.T, path string) {
	t.Helper()
	if _, err := os.Stat(path); err != nil {
		t.Fatalf("path %q doesn't exist, got err; %v", path, err)
	}
}

func TestInstaller_DeleteFiles(t *testing.T) {
	t.Run("Delete folder + contents and root folder if empty", func(t *testing.T) {
		base := t.TempDir()

		mustMkdirAll(t, filepath.Join(base, "LUI", "api"))
		mustMkdirAll(t, filepath.Join(base, "LUI", "src", "Utils"))
		mustWriteFile(t, filepath.Join(base, "LUI", "src", "Utils", "helper.go"))
		mustWriteFile(t, filepath.Join(base, "LUI", "readme.txt"))

		mustMkdirAll(t, filepath.Join(base, "keep"))
		mustWriteFile(t, filepath.Join(base, "keep", "keep.plugin"))

		i := &Installer{}

		err := i.DeleteFiles(base, []string{
			"LUI/api",
			"LUI/src",
			"LUI/example.plugin",
		})

		if err != nil {
			t.Fatal(err)
		}

		assertNotExists(t, filepath.Join(base, "LUI", "api"))
		assertNotExists(t, filepath.Join(base, "LUI", "src"))
		assertNotExists(t, filepath.Join(base, "LUI", "example.plugin"))
		assertExists(t, filepath.Join(base, "keep", "keep.plugin"))
	})

	t.Run("Delete folder + contents and root folder if empty and additionally delete related folders on the same level", func(t *testing.T) {
		base := t.TempDir()

		mustMkdirAll(t, filepath.Join(base, "Acumen", "api"))
		mustMkdirAll(t, filepath.Join(base, "Acumen", "src", "Utils"))
		mustWriteFile(t, filepath.Join(base, "Acumen", "src", "Utils", "helper.go"))
		mustWriteFile(t, filepath.Join(base, "Acumen", "example.plugin"))

		mustMkdirAll(t, filepath.Join(base, "AcumenReloader"))
		mustWriteFile(t, filepath.Join(base, "AcumenReloader", "init.lua"))

		mustMkdirAll(t, filepath.Join(base, "keep"))
		mustWriteFile(t, filepath.Join(base, "keep", "keep.plugin"))

		i := &Installer{}

		err := i.DeleteFiles(base, []string{
			"Acumen/api",
			"Acumen/src",
			"Acumen/example.plugin",
			"AcumenReloader/init.lua",
		})

		if err != nil {
			t.Fatal(err)
		}

		assertNotExists(t, filepath.Join(base, "Acumen", "api"))
		assertNotExists(t, filepath.Join(base, "Acumen", "src"))
		assertNotExists(t, filepath.Join(base, "Acumen", "example.plugin"))
		assertNotExists(t, filepath.Join(base, "Acumen"))
		assertNotExists(t, filepath.Join(base, "AcumenReloader", "init.lua"))
		assertNotExists(t, filepath.Join(base, "AcumenReloader"))

		assertExists(t, filepath.Join(base, "keep", "keep.plugin"))
	})

	t.Run("Empty files list doesn't throw an error", func(t *testing.T) {
		base := t.TempDir()
		i := &Installer{}

		err := i.DeleteFiles(base, []string{})

		if err != nil {
			t.Fatal(err)
		}
	})
}
