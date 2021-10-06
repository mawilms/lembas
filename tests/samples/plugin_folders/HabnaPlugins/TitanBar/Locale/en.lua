-- en.lua
-- Written by Habna


_G.L = {};
L["TBLang"] = "TitanBar: English language loaded!";
L["TBLoad"] = "TitanBar " .. Version .. " by Habna loaded!";
L["TBSSCS"] = "TitanBar: Screen size has changed, repositioning controls...";
L["TBSSCD"] = "TitanBar: done!";
L["TBOpt"] = "Options are available by right clicking on TitanBar";

--Misc
L["NoData"] = "No other data available in API";
L["NA"] = "N/A";
--L["dmg"] = " dmg";
L["You"] = "You: ";
L["ButDel"] = "Delete information of this character";
--L[""] = "";

-- TitanBar Menu
L["MBag"] = "Wallet";
L["MGSC"] = "Money";
L["MDP"] = "Destiny points";
L["MSP"] = "Shard";
L["MSM"] = "Mark";
L["MMP"] = "Medallion";
L["MSL"] = "Seal";
L["MCP"] = "Commendation";
L["MTP"] = "Turbine points";
L["MBI"] = "Backpack infos";
L["MPI"] = "Player infos";
L["MEI"] = "Equipment infos";
L["MDI"] = "Durability infos";
L["MPL"] = "Player Location";
L["MGT"] = "Time";
L["MOP"] = "More options";
L["MPP"] = "Profile";
L["MSC"] = "Shell commands";
L["MRA"] = "Reset all settings";
L["MUTB"] = "Unload";
L["MRTB"] = "Reload";
L["MATB"] = "About ";
L["MBG"] = "Set back color";
L["MCL"] = "Change language to ...";
L["MCLen"] = "English";
L["MCLfr"] = "French";
L["MCLde"] = "Deutsch";
L["MTI"] = "Track Items";
--L["MView"] = "View your ";
L["MVault"] = "Vault";
L["MStorage"] = "Shared Storage";
--L["MBank"] = "Bank";
L["MDayNight"] = "Day & Night Time";
L["MReputation"] = "Reputation";

-- Control Menu
L["MCU"] = "Unload ...";
L["MCBG"] = "Change back color of this control";
L["MTBBG"] = "Apply TitanBar back color to ...";
L["MTBBGC"] = "this control";
L["MTBBGAC"] = "all control";
L["MCRBG"] = "Reset back color of ...";
L["MCABT"] = "Apply this control back color to ...";
L["MCABTA"] = "all control & TitanBar";
L["MCABTTB"] = "TitanBar";
L["MCRC"] = "Refresh ...";

-- Background window
L["BWTitle"] = "Set back color";
L["BWAlpha"] = "Alpha";
L["BWCurSetColor"] = "Currently set color";
L["BWApply"] = " Apply color to all elements";
L["BWSave"] = "Save color";
L["BWDef"] = "Default";
L["BWBlack"] = "Black";
L["BWTrans"] = "Transparent";

-- Wallet infos window
L["WIt"] = "Right click a currency name to get it's settings";
L["WIot"] = "On TitanBar";
L["WIiw"] = "In tooltip";
L["WIds"] = "Don't show";
L["WInc"] = "You track no currency!\nLeft click to see the currency list.";

-- Money infos window
L["MIWTitle"] = "Coin";
L["MIWTotal"] = "Total";
L["MIWAll"] = "Show total on TitanBar";
L["MIWCM"] = "Show player money";
L["MIWCMAll"] = "Show to all your character";
L["MIWSSS"] = "Show session statistics in tooltip";
L["MIWSTS"] = "Show today statistics in tooltip";
L["MIWID"] = " wallet info deleted!"
L["MIMsg"] = "No wallet info was found!"
L["MISession"] = "Session";
L["MIDaily"] = "Today";
L["MIStart"] = "Starting";
L["MIEarned"] = "Earned";
L["MISpent"] = "Spent";
--L["MITotEarned"] = "Total earned";
--L["MITotSpent"] = "Total spent";

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
L["BIh"] = "backpack";
L["BID"] = " bags info deleted!"

-- Bank window
L["BKh"] = "bank";

-- Day & Night window
L["Dawn"] = "Dawn";
L["Morning"] = "Morning";
L["Noon"] = "Noon";
L["Afternoon"] = "Afternoon";
L["Dusk"] = "Dusk";
L["Gloaming"] = "Gloaming";
L["Evening"] = "Evening";
L["Midnight"] = "Midnight";
L["LateWatches"] = "Late Watches";
L["Foredawn"] = "Foredawn";
L["NextT"] = "Show next time";
L["TAjustL"] = "Timer seed";

