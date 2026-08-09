package internal

import (
	"os"
	"path/filepath"
	"runtime"
	"testing"
)

var (
	_, b, _, _ = runtime.Caller(0)

	apiResponse = filepath.Join(filepath.Dir(b), "..", "test", "api_response.xml")
)

func TestParseXmlResponse(t *testing.T) {
	data, err := os.ReadFile(apiResponse)
	if err != nil {
		t.Fatal("Unable to read the sample file", err)
	}

	addons, err := ParseXmlResponse(data)
	if err != nil {
		t.Fatal("Failed to parse sample file", err)
	}

	if len(addons) != 5 {
		t.Fatalf("Expected 5 entries in the XML. Got %v", len(addons))
	}
}
