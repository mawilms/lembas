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
		-- English --
		------------------------------------------------------------------------------------------
		Strings.PluginName = "Voyage";
		Strings.PluginText = "By Homeopatix";
		Strings.PluginEscEnable = "Escape key Activated";
		Strings.PluginEscDesable = "Escape key Desactivated";
		Strings.PluginAltEnable = "Alt key Activated";
		Strings.PluginAltDesable = "Alt key Desactivated";
		Strings.PluginOptionsText = "Options Voyage";
		Strings.PluginTitreHelpWindow = "Help for Voyage";
		Strings.PluginHouseText = "House location";
		------------------------------------------------------------------------------------------
		-- help --
		------------------------------------------------------------------------------------------
		Strings.PluginHelp1 = "\n\nList of all commands:\n";
		Strings.PluginHelp2 = "/Voy help - Show the help window.\n";
		Strings.PluginHelp3 = "/Voy show - Show the window.\n";
		Strings.PluginHelp4 = "/Voy hide - Hide the window.\n";
		Strings.PluginHelp5 = "/Voy default - Reset shortcuts.\n";
		Strings.PluginHelp6 = "/Voy lock to lock or unlock the icons\n";
		Strings.PluginHelp7 = "/Voy options - Display the options window.\n";
		Strings.PluginHelp8 = "/Voy clear - Delete all shortcuts.\n";
		Strings.PluginHelp9 = "/Voy clearteleport - Delete all the milestones location.\n";
		Strings.PluginHelp10 = "/Voy alt - Activate or deactivate the alt key to move the icon.\n";
		Strings.PluginHelp11 = "/Voy clearhouse - Delete all the houses locations.\n\n";
		Strings.PluginHelp12 = "Right click the icon to show the options panel\n\n";
		Strings.PluginHelp13 = "Display default reputation shortcuts, you can disable the checkBox\n";
		Strings.PluginHelp14 = "< Show reputation trip > to turn them off\n\n";
		Strings.PluginHelp15 = "You can change the location of the shortcuts or add more by dragging and dropping and click on\n";
		Strings.PluginHelp16 = "< Keep shortcuts > to disable automatic generation\n";
		Strings.PluginHelp17 = "of shortcuts and keep your changes\n\n";
		Strings.PluginHelp18 = "You can define the location of your different houses by clicking on the icon of the little house\n";
		Strings.PluginHelp19 = "on the right of the text\n\n";
		Strings.PluginHelp20 = "You can define the location of your milestones by clicking on the icon\n\n";
		Strings.PluginHelp21 = "You can delete a shortcut with the mouse wheel\n\n";
		Strings.PluginHelp22 = "You can right click on a shortcut to display the map of the destination ";
		Strings.PluginHelp23 = "and right click on the same shortcut to close it\n\n";
		------------------------------------------------------------------------------------------
		-- map window --
		------------------------------------------------------------------------------------------
		Strings.PluginMap1 = "Close the window";
		Strings.PluginMap2 = "Undefined";
		------------------------------------------------------------------------------------------
		-- house location  --
		------------------------------------------------------------------------------------------
		Strings.PluginHousePersonal = "Personal house location";
		Strings.PluginHouseConfrerie = "Kingship house location";
		Strings.PluginHouseConfrerieFriend = "Kingship Member's house location";
		Strings.PluginHousePremium = "Premium house location";
		Strings.PluginHouse1 = " Bree-Land";
		Strings.PluginHouse2 = " Falathlorn";
		Strings.PluginHouse3 = " Thorin's hall";
		Strings.PluginHouse4 = " The Shire";
		Strings.PluginHouse5 = " Eastfold hills";
		Strings.PluginHouse6 = " Kingstead meaddows";
		Strings.PluginHouse7 = " Cape of Belfalas";
		Strings.PluginHouseAlert = "Personal house not defined in the options";
		Strings.PluginTeleportAlert = "Milestone not defined in options";
		------------------------------------------------------------------------------------------
		-- command text  --
		------------------------------------------------------------------------------------------
		Strings.PluginWindowShow = "Show the window.";
		Strings.PluginWindowHide = "Hide the window.";
		Strings.PluginWindowDefault = "Reset to default settings.";
		Strings.PluginWindowClear = "Delete all shortcuts.";
		Strings.PluginWindowClearTeleport = "Delete all the milestones location.";
		Strings.PluginWindowClearHouse = "Delete all the houses locations.";
		Strings.PluginLocked = "Icons Locked";
		Strings.PluginUnlocked = "Icons Unlocked";
		------------------------------------------------------------------------------------------
		-- option window --
		------------------------------------------------------------------------------------------
		Strings.PluginOption1 = "Number of lines";
		Strings.PluginOption2 = "Number of slots per line";
		Strings.PluginOption3 = "Number of Return to a linked cue point";
		Strings.PluginOption4 = "Return to home...";
		Strings.PluginOption5 = " Personal House";
		Strings.PluginOption6 = " Kinship House";
		Strings.PluginOption7 = " Premium House";
		Strings.PluginOption8 = "Show reputation trip";
		Strings.PluginOption9 = " Yes";
		Strings.PluginOption10 = "Validate Changes";
		Strings.PluginOption11 = "Kinship Member's House";
		Strings.PluginOption12 = " Keep your changes";
		Strings.PluginOptionAlert = "!!! REINITIALIZE ALL SHORTCUTS !!!";
		Strings.PluginOptionShowWindow = "Display the options Window";
		------------------------------------------------------------------------------------------
		-- label text  --
		------------------------------------------------------------------------------------------
		Strings.PluginLabel1 = "Personal house location";
		Strings.PluginLabel2 = "Kinship house location";
		Strings.PluginLabel3 = "Kinship's friend house location";
		Strings.PluginLabel4 = "Premium house location";
		Strings.PluginLabel5 = "Show the Help";
		Strings.PluginButtonHelpWindow = "Close Help";
		------------------------------------------------------------------------------------------
		-- TELEPORT LOCATIONS --
		------------------------------------------------------------------------------------------
		Strings.PluginDefinTeleport = "Define Milestone";
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
		Strings.TeleportSousRegion2 = "Bree-land";
		Strings.TeleportSousRegion3 = "Enedwaith ";
		Strings.TeleportSousRegion4 = "Ered Luin";
		Strings.TeleportSousRegion5 = "Eregion";
		Strings.TeleportSousRegion6 = "Evendim";
		Strings.TeleportSousRegion7 = "Forochel";
		Strings.TeleportSousRegion8 = "The Lone-lands";
		Strings.TeleportSousRegion9 = "The Misty Mountains";
		Strings.TeleportSousRegion10 = "The North Downs";
		Strings.TeleportSousRegion11 = "The Shire";
		Strings.TeleportSousRegion12 = "The Trollshaws";
		------------------------------------------------------------------------------------------
		-- Teleport sous Location Rhovanion --
		------------------------------------------------------------------------------------------
		Strings.TeleportSousRegion13 = "Lothl\195\179rien";
		Strings.TeleportSousRegion14 = "Mirkwood";
		Strings.TeleportSousRegion15 = "Moria";
		Strings.TeleportSousRegion16 = "Trum Dreng";
		Strings.TeleportSousRegion17 = "Wildmoore";
		--Strings.TeleportSousRegion18 = "Pren Gwydh";
		--Strings.TeleportSousRegion19 = "T\195\162l Methedras";
		--Strings.TeleportSousRegion20 = "Starkmoor";
		--Strings.TeleportSousRegion21 = "Gravenwood";
		--Strings.TeleportSousRegion22 = "Dunbog";
		--Strings.TeleportSousRegion23 = "Carreglyn";
		Strings.TeleportSousRegion24 = "Heathfells";
		Strings.TeleportSousRegion25 = "Nan Curun\195\173r";
		Strings.TeleportSousRegion26 = "Isengard";
		Strings.TeleportSousRegion27 = "Nan Curun\195\173r";
		Strings.TeleportSousRegion28 = "Brown Lands";
		--Strings.TeleportSousRegion29 = "Eorlsmead";
		--Strings.TeleportSousRegion30 = "Eorlsmead";
		--Strings.TeleportSousRegion31 = "Parth Celebrant";
		--Strings.TeleportSousRegion32 = "The Rushgore";
		--Strings.TeleportSousRegion33 = "Thinglad";
		Strings.TeleportSousRegion34 = "Entwash Vale";
		Strings.TeleportSousRegion35 = "Norcrofts";
		Strings.TeleportSousRegion36 = "Sutcrofts";
		Strings.TeleportSousRegion37 = "The East Wall";
		Strings.TeleportSousRegion38 = "The Wold";
		Strings.TeleportSousRegion39 = "Kingstead";
		Strings.TeleportSousRegion40 = "Eastfold";
		Strings.TeleportSousRegion41 = "Broadacres";
		Strings.TeleportSousRegion42 = "Stonedeans";
		Strings.TeleportSousRegion43 = "Westfold";
		Strings.TeleportSousRegion44 = "Helm's Deep";
		Strings.TeleportSousRegion45 = "The vales of anduin";  
		Strings.TeleportSousRegion46 = "Wells of Langflood";     -- new to add
		Strings.TeleportSousRegion47 = "Elderslade";     -- new to add
		Strings.TeleportSousRegion48 = "Iron hills";     -- new to add
		Strings.TeleportSousRegion49 = "The Dale-lands";     -- new to add
		Strings.TeleportSousRegion50 = "Ered Mithrin";     -- new to add
		Strings.TeleportSousRegion51 = "Azanulbizar";     -- new in the U30
		------------------------------------------------------------------------------------------
		-- Teleport sous Location Gondor --
		------------------------------------------------------------------------------------------
		Strings.TeleportSousRegion52 = "Blackroot Vale";
		Strings.TeleportSousRegion53 = "Lamedon";
		Strings.TeleportSousRegion54 = "Havens of Belfalas";
		Strings.TeleportSousRegion55 = "Ringl\195\179 Vale";
		Strings.TeleportSousRegion56 = "Dor-en-Ernil";
		Strings.TeleportSousRegion57 = "Lower Lebennin";
		Strings.TeleportSousRegion58 = "Upper Lebennin";
		Strings.TeleportSousRegion59 = "Lossarnach";
		Strings.TeleportSousRegion60 = "South Ithilien";	
		Strings.TeleportSousRegion61 = "Far An\195\179rien";
		Strings.TeleportSousRegion62 = "Taur Dr\195\186adan";
		Strings.TeleportSousRegion63 = "Talath Anor";
		Strings.TeleportSousRegion64 = "Pelennor";
		Strings.TeleportSousRegion65 = "Pelennor, after battle";
		Strings.TeleportSousRegion66 = "North Ithilien";
		------------------------------------------------------------------------------------------
		-- Teleport sous Location Mordor --
		------------------------------------------------------------------------------------------
		Strings.TeleportSousRegion67 = "The Wastes";
		Strings.TeleportSousRegion68 = "Torech Ungol";
		--Strings.TeleportSousRegion63 = "Minas Morgul";
		Strings.TeleportSousRegion69 = "Ud\195\185n";
		Strings.TeleportSousRegion70 = "Dor Amarth";
		Strings.TeleportSousRegion71 = "Lhingris";
		Strings.TeleportSousRegion72 = "Talath \195\154rui";
		Strings.TeleportSousRegion73 = "Agarnaith";
		Strings.TeleportSousRegion74 = "Mordor Besieged";
		Strings.TeleportSousRegion75 = "The Morgul vale";
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
		Strings.Teleport[7] = " Bree - South Gate";
		Strings.Teleport[8] = " Bree - The Prancing Pony";
		Strings.Teleport[9] = " Bree - West Gate";
		Strings.Teleport[10] = " Bree-land Homesteads";
		Strings.Teleport[11] = " Buckland";
		Strings.Teleport[12] = " Combe";
		------------------------------------------------------------------------------------------
		-- Teleport Location Enedwaith  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[13] = " Echad Dagoras";
		Strings.Teleport[14] = " Lhanuch";
		Strings.Teleport[15] = " Harndirion";
		Strings.Teleport[16] = " Maur Tulhau";
		Strings.Teleport[17] = " N\195\161r's Peak";
		Strings.Teleport[18] = " Lich Bluffs";
		Strings.Teleport[19] = " Mournshaws";
		------------------------------------------------------------------------------------------
		-- Teleport Location Ered Luin  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[20] = " Celondim";
		Strings.Teleport[21] = " Duillond";
		Strings.Teleport[22] = " Gondamon";
		Strings.Teleport[23] = " Falathlorn Homesteads";
		Strings.Teleport[24] = " Thorin's Hall";
		Strings.Teleport[25] = " Thorin's Hall Homesteads";
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
		Strings.Teleport[32] = " The Eavespires";
		Strings.Teleport[33] = " Ost Forod";
		Strings.Teleport[34] = " High King's Crossing";
		Strings.Teleport[35] = " Oatbarton";
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
		Strings.Teleport[43] = " The Forsaken Inn";

		------------------------------------------------------------------------------------------
		-- Teleport Location The misty moutains  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[44] = " Gl\195\179in's Camp";
		Strings.Teleport[45] = " Vindurhal";
		------------------------------------------------------------------------------------------
		-- Teleport Location The north Downs  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[46] = " Esteld\195\173n";
		Strings.Teleport[47] = " Trestlebridge";
		------------------------------------------------------------------------------------------
		-- Teleport Location The shire  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[48] = " Brockenborings";
		Strings.Teleport[49] = " Budgeford";
		Strings.Teleport[50] = " Hobbiton";
		Strings.Teleport[51] = " Little Delving";
		Strings.Teleport[52] = " Michel Delving";
		Strings.Teleport[53] = " Shire Homesteads";
		------------------------------------------------------------------------------------------
		-- Teleport Location The trollshaws  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[54] = " Echad Candelleth";
		Strings.Teleport[55] = " Rivendell";
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
		Strings.Teleport[61] = " Mirk-eaves";
		Strings.Teleport[62] = " The Haunted Inn";
		Strings.Teleport[63] = " Ost Galadh";
		Strings.Teleport[64] = " Estolad Mernael";
		Strings.Teleport[65] = " Mithechad";
		Strings.Teleport[66] = " Thang\195\186lhad";
		------------------------------------------------------------------------------------------
		-- Teleport Location Moria  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[67] = " The great delving";
		Strings.Teleport[68] = " Dolven-view";
		Strings.Teleport[69] = " Deep Descent";
		Strings.Teleport[70] = " The Chamber of the Crossroads";
		Strings.Teleport[71] = " The Twenty-first Hall";
		Strings.Teleport[72] = " The Rotting Cellar";
		Strings.Teleport[73] = " The Water-Works";
		Strings.Teleport[74] = " Foundations of stone";
		Strings.Teleport[75] = " Redhornes lodes";
		Strings.Teleport[76] = " Jaz\195\162rgund";
		Strings.Teleport[77] = " The Fanged Pit";
		------------------------------------------------------------------------------------------
		-- Teleport Location Pays de Dun  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[78] = " Lhan Tarren";
		Strings.Teleport[79] = " Echad Naeglanc";
		Strings.Teleport[80] = " Galtrev";
		Strings.Teleport[81] = " T\195\162l Methedras Gate";
		Strings.Teleport[82] = " Avardin";
		Strings.Teleport[83] = " Rohirrim Scout-camp";
		Strings.Teleport[84] = " Lhan Rhos";
		Strings.Teleport[85] = " Barnavon";
		------------------------------------------------------------------------------------------
		-- Teleport Location landes farouche  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[86] = " Forlaw";
		------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------
		-- Teleport Location Heathfells  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[87] = " Forthbrond";
		Strings.Teleport[88] = " Grimbold's Camp";
		------------------------------------------------------------------------------------------
		-- Teleport Location Nan Curun\195\173r  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[89] = " Dagoras' Camp";
		------------------------------------------------------------------------------------------
		-- Teleport Location Isengard  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[90] = " Ox-clan Merchant Camp";
		------------------------------------------------------------------------------------------
		-- Teleport Location Nan Curun\195\173r  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[91] = " Isengard (after)";
		------------------------------------------------------------------------------------------
		-- Teleport Location Le grand fleuve  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[92] = " Etheburg";
		Strings.Teleport[93] = " Stangard";
		Strings.Teleport[94] = " Wailing hills";
		Strings.Teleport[95] = " Parth Celebrant";
		Strings.Teleport[96] = " Aculf's Camp";
		Strings.Teleport[97] = " Haldirith";
		------------------------------------------------------------------------------------------
		-- Teleport Location Entwash Vale  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[98] = " Eaworth";
		Strings.Teleport[99] = " Thornhope";
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
		Strings.Teleport[105] = " Snowbourn";
		Strings.Teleport[106] = " Walstow";
		------------------------------------------------------------------------------------------
		-- Teleport Location The East Wall  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[107] = " Mansig's Encampment";
		Strings.Teleport[108] = " Parth Galen";
		------------------------------------------------------------------------------------------
		-- Teleport Location The Wold  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[109] = " Harwick";
		Strings.Teleport[110] = " Floodwend";
		Strings.Teleport[111] = " Langhold";
		------------------------------------------------------------------------------------------
		-- Teleport Location Kingstead  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[112] = " Entwade";
		Strings.Teleport[113] = " Middlemead";
		Strings.Teleport[114] = " Edoras";
		Strings.Teleport[115] = " Upbourn";
		Strings.Teleport[116] = " Underharrow";
		Strings.Teleport[117] = " Dunharrow";
		------------------------------------------------------------------------------------------
		-- Teleport Location Eastfold  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[118] = " Aldburg";
		Strings.Teleport[119] = " Beaconwatch";
		Strings.Teleport[120] = " Fenmarch";
		------------------------------------------------------------------------------------------
		-- Teleport Location Eastfold  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[121] = " Oserley";
		Strings.Teleport[122] = " Stoke";
		------------------------------------------------------------------------------------------
		-- Teleport Location Stonedeans  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[123] = " Woodhurst";
		Strings.Teleport[124] = " Brockbridge";
		Strings.Teleport[125] = " Gapholt";
		------------------------------------------------------------------------------------------
		-- Teleport Location Westfold  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[126] = " Grimslade";
		Strings.Teleport[127] = " Helm's Deep";
		------------------------------------------------------------------------------------------
		-- Teleport Location Helm's Deep  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[128] = " Helm's Deep";
		------------------------------------------------------------------------------------------
		-- Teleport Location val d'andiun  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[129] = " Beorningh\195\186s";
		Strings.Teleport[130] = " Hultvis";
		Strings.Teleport[131] = " Arhaim";
		Strings.Teleport[132] = " Bl\195\179mgard";
		Strings.Teleport[133] = " Vegb\195\161r";
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
		Strings.Teleport[139] = " Hammerstead"; -- new to add from here
		Strings.Teleport[140] = " J\195\161rnfast"; -- new to add from here
		------------------------------------------------------------------------------------------
		-- Teleport Location terres de dale  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[141] = " Dale"; -- new to add from here
		Strings.Teleport[142] = " Erebor"; -- new to add from here
		Strings.Teleport[143] = " Lake-town"; -- new to add from here
		Strings.Teleport[144] = " Loeglong"; -- new to add from here
		Strings.Teleport[145] = " Felegoth"; -- new to add from here
		Strings.Teleport[146] = " Tham Taerdol"; -- new to add from here
		------------------------------------------------------------------------------------------
		-- Teleport Location ered mithrin  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[147] = " Skarh\195\161ld"; -- new to add from here
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
		Strings.Teleport[167] = " Faramir's Lookout";
		------------------------------------------------------------------------------------------
		-- Teleport Location Far anorien  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[168] = " Ost Rimmon";
		------------------------------------------------------------------------------------------
		-- Teleport Location taur druadan  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[169] = " Eilenach";
		Strings.Teleport[170] = " Taur Dr\195\186adan";
		-----------------------------------------------------------------------------------------
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
		Strings.Teleport[173] = " Aragorn Pavilion";
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
		Strings.Teleport[176] = " Camp of the Host";
		Strings.Teleport[177] = " Slag-Hills";
		Strings.Teleport[178] = " Haerondir";
		------------------------------------------------------------------------------------------
		-- Teleport Location torech ungol  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[179] = " Amon Amarth";
		------------------------------------------------------------------------------------------
		-- Teleport Location Udun  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[180] = " Ud\195\185n Foothold";
		------------------------------------------------------------------------------------------
		-- Teleport Location Dor Amarth  --
		------------------------------------------------------------------------------------------
		Strings.Teleport[181] = " Ruins of D\195\173ngarth";
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