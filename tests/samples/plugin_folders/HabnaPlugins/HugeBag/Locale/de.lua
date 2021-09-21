-- de.lua
-- Written by Habna -- Translated with google, Wicky & DaBear78.


_G.L = {};
L["HBLang"] = "HugeBag: Deutsche Sprache geladen!";-- Thx DaBear78!
L["HBLoad"] = "HugeBag " .. Version .. " von Habna geladen!";

--Misc
L["ButDel"] = "L\195\182schen von Informationen dieser Art"; --Löschen
--L[""] = "";

--Main form (Widget)
L["HugeBag"] = "HugeBag";
L["HugeBag--"] = "HugeBag - ";
L["Free"] = "Frei: ";
L["Max"] = "  Max: ";
L["Used"] = "  Belegt: ";
L["Sort"] = "[S]";-- Sortieren, Thx DaBear78!
L["Merge"] = "[St]";-- Stapeln, Thx DaBear78!
L["Search"] = "[Su]";
L["Bags"] = "[R]";
L["Vault"] = "[B]";
L["SStorage"] = "[G]";
L["FF"] = "F";
L["UU"] = "B";
L["MM"] = "M";

--Main form (Window)
L["HB--"] = "HB - ";
L["F"] = "F: ";
L["U"] = "  B: ";
L["M"] = "  M: ";

--Options window
L["OWinLP"] = "Legen Sie Profil-Einstellungen";
L["OWinSP"] = "Speichern der aktuellen Einstellungen zum Profil";

--Options widget
L["OWidLoc"] = "Position des Widgets ...";-- Thx DaBear78!
L["OWidLocL"] = "links";
L["OWidLocR"] = "rechts";
L["OWidTop"] = "Optionen oberer Bereich ...";-- Thx DaBear78!
L["OWidTopT"] = "Bild anzeigen";-- Thx DaBear78!
L["OWidTopI"] = "Informationen anzeigen";
L["OWidTopN"] = "Nichts anzeigen";-- Thx DaBear78!
L["OWidSide"] = "Optionen Seitenbereich ...";-- Thx DaBear78!
L["OWidBot"] = "Optionen unterer Bereich ...";-- Thx DaBear78!
L["OWidAOT"] = "'Immer im Vordergrund' von HugeBag umschalten";-- Thx DaBear78!
L["OWidIM"] = "Stapel-Funktion umkehren";-- Thx DaBear78!
L["OWidBC"] = "\195\132ndern der Hintergrundfarbe";--Ändern -- Thx DaBear78!
L["OWidL"] = "Sprache \195\164ndern ...";-- Thx Wicky! -- Ändern
L["OWidLen"] = "Englisch";
L["OWidLfr"] = "Franz\195\182sisch";-- Thx Wicky! -- Französisch
L["OWidLde"] = "Deutsch";
L["OWidView"] = "Anzeigen ";-- Thx DaBear78!
L["OWidSort"] = "Sortieren";-- Thx DaBear78!
L["OWidMerge"] = "Stapeln";-- Thx DaBear78!
L["OWidSearch"] = "Suche";
L["OWidBags"] = "rucksack";
L["OWidVault"] = "bankfach";-- Thx DaBear78!
L["OWidStorage"] = "gemeinsamer Lagerraum";-- Thx DaBear78!
L["OWidNeed"] = "Einmaliges \195\150ffnen von '";-- Thx DaBear78! --Öffnen
L["OWidOnce"] = "' n\195\182tig, damit die Anzeige m\195\182glich ist.";-- Thx DaBear78! --nötig, möglich

-- Background window
L["BWTitle"] = "Farbeinstellung";-- Thx Wicky!
L["BWAlpha"] = "Alpha";
L["BWCurSetColor"] = "Aktuelle Farbe";
L["BWSave"] = "Speichern";-- Thx Wicky!
L["BWDef"] = "Standard";-- Thx DaBear78!
L["BWBlack"] = "Schwarz";

-- Vault window
L["VTh"] = "Bankfach";-- Thx DaBear78!
L["VTnd"] = "Es wurden keine Daten f\195\188r diesen Charakter gefunden";--für
L["VTID"] = " vault info gel\195\182scht!"; --gelöscht
L["VTSe"] = "Suchen:"
L["VTAll"] = "-- Alle --"

-- Shared Storage window
L["SSh"] = "gemeinsamer Lagerraum";-- Thx DaBear78!
L["SSnd"] = "M\195\188ssen Sie Ihre gemeinsamer Lagerraum mindestens einmal \195\182ffnen";--Müssen, öffnen