-- Reputation window
L["RPt"] = "select / unselect a faction\nright click to get it's settings";
L["RPnf"] = "You track no faction!\nLeft click to see the faction list.";
--All reputation name was moved to 'functionCtr.lua' in the LoadPlayerReputation() function
L["RPMSR"] = "Maximum standing reached"
L["RPGL1"] = "Neutral";
L["RPGL2"] = "Acquaintance";
L["RPGL3"] = "Friend";
L["RPGL4"] = "Ally";
L["RPGL5"] = "Kindred";
L["RPBL1"] = "Outsider";
L["RPBL2"] = "Enemy";--need traduction
L["RPBL3"] = "bad 3";--need traduction
L["RPBL4"] = "bad 4";--need traduction
L["RPBL5"] = "bad 5";--need traduction
L["RPGG1"] = "Initiate";
L["RPGG2"] = "Apprentice";
L["RPGG3"] = "Journeyman";
L["RPGG4"] = "Expert";
L["RPGG5"] = "Artisan";
L["RPGG6"] = "Master";
L["RPGG7"] = "Supreme";

-- Infamy/Renown window
if PlayerAlign == 1 then L["IFWTitle"] = "Renown"; L["IFIF"] = "Total renown:";
else L["IFWTitle"] = "Infamy"; L["IFIF"] = "Total infamy:"; end
L["IFCR"] = "Your rank:";
L["IFTN"] = "points for the next rank";

-- GameTime window
L["GTWTitle"] = "Real/Server Time";
L["GTW24h"] = "Show time in 24 hour format";
L["GTWSST"] = "Show server time       GMT";
L["GTWSBT"] = "Show real & server time";
L["GTWST"] = "Server: ";
L["GTWRT"] = "Real: ";

-- More Options window
L["OPWTitle"] = L["MOP"];
L["OPHText"] = "Height:";
L["OPFText"] = "Font:";
L["OPAText"] = "Auto hide:";
L["OPAHD"] = "Disabled";
L["OPAHE"] = "Always";
L["OPAHC"] = "Only in combat";
L["OPIText"] = "Icon size:";
L["OPTBTop"] = "At top of screen";
L["OPISS"] = "Small";
L["OPISM"] = "Medium";
L["OPISL"] = "Large";

-- Profile window
L["PWLoad"] = "Load"; 
L["PWSave"] = "Save";
L["PWCreate"] = "Create";
L["PWCancel"] = "Cancel";
L["PWNFound"] = "No profile was found";
L["PWEPN"] = "Enter a profile name";
L["PWProfil"] = "Profile";
L["PWDeleted"] = "deleted";
L["PWLoaded"] = "loaded";
L["PWFail"] = "This profile cannot be loaded because the language of the game is not the same language of this profile";

-- Shell commands window
L["SCWTitle"] = "TitanBar Shell Commands";
L["SCWC1"] = "Show TitanBar Options";
L["SCWC2"] = "Unload TitanBar";
L["SCWC3"] = "Reload TitanBar";
L["SCWC4"] = "Reset all settings to default";
L["SCWC5"] = "Show/hide Money control";
L["SCWC6"] = "Show/hide Destiny Points control";
L["SCWC7"] = "Show/hide Backpack control";
L["SCWC8"] = "Show/hide Player control";
L["SCWC9"] = "Show/hide Equipment control";
L["SCWC10"] = "Show/hide Durability control";
L["SCWC11"] = "Show/hide Player location control";
L["SCWC12"] = "Show/hide Time control";
L["SCWC13"] = "Show/hide Shell Commands window";
L["SCWC14"] = "Show/hide Shard control";
L["SCWC15"] = "Show/hide Skirmish marks control";
L["SCWC16"] = "Show/hide Medallion control";
L["SCWC17"] = "Show/hide Seal control";
L["SCWC18"] = "Show/hide Commendation control";
--L["SCWC19"] = "Show/hide infamy/renown control"; --was move after SCa19
L["SCWC20"] = "Show/hide Vault control";
L["SCWC21"] = "Show/hide Shared Storage control";
L["SCWC22"] = "Show/hide Day & Night control";
L["SCWC23"] = "Show/hide Track Items control";
L["SCWC24"] = "Show/hide Reputation control";
L["SCWC25"] = "Show/hide Turbine Points control";
L["SCWC26"] = "Show/hide Wallet control";
--L["SCWC??"] = "Show/hide Bank control";
--L["SCWC??"] = "Show About TitanBar window";

