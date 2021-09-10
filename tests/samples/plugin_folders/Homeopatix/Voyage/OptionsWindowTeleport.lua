------------------------------------------------------------------------------------------
-- OptionWindow file
-- Written by Homeopatix
-- 17 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- define size of the window
------------------------------------------------------------------------------------------
local windowWidth = 0;
local windowHeight = 0;

if(playerAlignement == 1)then
	windowWidth = 450;
	windowHeight = 800;
end

checkBox = { };
------------------------------------------------------------------------------------------
-- create the options window
------------------------------------------------------------------------------------------
function GenerateOptionsWindowTeleport(value, teleportNumber)

		if(value == "Eregion")then
			if Turbine.Engine.GetLanguage() == Turbine.Language.German then
				windowWidth = 795;
				windowHeight = 640;
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
				windowWidth = 815;
				windowHeight = 640;
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
				windowWidth = 795;
				windowHeight = 640;
			end
			posx = 20;
			posy = 70;
		end
		if(value == "Rhovanion")then
			if Turbine.Engine.GetLanguage() == Turbine.Language.German then
				windowWidth = 1175;
				windowHeight = 710;
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
				windowWidth = 1165;
				windowHeight = 710;
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
				windowWidth = 1155;
				windowHeight = 710;
			end
			
			posx = 20;
			posy = 70;
		end
		if(value == "Gondor")then
			if Turbine.Engine.GetLanguage() == Turbine.Language.German then
				windowWidth = 640;
				windowHeight = 550;
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
				windowWidth = 620;
				windowHeight = 550;
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
				windowWidth = 610;
				windowHeight = 550;
			end
			
			posx = 40;
			posy = 70;
		end
		if(value == "Mordor")then
			if Turbine.Engine.GetLanguage() == Turbine.Language.German then
				windowWidth = 400;
				windowHeight = 570;
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
				windowWidth = 400;
				windowHeight = 570;
			elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
				windowWidth = 400;
				windowHeight = 570;
			end
			
			posx = 40;
			posy = 70;
		end

		OptionsWindowTeleport=Turbine.UI.Lotro.GoldWindow(); 
		OptionsWindowTeleport:SetSize(windowWidth, windowHeight); 

		if(value == "Eregion")then
			OptionsWindowTeleport:SetText(Strings.TeleportRegion1); 
		end
		if(value == "Rhovanion")then
			OptionsWindowTeleport:SetText(Strings.TeleportRegion2); 
		end
		if(value == "Gondor")then
			OptionsWindowTeleport:SetText(Strings.TeleportRegion3); 
		end
		if(value == "Mordor")then
			OptionsWindowTeleport:SetText(Strings.TeleportRegion4); 
		end

		OptionsWindowTeleport.Message=Turbine.UI.Label(); 
		OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
		OptionsWindowTeleport.Message:SetSize(200,15); 
		OptionsWindowTeleport.Message:SetPosition(windowWidth/2 - 100, windowHeight - 17 ); 
		OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		OptionsWindowTeleport.Message:SetText(Strings.PluginText); 

		OptionsWindowTeleport:SetZOrder(1);
		OptionsWindowTeleport:SetWantsKeyEvents(true);
		OptionsWindowTeleport:SetVisible(false);

		local offset = math.floor(OptionsWindowTeleport:GetWidth() / 4);

		OptionsWindowTeleport:SetPosition((Turbine.UI.Display:GetWidth()-OptionsWindowTeleport:GetWidth())/2,(Turbine.UI.Display:GetHeight()-OptionsWindowTeleport:GetHeight())/2);
		
		-----------------------------------------
		-- center window---------------
		----------------------------------------

		if(value == "Eregion")then
			DisplayEregion();
		end
		if(value == "Rhovanion")then
			DisplayRhovanion();
		end
		if(value == "Gondor")then
			DisplayGondor();
		end
		if(value == "Mordor")then
			DisplayMordor();
		end

		buttonValiderTeleport = Turbine.UI.Lotro.GoldButton();
		buttonValiderTeleport:SetParent( OptionsWindowTeleport );
		buttonValiderTeleport:SetPosition(windowWidth/2 - 125, windowHeight - 40);
		buttonValiderTeleport:SetSize( 300, 20 );
		buttonValiderTeleport:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		buttonValiderTeleport:SetText( Strings.PluginOption10 );
		buttonValiderTeleport:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		buttonValiderTeleport:SetVisible(true);
		buttonValiderTeleport:SetMouseVisible(true);
		
		ClosingTheOptionsWindowTeleport();
		ValidateSelection(value, teleportNumber);
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------
function ValidateSelection(value, teleportNumber)
	buttonValiderTeleport.MouseClick = function(sender, args)
		------------------------------------------------------------------------------------------
		-- checking the checkbox --
		------------------------------------------------------------------------------------------
		if(value == "Eregion")then
			for i=1, 56 do
				if (checkBox[i]:IsChecked()) then
					settings["Teleport_" .. teleportNumber]["value"] = i;
				end
			end
		end
		if(value == "Rhovanion")then
			for i=57, 148 do
				if (checkBox[i]:IsChecked()) then
					settings["Teleport_" .. teleportNumber]["value"] = i;
				end
			end
		end
		if(value == "Gondor")then
			for i=149, 175 do
				if (checkBox[i]:IsChecked()) then
					settings["Teleport_" .. teleportNumber]["value"] = i;
				end
			end
		end
		if(value == "Mordor")then
			for i=176, 195 do
				if (checkBox[i]:IsChecked()) then
					settings["Teleport_" .. teleportNumber]["value"] = i;
				end
			end
		end

		OptionsWindowTeleport:SetVisible(false);
		GenerateOptionsWindow();
		OptionsWindow:SetVisible(true);
	end