-- Backpack window
L["BIh"] = "Rucksack";
L["BID"] = " Taschen info gel\195\182scht!"; --gelöscht

-- Bank window
L["BKh"] = "Bank";-- Thx DaBear78!

--Functions output text
L["FEscH"] = "HugeBag: Beim Dr\195\188cken der 'Esc'-Taste ausblenden";--Drücken -- Thx DaBear78!
L["FEscS"] = "HugeBag: Beim Dr\195\188cken der 'Esc'-Taste sichtbar bleiben";--Drücken -- Thx DaBear78!
L["FLoadS"] = "HugeBag: Ab dem n\195\164chsten Mal nach dem Laden automatisch anzeigen";--nächsten -- Thx DaBear78!
L["FLoadH"] = "HugeBag: Ab dem n\195\164chsten Mal nach dem Laden automatisch verbergen";--nächsten -- Thx DaBear78!
L["FWidget"] = "HugeBag: Ab dem n\195\164chsten Mal im Widget-Modus laden";--nächsten -- Thx DaBear78!
L["FWin"] = "HugeBag: Ab dem n\195\164chsten Mal im Fenster-Modus laden";--nächsten -- Thx DaBear78!
L["FAOTS"] = "HugeBag: Ab dem n\195\164chsten Mal immerim Vordergrund anzeigen";--nächsten -- Thx DaBear78!
L["FAOTH"] = "HugeBag: Ab dem n\195\164chsten Mal nicht immer im Vordergrund anzeigen";--nächsten -- Thx DaBear78!
L["FMergeD"] = "HugeBag: Stapeln von Gegenst\195\164nden ";--Gegenständen -- Thx DaBear78!
L["FMerge1"] = " zu 1";
L["FMergeU"] = "HugeBag: Stapele Gegenst\195\164nde 1 bis ";--Gegenstände -- Thx DaBear78!
L["FButVis"] = "HugeBag: Die Kn\195\182pfe sind nun eingeblendet";--Knöpfe -- Thx DaBear78!
L["FButNVis"] = "HugeBag: Die Kn\195\182pfe sind nun ausgeblendet";--Knöpfe -- Thx DaBear78!
L["FSortVis"] = "HugeBag: Schaltfl\195\164che Sortieren jetzt sichtbar"; --Schaltfläche
L["FSortNVis"] = "HugeBag: Schaltfl\195\164che Sortieren jetzt unsichtbar" --Schaltfläche
L["FMergeVis"] = "HugeBag: Merge-Taste nun sichtbar";
L["FMergeNVis"] = "HugeBag: Merge-Taste nun unsichtbar"
L["FSearchVis"] = "HugeBag: Suchen-Schaltfl\195\164che jetzt sichtbar"; --Schaltfläche
L["FSearchNVis"] = "HugeBag: Suchen-Schaltfl\195\164che jetzt unsichtbar"; --Schaltfläche
L["FBagsVis"] = "HugeBag: rucksack jetzt sichtbar";
L["FBagsNVis"] = "HugeBag: rucksack nun unsichtbar";
L["FVaultVis"] = "HugeBag: bankfach jetzt sichtbar";
L["FVaultNVis"] = "HugeBag: bankfach nun unsichtbar";
L["FSShVis"] = "HugeBag: Sgemeinsamer Lagerraum jetzt sichtbar";
L["FSSNVis"] = "HugeBag: gemeinsamer Lagerraum nun unsichtbar";
L["BLT"] = "HugeBag: Jetzt zeigt langen Text";
L["BST"] = "HugeBag: Jetzt zeigt kurze Text";
L["FCP"] = "HugeBag: Kein Profil-Einstellungen gefunden wurde. Profil wurde erstellt mit den aktuellen Einstellungen";
L["FLP"] = "HugeBag: Profil-Einstellungen wurden erfolgreich geladen";
L["FSP"] = "HugeBag: Die aktuellen Einstellungen werden im Profil gespeichert";