-- Shell commands
L["SC0"] = "Command not supported";
L["SCa1"] = "options";
L["SCb1"] = "opt / ";
L["SCa2"] = "unload";
L["SCb2"] = "  u / ";
L["SCa3"] = "reload";
L["SCb3"] = "  r / ";
L["SCa4"] = "resetall";
L["SCb4"] = " ra / ";
L["SCa5"] = "money";
L["SCb5"] = " mi / ";
L["SCa6"] = "destiny";
L["SCb6"] = " dp / ";
L["SCa7"] = "bag";
L["SCb7"] = " bi / ";
L["SCa8"] = "player";
L["SCb8"] = " pi / ";
L["SCa9"] = "equipment";
L["SCb9"] = " ei / ";
L["SCa10"] = "durability";
L["SCb10"] = " di / ";
L["SCa11"] = "location";
L["SCb11"] = " pl / ";
L["SCa12"] = "time";
L["SCb12"] = " gt / ";
L["SCa13"] = "shell";
L["SCb13"] = " sc / ";
L["SCa14"] = "shards";
L["SCb14"] = " sp / ";
L["SCa15"] = "skirmish marks";
L["SCb15"] = " sm / ";
L["SCa16"] = "medallions";
L["SCb16"] = " mp / ";
L["SCa17"] = "seals";
L["SCb17"] = " sl / ";
L["SCa18"] = "commendations";
L["SCb18"] = " cp / ";
if PlayerAlign == 1 then L["SCa19"] = "renown";
else L["SCa19"] = "infamy"; end
L["SCb19"] = " ir / ";
L["SCWC19"] = "Show/hide " .. L["SCa19"] .. " control";
L["SCa20"] = "vault";
L["SCb20"] = " vt / ";
L["SCa21"] = "shared storage";
L["SCb21"] = " ss / ";
L["SCa22"] = "day & night";
L["SCb22"] = " dn / ";
L["SCa23"] = "track items";
L["SCb23"] = " ti / ";
L["SCa24"] = "reputation";
L["SCb24"] = " rp / ";
L["SCa25"] = "turbine points";
L["SCb25"] = " tp / ";
L["SCa26"] = "wallet";
L["SCb26"] = " wi / ";
--L["SCa??"] = "bank";
--L["SCb??"] = " bk / ";
--L["SCa??"] = "about";
--L["SCb??"] = "ab / ";

-- Durability infos window
L["DWTitle"] = "Durability infos";
L["DWLbl"] = " damaged item";
L["DWLbls"] = " damaged items";
L["DWLblND"] = "All your items are at 100%";
L["DIIcon"] = "Show icon in tooltip";
L["DIText"] = "Show item name in tooltip";
L["DWnint"] = "Not showing icon & item name";

-- Equipment infos window
--L["EWTitle"] = "Equipment infos";
L["EWLbl"] = "Items currently on your character";
L["EWLblD"] = "Score";
L["EWItemNP"] = " Item not present";
--L["EWItemF"] = " item was found";
--L["EWItemsF"] = " items was found";
L["EWST1"] = "Head";
L["EWST2"] = "Left Earring";
L["EWST3"] = "Right Earring";
L["EWST4"] = "Necklace";
L["EWST5"] = "Shoulder";
L["EWST6"] = "Back";
L["EWST7"] = "Chest";
L["EWST8"] = "Left Bracelet";
L["EWST9"] = "Right Bracelet";
L["EWST10"] = "Left Ring";
L["EWST11"] = "Right Ring";
L["EWST12"] = "Gloves";
L["EWST13"] = "Legs";
L["EWST14"] = "Feet";
L["EWST15"] = "Pocket";
L["EWST16"] = "Primary Weapon";
L["EWST17"] = "Secondary Weapon/Shield";
L["EWST18"] = "Ranged Weapon";
L["EWST19"] = "Craft Tool";
L["EWST20"] = "Class";

