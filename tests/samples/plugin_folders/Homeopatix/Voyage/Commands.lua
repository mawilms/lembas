------------------------------------------------------------------------------------------
-- Command file
-- Written by Homeopatix
-- 7 january 2021
------------------------------------------------------------------------------------------
VoyageCommand = Turbine.ShellCommand();
------------------------------------------------------------------------------------------
-- commands
------------------------------------------------------------------------------------------
function VoyageCommand:Execute( command, arguments )
	------------------------------------------------------------------------------------------
	-- Turn arguments to lower case characters --
	------------------------------------------------------------------------------------------
	arguments = string.lower(arguments);
	------------------------------------------------------------------------------------------
	-- Help command--
	------------------------------------------------------------------------------------------
	if ( arguments == "help" ) then
		commandsHelp();

		if(playerAlignement == 1)then 
			GenerateHelpWindow();
			HelpWindow:SetVisible(true);
		end
------------------------------------------------------------------------------------------
--  show 
------------------------------------------------------------------------------------------
	elseif ( arguments == "show" ) then
		Turbine.Shell.WriteLine(rgb["start"] .. pluginName .. rgb["clear"] .. " - " .. Strings.PluginWindowShow);
		VoyageWindow:SetVisible(true);
		settings["isWindowVisible"]["isWindowVisible"] = true;
		SaveSettings();
------------------------------------------------------------------------------------------
--  hide
------------------------------------------------------------------------------------------
	elseif ( arguments == "hide" ) then
		Turbine.Shell.WriteLine(rgb["start"] .. pluginName .. rgb["clear"] .. " - " .. Strings.PluginWindowHide);
		VoyageWindow:SetVisible(false);
		settings["isWindowVisible"]["isWindowVisible"] = false;
		SaveSettings();
------------------------------------------------------------------------------------------
--  lock
------------------------------------------------------------------------------------------
	elseif ( arguments == "lock" ) then
		if(settings.isLocked == false)then
			settings.isLocked = true;
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " : " .. Strings.PluginLocked);
		else
			settings.isLocked = false;
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " : " .. Strings.PluginUnlocked);
		end
		SaveSettings();
------------------------------------------------------------------------------------------
--  default
------------------------------------------------------------------------------------------
	elseif ( arguments == "default" ) then
		Turbine.Shell.WriteLine(rgb["start"] .. pluginName .. rgb["clear"] .. " - " .. Strings.PluginWindowDefault);
		VoyageWindow:SetVisible(false);
		settings["windowPosition"]["xPos"] = 500;
		settings["windowPosition"]["yPos"] = 500;
		settings["optionsWindowPosition"]["xPos"] = 500;
		settings["optionsWindowPosition"]["yPos"] = 500;
		settings["IconPosition"]["xPosIcon"] = 500;
   		settings["IconPosition"]["yPosIcon"] = 500;
		settings["isMinimizeEnabled"]["isMinimizeEnabled"] = true;
		settings["isWindowVisible"]["isWindowVisible"] = true;
		settings["escEnable"]["escEnable"] = false;
		settings["isWindowVisible"]["isWindowVisible"] = false;
		settings["nbrLine"]["nbr"] = 10;
		settings["nbrSlots"]["nbr"] = 10;
		settings["travelHome"]["nbr"] = 4;
		settings["teleport"]["nbr"] = 11;
		settings["isWindowVisible"]["isWindowVisible"] = false;
		settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = false;
		settings["displayPersonal"]["value"] = true;
		settings["displayPremium"]["value"] = true;
		settings["displayConfrerie"]["value"] = true;
		settings["displayConfrerieFriend"]["value"] = true;
		settings["displayReput"]["value"] = false;
		settings["FirstInitialization"]["value"] = false;
		settings["racePlayer"]["nbr"] = 0;
		settings["classPlayer"]["nbr"] = 0;
		settings["displayReput"]["value"] = true;
		settings["personalHouseMap"]["value"] = 0;
		settings["confrerieHouseMap"]["value"] = 0;
		settings["confrerieFriendHouseMap"]["value"] = 0;
		settings["premiumHouseMap"]["value"] = 0;
		settings["Teleport_1"]["value"] = 0;
		settings["Teleport_2"]["value"] = 0;
		settings["Teleport_3"]["value"] = 0;
		settings["Teleport_4"]["value"] = 0;
		settings["Teleport_5"]["value"] = 0;
		settings["Teleport_6"]["value"] = 0;
		settings["Teleport_7"]["value"] = 0;
		settings["Teleport_8"]["value"] = 0;
		settings["Teleport_9"]["value"] = 0;
		settings["Teleport_10"]["value"] = 0;
		settings["Teleport_11"]["value"] = 0;
		ClearWindow();
		SaveSettings();
		UpdateWindow();
		UpdateOptionsWindow();