--Functions window output text
L["FSlotsS"] = "HugeBag: Platz-Info im Titel zeigen";-- Thx DaBear78!
L["FSlotsH"] = "HugeBag: Platz-Info nicht im Titel zeigen";-- Thx DaBear78!
L["FSkinS"] = "HugeBag: Skin & Titel anzeigen";-- Thx DaBear78!
L["FSkinH"] = "HugeBag: Weder Skin noch Titel anzeigen";-- Thx DaBear78!
L["FIH"] = "HugeBag: Gegenst\195\164nde horizontal anordnen";--Gegenstände -- Thx DaBear78!
L["FIV"] = "HugeBag: Gegenst\195\164nde vertikal anordnen";--Gegenstände -- Thx DaBear78!
L["FSL"] = "HugeBag: Das Fenster ist nicht ver\195\164nderbar";--veränderbar -- Thx DaBear78!
L["FSNL"] = "HugeBag: Das Fenster ist ver\195\164nderbar";--veränderbar -- Thx DaBear78!
L["FPL"] = "HugeBag: Die Fenster-Position ist jetzt gesperrt";-- Thx DaBear78!
L["FPNL"] = "HugeBag: Die Fenster-Position ist nun freigegeben";-- Thx DaBear78!
L["ISE"] = "HugeBag: Die Funktion, um die Gr\195\182\195\159e der Icons \195\164ndern ist nun aktiviert";--Größe, ändern
L["ISD"] = "HugeBag: Die Funktion, um die Gr\195\182\195\159e der Icons \195\164ndern ist jetzt deaktiviert";--Größe, ändern

--Functions widget output text
L["FWidShow"] = "HugeBag: Unm\195\182glich, ich bin schon sichtbar";--Unmöglich -- Thx DaBear78!
L["FWidTBTitle"] = "HugeBag: Zeige Bild im oberen Bereich";-- Thx DaBear78!
L["FWidTBInfo"] = "HugeBag: Zeige Informationen im oberen Bereich";-- Thx DaBear78!
L["FWidTBNot"] = "HugeBag: Zeige nichts im oberen Bereich";-- Thx DaBear78!
L["FWidSBImg"] = "HugeBag: Zeige Bild im Seitenbereich";-- Thx DaBear78!
L["FWidSBInfo"] = "HugeBag: Zeige Informationen im Seitenbereich";-- Thx DaBear78!
L["FWidSBNot"] = "HugeBag: Zeige nichts im Seitenbereich";-- Thx DaBear78!
L["FWidActive"] = "HugeBag: Kann die Kn\195\182pfe nicht anzeigen/verbergen w\195\164hrend 'Sortieren', 'Stapeln' oder 'Suchen' aktiv ist!";--während -- Thx DaBear78!
L["FWidHide"] = "HugeBag: Unm\195\182glich, ich bin schon versteckt";--Unmöglich -- Thx DaBear78!

--Settings widget output text
L["SWidRA"] = "HugeBag: Alle Einstellungen wurden auf Standard zur\195\188ckgesetzt";--zurückgesetzt -- Thx DaBear78!

--Settings window output text
L["SWinRLS"] = "HugeBag: Gr\195\182\195\159e und Position auf Standard zur\195\188ckgesetzt";--Größe, zurückgesetzt -- Thx DaBear78!

--Widget & Window shell commands
L["SCWTitle"] = "HugeBag Shell-Befehle";-- Thx DaBear78!
L["SC0"] = "Dieser Befehl wird nicht unterstützt";
L["SC1"] = "Zeige HugeBag";
L["SC2"] = "HugeBag ausblenden";
L["SC3"] = "HugeBag entfernen";-- Thx DaBear78!
L["SC4"] = "HugeBag neuladen";-- Thx DaBear78!
L["SC5"] = "Alle Einstellungen auf Standard zur\195\188cksetzen";--Zurückstellen -- Thx DaBear78!
L["SC6"] = "HugeBag beim Dr\195\188cken der 'Esc'-Taste angezeigt lassen / verbergen";--Drücken -- Thx DaBear78!
L["SC7"] = "HugeBag nach dem Laden anzeigen / verbergen";-- Thx DaBear78!
L["SC8"] = "Umschalten zwischen Fenster- und Widget-Modus";-- Thx DaBear78!
L["SC9"] = "Immer im Vordergrund";-- Thx DaBear78!
L["SC10"] = "Kn\195\182pfe anzeigen / verbergen";--Knöpfe -- Thx DaBear78!
L["SC11"] = "Inventar sortieren (Mit freundlicher Genehmigung von MrJackdaw)";-- Thx DaBear78!
L["SC12"] = "Stapelbare Gegenst\195\164nde stapeln";--Gegenstände -- Thx DaBear78!
L["SC13"] = "Stapel-Funktion Standard: 1 bis 45/75";-- Thx DaBear78!
L["SC14"] = "Zeige Shell-Befehle";
L["SC15"] = "Optionen anzeigen";
L["SC16"] = "Anzeigen / ausblenden Schaltfl\195\164che Sortieren";--Schaltfläche
L["SC17"] = "Anzeigen / ausblenden Merge-Taste";
L["SC18"] = "Anzeigen / ausblenden Schaltfl\195\164che Suchen";--Schaltfläche
L["SC19"] = "Anzeigen / ausblenden rucksack";
L["SC20"] = "Anzeigen / ausblenden bankfach";
L["SC21"] = "Anzeigen / ausblenden gemeinsamer lagerraum";
L["SC22"] = L["OWinLP"];
L["SC23"] = L["OWinSP"];
L["SC24"] = "Anzeigen / ausblenden Schaltfl\195\164che rucksack";
L["SC25"] = "Anzeigen / ausblenden Schaltfl\195\164che bankfach";
L["SC26"] = "Anzeigen / ausblenden Schaltfl\195\164che gemeinsamer lagerraum";
L["SC27"] = "\195\132ndern Schaltfl\195\164chen Icon/Text"; -- Ändern, Schaltflächen

