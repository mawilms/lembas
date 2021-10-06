-- en.lua
-- Written by Habna


_G.L = {};
L["HBLang"] = "HugeBag: English language loaded!";
L["HBLoad"] = "HugeBag " .. Version .. " by Habna loaded!";

--Misc
L["ButDel"] = "Delete information of this character";
--L[""] = "";

--Main form (Widget)
L["HugeBag"] = "HugeBag";
L["HugeBag--"] = "HugeBag - ";
L["Free"] = "Free: ";
L["Max"] = "  Max: ";
L["Used"] = "  Used: ";
L["Sort"] = "[S]";
L["Merge"] = "[M]";
L["Search"] = "[F]";
L["Bags"] = "[B]";
L["Vault"] = "[V]";
L["SStorage"] = "[SS]";
L["FF"] = "F";
L["UU"] = "U";
L["MM"] = "M";

--Main form (Window)
L["HB--"] = "HB - ";
L["F"] = "F: ";
L["U"] = "  U: ";
L["M"] = "  M: ";

--Options window
L["OWinLP"] = "Load profile settings";
L["OWinSP"] = "Save current settings to profile";

--Options widget
L["OWidLoc"] = "Set HugeBag widget location to ...";
L["OWidLocL"] = "left";
L["OWidLocR"] = "right";
L["OWidTop"] = "Top section options ...";
L["OWidTopT"] = "Show HugeBag image";
L["OWidTopI"] = "Show slots informations";
L["OWidTopN"] = "Show nothing";
L["OWidSide"] = "Side section options ...";
L["OWidBot"] = "Bottom section options ...";
L["OWidAOT"] = "Change HugeBag 'Always On Top' ability";
L["OWidIM"] = "Inverse merge function";
L["OWidBC"] = "Set HugeBag back color";
L["OWidL"] = "Change language to ...";
L["OWidLen"] = "English";
L["OWidLfr"] = "French";
L["OWidLde"] = "Deutsch";
L["OWidView"] = "View your ";
L["OWidSort"] = "Sort";
L["OWidMerge"] = "Merge";
L["OWidSearch"] = "Find";
L["OWidBags"] = "Bags";
L["OWidVault"] = "Vault";
L["OWidStorage"] = "Shared Storage";
L["OWidNeed"] = "Need to open a valid ";
L["OWidOnce"] = " at least once";

-- Background window
L["BWTitle"] = "Set back color";
L["BWAlpha"] = "Alpha";
L["BWCurSetColor"] = "Currently set color";
L["BWSave"] = "Save color";
L["BWDef"] = "Default";
L["BWBlack"] = "Black";

-- Vault window
L["VTh"] = "vault";
L["VTnd"] = "No data was found for this character";
L["VTID"] = " vault info deleted!"
L["VTSe"] = "Search:"
L["VTAll"] = "-- All --"

-- Shared Storage window
L["SSh"] = "shared storage";
L["SSnd"] = "Need to open your shared storage at least once";

-- Backpack window
L["BIh"] = "Bags";
L["BID"] = " bags info deleted!"

-- Bank window
L["BKh"] = "bank";

--Functions output text
L["FEscH"] = "HugeBag: I will hide when 'esc' key is pressed";
L["FEscS"] = "HugeBag: I will stay visible when 'esc' key is pressed";
L["FLoadS"] = "HugeBag: I will load visibile next time";
L["FLoadH"] = "HugeBag: I will load hidden next time";
L["FWidget"] = "HugeBag: Will load in widget mode next time";
L["FWin"] = "HugeBag: Will load in window mode next time";
L["FAOTS"] = "HugeBag: Will be always on top next time";
L["FAOTH"] = "HugeBag: Will not be always on top next time";
L["FMergeD"] = "HugeBag: Will merge items from slot ";
L["FMerge1"] = " to 1";
L["FMergeU"] = "HugeBag: Will merge items from slot 1 to ";
L["FButVis"] = "HugeBag: Buttons are now visible";
L["FButNVis"] = "HugeBag: Buttons are now invisible"
L["FSortVis"] = "HugeBag: Sort button now visible";
L["FSortNVis"] = "HugeBag: Sort button now invisible"
L["FMergeVis"] = "HugeBag: Merge button now visible";
L["FMergeNVis"] = "HugeBag: Merge button now invisible"
L["FSearchVis"] = "HugeBag: Search button now visible";
L["FSearchNVis"] = "HugeBag: Search button now invisible";
L["FBagsVis"] = "HugeBag: Bags button now visible";
L["FBagsNVis"] = "HugeBag: Bags button now invisible";
L["FVaultVis"] = "HugeBag: Vault button now visible";
L["FVaultNVis"] = "HugeBag: Vault button now invisible";
L["FSShVis"] = "HugeBag: Shared Storage button now visible";
L["FSSNVis"] = "HugeBag: Shared Storage button now invisible";
L["BLT"] = "HugeBag: Now showing long text";
L["BST"] = "HugeBag: Now showing short text";
L["FCP"] = "HugeBag: No profile settings was found. Profile was created using current settings";
L["FLP"] = "HugeBag: Profile settings were loaded successfully";
L["FSP"] = "HugeBag: The current settings are saved in the profile";

