------------------------------------------------------------------------------------------
-- Load and save file
-- Written by Homeopatix
-- 7 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create or load the settings
------------------------------------------------------------------------------------------
function LoadSettings()
	local _settings = PatchDataLoad(Turbine.DataScope.Character, "Voyage_Settings", settings);
    if (_settings ~= nil) then 
		settings = _settings; 
	end
------------------------------------------------------------------------------------------
	--- adding new vars in the settings file ---
------------------------------------------------------------------------------------------
	if( not settings.Teleport_1 or 
    not settings.Teleport_2 or
    not settings.isLocked or
    not settings.altEnable or
    settings["hunterLoc"]["nbr"] ~= 45)then -- add two more for the U29 Update and two more in the U30
    settings = {
            windowPosition = { 
                xPos = settings["windowPosition"]["xPos"], 
                yPos = settings["windowPosition"]["yPos"] 
            },
            optionsWindowPosition = { 
                xPos = settings["optionsWindowPosition"]["xPos"], 
                yPos = settings["optionsWindowPosition"]["yPos"] 
            },
            IconPosition = { 
                xPosIcon = settings["IconPosition"]["xPosIcon"], 
                yPosIcon = settings["IconPosition"]["yPosIcon"] 
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
    end
end
------------------------------------------------------------------------------------------
-- create the save settings
------------------------------------------------------------------------------------------
function SaveSettings()
	settings["windowPosition"]["xPos"] = tonumber(VoyageWindow:GetLeft());
    settings["windowPosition"]["yPos"] = tonumber(VoyageWindow:GetTop());
	settings["optionsWindowPosition"]["xPos"] = tonumber(OptionsWindow:GetLeft());
	settings["optionsWindowPosition"]["yPos"] = tonumber(OptionsWindow:GetTop());
    settings["IconPosition"]["xPosIcon"] = tonumber(MinimizedIconVoyage:GetLeft());
   	settings["IconPosition"]["yPosIcon"] = tonumber(MinimizedIconVoyage:GetTop());
	settings["isMinimizeEnabled"]["isMinimizeEnabled"] = settings["isMinimizeEnabled"]["isMinimizeEnabled"];
	settings["isWindowVisible"]["isWindowVisible"] = settings["isWindowVisible"]["isWindowVisible"];
	settings["escEnable"]["escEnable"] = settings["escEnable"]["escEnable"];
    settings["altEnable"]["altEnable"] = settings["altEnable"]["altEnable"];

	for i=1, 100 do
		settings["shortcuts"]["Data" .. i] = settings["shortcuts"]["Data" .. i];
	end

	settings["shortcuts"]["Type"] = settings["shortcuts"]["Type"];

	settings["travelHome"]["nbr"] = tonumber(settings["travelHome"]["nbr"]);
    settings["teleport"]["nbr"] = tonumber(settings["teleport"]["nbr"]);
    settings["hunterLoc"]["nbr"] = tonumber(settings["hunterLoc"]["nbr"]);
	settings["racialLoc"]["nbr"] = tonumber(settings["racialLoc"]["nbr"]);
	settings["wardenLoc"]["nbr"] = tonumber(settings["wardenLoc"]["nbr"]);
	settings["reputLoc"]["nbr"] = tonumber(settings["reputLoc"]["nbr"]);

	settings["creepLoc"]["nbr"] = tonumber(settings["creepLoc"]["nbr"]);

	settings["nbrLine"]["nbr"] = tonumber(settings["nbrLine"]["nbr"]);
	settings["nbrSlots"]["nbr"] = tonumber(settings["nbrSlots"]["nbr"]);

	settings["racePlayer"]["nbr"] = tonumber(settings["racePlayer"]["nbr"]);
	settings["classPlayer"]["nbr"] = tonumber(settings["classPlayer"]["nbr"]);

	settings["FirstInitialization"]["value"] = settings["FirstInitialization"]["value"];

	settings["displayPersonal"]["value"] = settings["displayPersonal"]["value"];
	settings["displayPremium"]["value"] = settings["displayPremium"]["value"];
	settings["displayConfrerie"]["value"] = settings["displayConfrerie"]["value"];
	settings["displayConfrerieFriend"]["value"] = settings["displayConfrerieFriend"]["value"];

	settings["displayReput"]["value"] = settings["displayReput"]["value"];

	settings["keepShortcuts"]["value"] = settings["keepShortcuts"]["value"];

    ------------------------------------------------------------------------------------------
	-- new vars adds since last patch --
    ------------------------------------------------------------------------------------------
	settings["isMapWindowVisible"]["value"] = settings["isMapWindowVisible"]["value"];
    settings["personalHouseMap"]["value"] = tonumber(settings["personalHouseMap"]["value"]);
    settings["confrerieHouseMap"]["value"] = tonumber(settings["confrerieHouseMap"]["value"]);
    settings["confrerieFriendHouseMap"]["value"] = tonumber(settings["confrerieFriendHouseMap"]["value"]);
    settings["premiumHouseMap"]["value"] = tonumber(settings["premiumHouseMap"]["value"]);

    settings["Teleport_1"]["value"] = tonumber(settings["Teleport_1"]["value"]);
    settings["Teleport_2"]["value"] = tonumber(settings["Teleport_2"]["value"]);
    settings["Teleport_3"]["value"] = tonumber(settings["Teleport_3"]["value"]);
    settings["Teleport_4"]["value"] = tonumber(settings["Teleport_4"]["value"]);
    settings["Teleport_5"]["value"] = tonumber(settings["Teleport_5"]["value"]);
    settings["Teleport_6"]["value"] = tonumber(settings["Teleport_6"]["value"]);
    settings["Teleport_7"]["value"] = tonumber(settings["Teleport_7"]["value"]);
    settings["Teleport_8"]["value"] = tonumber(settings["Teleport_8"]["value"]);
    settings["Teleport_9"]["value"] = tonumber(settings["Teleport_9"]["value"]);
    settings["Teleport_10"]["value"] = tonumber(settings["Teleport_10"]["value"]);
    settings["Teleport_11"]["value"] = tonumber(settings["Teleport_11"]["value"]);
   
	------------------------------------------------------------------------------------------
    -- save the settings --
    ------------------------------------------------------------------------------------------
	PatchDataSave( Turbine.DataScope.Character, "Voyage_Settings", settings);
end