-- Player Infos control
--L["PINAME"] = "Your name";
--L["PILVL"] = "Your level";
--L["PIICON"] = "Your are a ";
L["Morale"] = "Morale";
L["Power"] = "Power";
L["Armour"] = "Armour";
L["Stats"] = "Statistics";
L["Might"] = "Might";
L["Agility"] = "Agility";
L["Vitality"] = "Vitality";
L["Will"] = "Will";
L["Fate"] = "Fate";
L["Finesse"] = "Finesse";
L["Mitigations"] = "Mitigations";
L["Common"] = "Common";
L["Fire"] = "Fire";
L["Frost"] = "Frost";
L["Shadow"] = "Shadow";
L["Lightning"] = "Lightning";
L["Acid"] = "Acid";
L["Physical"] = "Physical";
L["Tactical"] = "Tactical";
L["Healing"] = "Healing";
L["Outgoing"] = "Outgoing";
L["Incoming"] = "Incoming";
L["Avoidances"] = "Avoidances";
L["Block"] = "Block";
L["Parry"] = "Parry";
L["Evade"] = "Evade";
L["Resistances"] = "Resistances";
L["Base"] = "Base";
L["CritAvoid"] = "Crit. Avoid";
L["CritChance"] = "Crit. Chance";
L["Mastery"] = "Mastery";
L["Level"] = "Level";
L["Race"] = "Race";
L["Class"] = "Class";
L["XP"] = "Exp.";
L["MLvl"] = "Maximum level reached";

-- Money Infos control
L["MGh"] = "Quantity of gold";
L["MSh"] = "Quantity of silver";
L["MCh"] = "Quantity of copper";
L["MGB"] = "Bag of Gold Coins"; -- Thx Heridan!
L["MSB"] = "Bag of Silver Coins"; -- Thx Heridan!
L["MCB"] = "Bag of Copper Coins"; -- Thx Heridan!

-- Destiny Points control
L["DPh"] = "These are your destiny points";

-- Shards control
L["SPh"] = "These are your shard";

-- Skirmish marks control
L["SMh"] = "These are your skirmish marks";

-- Medallions control
L["MPh"] = "These are your medallion";

-- Seals control
L["SLh"] = "These are your seal";

-- Commendations control
L["CPh"] = "These are your Commendation";

-- Turbine Points control
L["TPh"] = "These are your Turbine points";

-- Bag Infos control
--L["BIh"] = "Backpack informations";
--L["BIt1"] = "Number of occupied slots/max";
L["BINI"] = "You track no item!\nLeft click to see your items."
L["BIIL"] = "Items list"
L["BIT"] = "Select / unselect an item"
L["BIUsed"] = " Show used over free slots";
L["BIMax"] = " Show total bag slots";
L["BIMsg"] = "No stackable item was found in your bag!"

-- Equipment Infos control
L["EIh"] = "Points for all your equipment";
L["EIt1"] = "Left click to open the options window";
L["EIt2"] = "Hold left click to move the control";
L["EIt3"] = "Right click to open the control menu";

-- Durability Infos control
L["DIh"] = "Durability of all your equipment";

-- Player Location control
L["PLh"] = "This is where you are";
L["PLMsg"] = "Enter a City!";

-- Game Time control
L["GTh"] = "Real/Server Time";

-- Chat message
L["TBR"] = "TitanBar: All my settings was set back to default";

-- Character Race
L["Elf"] = "Elf";
L["Man"] = "Man";
L["Dwarf"] = "Dwarf";
L["Hobbit"] = "Hobbit";

-- Free People Class
L["Burglar"] = "Burglar";
L["Captain"] = "Captain";
L["Champion"] = "Champion";
L["Guardian"] = "Guardian";
L["Hunter"] = "Hunter";
L["Lore-Master"] = "Lore-Master";
L["Minstrel"] = "Minstrel";
L["Rune-Keeper"] = "Rune-Keeper";
L["Warden"] = "Warden";

-- Monster Play Class
L["Reaver"] = "Reaver";
L["Weaver"] = "Weaver";
L["Blackarrow"] = "Blackarrow";
L["Warleader"] = "Warleader";
L["Stalker"] = "Stalker";
L["Defiler"] = "Defiler";

-- Durability
L["D"] = "Durability";
L["D1"] = "All Durability";
L["D2"] = "Weak";
L["D3"] = "Substantial";
L["D4"] = "Brittle";
L["D5"] = "Normal";
L["D6"] = "Tough";
L["D7"] = "Filmsy";
L["D8"] = "Indestructible";

-- Quality
L["Q"] = "Quality";
L["Q1"] = "All Quality";
L["Q2"] = "Common";
L["Q3"] = "UnCommon";
L["Q4"] = "Incomparable";
L["Q5"] = "Rare";
L["Q6"] = "Legendary";