L["SCa1"] = "anzeige";
L["SCb1"] = "shb / ";
L["SCa2"] = "verbergen";
L["SCb2"] = "hhb / ";
L["SCa3"] = "entfernen";-- Thx DaBear78!
L["SCb3"] = "  u / ";
L["SCa4"] = "neuladen";-- Thx DaBear78!
L["SCb4"] = "  r / ";
L["SCa5"] = "zur\195\188cksetzen";--zurücksetzen
L["SCb5"] = " ra / ";
L["SCa6"] = "wesc";
L["SCb6"] = "  w / ";
L["SCa7"] = "sichtbar";
L["SCb7"] = "  v / ";
L["SCa8"] = "modus";
L["SCb8"] = "hbm / ";
L["SCa9"] = "vordergrund";-- Thx DaBear78!
L["SCb9"] = "aot / ";
L["SCa10"] = "kn\195\182pfe";--knöpfe -- Thx DaBear78!
L["SCb10"] = " bv / ";
L["SCa11"] = "sortieren";-- Thx DaBear78!
L["SCb11"] = " si / ";
L["SCa12"] = "stapeln";-- Thx DaBear78!
L["SCb12"] = " mi / ";
L["SCa13"] = "r\195\188ckg\195\164ngig";--rückgängig -- Thx DaBear78!
L["SCb13"] = " im / ";
L["SCa14"] = "hilfe";-- Thx DaBear78!
L["SCb14"] = " sc / ";
L["SCa15"] = "optionen";
L["SCb15"] = "opt / ";
L["SCa16"] = "zeigenart";
L["SCb16"] = "sbv / ";
L["SCa17"] = "zeigenverschmelzen";
L["SCb17"] = "mbv / ";
L["SCa18"] = "zeigensuche";
L["SCb18"] = "ebv / ";
L["SCa19"] = "rucksack";
L["SCb19"] = "bp / ";
L["SCa20"] = "bankfach";
L["SCb20"] = "vt / ";
L["SCa21"] = "gemeinsamer lagerraum";
L["SCb21"] = "ss / ";
L["SCa22"] = "Lastprofil";
L["SCb22"] = "lp / ";
L["SCa23"] = "Profil speichern";
L["SCb23"] = "sp / ";
L["SCa24"] = "showbags";
L["SCb24"] = "bbv / ";
L["SCa25"] = "showvault";
L["SCb25"] = "vbv / ";
L["SCa26"] = "showss";
L["SCb26"] = "hbv / ";
L["SCa27"] = "wechseln";
L["SCb27"] = "sbb / ";

--Widget shell commands



--Window shell commands
L["WinSC1"] = "Position und Gr\195\182\195\159e auf Standard setzen";--Größe -- Thx DaBear78!
L["WinSC2"] = "Skin & Titel anzeigen / ausblenden";-- Thx DaBear78!
L["WinSC3"] = "Orientierung der Gegenst\195\164nde \195\164ndern";--Gegenstände, Ändern -- Thx DaBear78!
L["WinSC4"] = "Sperren / entsperren der Gr\195\182\195\159e";--Größe -- Thx DaBear78!
L["WinSC5"] = "Sperren / entsperren der Position";
L["WinSC6"] = "Aktivieren/Deaktivieren Symbol Justagefunktion";

