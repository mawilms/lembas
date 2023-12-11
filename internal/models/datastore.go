package models

type DatastoreModel map[string]DatastoreEntryModel

type DatastoreEntryModel struct {
	Plugin LocalPluginModel
	Files  []string
}
