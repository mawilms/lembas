package internal

import "testing"

func TestDownloadPackageInformation(t *testing.T) {
	plugins, err := DownloadPackageInformation()
	if err != nil {
		t.Error(err)
	}

	_ = plugins
}