L["WinSCa1"] = "zur\195\188cksetzenpg";--zurücksetzen
L["WinSCb1"] = "rls / ";
L["WinSCa2"] = "skin";-- Thx DaBear78!
L["WinSCb2"] = " sk / ";
L["WinSCa3"] = "orientierung";-- Thx DaBear78!
L["WinSCb3"] = " io / ";
L["WinSCa4"] = "gr\195\182\195\159e";--Größe -- Thx DaBear78!
L["WinSCb4"] = " ls / ";
L["WinSCa5"] = "positionsperren";-- Thx DaBear78!
L["WinSCb5"] = " lp / ";
L["WinSCa6"] = "icon-Gr\195\182\195\159e";--Größe
L["WinSCb6"] = " is / ";

--Merge
L["FAMergeS"] = "HugeBag: Stapeln gestartet";-- Thx DaBear78!
L["FAMergeF"] = "HugeBag: Stapeln abgeschlossen";-- Thx DaBear78!
L["FAMergeE"] = "Kann nicht stapeln w\195\164hrend 'sortieren', 'stapeln' oder 'Suche' aktiv ist!";-- Thx DaBear78! --während
L["FAMergeFA"] = " abgeschlossen nach ";-- Thx DaBear78!
L["FAMergeSec"] = " Sekunden";-- Thx DaBear78!

--Sort
L["FSSortS"] = "HugeBag: Sortierung gestartet";-- Thx DaBear78!
L["FSSortF"] = "HugeBag: Sortierung beendet";-- Thx DaBear78!
L["FSSortE"] = "Kann nicht zu sortieren, wenn 'sortieren', 'stapeln' oder 'Suche' aktiv ist!";-- Thx DaBear78!
L["FSSortFS"] = "HugeBag: Aus Sicherheitsgr\195\188nden wurde die Sortierung abgebrochen, da sie nicht abgeschlosssen werden konnte nach ";--Sicherheitsgründen -- Thx DaBear78!

