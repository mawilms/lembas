package models

import "testing"

func TestParseFavorites(t *testing.T) {
	content := []byte(`<Favorites>
	<Ui>
	<UID>1126</UID>
	<UIName>AltHolic</UIName>
	<UIAuthorName>homeopatix</UIAuthorName>
	<UIVersion>4.40</UIVersion>
	<UIUpdated>1701967106</UIUpdated>
	<UIDownloads>377841</UIDownloads>
	<UICategory>Bags Bank & Inventory</UICategory>
	<UIDescription>
	DESCRIPTION Francais AltHolic est un petit plugin pour avoir une vision rapide de vos alts Cliquer sur licon du petit sac de pieces pour affiche le portemonnaie du personnage slectionn Clique sur licone de la classe affiche lequipement du personnage slectionn Clique sur le coffre affiche le coffre du personnage slectionn Clique sur le sac dos affiche le sac dos du personnage slectionn Clique sur le petit coffre en haut a gauche pour afficher le stockage partag Clique sur la loupe pour effectu une recherche Clique sur...
	</UIDescription>
	<UIFile>AltHolicV4.40.zip</UIFile>
	<UIMD5/>
	<UISize>839424</UISize>
	<UIFileURL>
	http://www.lotrointerface.com/downloads/download1126
	</UIFileURL>
	</Ui>
	<Ui>
	<UID>1218</UID>
	<UIName>Festival Buddy II</UIName>
	<UIAuthorName>b414213562</UIAuthorName>
	<UIVersion>2.0.3</UIVersion>
	<UIUpdated>1701927807</UIUpdated>
	<UIDownloads>8216</UIDownloads>
	<UICategory>Other</UICategory>
	<UIDescription>
	Introduction Festival Buddy II is a simple tool to help you keep track of the festivities throughout Middleearth. It is an updated version of the original Festival Buddy by Galuhad. It will display the number of tokens in your wallet when some effects have expired e.g. the treasure chests in the Haunted Barrow and a simple quest guide for those quests that are easily forgotten. Theres also a dance instructor to help you with the dance quests and a barter list...
	</UIDescription>
	<UIFile>Festival Buddy II v2.0.3.zip</UIFile>
	<UIMD5/>
	<UISize>11724257</UISize>
	<UIFileURL>
	http://www.lotrointerface.com/downloads/download1218
	</UIFileURL>
	</Ui>
</Favorites>`)

	plugins, err := ParseFeed(content)
	if err != nil {
		t.Errorf("Error while parsing XML content: %v", err)
	}

	if len(plugins) != 2 {
		t.Errorf("Expected 2 plugins, got %v", len(plugins))
	}
}
