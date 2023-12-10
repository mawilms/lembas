package internal

import (
	"testing"
)

func setupTestCase(t *testing.T) func(t *testing.T) {
	t.Log("setup test case")
	return func(t *testing.T) {
		t.Log("teardown test case")
	}
}

func TestOpen(t *testing.T) {
	teardownTestCase := setupTestCase(t)
	defer teardownTestCase(t)

	//store := Datastore{
	//	Path: "Bla",
	//}
	//
	//content, err := store.Open()
	//if err != nil {
	//	t.Errorf("Unable to read JSON file. Error: %v", err)
	//}
}