------------------------------------------------------------------------------------------
--  options
------------------------------------------------------------------------------------------
	elseif ( arguments == "options" ) then
		Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginOptionShowWindow);
		OptionsWindow:SetVisible(true);
		VoyageWindow:SetVisible(false);
		settings["isWindowVisible"]["isWindowVisible"] = false;
		settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = true;
		SaveSettings();
------------------------------------------------------------------------------------------
--  clear
------------------------------------------------------------------------------------------
	elseif ( arguments == "clear" ) then
		Turbine.Shell.WriteLine(rgb["start"] .. pluginName .. rgb["clear"] .. " - " .. Strings.PluginWindowClear);
		settings["Teleport_1"]["value"] = 0;
		settings["Teleport_2"]["value"] = 0;
		settings["Teleport_3"]["value"] = 0;
		settings["Teleport_4"]["value"] = 0;
		settings["Teleport_5"]["value"] = 0;
		settings["Teleport_6"]["value"] = 0;
		settings["Teleport_7"]["value"] = 0;
		settings["Teleport_8"]["value"] = 0;
		settings["Teleport_9"]["value"] = 0;
		settings["Teleport_10"]["value"] = 0;
		settings["Teleport_11"]["value"] = 0;
		settings["displayPersonal"]["value"] = true;
		settings["displayPremium"]["value"] = true;
		settings["displayConfrerie"]["value"] = true;
		settings["displayConfrerieFriend"]["value"] = true;
		settings["displayReput"]["value"] = false;
		settings["personalHouseMap"]["value"] = 0;
		settings["confrerieHouseMap"]["value"] = 0;
		settings["confrerieFriendHouseMap"]["value"] = 0;
		settings["premiumHouseMap"]["value"] = 0;
		ClearWindow();
		SaveSettings();
------------------------------------------------------------------------------------------
--  clear teleport location
------------------------------------------------------------------------------------------
	elseif ( arguments == "clearteleport" ) then
		Turbine.Shell.WriteLine(rgb["start"] .. pluginName .. rgb["clear"] .. " - " .. Strings.PluginWindowClearTeleport);
		settings["Teleport_1"]["value"] = 0;
		settings["Teleport_2"]["value"] = 0;
		settings["Teleport_3"]["value"] = 0;
		settings["Teleport_4"]["value"] = 0;
		settings["Teleport_5"]["value"] = 0;
		settings["Teleport_6"]["value"] = 0;
		settings["Teleport_7"]["value"] = 0;
		settings["Teleport_8"]["value"] = 0;
		settings["Teleport_9"]["value"] = 0;
		settings["Teleport_10"]["value"] = 0;
		settings["Teleport_11"]["value"] = 0;
		settings["teleport"]["nbr"] = 11;
		ClearWindow();
		UpdateOptionsWindow();
		SaveSettings();
------------------------------------------------------------------------------------------
--  clear house location
------------------------------------------------------------------------------------------
	elseif ( arguments == "clearhouse" ) then
		Turbine.Shell.WriteLine(rgb["start"] .. pluginName .. rgb["clear"] .. " - " .. Strings.PluginWindowClearHouse);
		settings["personalHouseMap"]["value"] = 0;
		settings["confrerieHouseMap"]["value"] = 0;
		settings["confrerieFriendHouseMap"]["value"] = 0;
		settings["premiumHouseMap"]["value"] = 0;
		settings["travelHome"]["nbr"] = 4;
		ClearWindow();
		UpdateOptionsWindow();
		SaveSettings();
------------------------------------------------------------------------------------------
--  escape
------------------------------------------------------------------------------------------
	elseif ( arguments == "esc" ) then
		if(settings["escEnable"]["escEnable"] == true) then
			Turbine.Shell.WriteLine(rgb["start"] .. pluginName .. rgb["clear"] .. " - " .. Strings.PluginEscDesable);
			settings["escEnable"]["escEnable"] = false;
		else
			Turbine.Shell.WriteLine(rgb["start"] .. pluginName .. rgb["clear"] .. " - " .. Strings.PluginEscEnable);
			settings["escEnable"]["escEnable"] = true;
		end
		SaveSettings();
------------------------------------------------------------------------------------------
-- alt command--
------------------------------------------------------------------------------------------
	elseif ( arguments == "alt" ) then
		if(settings["altEnable"]["altEnable"] == true) then
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginAltDesable);
			settings["altEnable"]["altEnable"] = false;
		else
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginAltEnable);
			settings["altEnable"]["altEnable"] = true;
		end
		SaveSettings();
	end
end
------------------------------------------------------------------------------------------
-- Add the sahell command --
------------------------------------------------------------------------------------------
Turbine.Shell.AddCommand( "Voy;Voyage", VoyageCommand );