--Items menu
L["All"] = "Alle";
L["ShowAll"] = "Alle Gegenst\195\164nde";--Gegenstände -- Thx DaBear78!
L["Show"] = "Anzeige ...";
L["Potions"] = "Tr\195\164nke";--Tränke
L["Healing"] = "Healing";
L["Tools"] = "Werkzeuge";
L["Devices"] = "Ger\195\164te";--Geräte
L["Jewelry"] = "Geschmeide";-- Thx DaBear78!
L["Components"] = "Komponenten";
L["BR"] = "Tausch & Ruf";-- Thx DaBear78!
L["QI"] = "Quest-Items";-- Thx DaBear78!
L["Resources"] = "Ressourcen";
L["Perks"] = "Verbesserungen";-- Thx DaBear78!
L["Misc"] = "Verschiedenes";-- Thx DaBear78!
L["Misc2"] = "Verschiedenes 2";-- Thx DaBear78!
L["Mounts"] = "Reittiere";-- Thx DaBear78!
L["Special"] = "Besonderes";-- Thx DaBear78!
L["Dye"] = "Farbe";-- Thx DaBear78!
L["Relic"] = "Relikt";
L["Festival"] = "Festival";
L["Book"] = "Barde Buch";
L["Tome"] = "W\195\164lzer";--Wälzer
L["ShowBuff"] = "Zeige St\195\164rkungszauber ...";--Stärkungszauber -- Thx DaBear78!
L["Scroll"] = "Schriftrolle";-- Thx DaBear78!
L["Trap"] = "Falle";
L["SP"] = "Schildstachel";
L["Oil"] = "\195\150l";
L["ShowLegendary"] = "Zeige Legend\195\164res ...";--legendäres -- Thx DaBear78!
L["WE"] = "Waffen-Erfahrung";-- Thx DaBear78!
L["WIML"] = "Steigerung des Waffen-Levels";-- Thx DaBear78!
L["WRL"] = "Waffen-Eigenschaften tauschen";-- Thx DaBear78!
L["WR"] = "Waffenpunkte zur\195\188cksetzen";--Zurücksetzen -- Thx DaBear78!
L["WUL"] = "Waffen-Verm\195\164chtnis steigern";--Vermächtnis -- Thx DaBear78!
L["ShowFishing"] = "Zeige Angeln ...";
L["Fish"] = "Fisch";
L["Bait"] = "K\195\182der";--Köder
L["Pole"] = "Angelrute";
L["Other"] = "Andere";
L["ShowFoods"] = "Zeige Lebensmittel ...";-- Thx DaBear78!
L["Food"] = "Lebensmittel";
L["ShowIngredient"] = "Zeige Zutat ...";-- Thx DaBear78!
L["Ingredient"] = "Zutat";
L["OI"] = "Optionale Zutaten";-- Thx DaBear78!
L["ShowTrophys"] = "Zeige Troph\195\164en ...";--Trophäen
L["Trophy"] = "Troph\195\164e";--Trophäe
L["ST"] = "besondere Troph\195\164e";--Trophäe
L["ShowRecipes"] = "Alle Rezepte ...";
L["MS"] = "R\195\188stungsschmied";--Rüstungsschmied -- Thx DaBear78!
L["WS"] = "Waffenschmied";
L["Tailor"] = "Schneider";
L["Jeweller"] = "Goldschmied";-- Thx DaBear78!
L["Cook"] = "Koch";-- Thx DaBear78!
L["Scholar"] = "Gelehrter";-- Thx DaBear78!
L["WW"] = "Drechsler";-- Thx DaBear78!
L["Farmer"] = "Bauer";-- Thx DaBear78!
L["Prospecter"] = "Sch\195\188rfer";--Schürfer -- Thx DaBear78!
L["Forester"] = "F\195\182rster";--Förster -- Thx DaBear78!
L["Apprentice"] = "Lehrling";
L["Journeyman"] = "Geselle";-- Thx DaBear78!
L["Expert"] = "Experte";
L["Artisan"] = "Virtuose";-- Thx DaBear78!
L["Master"] = "Meister";-- Thx DaBear78!
L["Supreme"] = "\195\156berragend";--Überragend-- Thx DaBear78!
L["Westfold"] = "Westfold";
L["ShowWeapon"] = "Alle Waffen ...";
L["Axe"] = "Axt";-- Thx DaBear78!
L["Club"] = "Keule";-- Thx DaBear78!
L["Crossbow"] = "Armbrust";
L["Bow"] = "Bogen";
L["Dagger"] = "Dolch";
L["Halberd"] = "Hellebarde";
L["Mace"] = "Streitkolben";
L["Staff"] = "Stab";-- Thx DaBear78!
L["Sword"] = "Schwert";
L["Hammer"] = "Hammer";
L["Orb"] = "Runenstein";-- Thx DaBear78!
L["Javelin"] = "Wurfspeer";-- Thx DaBear78!
L["Spear"] = "Speer";-- Thx DaBear78!
L["ShowArmor"] = "Alle R\195\188stungen ...";--R\195\188stungen
L["Shoes"] = "Schuhe";-- Thx DaBear78!
L["Leggings"] = "Hosen";-- Thx DaBear78!
L["Gloves"] = "Handschuhe";-- Thx DaBear78!
L["Chest"] = "Brust";
L["Cloak"] = "Umh\195\164nge";--Umhänge -- Thx DaBear78!
L["Hat"] = "H\195\188te";--Hüte -- Thx DaBear78!
L["Shield"] = "Schilde";-- Thx DaBear78!
L["GuardianBelt"] = "W\195\164chter G\195\188rtel"; -- Wächter, Gürtel -- Thx DaBear78!
L["ShowClass"] = "Zeige Klassen-Gegenst\195\164nde ...";--Gegenstände -- Thx DaBear78!
L["ShowCosmetic"] = "Zeige Zierwerk-Artikel ...";-- Thx DaBear78!
L["Back"] = "zur\195\188ck";--zurück
L["Head"] = "Kopf";
L["UB"] = "Oberk\195\182rper";--Oberkörper -- Thx DaBear78!
L["Feet"] = "F\195\188\195\159e";--Füße -- Thx DaBear78!
L["Shoulder"] = "Schultern";
L["ShowDecoration"] = "Zeige Dekorationen ...";-- Thx DaBear78!
L["Ceiling"] = "Decke";
L["Floor"] = "Boden";
L["Furniture"] = "M\195\182bel";--Möbel
L["Music"] = "Musik";
L["Yard"] = "Hof";
L["Wall"] = "Wand";
L["SurfacePaint"] = "Wandfarbe";-- Thx DaBear78!

-- Free People Class
L["Guardian"] = "W\195\164chter"; -- Wächter
L["Captain"] = "Hauptmann";
L["Minstrel"] = "Barde";
L["Burglar"] = "Schurke";
L["Hunter"] = "J\195\164ger"; --Jäger
L["Champion"] = "Waffenmeister";
L["Lore-Master"] = "Kundiger";
L["Rune-Keeper"] = "Runenbewahrer";
L["Warden"] = "H\195\188ter"; -- Hüter -- Thx DaBear78!