end

function DisplayEregion()
	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion1); 
			
	for i=1, 5 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Angmar

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion2); 
			
	for i=6, 12 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin bree-land

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion3); 
			
	for i=13, 19 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Enedwaith 
	-- nouvelle ligne
	posy = 70;
	posx = posx + 200;
	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion4); 
			
	for i=20, 25 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Ered Luin 

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion5); 
			
	for i=26, 29 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin Eregion
	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion6); 
			
	for i=30, 36 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Evendim 

	-- nouvelle ligne
	posy = 70;
	posx = posx + 200;
	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion7); 
			
	for i=37, 41 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin forochel 


	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion8); 
			
	for i=42, 43 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin lone lands 

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion9); 
			
	for i=44, 45 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Rhe misty moutains

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion10); 
			
	for i=46, 47 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Rhe The North down 

	-- nouvelle ligne
	posy = 70;
	posx = posx + 200;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion11); 
			
	for i=48, 53 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Rhe The shire 

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion12); 
			
	for i=54, 56 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Rhe The trollshaws 
end --- stoped at 55, sous region = 12
function DisplayRhovanion()
	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion13); 
			
	for i=57, 60 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Lothorien

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion14); 
			
	for i=61, 66 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Mirkwood

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion15); 
			
	for i=67, 77 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Mirkwood
	-- nouvelle ligne

	-- ci dessous pays de dun
	posy = 70;
	posx = posx + 200;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion16); 
			
	for i=78, 85 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin pay de dun
	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion17); 
			
	for i=86, 86 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin landes farouche
	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion24); 
			
	for i=87, 88 do 
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Heathfells

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion25); 
			
	for i=89, 89 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Nan Curunír

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion26); 
			
	for i=90, 90 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 30); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin  Isengard


	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion27); 
			
	for i=91, 91 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin  Nan Curunír

	-- nouvelle ligne
	posy = 70;
	posx = posx + 200;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion28); 
			
	for i=92, 97 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin   le grand fleuve

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion34); 
			
	for i=98, 99 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin   Entwash Vale


	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion35); 
			
	for i=100, 102 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;


	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion36); 
			
	for i=103, 106 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin   Sutcrofts

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion37); 
			
	for i=107, 108 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	
	-- fin The East Wall

	-- nouvelle ligne
	posy = 70;
	posx = posx + 200;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion38); 
			
	for i=109, 111 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin The  Wold

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion39); 
			
	for i=112, 117 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin  Kingstead

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion40); 
			
	for i=118, 120 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	
	-- fin  Eastfold
	posy = posy + 35;
	

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion41); 
			
	for i=121, 122 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin  Eastfold

	

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion42); 

	for i=123, 125 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end

	-- fin  Stonedeans
	-- nouvelle ligne
	posy = 70;
	posx = posx + 200;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion43); 

	for i=126, 127 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin  Westfold

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion44); 

	for i=128, 128 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin  Helm's Deep
	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion45); 
			
	for i=129, 133 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end

	-- fin val d'anduin'
	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion46); 
			
	for i=134, 137 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	--- Puit du long fleuve
	posy = posy + 35;


	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion47); 
			
	for i=138, 138 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	--- Val d'Aïeul

	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion48); 
			
	for i=139, 140 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin mont de fer

	-- nouvelle ligne
	posy = 70;
	posx = posx + 200;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion49); 
			
	for i=141, 146 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin terre de dale

	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion50); 
			
	for i=147, 147 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin Ered Mithrin

	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion51); 
			
	for i=148, 148 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin azanulbizar
