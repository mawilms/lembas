------------------------------------------------------------------------------------------
-- UI file
-- Written by Homeopatix
-- 7 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- define the player attributs
------------------------------------------------------------------------------------------
GetThePLayerDatas();
------------------------------------------------------------------------------------------
--  first initialization settings
------------------------------------------------------------------------------------------
if(settings["FirstInitialization"]["value"] == true)then
	if(classP == 31 or
	classP == 214 or
	classP == 24 or
	classP == 193 or
	classP == 40 or
	classP == 185 or
	classP == 23 or
	classP == 172)then
		settings["nbrLine"]["nbr"] = 10;
	end
	if(classP == 194)then
		settings["nbrLine"]["nbr"] = 10;
	end
	if(classP == 162)then
		settings["nbrLine"]["nbr"] = 10;
	end
	
	settings["FirstInitialization"]["value"] = false;
end
------------------------------------------------------------------------------------------
-- create the window
------------------------------------------------------------------------------------------
centerWindow = {};
centerLabel = {};
centerQS = {};

function GenerateWindow()

		local horizontalPosition = 20 ;
		local verticalPosition = 40;
		local nbrSlot = 0;
		local windowWidth = (settings["nbrSlots"]["nbr"] * 42) + 38;
		local windowHeight = (settings["nbrLine"]["nbr"] * 42) + 60;
		local totalSlots = tonumber(settings["nbrSlots"]["nbr"]) * tonumber(settings["nbrLine"]["nbr"]);

		VoyageWindow=Turbine.UI.Lotro.GoldWindow(); 
		VoyageWindow:SetSize(windowWidth, windowHeight); 
		VoyageWindow:SetText(Strings.PluginName); 

		VoyageWindow.Message=Turbine.UI.Label(); 
		VoyageWindow.Message:SetParent(VoyageWindow); 
		VoyageWindow.Message:SetSize(150,10); 
		VoyageWindow.Message:SetPosition(windowWidth/2 - 75, windowHeight - 20 ); 
		VoyageWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		VoyageWindow.Message:SetText(Strings.PluginText); 

		VoyageWindow:SetZOrder(0);
		VoyageWindow:SetWantsKeyEvents(true);

		VoyageWindow:SetWantsUpdates(true);

		if(settings["windowPosition"]["xPos"] == 100 and settings["windowPosition"]["yPos"] == 100)then
			VoyageWindow:SetPosition((Turbine.UI.Display:GetWidth()-VoyageWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-VoyageWindow:GetHeight())/2);
		else
			VoyageWindow:SetPosition(settings["windowPosition"]["xPos"], settings["windowPosition"]["yPos"]);
		end

		------------------------------------------------------------------------------------------
		-- center window --
		------------------------------------------------------------------------------------------

		for i=1, totalSlots do
			if(nbrSlot == tonumber(settings["nbrSlots"]["nbr"]))then
				verticalPosition = verticalPosition + 42;
				nbrSlot = 0;
				horizontalPosition = 20;
			end
			
			centerWindow[i] = Turbine.UI.Extensions.SimpleWindow();
			centerWindow[i]:SetSize( 40 , 40 );
			centerWindow[i]:SetParent( VoyageWindow );
			centerWindow[i]:SetPosition( horizontalPosition , verticalPosition);
			centerWindow[i]:SetVisible( true );
			centerWindow[i]:SetBackColor( Turbine.UI.Color( .3, .5, .7, .5) );

			centerLabel = Turbine.UI.Label();
			centerLabel:SetParent(centerWindow[i]);
			centerLabel:SetPosition( 0, 0 );
			centerLabel:SetSize( 40, 40  );
			centerLabel:SetText( "" );
			centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			centerLabel:SetZOrder(-1);
			centerLabel:SetMouseVisible(false);

			centerQS[i] = Turbine.UI.Lotro.Quickslot();
			centerQS[i]:SetParent( centerWindow[i] );
			centerQS[i]:SetPosition( 1, 1 );
			centerQS[i]:SetSize( 36, 36 );
			centerQS[i]:SetUseOnRightClick(false);

			nbrSlot = nbrSlot + 1;
			horizontalPosition = horizontalPosition + 42;

		end

	------------------------------------------------------------------------------------------
	-- setting the datas	
	------------------------------------------------------------------------------------------
	if(settings["keepShortcuts"]["value"] == false)then
		SettingTheDatas();
	end
	SettingTheShortCuts();
	DragAndDrop();
	DeleteShortCutes();
	MouseClickHandler();
	EscapeKeyPressed();
	ClosingTheWindow();