--Functions window output text
L["FSlotsS"] = "HugeBag: Now showing slots informations in the title";
L["FSlotsH"] = "HugeBag: Not showing slots informations in the title";
L["FSkinS"] = "HugeBag: Now showing skin & title";
L["FSkinH"] = "HugeBag: hiding skin & title";
L["FIH"] = "HugeBag: Items are now horizontal";
L["FIV"] = "HugeBag: Items are now vertical";
L["FSL"] = "HugeBag: Window is not resizable";
L["FSNL"] = "HugeBag: Window is now reziable";
L["FPL"] = "HugeBag: Window position is now lock";
L["FPNL"] = "HugeBag: Window position is unlock";
L["ISE"] = "HugeBag: Icon resize function is now enabled";
L["ISD"] = "HugeBag: Icon resize function is now disabled";

--Functions widget output text
L["FWidShow"] = "HugeBag: Impossible, I'm already visible";
L["FWidTBTitle"] = "HugeBag: Showing image in top section";
L["FWidTBInfo"] = "HugeBag: Showing info in top section";
L["FWidTBNot"] = "HugeBag: Showing nothing in top section";
L["FWidSBImg"] = "HugeBag: Showing image in side section";
L["FWidSBInfo"] = "HugeBag: Showing info in side section";
L["FWidSBNot"] = "HugeBag: Showing nothing in side section";
L["FWidActive"] = "Can't show/hide buttons when sort, merge or search function are active!";
L["FWidHide"] = "HugeBag: Impossible, I'm already hidden";

--Settings widget output text
L["SWidRA"] = "HugeBag: All my settings was set back to default";

--Settings window output text
L["SWinRLS"] = "HugeBag: My location and size was set back to default";

--Widget & Window shell commands
L["SCWTitle"] = "HugeBag Shell Commands";
L["SC0"] = "Command not supported";
L["SC1"] = "Show HugeBag";
L["SC2"] = "Hide HugeBag";
L["SC3"] = "Unload HugeBag";
L["SC4"] = "Reload HugeBag";
L["SC5"] = "Reset all settings to default";
L["SC6"] = "Show/hide HugeBag when the 'esc' key is press";
L["SC7"] = "Show/hide HugeBag at startup";
L["SC8"] = "Change between widget and window mode";
L["SC9"] = "Ability to be always on top are not";
L["SC10"] = "Show/hide buttons";
L["SC11"] = "Sort HugeBag items (Courtesy of MrJackdaw)";
L["SC12"] = "Merge stackable item into one stack";
L["SC13"] = "Default merge function: slot 1 to 75";
L["SC14"] = "Show HugeBag shell commands";
L["SC15"] = "Show HugeBag Options";
L["SC16"] = "Show/hide sort button";
L["SC17"] = "Show/hide merge button";
L["SC18"] = "Show/hide search button";
L["SC19"] = "Show/hide bags window";
L["SC20"] = "Show/hide vault window";
L["SC21"] = "Show/hide shared storage window";
L["SC22"] = L["OWinLP"];
L["SC23"] = L["OWinSP"];
L["SC24"] = "Show/hide bags button";
L["SC25"] = "Show/hide vault button";
L["SC26"] = "Show/hide shared storage button";
L["SC27"] = "Show buttons short/long text";