end 
function DisplayGondor()
	--posy = posy + 35;
	-- fin Blackroot Vale

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion52); 
			
	for i=149, 152 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin Lamedon

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion53); 
			
	for i=153, 154 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin  Havens of Belfalas

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion54); 
			
	for i=155, 157 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin  Ringló Vale

	-- nouvelle ligne

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion55); 
			
	for i=158, 158 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin  Dor-en-Ernil

	posy = 70;
	posx = posx + 200;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion56); 
			
	for i=159, 159 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;

	-- fin  Lebennin
	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion57); 
			
	for i=160, 161 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin  Upper Lebennin

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion58); 
			
	for i=162, 163 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin  Lossarnach

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion59); 
			
	for i=164, 165 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion60); 
			
	for i=166, 167 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;

	posy = 70;
	posx = posx + 200;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion61); 
			
	for i=168, 168 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion62); 
			
	for i=169, 170 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end

	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion63); 
			
	for i=171, 171 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;

	end
	-- fin  taur druadan	

	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion64); 
			
	for i=172, 172 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;

	end
	-- fin  pelennor (minas tirith)

	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion65); 
			
	for i=173, 174 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;

	end
	-- fin  pelennor après la bataille

	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion66); 
			
	for i=175, 175 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;

	end
	-- fin  ithilien du nord

end -- stoped at 160, sous region 55
function DisplayMordor()

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion67); 
			
	for i=176, 178 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	posy = posy + 35;
	-- fin La landes désertiques

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion68); 
			
	for i=179,	179 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	
	posy = posy + 35;
	-- fin minas morgul

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion69); 
			
	for i=180,	180 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end

	posy = posy + 35;
	-- fin Ud\195\185n

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion70); 
			
	for i=181, 181 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end

	posy = posy + 35;
	-- fin Dor Amarth

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion71); 
			
	for i=182,	183 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin lingrish
	posy = posy + 35;
	

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion72); 
			
	for i=184,	184 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin Gorgoroth
	posy = 70;
	posx = posx + 200;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion73); 
			
	for i=185,	186 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin Gorgoroth

	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion74); 
			
	for i=187,	190 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 20); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin Gorgoroth
	
	posy = posy + 35;

	OptionsWindowTeleport.Message=Turbine.UI.Label(); 
	OptionsWindowTeleport.Message:SetParent(OptionsWindowTeleport); 
	OptionsWindowTeleport.Message:SetSize(200,15); 
	OptionsWindowTeleport.Message:SetPosition(posx, posy - 20 ); 
	OptionsWindowTeleport.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleLeft); 
	OptionsWindowTeleport.Message:SetText(Strings.TeleportSousRegion75); 
			
	for i=191,	195 do
		checkBox[i] = Turbine.UI.Lotro.CheckBox();
		checkBox[i]:SetParent( OptionsWindowTeleport );
		checkBox[i]:SetSize(200, 25); 
		checkBox[i]:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		checkBox[i]:SetText(Strings.Teleport[i]);
		checkBox[i]:SetPosition(posx, posy);
		checkBox[i]:SetVisible(true);
		checkBox[i]:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		posy = posy + 25;
	end
	-- fin morgul vale

end
------------------------------------------------------------------------------------------
-- Closing window handler
------------------------------------------------------------------------------------------
function ClosingTheOptionsWindowTeleport()
	function OptionsWindowTeleport:Closing(sender, args)
		GenerateOptionsWindow();
		settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = true;
		OptionsWindow:SetVisible(true);
		SaveSettings();
	end
end