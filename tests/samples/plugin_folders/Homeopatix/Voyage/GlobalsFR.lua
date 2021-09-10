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
	-- Francais --
	------------------------------------------------------------------------------------------
		Strings.PluginName = "Voyage";
		Strings.PluginText = "Par Homeopatix";
		Strings.PluginEscEnable = "Touche Escape activ\195\169";
		Strings.PluginEscDesable = "Touche Escape desactiv\195\169";
		Strings.PluginAltEnable = "Touche Alt activ\195\169";
		Strings.PluginAltDesable = "Touche Alt desactiv\195\169";
		Strings.PluginOptionsText = "Voyage Options";
		Strings.PluginTitreHelpWindow = "Aide Pour Voyage";
		Strings.PluginHouseText = "Emplacement de maison";
		------------------------------------------------------------------------------------------
		-- help --
		------------------------------------------------------------------------------------------
		Strings.PluginHelp1 = "\n\nListe des commandes:\n";
		Strings.PluginHelp2 = "/Voy help - affiche la fen\195\168tre. d'aide\n";
		Strings.PluginHelp3 = "/Voy show - affiche la fen\195\168tre.\n";
		Strings.PluginHelp4 = "/Voy hide - cache la fen\195\168tre.\n";
		Strings.PluginHelp5 = "/Voy lock pour verrouill\195\169 ou d\195\169verrouill\195\169 les icones\n";
		Strings.PluginHelp6 = "/Voy default - r\195\169initialise les raccourcis.\n";
		Strings.PluginHelp7 = "/Voy options - affiche la fen\195\168tre d'options.\n";
		Strings.PluginHelp8 = "/Voy clear - efface tous les raccourcis.\n";
		Strings.PluginHelp9 = "/Voy clearteleport - Efface tous les teleports.\n";
		Strings.PluginHelp10 = "/Voy alt - Active ou d\195\169sactive la touche alt pour le d\195\169placement de l'icon.\n";
		Strings.PluginHelp11 = "/Voy clearhouse - Efface toute les emplacments de maison.\n\n";
		Strings.PluginHelp12 = "Clique droit sur l'icon pour afficher la fen\195\168tre d'options\n\n";
		Strings.PluginHelp13 = "Affiche les raccourcis de r\195\169putation par d\195\169fault, vous pouvez d\195\169sactiver le checkBox\n";
		Strings.PluginHelp14 = "< Afficher le voyage de r\195\169putation > pour les d\195\169sactiver\n\n";
		Strings.PluginHelp15 = "Vous pouvez modifier l'emplacement des raccourcis ou en rajouter en glisser/d\195\169poser et cliquez sur\n";
		Strings.PluginHelp16 = "< Conserver les raccourcis > pour d\195\169sactiver la g\195\169n\195\169ration automatique des raccourcis\n";
		Strings.PluginHelp17 = "et conserver vos modifications\n\n";
		Strings.PluginHelp18 = "Vous pouvez d\195\169finir l'emplacement de vos dif\195\169rentes maison en cliquant sur l'icone\n";
		Strings.PluginHelp19 = "de la petite maison \195\160 droite du texte\n\n";
		Strings.PluginHelp20 = "Vous pouvez d\195\169finir l'emplacement de vos point de rep\195\168re li\195\169s en cliquant sur l'icone\n\n";
		Strings.PluginHelp21 = "Vous pouvez effacer un raccourci avec la molette de la souris\n\n";
		Strings.PluginHelp22 = "Vous pouvez faire un clique droite sur un raccourcis pour afficher la carte de la destination\n";
		Strings.PluginHelp23 = "et faire un clique droite sur le m\195\170me raccourcis pour la fermer\n\n";
		------------------------------------------------------------------------------------------
		-- map window --
		------------------------------------------------------------------------------------------
		Strings.PluginMap1 = "Fermer la fen\195\170tre";
		Strings.PluginMap2 = "Non d\195\169finis";
		------------------------------------------------------------------------------------------
		-- house location  --
		------------------------------------------------------------------------------------------
		Strings.PluginHousePersonal = "Maison personnelle";
		Strings.PluginHouseConfrerie = "Maison de confr\195\169rie";
		Strings.PluginHouseConfrerieFriend = "Maison d'amis de confr\195\169rie";
		Strings.PluginHousePremium = "Maison premium";
		Strings.PluginHouse1 = " Bree";
		Strings.PluginHouse2 = " Falathlorn";
		Strings.PluginHouse3 = " Palais de Thorin";
		Strings.PluginHouse4 = " La Comt\195\169";
		Strings.PluginHouse5 = " l'Estfolde";
		Strings.PluginHouse6 = " Prairies de terre-du-roi";
		Strings.PluginHouse7 = " Cap de Belfalas";
		Strings.PluginHouseAlert = "Maison personelle non d\195\169finis dans les options";
		Strings.PluginTeleportAlert = "point de rep\195\168re li\195\169 non d\195\169finis dans les options";
		------------------------------------------------------------------------------------------
		-- command text  --
		------------------------------------------------------------------------------------------
		Strings.PluginWindowShow = "Affiche la fen\195\168tre.";
		Strings.PluginWindowHide = "Cache la fen\195\168tre.";
		Strings.PluginWindowDefault = "R\195\169initialise les param\195\168tres par d\195\169faut.";
		Strings.PluginWindowClear = "Efface tous les raccourcis.";
		Strings.PluginWindowClearTeleport = "Efface tous les teleport.";
		Strings.PluginWindowClearHouse = "Efface toute les emplacments de maison.";
		Strings.PluginLocked = "Icones verrouill\195\169es";
		Strings.PluginUnlocked = "Icones d\195\169verouill\195\169es";
		------------------------------------------------------------------------------------------
		-- option window --
		------------------------------------------------------------------------------------------
		Strings.PluginOption1 = "Nombre de lignes";
		Strings.PluginOption2 = "Nombre d'emplacements par ligne";
		Strings.PluginOption3 = "Nombre de Retour \195\160 un point de rep\195\168re li\195\169";
		Strings.PluginOption4 = "Retour \195\160 la Maison...";
		Strings.PluginOption5 = " Maison personnelle";
		Strings.PluginOption6 = " Maison de confr\195\169rie";
		Strings.PluginOption7 = " Maison premium";
		Strings.PluginOption8 = "Afficher les voyages de r\195\169putation";
		Strings.PluginOption9 = " Oui";
		Strings.PluginOption10 = "Valider les changements";
		Strings.PluginOption11 = " Maison d'un membre de confr\195\169rie";
		Strings.PluginOption12 = " Conserver vos modifications";
		Strings.PluginOptionAlert = "!!! REINITIALIZE TOUS LES RACCOURCIS !!!";
		Strings.PluginOptionShowWindow = "Affiche la fen\195\168tre d'options";
		------------------------------------------------------------------------------------------
		-- label text  --
		------------------------------------------------------------------------------------------
		Strings.PluginLabel1 = "Emplacement la maison personnel";
		Strings.PluginLabel2 = "Emplacement de la maison de confr\195\169rie";
		Strings.PluginLabel3 = "Emplacement de la maison d'ami de la confr\195\169rie";
		Strings.PluginLabel4 = "Emplacement de la maison premium";
		Strings.PluginLabel5 = "Afficher l'aide";
		Strings.PluginButtonHelpWindow = "Fermer l'aide";
		------------------------------------------------------------------------------------------
		-- TELEPORT LOCATIONS --
		------------------------------------------------------------------------------------------
		Strings.PluginDefinTeleport = "Definir teleport";
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
		Strings.TeleportSousRegion2 = "Pays de Bree";
		Strings.TeleportSousRegion3 = "Enedwaith ";
		Strings.TeleportSousRegion4 = "Ered Luin";
		Strings.TeleportSousRegion5 = "Eregion";
		Strings.TeleportSousRegion6 = "Evendim";
		Strings.TeleportSousRegion7 = "Forochel";
		Strings.TeleportSousRegion8 = "Terres Solitaire";
		Strings.TeleportSousRegion9 = "Monts Brumeux";
		Strings.TeleportSousRegion10 = "Hauts du Nord";
		Strings.TeleportSousRegion11 = "La comt\195\169";
		Strings.TeleportSousRegion12 = "Trou\195\169e des Trolls";
		------------------------------------------------------------------------------------------
		-- Teleport sous Location Rhovanion --
		------------------------------------------------------------------------------------------
		Strings.TeleportSousRegion13 = "Lothl\195\179rien";
		Strings.TeleportSousRegion14 = "For\195\170t Noire";
		Strings.TeleportSousRegion15 = "Moria";
		Strings.TeleportSousRegion16 = "Pays de Dun"; -- new from here
		Strings.TeleportSousRegion17 = "Les landes farouches"; 
		--Strings.TeleportSousRegion18 = "Pren Gwydh";-- not needed
		--Strings.TeleportSousRegion19 = "T\195\162l Methedras";-- not needed
		--Strings.TeleportSousRegion20 = "Apreterre";-- not needed
		--Strings.TeleportSousRegion21 = "Boisouvr\195\169";-- not needed
		--Strings.TeleportSousRegion22 = "Marais de dun";-- not needed
		--Strings.TeleportSousRegion23 = "Carreglyn";-- not needed
		Strings.TeleportSousRegion24 = "Trou\195\169e du Rohan";
		Strings.TeleportSousRegion25 = "Nan Curun\195\173r";
		Strings.TeleportSousRegion26 = "Isengard";
		Strings.TeleportSousRegion27 = "Nan Curun\195\173r";
		Strings.TeleportSousRegion28 = "Le grand fleuve"; -- new from here
		--Strings.TeleportSousRegion29 = "Pr\195\169 des eorls";-- not needed
		--Strings.TeleportSousRegion30 = "Pr\195\169 des eorls";-- not needed
		--Strings.TeleportSousRegion31 = "Parth Celebrant";-- not needed
		--Strings.TeleportSousRegion32 = "Rushgore";-- not needed
		--Strings.TeleportSousRegion33 = "Clairfine";-- not needed
		Strings.TeleportSousRegion34 = "Vall\195\169e de l'entalluve";
		Strings.TeleportSousRegion35 = "Norcrofts";
		Strings.TeleportSousRegion36 = "Sutcrofts";
		Strings.TeleportSousRegion37 = "Le mur de l'est";
		Strings.TeleportSousRegion38 = "Le plateau";
		Strings.TeleportSousRegion39 = "Terre-du-roi";
		Strings.TeleportSousRegion40 = "Eastfold";
		Strings.TeleportSousRegion41 = "Grands-arpents";
		Strings.TeleportSousRegion42 = "Pierreval";
		Strings.TeleportSousRegion43 = "Ouestfold";
		Strings.TeleportSousRegion44 = "Gouffre de Helm";
		Strings.TeleportSousRegion45 = "Val d'Andiun";    
		Strings.TeleportSousRegion46 = "Puit du long fleuve";     -- new to add
		Strings.TeleportSousRegion47 = "Val d'A\195\175eul";     -- new to add
		Strings.TeleportSousRegion48 = "Monts du fer";     -- new to add
		Strings.TeleportSousRegion49 = "Terres de Dale";     -- new to add
		Strings.TeleportSousRegion50 = "Ered Mithrin";     -- new to add
		Strings.TeleportSousRegion51 = "Azanulbizar";     -- new in the U30
		------------------------------------------------------------------------------------------
		-- Teleport sous Location Gondor --
		------------------------------------------------------------------------------------------
		Strings.TeleportSousRegion52 = "Vall\195\169e de la racine noire";
		Strings.TeleportSousRegion53 = "Lamedon";
		Strings.TeleportSousRegion54 = "Havres de Belfalas";
		Strings.TeleportSousRegion55 = "Val de Ringl\195\179";
		Strings.TeleportSousRegion56 = "Dor-en-Ernil";
		Strings.TeleportSousRegion57 = "Bas-Lebennin";
		Strings.TeleportSousRegion58 = "Haut-Lebennin";
		Strings.TeleportSousRegion59 = "Lossarnach";
		Strings.TeleportSousRegion60 = "Ithilien du sud";
		Strings.TeleportSousRegion61 = "Lointain An\195\179rien";
		Strings.TeleportSousRegion62 = "Taur Dr\195\186adan";
		Strings.TeleportSousRegion63 = "Talath Anor";
		Strings.TeleportSousRegion64 = "Pelennor";
		Strings.TeleportSousRegion65 = "Pelennor, apr\195\168s bataille";
		Strings.TeleportSousRegion66 = "Ithilien du nord";
		------------------------------------------------------------------------------------------
		-- Teleport sous Location Mordor --
		------------------------------------------------------------------------------------------
		Strings.TeleportSousRegion67 = "La landes d\195\168sertiques";
		Strings.TeleportSousRegion68 = "Torech Ungol";
		--Strings.TeleportSousRegion63 = "Minas Morgul";
		Strings.TeleportSousRegion69 = "Ud\195\185n";
		Strings.TeleportSousRegion70 = "Dor Amarth";
		Strings.TeleportSousRegion71 = "Lhingris";
		Strings.TeleportSousRegion72 = "Talath \195\154rui";
		Strings.TeleportSousRegion73 = "Agarnaith";
		Strings.TeleportSousRegion74 = "Le si\195\168ge du Mordor";
		Strings.TeleportSousRegion75 = "Vall\195\168e de Morgul";
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
		Strings.Teleport[7] = " Bree - Porte Sud";
		Strings.Teleport[8] = " Bree - Le poney Fringant";
		Strings.Teleport[9] = " Bree - Porte Ouest";
		Strings.Teleport[10] = " R\195\169sidences de Bree";
		Strings.Teleport[11] = " Pays de Bouc";
		Strings.Teleport[12] = " Combe";
		------------------------------------------------------------------------------------------
		-- Teleport Location Enedwaith  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[13] = " Echad Dagoras";
		Strings.Teleport[14] = " Lhanoch";
		Strings.Teleport[15] = " Harndirion";
		Strings.Teleport[16] = " Maur Tulhau";
		Strings.Teleport[17] = " Pic de N\195\161r";
		Strings.Teleport[18] = " Rivemort";
		Strings.Teleport[19] = " Tristebois";
		------------------------------------------------------------------------------------------
		-- Teleport Location Ered Luin  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[20] = " Celondim";
		Strings.Teleport[21] = " Duillond";
		Strings.Teleport[22] = " Gondamon";
		Strings.Teleport[23] = " Propri\195\169t\195\169s de Falathlorn";
		Strings.Teleport[24] = " Palais de Thorin";
		Strings.Teleport[25] = " R\195\169sidences de Thorin";
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
		Strings.Teleport[32] = " Hautecimes";
		Strings.Teleport[33] = " Ost Forod";
		Strings.Teleport[34] = " Carrefour du roi";
		Strings.Teleport[35] = " Castelforge";
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
		Strings.Teleport[43] = " L'auberge abandonn\195\169e";

		------------------------------------------------------------------------------------------
		-- Teleport Location The misty moutains  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[44] = " Camp de Gl\195\179in";
		Strings.Teleport[45] = " Vindurhal";
		------------------------------------------------------------------------------------------
		-- Teleport Location The north Downs  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[46] = " Esteld\195\173n";
		Strings.Teleport[47] = " Pont-\195\160-tr\195\169teaux";
		------------------------------------------------------------------------------------------
		-- Teleport Location The shire  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[48] = " Trous des grisards";
		Strings.Teleport[49] = " Gu\195\169-du-pont";
		Strings.Teleport[50] = " Hobbitebourg";
		Strings.Teleport[51] = " Courtecave";
		Strings.Teleport[52] = " Grand'Cave";
		Strings.Teleport[53] = " R\195\169sidences de la comt\195\169";
		------------------------------------------------------------------------------------------
		-- Teleport Location The trollshaws  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[54] = " Echad Candelleth";
		Strings.Teleport[55] = " Foncombe";
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
		Strings.Teleport[61] = " L'or\195\169e noire";
		Strings.Teleport[62] = " L'auberge hant\195\169e";
		Strings.Teleport[63] = " Ost Galadh";
		Strings.Teleport[64] = " Estolad Mernael";
		Strings.Teleport[65] = " Mithechad";
		Strings.Teleport[66] = " Thang\195\186lhad";
		------------------------------------------------------------------------------------------
		-- Teleport Location Moria  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[67] = " Seuil de Durin";
		Strings.Teleport[68] = " Belv\195\169d\195\168re enfoui";
		Strings.Teleport[69] = " Longue descente";
		Strings.Teleport[70] = " Chambre de la crois\195\169e des chemins";
		Strings.Teleport[71] = " La vingt et uni\195\168me salle";
		Strings.Teleport[72] = " Profondeurs ardentes";
		Strings.Teleport[73] = " Syst\195\168me hydraulique";
		Strings.Teleport[74] = " Fondations de pierre";
		Strings.Teleport[75] = " Filons du Rubicorne";
		Strings.Teleport[76] = " Jaz\195\162rgund";
		Strings.Teleport[77] = " La Fosse mordante";
		------------------------------------------------------------------------------------------
		-- Teleport Location Pays de Dun  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[78] = " Lhan Tarren";
		Strings.Teleport[79] = " Echad Naeglanc";
		Strings.Teleport[80] = " Galtrev";
		Strings.Teleport[81] = " Porte de T\195\162l Methedras";
		Strings.Teleport[82] = " Apreterre";
		Strings.Teleport[83] = " Camp des Rohirrim";
		Strings.Teleport[84] = " Lhan Rhos";
		Strings.Teleport[85] = " Barnavon";
		------------------------------------------------------------------------------------------
		-- Teleport Location landes farouche  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[86] = " Forloi";
		------------------------------------------------------------------------------------------
		-- Teleport Location Heathfells  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[87] = " Brondavant";
		Strings.Teleport[88] = " Camp de Grimbold";
		------------------------------------------------------------------------------------------
		-- Teleport Location Nan Curun\195\173r  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[89] = " Camp de Dagoras";
		------------------------------------------------------------------------------------------
		-- Teleport Location Isengard  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[90] = " Camp marchants Ox-clan";
		------------------------------------------------------------------------------------------
		-- Teleport Location Nan Curun\195\173r  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[91] = " Isengard (Apr\195\168s)";
		------------------------------------------------------------------------------------------
		-- Teleport Location Le grand fleuve  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[92] = " Etheburg";
		Strings.Teleport[93] = " Stangard";
		Strings.Teleport[94] = " Collines G\195\169missantes";
		Strings.Teleport[95] = " Parth Celebrant";
		Strings.Teleport[96] = " Camp d'Aculf";
		Strings.Teleport[97] = " Haldirith";
		------------------------------------------------------------------------------------------
		-- Teleport Location Entwash Vale  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[98] = " Eaworth";
		Strings.Teleport[99] = " Esp\195\169ronce";
		------------------------------------------------------------------------------------------
		-- Teleport Location Norcrofts  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[100] = " Cliving";
		Strings.Teleport[101] = " Elthengels";
		Strings.Teleport[102] = " Faldham";
		------------------------------------------------------------------------------------------
		-- Teleport Location Sutcrofts  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[103] = " Garsfeld";
		Strings.Teleport[104] = " Hytbold";
		Strings.Teleport[105] = " Neigebronne";
		Strings.Teleport[106] = " Rangeval";
		------------------------------------------------------------------------------------------
		-- Teleport Location The East Wall  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[107] = " Campement de Mansig";
		Strings.Teleport[108] = " Parth Galen";
		------------------------------------------------------------------------------------------
		-- Teleport Location The Wold  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[109] = " Harwick";
		Strings.Teleport[110] = " Coudeflocs";
		Strings.Teleport[111] = " Langhold";
		------------------------------------------------------------------------------------------
		-- Teleport Location Kingstead  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[112] = " Gu\195\169 d'ent";
		Strings.Teleport[113] = " Bourgmitan";
		Strings.Teleport[114] = " Edoras";
		Strings.Teleport[115] = " Upbourn";
		Strings.Teleport[116] = " Sousharrow";
		Strings.Teleport[117] = " Dunharrow";
		------------------------------------------------------------------------------------------
		-- Teleport Location Eastfold  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[118] = " Aldburg";
		Strings.Teleport[119] = " Veillefeu";
		Strings.Teleport[120] = " Fenmarch";
		------------------------------------------------------------------------------------------
		-- Teleport Location Eastfold  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[121] = " Oserley";
		Strings.Teleport[122] = " Stoke";
		------------------------------------------------------------------------------------------
		-- Teleport Location Stonedeans  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[123] = " Tertebois";
		Strings.Teleport[124] = " Torrepont";
		Strings.Teleport[125] = " Gapholt";
		------------------------------------------------------------------------------------------
		-- Teleport Location Westfold  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[126] = " Grimslade";
		Strings.Teleport[127] = " Gouffre de helm";
		------------------------------------------------------------------------------------------
		-- Teleport Location Helm's Deep  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[128] = " Gouffre de helm";
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
		Strings.Teleport[139] = " Martelieu"; -- new to add from here
		Strings.Teleport[140] = " J\195\161rnfast"; -- new to add from here
		------------------------------------------------------------------------------------------
		-- Teleport Location terres de dale  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[141] = " Dale"; -- new to add from here
		Strings.Teleport[142] = " Erebor"; -- new to add from here
		Strings.Teleport[143] = " Ville du lac"; -- new to add from here
		Strings.Teleport[144] = " Loeglong"; -- new to add from here
		Strings.Teleport[145] = " Felegoth"; -- new to add from here
		Strings.Teleport[146] = " Tham Taerdol"; -- new to add from here
		------------------------------------------------------------------------------------------
		-- Teleport Location ered mithrin  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[147] = " Skarhald"; -- new to add from here
		------------------------------------------------------------------------------------------
		-- Teleport Location azanulbizar --
		------------------------------------------------------------------------------------------
		Strings.Teleport[148] = " Gabilthurkhu"; -- new to add from U30
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
		Strings.Teleport[160] = " Ost Anglebed";
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
		Strings.Teleport[167] = " Poste de Faramir";
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
		Strings.Teleport[173] = " Pavillion D'Aragorn";
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
		Strings.Teleport[176] = " Camp de l'arm\195\169e";
		Strings.Teleport[177] = " Collines Arides";
		Strings.Teleport[178] = " Haerondir";
		-----------------------------------------------------------------------------------------
		-- Teleport Location torech ungol  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[179] = " Amon Amarth";
		------------------------------------------------------------------------------------------
		-- Teleport Location Udun  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[180] = " Fort D'Ud\195\185n";
		-----------------------------------------------------------------------------------------
		-- Teleport Location Dor Amarth  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[181] = " Ruines de Dingarth";
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