------------------------------------------------------------------------------------------
-- fonctions file
-- Written by Homeopatix
-- 7 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- define the player attributs
------------------------------------------------------------------------------------------
function GetThePLayerDatas()
    playerAlignement = Turbine.Gameplay.LocalPlayer.GetInstance():GetAlignment();
	------------------------------------------------------------------------------------------
	-- player data help
	------------------------------------------------------------------------------------------
	-- race --
	-- 81 = hobbit
	-- 23 = homme
	-- 65 = elf
	-- 114 =  beornide
	-- 120 = nain des haches robuste
	-- 73 = nain
	-- 117 = haut elf

	-- class --
	-- 194 = sentinelle
	-- 162 = chasseur
	-- 31 = minstrel
	-- 214 = beornide
	-- 24 = capitine
	-- 193 = maitre des runes
	-- 40 = cambrioleur
	-- 185 = maitre du savoir
	-- 23 = gardien
	-- 172 = champion
	-- 194 = sentinelle
	-- 162 = chasseur

	-- alignement : 1 = freepoeple
	-- alignement : 2 = monsterPlay
    
    if(playerAlignement == Turbine.Gameplay.Alignment.FreePeople)then
	    player = Turbine.Gameplay.LocalPlayer.GetInstance();
	    playerAttr = player:GetAttributes();
	    vocation = playerAttr:GetVocation();
	    classP = player:GetClass();
		settings["classPlayer"]["nbr"] = classP;
	    race = player:GetRace();
		settings["racePlayer"]["nbr"] = race;
    end
end
------------------------------------------------------------------------------------------
-- debugage part --
------------------------------------------------------------------------------------------
function Debugage(value)
	GetThePLayerDatas();

	local travHome = 0;
	travHome = settings["travelHome"]["nbr"];
	local tele = 0;
	tele = settings["teleport"]["nbr"];
	local racialLoc = 0;
	racial = settings["racialLoc"]["nbr"];
	local warden = 0;
	warden = settings["wardenLoc"]["nbr"];
	local hunter = 0;
	hunter = settings["hunterLoc"]["nbr"];
	local reput = 0;
	reput = settings["reputLoc"]["nbr"];
	local race = 0;
	race = settings["racePlayer"]["nbr"];
	local classP = 0;
	classP = settings["classPlayer"]["nbr"];

	--Turbine.Shell.WriteLine("\n---- Debug part " .. value .. " ----\n");
	--Turbine.Shell.WriteLine("valHome : " .. valHome);
	--Turbine.Shell.WriteLine("tele : " .. tele);
	--Turbine.Shell.WriteLine("racial : " .. racial);
	--Turbine.Shell.WriteLine("warden : " .. warden);
	--Turbine.Shell.WriteLine("hunter : " .. hunter);
	--Turbine.Shell.WriteLine("reput : " .. reput);
	--Turbine.Shell.WriteLine("race : " .. race);
	--Turbine.Shell.WriteLine("class : " .. classP);
end
------------------------------------------------------------------------------------------
--setting the datas of the shortcuts
------------------------------------------------------------------------------------------
function SettingTheDatas()
	GetThePLayerDatas();

	if(playerAlignement == 1)then
		SetDatasFreePeople();
	else
		SetDatasMonsterPlay();
	end
end
------------------------------------------------------------------------------------------
--setting the datas of the shortcuts for monsterPlay
------------------------------------------------------------------------------------------
function SetDatasMonsterPlay()
	local creep = 0;
	creep = settings["creepLoc"]["nbr"];

	for i=0, creep do
		if(settings["shortcuts"]["Data" .. i] == "") then
			settings["shortcuts"]["Data" .. i] = creepLocations[i];
		end
	end
end