end
------------------------------------------------------------------------------------------
-- setting the shortcuts	
------------------------------------------------------------------------------------------
function SettingTheShortCuts()
		local totalSlots = tonumber(settings["nbrSlots"]["nbr"]) * tonumber(settings["nbrLine"]["nbr"]);

		for i=1, totalSlots do
			if(settings["shortcuts"]["Data" .. i] ~= "") then
				centerQS[i]:SetShortcut( Turbine.UI.Lotro.Shortcut( settings["shortcuts"]["Type"], settings["shortcuts"]["Data" .. i] ) );
			end
		end
end
------------------------------------------------------------------------------------------
-- setting the shortcuts for drag and drop	
------------------------------------------------------------------------------------------
function DragAndDrop()
	local totalSlots = tonumber(settings["nbrSlots"]["nbr"]) * tonumber(settings["nbrLine"]["nbr"]);

	for i=1, totalSlots do
		centerQS[i].DragDrop = function(sender, args)
			local tmp = Turbine.UI.Lotro.Quickslot();

			tmp = centerQS[i]:GetShortcut();
			tmp = tmp:GetData();

			--Turbine.Shell.WriteLine(tmp);

			settings["shortcuts"]["Data" .. i] = tmp;

			SaveSettings();
		end
	end
end
------------------------------------------------------------------------------------------
-- delete the shortcut with mouse wheel
------------------------------------------------------------------------------------------
function DeleteShortCutes()
	local totalSlots = tonumber(settings["nbrSlots"]["nbr"]) * tonumber(settings["nbrLine"]["nbr"]);

	for i=1, totalSlots do
		centerQS[i].MouseWheel = function(sender, args)
			if(settings.isLocked == false)then
				settings["shortcuts"]["Data" .. i] = ""; 
				centerQS[i]:SetShortcut(Turbine.UI.Lotro.Shortcut());
				SaveSettings();
			end
		end
	end
end
------------------------------------------------------------------------------------------
-- MousCLick Handler
------------------------------------------------------------------------------------------
function MouseClickHandler()
	local totalSlots = tonumber(settings["nbrSlots"]["nbr"]) * tonumber(settings["nbrLine"]["nbr"]);

	for i=1, totalSlots do
		centerQS[i].MouseClick = function(sender, args)
			if (args.Button == Turbine.UI.MouseButton.Left) then
				VoyageWindow:SetVisible(false);
				settings["isWindowVisible"]["isWindowVisible"] = false;
				SaveSettings();
			end
			if (args.Button == Turbine.UI.MouseButton.Right) then
				if(settings["isMapWindowVisible"]["value"] == false)then
					if( CheckRacial(centerQS[i]:GetShortcut():GetData()))then
						CreateMapWindow(ReturnIndex(settings["shortcuts"]["Data" .. i], racialLocations), "racial");
						settings["isMapWindowVisible"]["value"] = true;
						MapWindow:SetVisible(true);
					end
					if( CheckReput(centerQS[i]:GetShortcut():GetData()))then
						CreateMapWindow(ReturnIndex(settings["shortcuts"]["Data" .. i], reputLocations), "reput");
						settings["isMapWindowVisible"]["value"] = true;
						MapWindow:SetVisible(true);
					end
					if( CheckHouse(centerQS[i]:GetShortcut():GetData()))then
						CreateMapWindow(ReturnIndex(settings["shortcuts"]["Data" .. i], houseLocations), "house");
						settings["isMapWindowVisible"]["value"] = true;
						MapWindow:SetVisible(true);
					end
					if( CheckWarden(centerQS[i]:GetShortcut():GetData()))then
						CreateMapWindow(ReturnIndex(settings["shortcuts"]["Data" .. i], wardenLocations), "warden");
						settings["isMapWindowVisible"]["value"] = true;
						MapWindow:SetVisible(true);
					end
					if( CheckHunter(centerQS[i]:GetShortcut():GetData()))then
						CreateMapWindow(ReturnIndex(settings["shortcuts"]["Data" .. i], hunterLocations), "hunter");
						settings["isMapWindowVisible"]["value"] = true;
						MapWindow:SetVisible(true);
					end
					if( CheckCreep(centerQS[i]:GetShortcut():GetData()))then
						CreateMapWindow(ReturnIndex(settings["shortcuts"]["Data" .. i], creepLocations), "creep");
						settings["isMapWindowVisible"]["value"] = true;
						MapWindow:SetVisible(true);
					end
					if( CheckTele(centerQS[i]:GetShortcut():GetData()))then
					----------------------------------------------
					--- debuggage ----
					----------------------------------------------
					--Turbine.Shell.WriteLine("Checking teleport : " .. i);
					--Turbine.Shell.WriteLine("position du raccourci : " .. i);

						CreateMapWindow(settings["Teleport_" .. FindWichTeleport(i)]["value"], "tele");
						settings["isMapWindowVisible"]["value"] = true;
						MapWindow:SetVisible(true);
					end
				else
					CloseMapWindow();
				end
			end
		end
	end
