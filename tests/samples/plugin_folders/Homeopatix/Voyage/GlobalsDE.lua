------------------------------------------------------------------------------------------
-- localization file
-- Written by Homeopatix
-- 7 january 2021
------------------------------------------------------------------------------------------
function CreateLocalizationInfo()
	Strings = {
		Teleport = {}
	};

	------------------------------------------------------------------------------------------
	-- Deutsche --
	------------------------------------------------------------------------------------------
		Strings.PluginName = "Voyage";
		Strings.PluginText = "Von Homeopatix";
		Strings.PluginEscEnable = "Escape-Taste aktiviert";
		Strings.PluginEscDesable = "Escape-Taste deaktiviert";
		Strings.PluginAltEnable = "Alt-Taste aktiviert";
		Strings.PluginAltDesable = "Alt-Taste deaktiviert";
		Strings.PluginOptionsText = "Voyage Optionen";
		Strings.PluginTitreHelpWindow = "Hilfe f\195\188r Voyage";
		Strings.PluginHouseText = "Hauslage";
		------------------------------------------------------------------------------------------
		-- help --
		------------------------------------------------------------------------------------------
		Strings.PluginHelp1 = "\n\nListe der Befehle:\n";
		Strings.PluginHelp2 = "/Voy help - Schaufenster help.\n";
		Strings.PluginHelp3 = "/Voy show - Schaufenster.\n";
		Strings.PluginHelp4 = "/Voy hide - verstecke das Fenster.\n";
		Strings.PluginHelp5 = "/Voy default - Verkn\195\188pfungen zur\195\188cksetzen.\n";
		Strings.PluginHelp6 = "/Voy lock um die Symbole zu sperren oder zu entsperren\n";
		Strings.PluginHelp7 = "/Voy options - Zeigen Sie das Optionsfenster an.\n";
		Strings.PluginHelp8 = "/Voy clear - L\195\182schen Sie alle Verkn\195\188pfungen.\n";
		Strings.PluginHelp9 = "/Voy clearteleport - L\195\182schen Sie alle Meilensteinpositionen.\n";
		Strings.PluginHelp10 = "/Voy alt - ALT-Taste gedr\195\188ckt halten, um das Symbol zu verschieben.\n";
		Strings.PluginHelp11 = "/Voy clearhouse - L\195\182schen Sie alle Standorte der H\195\164user.\n\n";
		Strings.PluginHelp12 = "Klicken Sie mit der rechten Maustaste auf das Symbol, um das Optionsfeld anzuzeigen";
		Strings.PluginHelp13 = "Zeigen Sie Standard-Reputationsverkn\195\188pfungen an. Sie k\195\182nnen das \195\164stchen deaktivieren\n";
		Strings.PluginHelp14 = "< Reputationsreise anzeigen >, um sie auszuschalten\n\n";
		Strings.PluginHelp15 = "Sie k\195\182nnen die Position der Verkn\195\188pfungen \195\164ndern oder weitere hinzuf\195\188gen, indem Sie sie ziehen und ablegen und auf klicken\n";
		Strings.PluginHelp16 = "< Behalten Sie Ihre \195\132nderungen > bei, um die automatische Generierung von Verkn\195\188pfungen zu deaktivieren\n";
		Strings.PluginHelp17 = "und behalten Sie Ihre \195\132nderungen\n\n";
		Strings.PluginHelp18 = "Sie k\195\182nnen den Standort Ihrer verschiedenen H\195\164user definieren, indem Sie auf das Symbol klicken\n";
		Strings.PluginHelp19 = "des kleinen Hauses rechts vom Text\n\n";
		Strings.PluginHelp20 = "Sie k\195\182nnen den Ort Ihrer Meilensteine ​​definieren, indem Sie auf das Symbol klicken\n\n";
		Strings.PluginHelp21 = "Sie k\195\182nnen eine Verkn\195\188pfung mit dem Mausrad l\195\182schen\n\n";
		Strings.PluginHelp22 = "Sie k\195\182nnen mit der rechten Maustaste auf eine Verkn\195\188pfung klicken, um die Karte des Ziels anzuzeigen\n";
		Strings.PluginHelp23 = "oder klicken Sie mit der rechten Maustaste auf dieselbe Verkn\195\188pfung, um sie zu schlie\195\159en\n\n";
		------------------------------------------------------------------------------------------
		-- map window --
		------------------------------------------------------------------------------------------
		Strings.PluginMap1 = "schlie\195\159e das Fenster";
		Strings.PluginMap2 = "Nicht definiert";
		------------------------------------------------------------------------------------------
		-- house location  --
		------------------------------------------------------------------------------------------
		Strings.PluginHousePersonal = "Pers\195\182nliche Hauslage";
		Strings.PluginHouseConfrerie = "Haus der Bruderschaft";
		Strings.PluginHouseConfrerieFriend = "Bruderschaft Freund Haus";
		Strings.PluginHousePremium = "Premium-Haus";
		Strings.PluginHouse1 = " BreeLand";
		Strings.PluginHouse2 = " Falathlorn";
		Strings.PluginHouse3 = " Thorins halle";
		Strings.PluginHouse4 = " AuenLand";
		Strings.PluginHouse5 = " Ostfold-H\195\188gel";
		Strings.PluginHouse6 = " K\195\182nigsstattweiden";
		Strings.PluginHouse7 = " kaps von Belfalas";
		Strings.PluginHouseAlert = "Pers\195\182nliches Haus nicht in den Optionen definiert";
		Strings.PluginTeleportAlert = "Meilenstein nicht in Optionen definiert";
		------------------------------------------------------------------------------------------
		-- command text  --
		------------------------------------------------------------------------------------------
		Strings.PluginWindowShow = "Schaufenster.";
		Strings.PluginWindowHide = "Verstecke das Fenster.";
		Strings.PluginWindowDefault = "Auf Standardeinstellungen zur\195\188cksetzen.";
		Strings.PluginWindowClear = "L\195\182schen Sie alle Verkn\195\188pfungen.";
		Strings.PluginWindowClearTeleport = "L\195\182schen Sie alle Meilensteinpositionen.";
		Strings.PluginWindowClearHouse = "L\195\182schen Sie alle Standorte der H\195\164user.";
		Strings.PluginLocked = "Gesperrte Symbole";
		Strings.PluginUnlocked = "Symbole freigeschaltet";
		------------------------------------------------------------------------------------------
		-- option window --
		------------------------------------------------------------------------------------------
		Strings.PluginOption1 = "Anzahl der Zeilen";
		Strings.PluginOption2 = "Anzahl der Steckpl\195\164tze pro Zeile";
		Strings.PluginOption3 = "Anzahl Zu einem gebundenen Markstein zur\195\188ckkehren";
		Strings.PluginOption4 = "Zur\195\188ck zuhause...";
		Strings.PluginOption5 = " Eigenes Heim";
		Strings.PluginOption6 = " Heim Eurer Sippe";
		Strings.PluginOption7 = " Premiumheim";
		Strings.PluginOption8 = "Reputationsreisen anzeigen";
		Strings.PluginOption9 = " Ja";
		Strings.PluginOption10 = "\195\132nderungen validieren";
		Strings.PluginOption11 = "Heim des Sippenmitglieds";
		Strings.PluginOption12 = " Behalten Sie Ihre \195\132nderungen";
		Strings.PluginOptionAlert = "!!! REINITIALISIEREN SIE ALLE KURZSCHNITTE !!!";
		Strings.PluginOptionShowWindow = "Zeigen Sie das Optionsfenster an";
		------------------------------------------------------------------------------------------
		-- label text  --
		------------------------------------------------------------------------------------------
		Strings.PluginLabel1 = "Pers\195\182nliche Hauslage";
		Strings.PluginLabel2 = "Verwandtschaftshaus Lage";
		Strings.PluginLabel3 = "Verwandtschaftsfreund Hausstandort";
		Strings.PluginLabel4 = "Premium Hauslage";
		Strings.PluginLabel5 = "Zeigen Sie die Hilfe";
		Strings.PluginButtonHelpWindow = "Hilfe schlie\195\159en";
		------------------------------------------------------------------------------------------
		-- TELEPORT LOCATIONS --
		------------------------------------------------------------------------------------------
		Strings.PluginDefinTeleport = "Meilenstein definieren";
		------------------------------------------------------------------------------------------
		-- Teleport Location  REGION --
		------------------------------------------------------------------------------------------
		Strings.TeleportRegion1 = "Eregion";
		Strings.TeleportRegion2 = "Rhovanion";
		Strings.TeleportRegion3 = "Gondor";
		Strings.TeleportRegion4 = "Mordor";
		------------------------------------------------------------------------------------------
		-- Teleport sous Location  Eregion --
		------------------------------------------------------------------------------------------
		Strings.TeleportSousRegion1 = "Angmar";
		Strings.TeleportSousRegion2 = "Breeland";
		Strings.TeleportSousRegion3 = "Enedwaith ";
		Strings.TeleportSousRegion4 = "Ered Luin";
		Strings.TeleportSousRegion5 = "Eregion";
		Strings.TeleportSousRegion6 = "Evendim";
		Strings.TeleportSousRegion7 = "Forochel";
		Strings.TeleportSousRegion8 = "Einsame Lande";
		Strings.TeleportSousRegion9 = "Nebel-Gebirge";
		Strings.TeleportSousRegion10 = "Nordh\195\182hen";
		Strings.TeleportSousRegion11 = "Auen-Land";
		Strings.TeleportSousRegion12 = "Trollh\195\182hen";
		------------------------------------------------------------------------------------------
		-- Teleport sous Location Rhovanion --
		------------------------------------------------------------------------------------------
		Strings.TeleportSousRegion13 = "Lothl\195\179rien";
		Strings.TeleportSousRegion14 = "D\195\188sterwald";
		Strings.TeleportSousRegion15 = "Moria";
		Strings.TeleportSousRegion16 = "Trum Dreng";
		Strings.TeleportSousRegion17 = "Les landes farouches";
		--Strings.TeleportSousRegion18 = "Pren Gwydh";
		--Strings.TeleportSousRegion19 = "T\195\162l Methedras";
		--Strings.TeleportSousRegion20 = "\195\182dmoor";
		--Strings.TeleportSousRegion21 = "Deutwald";
		--Strings.TeleportSousRegion22 = "Dunmoor";
		--Strings.TeleportSousRegion23 = "Carreglyn";
		Strings.TeleportSousRegion24 = "Heathfells";
		Strings.TeleportSousRegion25 = "Nan Curun\195\173r";
		Strings.TeleportSousRegion26 = "Isengard";
		Strings.TeleportSousRegion27 = "Nan Curun\195\173r";
		Strings.TeleportSousRegion28 = "Braune Lande";
		--Strings.TeleportSousRegion29 = "Eorlsaue";
		--Strings.TeleportSousRegion30 = "Eorlsaue";
		--Strings.TeleportSousRegion31 = "Parth Celebrant";
		--Strings.TeleportSousRegion32 = "Die BinsenLache";
		--Strings.TeleportSousRegion33 = "Thinglad";
		Strings.TeleportSousRegion34 = "entwasser-tal";
		Strings.TeleportSousRegion35 = "Norhofen";
		Strings.TeleportSousRegion36 = "Suthofen";
		Strings.TeleportSousRegion37 = "Der ostwall";
		Strings.TeleportSousRegion38 = "Die steppe";
		Strings.TeleportSousRegion39 = "K\195\182nigsstatt";
		Strings.TeleportSousRegion40 = "Ostfold";
		Strings.TeleportSousRegion41 = "Weite mark";
		Strings.TeleportSousRegion42 = "felssenke";
		Strings.TeleportSousRegion43 = "Westfold";
		Strings.TeleportSousRegion44 = "Helms klamm";
		Strings.TeleportSousRegion45 = "Die T\195\164ler des Anduin";    
		Strings.TeleportSousRegion46 = "Quellen des Langflut";     -- new to add
		Strings.TeleportSousRegion47 = "Altestental";     -- new to add
		Strings.TeleportSousRegion48 = "Eisenberge";     -- new to add
		Strings.TeleportSousRegion49 = "Das Thalland";     -- new to add
		Strings.TeleportSousRegion50 = "Ered Mithrin";     -- new to add
		Strings.TeleportSousRegion51 = "Azanulbizar";     -- new in the U30
		------------------------------------------------------------------------------------------
		-- Teleport sous Location Gondor --
		------------------------------------------------------------------------------------------
		Strings.TeleportSousRegion52 = "Schwarzgrundtal";
		Strings.TeleportSousRegion53 = "Lamedon";
		Strings.TeleportSousRegion54 = "Anfurten von Belfalas";
		Strings.TeleportSousRegion55 = "Ringl\195\179tal";
		Strings.TeleportSousRegion56 = "Dor-en-Ernil";
		Strings.TeleportSousRegion57 = "Unter-Lebennin";
		Strings.TeleportSousRegion58 = "Ober-Lebennin";
		Strings.TeleportSousRegion59 = "Lossarnach";
		Strings.TeleportSousRegion60 = "S\195\188d-Ithilien";
		Strings.TeleportSousRegion61 = "Weites An\195\179rien";
		Strings.TeleportSousRegion62 = "Taur Dr\195\186adan";
		Strings.TeleportSousRegion63 = "Talath Anor";
		Strings.TeleportSousRegion64 = "Pelennor";
		Strings.TeleportSousRegion65 = "Pelennor, nach Kampf";
		Strings.TeleportSousRegion66 = "Nord-Ithilien";
		------------------------------------------------------------------------------------------
		-- Teleport sous Location Mordor --
		------------------------------------------------------------------------------------------
		Strings.TeleportSousRegion67 = "Das \195\150dland";
		Strings.TeleportSousRegion68 = "Torech Ungol";
		--Strings.TeleportSousRegion63 = "Minas Morgul";
		Strings.TeleportSousRegion69 = "Ud\195\185n";
		Strings.TeleportSousRegion70 = "Dor Amarth";
		Strings.TeleportSousRegion71 = "Lhingris";
		Strings.TeleportSousRegion72 = "Talath \195\154rui";
		Strings.TeleportSousRegion73 = "Agarnaith";
		Strings.TeleportSousRegion74 = "Belagertes Mordor";
		Strings.TeleportSousRegion75 = "Das Morgultal";
		------------------------------------------------------------------------------------------
		-- Teleport Location Angmar --
		------------------------------------------------------------------------------------------
		Strings.Teleport[1] = " Aughaire";
		Strings.Teleport[2] = " Gath Forthn\195\173r";
		Strings.Teleport[3] = " Imlad Balchorth";
		Strings.Teleport[4] = " T\195\161rmunn S\195\186rsa";
		Strings.Teleport[5] = " Gabilshath\195\187r";
		------------------------------------------------------------------------------------------
		-- Teleport Location Bree-land --
		------------------------------------------------------------------------------------------
		Strings.Teleport[6] = " Archet";
		Strings.Teleport[7] = " Bree - S\195\188dtor";
		Strings.Teleport[8] = " Bree - T\195\164nzelnden Pony";
		Strings.Teleport[9] = " Bree - Westtor";
		Strings.Teleport[10] = " Siedlung Breeland";
		Strings.Teleport[11] = " Buckland";
		Strings.Teleport[12] = " Schlucht";
		------------------------------------------------------------------------------------------
		-- Teleport Location Enedwaith  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[13] = " Echad Dagoras";
		Strings.Teleport[14] = " Lhanuch";
		Strings.Teleport[15] = " Harndirion";
		Strings.Teleport[16] = " Maur Tulhau";
		Strings.Teleport[17] = " N\195\161r's Peak";
		Strings.Teleport[18] = " Lich Bluffs";
		Strings.Teleport[19] = " Trauerh\195\182hen";
		------------------------------------------------------------------------------------------
		-- Teleport Location Ered Luin  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[20] = " Celondim";
		Strings.Teleport[21] = " Duillond";
		Strings.Teleport[22] = " Gondamon";
		Strings.Teleport[23] = " Siedlung Falathlorn";
		Strings.Teleport[24] = " Thorins Halle";
		Strings.Teleport[25] = " Siedlung Thorin's Hall ";
		------------------------------------------------------------------------------------------
		-- Teleport Location Eregion  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[26] = " Gwingris";
		Strings.Teleport[27] = " Echad Eregion";
		Strings.Teleport[28] = " Echad Dunann";
		Strings.Teleport[29] = " Echad Mirobel";
		------------------------------------------------------------------------------------------
		-- Teleport Location Evendim  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[30] = " Tinnudir";
		Strings.Teleport[31] = " Ann\195\186minas";
		Strings.Teleport[32] = " Der traufenspitz";
		Strings.Teleport[33] = " Feste Forod";
		Strings.Teleport[34] = " Kreuzung des K\195\182nigs";
		Strings.Teleport[35] = " Hafergut";
		Strings.Teleport[36] = " Dwaling";
		------------------------------------------------------------------------------------------
		-- Teleport Location Forochel  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[37] = " Kauppa-kohta";
		Strings.Teleport[38] = " Pynti-peldot";
		Strings.Teleport[39] = " Zigilgund";
		Strings.Teleport[40] = " Kuru-leiri";
		Strings.Teleport[41] = " S\195\187ri-kyl\195\164";
		------------------------------------------------------------------------------------------
		-- Teleport Location The Lone-lands  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[42] = " Ost Guruth";
		Strings.Teleport[43] = " Die verlassene Herberge";

		------------------------------------------------------------------------------------------
		-- Teleport Location The misty moutains  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[44] = " Gl\195\179in's lager";
		Strings.Teleport[45] = " Vindurhal";
		------------------------------------------------------------------------------------------
		-- Teleport Location The north Downs  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[46] = " Esteld\195\173n";
		Strings.Teleport[47] = " Schragen";
		------------------------------------------------------------------------------------------
		-- Teleport Location The shire  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[48] = " Dashbauten";
		Strings.Teleport[49] = " Balgfurt";
		Strings.Teleport[50] = " Hobbingen";
		Strings.Teleport[51] = " L\195\188tzel-Binge";
		Strings.Teleport[52] = " Michel-Binge";
		Strings.Teleport[53] = " Siedlung Auenland";
		------------------------------------------------------------------------------------------
		-- Teleport Location The trollshaws  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[54] = " Echad Candelleth";
		Strings.Teleport[55] = " Bruchtal";
		Strings.Teleport[56] = " Thorenhad";
		------------------------------------------------------------------------------------------
		-- Teleport Region Rhovanion  --
		------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------
		-- Teleport Location Lothorien  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[57] = " Caras Galadhon";
		Strings.Teleport[58] = " Mekhem-bizru";
		Strings.Teleport[59] = " Echad Andestel";
		Strings.Teleport[60] = " Imlad Lalaith";
		------------------------------------------------------------------------------------------
		-- Teleport Location Mirkwood  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[61] = " Dunkelsenke";
		Strings.Teleport[62] = " Heimgesuchte gasthaus";
		Strings.Teleport[63] = " Feste Galadh";
		Strings.Teleport[64] = " Estolad Mernael";
		Strings.Teleport[65] = " Mithechad";
		Strings.Teleport[66] = " Thang\195\186lhad";
		------------------------------------------------------------------------------------------
		-- Teleport Location Moria  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[67] = " Dis gro\195\159binge";
		Strings.Teleport[68] = " Durins weg";
		Strings.Teleport[69] = " Tiefer abgrund";
		Strings.Teleport[70] = " kammer des scheidewegs";
		Strings.Teleport[71] = " Einundzwanzigste halle";
		Strings.Teleport[72] = " Die lodernden tiefen";
		Strings.Teleport[73] = " Das Wasser-Werk";
		Strings.Teleport[74] = " Stein-Fundament";
		Strings.Teleport[75] = " Rothorn-Adern";
		Strings.Teleport[76] = " Jaz\195\162rgund";
		Strings.Teleport[77] = " Die Reisszahngrube";
		------------------------------------------------------------------------------------------
		-- Teleport Location Pays de Dun  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[78] = " Lhan Tarren";
		Strings.Teleport[79] = " Echad Naeglanc";
		Strings.Teleport[80] = " Galtrev";
		Strings.Teleport[81] = " T\195\162l Methedras tor";
		Strings.Teleport[82] = " Avardin";
		Strings.Teleport[83] = " Kundschafterlager der Rohirrim";
		Strings.Teleport[84] = " Lhan Rhos";
		Strings.Teleport[85] = " Barnavon";
		------------------------------------------------------------------------------------------
		-- Teleport Location landes farouche  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[86] = " Forlach";
		------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------
		-- Teleport Location Heathfells  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[87] = " Forthbrond";
		Strings.Teleport[88] = " Grimbold's Lager";
		------------------------------------------------------------------------------------------
		-- Teleport Location Nan Curun\195\173r  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[89] = " Dagoras' Lager";
		------------------------------------------------------------------------------------------
		-- Teleport Location Isengard  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[90] = " Ochsen-Clan-Handelslager";
		------------------------------------------------------------------------------------------
		-- Teleport Location Nan Curun\195\173r  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[91] = " Isengard (nach)";
		------------------------------------------------------------------------------------------
		-- Teleport Location Le grand fleuve  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[92] = " Etheburg";
		Strings.Teleport[93] = " Stangard";
		Strings.Teleport[94] = " Klageh\195\188gel";
		Strings.Teleport[95] = " Parth Celebrant";
		Strings.Teleport[96] = " Aculf's lager";
		Strings.Teleport[97] = " Haldirith";
		------------------------------------------------------------------------------------------
		-- Teleport Location Entwash Vale  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[98] = " Eaworth";
		Strings.Teleport[99] = " Dornenwarte";
		------------------------------------------------------------------------------------------
		-- Teleport Location Norcrofts  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[100] = " Stadt des waldmeisters";
		Strings.Teleport[101] = " Elthengels";
		Strings.Teleport[102] = " Feldheim";
		------------------------------------------------------------------------------------------
		-- Teleport Location Sutcrofts  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[103] = " Garsfeld";
		Strings.Teleport[104] = " Hytbold";
		Strings.Teleport[105] = " Schneegrenze";
		Strings.Teleport[106] = " Walstow";
		------------------------------------------------------------------------------------------
		-- Teleport Location The East Wall  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[107] = " Mansigs lager";
		Strings.Teleport[108] = " Parth Galen";
		------------------------------------------------------------------------------------------
		-- Teleport Location The Wold  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[109] = " Harwick";
		Strings.Teleport[110] = " Flutwend";
		Strings.Teleport[111] = " Langhold";
		------------------------------------------------------------------------------------------
		-- Teleport Location Kingstead  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[112] = " Entfurt";
		Strings.Teleport[113] = " Mittelaue";
		Strings.Teleport[114] = " Edoras";
		Strings.Teleport[115] = " Hochborn";
		Strings.Teleport[116] = " Unterharg";
		Strings.Teleport[117] = " Dunharg";
		------------------------------------------------------------------------------------------
		-- Teleport Location Eastfold  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[118] = " Aldburg";
		Strings.Teleport[119] = " Leuchtfeuerwacht";
		Strings.Teleport[120] = " Fenmarkt";
		------------------------------------------------------------------------------------------
		-- Teleport Location Eastfold  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[121] = " Oserley";
		Strings.Teleport[122] = " Schlotheim";
		------------------------------------------------------------------------------------------
		-- Teleport Location Stonedeans  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[123] = " Holzm\195\188hle";
		Strings.Teleport[124] = " Bachbr\195\188cke";
		Strings.Teleport[125] = " Gapholt";
		------------------------------------------------------------------------------------------
		-- Teleport Location Westfold  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[126] = " Grimslade";
		Strings.Teleport[127] = " Helms klamm";
		------------------------------------------------------------------------------------------
		-- Teleport Location Helm's Deep  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[128] = " Helms klamm";
		------------------------------------------------------------------------------------------
		-- Teleport Location val d'andiun  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[129] = " Beorningh\195\186s";
		Strings.Teleport[130] = " Hultvis";
		Strings.Teleport[131] = " Arhaim";
		Strings.Teleport[132] = " Blomgard";
		Strings.Teleport[133] = " Vegbar";
		------------------------------------------------------------------------------------------
		-- Teleport Location puit du long fleuve  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[134] = " Liml\195\179k";
		Strings.Teleport[135] = " Thokvist";
		Strings.Teleport[136] = " Lyndelby";
		Strings.Teleport[137] = " Hlithseld";
		------------------------------------------------------------------------------------------
		-- Teleport Location val d'Aïeul  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[138] = " Ann\195\187k-khurfu";
		------------------------------------------------------------------------------------------
		-- Teleport Location iron hills  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[139] = " Hammerstatt"; -- new to add from here
		Strings.Teleport[140] = " J\195\161rnfast"; -- new to add from here
		------------------------------------------------------------------------------------------
		-- Teleport Location terres de dale  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[141] = " Thal"; -- new to add from here
		Strings.Teleport[142] = " Erebor"; -- new to add from here
		Strings.Teleport[143] = " Seestadt"; -- new to add from here
		Strings.Teleport[144] = " Loeglong"; -- new to add from here
		Strings.Teleport[145] = " Felegoth"; -- new to add from here
		Strings.Teleport[146] = " Tham Taerdol"; -- new to add from here
		------------------------------------------------------------------------------------------
		-- Teleport Location ered mithrin  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[147] = " Dornholz"; -- new to add from here
		------------------------------------------------------------------------------------------
		-- Teleport Location azanulbizar --
		------------------------------------------------------------------------------------------
		Strings.Teleport[148] = " Gabilthurkhu"; -- new to add from U30
		------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------
		-- Teleport sous Location Gondor  --
		------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------
		-- Teleport Location Blackroot Vale  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[149] = " Morlad";
		Strings.Teleport[150] = " Alagrant";
		Strings.Teleport[151] = " Sardol";
		Strings.Teleport[152] = " Lancrath";
		------------------------------------------------------------------------------------------
		-- Teleport Location Lamedon  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[153] = " D\195\173nadab";
		Strings.Teleport[154] = " Calembel";
		------------------------------------------------------------------------------------------
		-- Teleport Location Havens of Belfalas  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[155] = " Tadrent";
		Strings.Teleport[156] = " Ost Lontir";
		Strings.Teleport[157] = " Dol Amroth";
		------------------------------------------------------------------------------------------
		-- Teleport Location Ringl\195\179 Vale  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[158] = " Ethring";
		------------------------------------------------------------------------------------------
		-- Teleport Location Dor-en-Ernil  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[159] = " Linhir";
		------------------------------------------------------------------------------------------
		-- Teleport Location Lebennin  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[160] = " Feste Anglebed";
		Strings.Teleport[161] = " Pelargir";
		------------------------------------------------------------------------------------------
		-- Teleport Location Upper Lebennin  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[162] = " Glaniath";
		Strings.Teleport[163] = " Tumladen";
		------------------------------------------------------------------------------------------
		-- Teleport Location Lossarnach  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[164] = " Arnach";
		Strings.Teleport[165] = " Imloth Melui";
		------------------------------------------------------------------------------------------
		-- Teleport Location South Ithilien  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[166] = " B\195\162r H\195\186rin";
		Strings.Teleport[167] = " Faramirs aussichtspunkt";
		------------------------------------------------------------------------------------------
		-- Teleport Location Far anorien  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[168] = " Ost Rimmon";
		------------------------------------------------------------------------------------------
		-- Teleport Location taur druadan  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[169] = " Eilenach";
		Strings.Teleport[170] = " Taur Dr\195\186adan";
		------------------------------------------------------------------------------------------
		-- Teleport Location talath Anor  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[171] = " Crithost";
		------------------------------------------------------------------------------------------
		-- Teleport Location Pelennor  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[172] = " Minas Tirith";
		------------------------------------------------------------------------------------------
		-- Teleport Location Pelennor après la bataille --
		------------------------------------------------------------------------------------------
		Strings.Teleport[173] = " Aragorn Pavillon";
		Strings.Teleport[174] = " Osgiliath";
		------------------------------------------------------------------------------------------
		-- Teleport Location ithilien du nord --
		------------------------------------------------------------------------------------------
		Strings.Teleport[175] = " Henneth Ann\195\187n";
		------------------------------------------------------------------------------------------
		-- Teleport sous Location Mordor  --
		------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------
		-- Teleport Location landes desertique  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[176] = " Lager des Heeres";
		Strings.Teleport[177] = " Die SchlackeH\195\188gel";
		Strings.Teleport[178] = " Haerondir";
		------------------------------------------------------------------------------------------
		-- Teleport Location torech ungol  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[179] = " Amon Amarth";
		------------------------------------------------------------------------------------------
		-- Teleport Location Udun  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[180] = " Ud\195\185n-Br\195\188ckenkopf";
		------------------------------------------------------------------------------------------
		-- Teleport Location Dor Amarth  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[181] = " Ruinen von Dingarth";
		------------------------------------------------------------------------------------------
		-- Teleport Location lingrish  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[182] = " Rath Cail";
		Strings.Teleport[183] = " Lant Angos";
		------------------------------------------------------------------------------------------
		-- Teleport Talath Urui  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[184] = " Talath \195\186rui";
		------------------------------------------------------------------------------------------
		-- Teleport Agarnaith  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[185] = " Agarnaith";
		Strings.Teleport[186] = " Dol R\195\187dh";
		------------------------------------------------------------------------------------------
		-- Teleport Location mordor besieged  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[187] = " Dingarth";
		Strings.Teleport[188] = " Echad-in-Edhil";		
		Strings.Teleport[189] = " Adambel";
		Strings.Teleport[190] = " Barthost";
		------------------------------------------------------------------------------------------
		-- Teleport Location morgul  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[191] = " Minas Morgul";
		Strings.Teleport[192] = " Echad Taerdim";
		Strings.Teleport[193] = " Echad Uial";
		Strings.Teleport[194] = " Estolad L\195\160n";
		Strings.Teleport[195] = " Taen Orwath";
end