function SetDatasFreePeople()
	GetThePLayerDatas();
	------------------------------------------------------------------------------------------
	-- setting the data	
	------------------------------------------------------------------------------------------
	local travHome = 0;
	travHome = settings["travelHome"]["nbr"];
	local tele = 0;
	tele = settings["teleport"]["nbr"];
	local racialLoc = 0;
	racial = settings["racialLoc"]["nbr"];
	local warden = 0;
	warden = settings["wardenLoc"]["nbr"];
	local hunter = 0;
	hunter = settings["hunterLoc"]["nbr"];
	local reput = 0;
	reput = settings["reputLoc"]["nbr"];
	local race = 0;
	race = settings["racePlayer"]["nbr"];
	local classP = 0;
	classP = settings["classPlayer"]["nbr"];

	local valHome = 0;
	local perso = false;
	local confr = false;
	local premi = false;
	local confr2 = false;

	------ Debug ------
	Debugage("Home");
	-------------------

	if(settings["shortcuts"]["Data" .. valHome+1] == "")then
		if(perso == false)then
			if(settings["displayPersonal"]["value"] == true)then
				settings["shortcuts"]["Data" .. valHome+1] = houseLocations[1];
				perso = true;
				valHome = valHome + 1;
			end
		end	
	end
	if(settings["shortcuts"]["Data" .. valHome+1] == "")then
		if(confr == false)then
			if(settings["displayConfrerie"]["value"] == true)then
				settings["shortcuts"]["Data" .. valHome+1] = houseLocations[2];
				confr = true;
				valHome = valHome + 1;
			end
		end	
	end
	if(settings["shortcuts"]["Data" .. valHome+1] == "")then
		if(confr2 == false)then
			if(settings["displayConfrerieFriend"]["value"] == true)then
				settings["shortcuts"]["Data" .. valHome+1] = houseLocations[3];
				confr2 = true;
				valHome = valHome + 1;
			end
		end	
	end
	if(settings["shortcuts"]["Data" .. valHome+1] == "")then
		if(premi == false)then
			if(settings["displayPremium"]["value"] == true)then
				settings["shortcuts"]["Data" .. valHome+1] = houseLocations[4];
				premi = true;
				valHome = valHome + 1;
			end
		end	
	end

	------ Debug ------
	Debugage("Teleport");
	-------------------

	for i=valHome, (tele+valHome) do
		if(settings["shortcuts"]["Data" .. i] == "") then
			settings["shortcuts"]["Data" .. i] = teleportLocations[i-valHome];
		end
	end

	------ Debug ------
	Debugage("Racial");
	-------------------

	for i=(tele+valHome), (tele+valHome+racial) do
		if(settings["shortcuts"]["Data" .. i] == "") then
			if(race == 81)then
				settings["shortcuts"]["Data" .. i] = racialLocations[2];
			end
			if(race == 23)then
				settings["shortcuts"]["Data" .. i] = racialLocations[1];
			end
			if(race == 65)then
				settings["shortcuts"]["Data" .. i] = racialLocations[4];
			end
			if(race == 114)then
				settings["shortcuts"]["Data" .. i] = racialLocations[5];
			end
			if(race == 120)then
				settings["shortcuts"]["Data" .. i] = racialLocations[7];
			end
			if(race == 73)then
				settings["shortcuts"]["Data" .. i] = racialLocations[3];
			end
			if(race == 117)then
				settings["shortcuts"]["Data" .. i] = racialLocations[6];
			end
		end
	end

	------ Debug ------
	Debugage("Warden");
	-------------------
	------------------------------------------------------------------------------------------
	-- setting the data	for hunter and warden
	------------------------------------------------------------------------------------------
	if(classP == 194)then  -- sentinelle
		for i=(tele+valHome+racial), (tele+valHome+warden+racial) do
			if(settings["shortcuts"]["Data" .. i] == "") then
				settings["shortcuts"]["Data" .. i] = wardenLocations[i-(tele+valHome+racial)];
			end
		end
		if(settings["displayReput"]["value"] == true)then
			for i=((tele+valHome+warden+racial)), (tele+valHome+racial+reput+warden) do
				if(settings["shortcuts"]["Data" .. i] == "") then
					settings["shortcuts"]["Data" .. i] = reputLocations[i-(tele+valHome+warden+racial)];
				end
			end
		end
	end

	------ Debug ------
	Debugage("Hunter");
	-------------------

	if(classP == 162)then  -- chasseur
		for i=(tele+valHome+racial), (tele+valHome+racial+hunter) do
			if(settings["shortcuts"]["Data" .. i] == "") then
				settings["shortcuts"]["Data" .. i] = hunterLocations[i-(tele+valHome+racial)];
			end
		end
		if(settings["displayReput"]["value"] == true)then
			for i=(tele+valHome+racial+hunter), (tele+valHome+racial+reput+hunter) do
				if(settings["shortcuts"]["Data" .. i] == "") then
					settings["shortcuts"]["Data" .. i] = reputLocations[i-((tele+valHome+racial+hunter))];
				end
			end
		end
	end
	------ Debug ------
	Debugage("Reputation");
	-------------------

	if(classP == 31 or
	classP == 214 or
	classP == 24 or
	classP == 193 or
	classP == 40 or
	classP == 185 or
	classP == 23 or
	classP == 172)then
		if(settings["displayReput"]["value"] == true)then
			for i=(tele+valHome+racial), (tele+valHome+racial+reput) do
				if(settings["shortcuts"]["Data" .. i] == "") then
					settings["shortcuts"]["Data" .. i] = reputLocations[i-(tele+valHome+racial)];
				end
			end
		end
	end
end
------------------------------------------------------------------------------------------
-- clear the main window
------------------------------------------------------------------------------------------
function ClearWindow()
	for i=1, 100 do
		settings["shortcuts"]["Data" .. i] = "";
		if(centerQS[i] ~= nil)then
			centerQS[i]:SetShortcut( Turbine.UI.Lotro.Shortcut( ));
		end
	end
end
------------------------------------------------------------------------------------------
-- display the list of command
------------------------------------------------------------------------------------------
function commandsHelp()
	notification(
		rgb["start"] .. 
		Strings.PluginHelp1 ..
		rgb["clear"] ..
		Strings.PluginHelp2 ..
		Strings.PluginHelp3 ..
		Strings.PluginHelp4 ..
		Strings.PluginHelp5 ..
		Strings.PluginHelp6 ..
		Strings.PluginHelp7 ..
		Strings.PluginHelp8 ..
		Strings.PluginHelp9 ..
		Strings.PluginHelp10
	);
