package internal

import (
	"path/filepath"
	"reflect"
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
		expect      ArchiveInfo
	}{
		{"same root and plugin folder", "LUI-v2.2.1.zip", ArchiveInfo{
			RootFolder: "LUI",
			Files:      "LUI/LICENSES/,LUI/LUI.plugin,LUI/LUI.plugincompendium,LUI/LUIReloader.plugin,LUI/api/,LUI/assets/,LUI/reloader/,LUI/src/",
		}},
		{"different root and plugin folder", "Altholic.zip", ArchiveInfo{
			RootFolder: "Homeopatix",
			Files:      "Homeopatix/AltHolic.plugin,Homeopatix/AltHolic.plugincompendium,Homeopatix/AltHolic/",
		}},
		{"doesn't contain a plugincompendium file", "AH_Buyout_Calculator_0.5.zip", ArchiveInfo{
			RootFolder: "Munkey",
			Files:      "Munkey/Ah.plugin,Munkey/Ah/",
		}},
	}

	for _, tt := range tests {
		t.Run(tt.name, func(t *testing.T) {
			samplesPath := setupSamplesPath(t)

			got, err := analyzeZip(filepath.Join(samplesPath, tt.archiveName))
			if err != nil {
				t.Fatalf("unable to process ZIP file")
			}

			if !reflect.DeepEqual(*got, tt.expect) {
				t.Fatalf("infos are different; got %v, expected %v", got, tt.expect)
			}
		})
	}
}