L["SCa1"] = "show";
L["SCb1"] = "shb / ";
L["SCa2"] = "hide";
L["SCb2"] = "hhb / ";
L["SCa3"] = "unload";
L["SCb3"] = "  u / ";
L["SCa4"] = "reload";
L["SCb4"] = "  r / ";
L["SCa5"] = "resetall";
L["SCb5"] = " ra / ";
L["SCa6"] = "wesc";
L["SCb6"] = "  w / ";
L["SCa7"] = "visible";
L["SCb7"] = "  v / ";
L["SCa8"] = "mode";
L["SCb8"] = "hbm / ";
L["SCa9"] = "top";
L["SCb9"] = "aot / ";
L["SCa10"] = "buttons";
L["SCb10"] = " bv / ";
L["SCa11"] = "sort";
L["SCb11"] = " si / ";
L["SCa12"] = "merge";
L["SCb12"] = " mi / ";
L["SCa13"] = "inversemerge";
L["SCb13"] = " im / ";
L["SCa14"] = "help";
L["SCb14"] = " sc / ";
L["SCa15"] = "options";
L["SCb15"] = "opt / ";
L["SCa16"] = "showsort";
L["SCb16"] = "sbv / ";
L["SCa17"] = "showmerge";
L["SCb17"] = "mbv / ";
L["SCa18"] = "showsearch";
L["SCb18"] = "ebv / ";
L["SCa19"] = "bags";
L["SCb19"] = "bp / ";
L["SCa20"] = "vault";
L["SCb20"] = "vt / ";
L["SCa21"] = "shared storage";
L["SCb21"] = "ss / ";
L["SCa22"] = "load profile";
L["SCb22"] = "lp / ";
L["SCa23"] = "save profile";
L["SCb23"] = "sp / ";
L["SCa24"] = "showbags";
L["SCb24"] = "bbv / ";
L["SCa25"] = "showvault";
L["SCb25"] = "vbv / ";
L["SCa26"] = "showss";
L["SCb26"] = "hbv / ";
L["SCa27"] = "switchbb";
L["SCb27"] = "sbb / ";

--Widget shell commands



--Window shell commands
L["WinSC1"] = "Reset location and size settings to default";
L["WinSC2"] = "Show/hide HugeBag skin & title";
L["WinSC3"] = "Change items oriention";
L["WinSC4"] = "Lock/unlock HugeBag size";
L["WinSC5"] = "Lock/unlock HugeBag position";
L["WinSC6"] = "Enable/Disable icon resize function";

L["WinSCa1"] = "resetls";
L["WinSCb1"] = "rls / ";
L["WinSCa2"] = "skin";
L["WinSCb2"] = " sk / ";
L["WinSCa3"] = "orientation";
L["WinSCb3"] = " io / ";
L["WinSCa4"] = "locksize";
L["WinSCb4"] = " ls / ";
L["WinSCa5"] = "lockpos";
L["WinSCb5"] = " lp / ";
L["WinSCa6"] = "iconsize";
L["WinSCb6"] = " is / ";

--Merge
L["FAMergeS"] = "HugeBag: Merging started";
L["FAMergeF"] = "HugeBag: Merging finished";
L["FAMergeE"] = "Can't merge when sort, mix, merge or search function are active!";
L["FAMergeFA"] = " finished after ";
L["FAMergeSec"] = " seconds";

--Sort
L["FSSortS"] = "HugeBag: Sorting started";
L["FSSortF"] = "HugeBag: Sorting finished";
L["FSSortE"] = "Can't sort when sort, mix, merge or search function are active!";
L["FSSortFS"] = "HugeBag: This fail safe aborted the sorting because the sorting fail to finish within ";