end
------------------------------------------------------------------------------------------
-- event handler for escape key
------------------------------------------------------------------------------------------
function EscapeKeyPressed()
	VoyageWindow.KeyDown=function(sender, args)
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			if(settings["escEnable"]["escEnable"] == false) then
				VoyageWindow:SetVisible(false);
				settings["isWindowVisible"]["isWindowVisible"] = false;
				SaveSettings();
			end
			OptionsWindow:SetVisible(false);
			OptionsWindowHousing:SetVisible(false);
			OptionsWindowRegion:SetVisible(false);
			OptionsWindowTeleport:SetVisible(false);
			settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = false;
			HelpWindow:SetVisible(false);
			SaveSettings();
		end
		-- https://www.lotro.com/forums/showthread.php?493466-How-to-hide-a-window-on-F12&p=6581962#post6581962
		if ( args.Action == 268435635 ) then
			hudVisible=not hudVisible;
			if hudVisible then
				VoyageWindow:SetVisible(false);
				OptionsWindow:SetVisible(false);
				OptionsWindowHousing:SetVisible(false);
				OptionsWindowRegion:SetVisible(false);
				OptionsWindowTeleport:SetVisible(false);
				MinimizedIconVoyage:SetVisible(false);
			else
				VoyageWindow:SetVisible(settings["isWindowVisible"]["isWindowVisible"]);
				MinimizedIconVoyage:SetVisible(true);
			end
		end
	end
end
------------------------------------------------------------------------------------------
-- window position changed
------------------------------------------------------------------------------------------
function WindowPositionChanged()
	VoyageWindow.PositionChanged = function( sender, args )
   		local x,y = VoyageWindow:GetPosition();
		settings["windowPosition"]["xPos"] = x;
   		settings["windowPosition"]["yPos"] = y;
		settings["optionsWindowPosition"]["xPos"] = x;
		settings["optionsWindowPosition"]["yPos"] = y;
		SaveSettings();
	end
end
------------------------------------------------------------------------------------------
-- options window position changed
------------------------------------------------------------------------------------------
function OptionsWindowPositionChanged()
	OptionsWindow.PositionChanged = function( sender, args )
		local x,y = OptionsWindow:GetPosition();
		settings["optionsWindowPosition"]["xPos"] = x;
		settings["optionsWindowPosition"]["yPos"] = y;
		SaveSettings();
	end
end
------------------------------------------------------------------------------------------
-- minimiza icon handling
------------------------------------------------------------------------------------------
function CreateAndHandleMinimizeIcon()
	if(settings["isWindowVisible"]["isWindowVisible"] == true)then
		MinimizedIconVoyage = MinimizedIcon(Images.MinimizedIcon, 32, 32, VoyageWindow:SetVisible(true));
	else
		MinimizedIconVoyage = MinimizedIcon(Images.MinimizedIcon, 32, 32, VoyageWindow:SetVisible(false));
	end

	MinimizedIconVoyage:SetPosition(settings["IconPosition"]["xPosIcon"], settings["IconPosition"]["yPosIcon"]);
	MinimizedIconVoyage:SetZOrder(0);

	MinimizedIconVoyage.PositionChanged = function()
		settings["IconPosition"]["xPosIcon"] = MinimizedIconVoyage:GetLeft();
		settings["IconPosition"]["yPosIcon"] = MinimizedIconVoyage:GetTop();
		SaveSettings();
	end
end
------------------------------------------------------------------------------------------
-- mouseHover handling
------------------------------------------------------------------------------------------
function SetTheMouseEnterForOptions()
	buttonDefineHouseLocationPersonal.MouseEnter = function()
		personalButtonLabel:SetVisible(true);
	end

	buttonDefineHouseLocationPersonal.MouseLeave = function()
		personalButtonLabel:SetVisible(false);
	end

	buttonDefineHouseLocationPersonal2.MouseEnter = function()
		personalButtonLabel2:SetVisible(true);
	end

	buttonDefineHouseLocationPersonal2.MouseLeave = function()
		personalButtonLabel2:SetVisible(false);
	end

	buttonDefineHouseLocationPersonal3.MouseEnter = function()
		personalButtonLabel3:SetVisible(true);
	end

	buttonDefineHouseLocationPersonal3.MouseLeave = function()
		personalButtonLabel3:SetVisible(false);
	end

	buttonDefineHouseLocationPersonal4.MouseEnter = function()
		personalButtonLabel4:SetVisible(true);
	end

	buttonDefineHouseLocationPersonal4.MouseLeave = function()
		personalButtonLabel4:SetVisible(false);
	end

	buttonDefineHelp.MouseEnter = function()
		helpButtonLabel:SetVisible(true);
	end

	buttonDefineHelp.MouseLeave = function()
		helpButtonLabel:SetVisible(false);
	end
end