end

function FindWichTeleport(i)
	if(settings["travelHome"]["nbr"] == 0)then
		return i;
	end
	if(settings["travelHome"]["nbr"] == 1)then
		return i;
	end
	if(settings["travelHome"]["nbr"] == 2)then
		return i-2;
	end
	if(settings["travelHome"]["nbr"] == 3)then
		return i-3;
	end
	if(settings["travelHome"]["nbr"] == 4)then
		return i-4;
	end
end
------------------------------------------------------------------------------------------
-- Closing window handler
------------------------------------------------------------------------------------------
function ClosingTheWindow()
	function VoyageWindow:Closing(sender, args)
		settings["isWindowVisible"]["isWindowVisible"] = false;
		MapWindow:SetVisible(false);
		SaveSettings();
	end
end
------------------------------------------------------------------------------------------
--  check the shortcut to define if it exist in the data file
------------------------------------------------------------------------------------------
function CheckRacial(value)
	for i=1, 7 do
		if(value == racialLocations[i])then
			return true;
		end
	end
end
function CheckCreep(value)
	for i=1, 17 do
		if(value == creepLocations[i])then
			return true;
		end
	end
end
function CheckReput(value)
	local valTmp = 0;
	valTmp = settings["reputLoc"]["nbr"];
	for i=1, valTmp do
		if(value == reputLocations[i])then
			return true;
		end
	end
end
function CheckHouse(value)
	for i=1, 4 do
		if(value == houseLocations[i])then
			return true;
		end
	end
end
function CheckWarden(value)
	local valTmp = 0;
	valTmp = settings["wardenLoc"]["nbr"];
	for i=1, valTmp do
		if(value == wardenLocations[i])then
			return true;
		end
	end
end
function CheckHunter(value)
	local valTmp = 0;
	valTmp = settings["hunterLoc"]["nbr"];
	for i=1, valTmp do
		if(value == hunterLocations[i])then
			return true;
		end
	end
end
function CheckTele(value)
	local valTmp = 0;
	valTmp = settings["teleport"]["nbr"];
	for i=1, valTmp do
		if(value == teleportLocations[i])then
			return true;
		end
	end
end
------------------------------------------------------------------------------------------
-- updating the window
------------------------------------------------------------------------------------------
function UpdateWindow()
	GenerateWindow();
end
------------------------------------------------------------------------------------------
--  returning index for map window
------------------------------------------------------------------------------------------
function ReturnIndex(value, where)
	local valTmp = 0;
	
	if(where == racialLocations)then
		valTmp = 7;
	end
	if(where == reputLocations)then
		valTmp = settings["reputLoc"]["nbr"];
	end
	if(where == houseLocations)then
		valTmp = 4;
	end
	if(where == wardenLocations)then
		valTmp = settings["wardenLoc"]["nbr"];
	end
	if(where == hunterLocations)then
		valTmp = settings["hunterLoc"]["nbr"];
	end
	if(where == creepLocations)then
		return 1;
	end
	-- loop through the list of names and search for the given value
    for i = 1, table.getn(where) do
        -- return the index value if a match is made
        if (where[i] == value) then
            return i;
        end
    end
end