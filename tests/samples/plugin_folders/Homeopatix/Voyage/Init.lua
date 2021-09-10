------------------------------------------------------------------------------------------
-- init file
-- Written by Homeopatix
-- 7 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Plugin's name --
------------------------------------------------------------------------------------------
pluginName = "Voyage";
------------------------------------------------------------------------------------------
-- File names --
------------------------------------------------------------------------------------------
settingsFileName = "Voyage_Settings";
------------------------------------------------------------------------------------------
-- Default settings --
------------------------------------------------------------------------------------------
settings = {
    windowPosition = { 
        xPos = 100, 
        yPos = 100 
    },
    optionsWindowPosition = { 
        xPos = 100, 
        yPos = 100 
    },
    IconPosition = { 
        xPosIcon = 500, 
        yPosIcon = 500 
    },
    shortcuts = { 
        Data1 = "", 
        Data2 = "",
        Data3 = "", 
        Data4 = "", 
        Data5 = "",
        Data6 = "", 
        Data7 = "",
        Data8 = "", 
        Data9 = "", 
        Data10 = "",
        Data11 = "",
        Data12 = "",
        Data13 = "",
        Data14 = "",
        Data15 = "",
        Data16 = "",
        Data17 = "",
        Data18 = "",
        Data19 = "",
        Data20 = "",
        Data21 = "",
        Data22 = "",
        Data23 = "",
        Data24 = "",
        Data25 = "",
        Data26 = "",
        Data27 = "",
        Data28 = "",
        Data29 = "",
        Data30 = "",
        Data31 = "",
        Data32 = "",
        Data33 = "",
        Data34 = "",
        Data35 = "",
        Data36 = "",
        Data37 = "",
        Data38 = "",
        Data39 = "",
        Data40 = "",
        Data41 = "",
        Data42 = "",
        Data43 = "",
        Data44 = "",
        Data45 = "",
        Data46 = "",
        Data47 = "",
        Data48 = "",
        Data49 = "",
        Data50 = "",
        Data51 = "",
        Data52 = "",
        Data53 = "",
        Data54 = "",
        Data55 = "",
        Data56 = "",
        Data57 = "",
        Data58 = "",
        Data59 = "",
        Data60 = "",
        Data61 = "",
        Data62 = "",
        Data63 = "",
        Data64 = "",
        Data65 = "",
        Data66 = "",
        Data67 = "",
        Data68 = "",
        Data69 = "",
        Data70 = "",
        Data71 = "",
        Data72 = "",
        Data73 = "",
        Data74 = "",
        Data75 = "",
        Data76 = "",
        Data77 = "",
        Data78 = "",
        Data79 = "",
        Data80 = "",
        Data81 = "",
        Data82 = "",
        Data83 = "",
        Data84 = "",
        Data85 = "",
        Data86 = "",
        Data87 = "",
        Data88 = "",
        Data89 = "",
        Data90 = "",
        Data91 = "",
        Data92 = "",
        Data93 = "",
        Data94 = "",
        Data95 = "",
        Data96 = "",
        Data97 = "",
        Data98 = "",
        Data99 = "",
        Data100 = "",
        Type = 6
    },
    isMinimizeEnabled = { 
        isMinimizeEnabled = true 
    },
    isWindowVisible = { 
        isWindowVisible = true 
    },
    isMapWindowVisible = { 
        value = false 
    },
    isOptionsWindowVisible = { 
        isOptionsWindowVisible = false 
    },
    escEnable = { 
        escEnable = false 
    },
    altEnable = { 
        altEnable = false 
    },
    FirstInitialization = { 
        value = true 
    },
    displayPersonal = { 
        value = true 
    },
    displayPremium = { 
        value = true 
    },
    displayConfrerie = { 
        value = true 
    },
    displayConfrerieFriend = { 
        value = true 
    },
    displayReput = { 
        value = true 
    },
    keepShortcuts = { 
        value = false 
    },
    isLocked = { 
        value = false 
    },
    travelHome = { 
        nbr = 4 
    },
    teleport = { 
        nbr = 11 
    },
    hunterLoc = { 
        nbr = 45 
    },
    wardenLoc = { 
        nbr = 38 
    },
    racialLoc = { 
        nbr = 1 
    },
    reputLoc = { 
        nbr = 41 
    },
    nbrSlots = { 
        nbr = 10 
    },
    creepLoc = { 
        nbr = 17 
    },
    racePlayer = { 
        nbr = 0 
    },
    classPlayer = { 
        nbr = 0 
    },
    personalHouseMap = { 
        value = 0 
    },
    confrerieHouseMap = { 
        value = 0 
    },
    confrerieFriendHouseMap = { 
        value = 0 
    },
    premiumHouseMap = { 
        value = 0 
    },
    Teleport_1 = { 
        value = 0 
    },
    Teleport_2 = { 
        value = 0 
    },
    Teleport_3 = { 
        value = 0 
    },
    Teleport_4 = { 
        value = 0 
    },
    Teleport_5 = { 
        value = 0 
    },
    Teleport_6 = { 
        value = 0 
    },
    Teleport_7 = { 
        value = 0 
    },
    Teleport_8 = { 
        value = 0 
    },
    Teleport_9 = { 
        value = 0 
    },
    Teleport_10 = { 
        value = 0 
    },
    Teleport_11 = { 
        value = 0 
    },
    nbrLine = { 
        nbr = 10 
    }
};
------------------------------------------------------------------------------------------
-- Resources settings --
------------------------------------------------------------------------------------------
ResourcePath = "Homeopatix/Voyage/Resources/";

Images = {
	MinimizedIcon = ResourcePath .. "Voyage.tga",
};
------------------------------------------------------------------------------------------
-- RGB color codes --
------------------------------------------------------------------------------------------
rgb = {
    start = "<rgb=#DAA520>",
    error = "<rgb=#FF0000>",
    clear = "</rgb>"
};
------------------------------------------------------------------------------------------
-- Load settings --
------------------------------------------------------------------------------------------
LoadSettings();