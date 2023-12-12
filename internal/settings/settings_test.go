package settings

import "testing"

func TestFindLotroFolder(t *testing.T) {
	_, err := findLotroDirectory()
	if err != nil {
		t.Error("Unable to locate lotro directory")
	}
}