--Items menu
L["All"] = "All";
L["ShowAll"] = "Show all items";
L["Show"] = "Show ...";
L["Potions"] = "Potions";
L["Healing"] = "Healing";
L["Tools"] = "Tools";
L["Devices"] = "Devices";
L["Jewelry"] = "Jewelry";
L["Components"] = "Components";
L["BR"] = "Barter & Reputation";
L["QI"] = "Quest items";
L["Resources"] = "Resources";
L["Perks"] = "Perks";
L["Misc"] = "Misc";
L["Misc2"] = "Misc 2";
L["Mounts"] = "Mounts";
L["Special"] = "Special";
L["Dye"] = "Dye";
L["Relic"] = "Relic";
L["Festival"] = "Festival";
L["Book"] = "Minstrel Book";
L["Tome"] = "Tome";
L["ShowBuff"] = "Show buff ...";
L["Scroll"] = "Scroll";
L["Trap"] = "Trap";
L["SP"] = "Shield Spikes";
L["Oil"] = "Oil";
L["ShowLegendary"] = "Show legendary ...";
L["WE"] = "Weapon Experience";
L["WIML"] = "Weapon Increase MaxLevel";
L["WRL"] = "Weapon Replace Legacy";
L["WR"] = "Weapon Reset";
L["WUL"] = "Weapon Upgrade Legacy";
L["ShowFishing"] = "Show fishing ...";
L["Fish"] = "Fish";
L["Bait"] = "Bait";
L["Pole"] = "Pole";
L["Other"] = "Other";
L["ShowFoods"] = "Show foods ...";
L["Food"] = "Food";
L["ShowIngredient"] = "Show ingredient ...";
L["Ingredient"] = "Ingredient";
L["OI"] = "Optional Ingredient";
L["ShowTrophys"] = "Show trophys ...";
L["Trophy"] = "Trophy";
L["ST"] = "Special Trophy";
L["ShowRecipes"] = "Show recipes ...";
L["MS"] = "Metalsmith";
L["WS"] = "Weaponsmith";
L["Tailor"] = "Tailor";
L["Jeweller"] = "Jeweller";
L["Cook"] = "Cook";
L["Scholar"] = "Scholar";
L["WW"] = "Wood worker";
L["Farmer"] = "Farmer";
L["Prospecter"] = "Prospecter";
L["Forester"] = "Forester";
L["Apprentice"] = "Apprentice";
L["Journeyman"] = "Journeyman";
L["Expert"] = "Expert";
L["Artisan"] = "Artisan";
L["Master"] = "Master";
L["Supreme"] = "Supreme";
L["Westfold"] = "Westfold";
L["ShowWeapon"] = "Show weapon ...";
L["Axe"] = "Axe";
L["Club"] = "Club";
L["Crossbow"] = "Crossbow";
L["Bow"] = "Bow";
L["Dagger"] = "Dagger";
L["Halberd"] = "Halberd";
L["Mace"] = "Mace";
L["Staff"] = "Staff";
L["Sword"] = "Sword";
L["Hammer"] = "Hammer";
L["Orb"] = "Orb";
L["Javelin"] = "Javelin";
L["Spear"] = "Spear";
L["ShowArmor"] = "Show armor ...";
L["Shoes"] = "Shoes";
L["Leggings"] = "Leggings";
L["Gloves"] = "Gloves";
L["Chest"] = "Chest";
L["Cloak"] = "Cloak";
L["Hat"] = "Hat";
L["Shield"] = "Shield";
L["GuardianBelt"] = "Guardian Belt";
L["ShowClass"] = "Show class items ...";
L["ShowCosmetic"] = "Show cosmetic items ...";
L["Back"] = "Back";
L["Head"] = "Head";
L["UB"] = "Upper Body";
L["Feet"] = "Feet";
L["Shoulder"] = "Shoulder";
L["ShowDecoration"] = "Show decoration ...";
L["Ceiling"] = "Ceiling";
L["Floor"] = "Floor";
L["Furniture"] = "Furniture";
L["Music"] = "Music";
L["Yard"] = "Yard";
L["Wall"] = "Wall";
L["SurfacePaint"] = "Surface Paint";

-- Free People Class
L["Guardian"] = "Guardian";
L["Captain"] = "Captain";
L["Minstrel"] = "Minstrel";
L["Burglar"] = "Burglar";
L["Hunter"] = "Hunter";
L["Champion"] = "Champion";
L["Lore-Master"] = "Lore-Master";
L["Rune-Keeper"] = "Rune-Keeper";
L["Warden"] = "Warden";