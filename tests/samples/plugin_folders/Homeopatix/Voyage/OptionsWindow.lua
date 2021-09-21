------------------------------------------------------------------------------------------
-- OptionWindow file
-- Written by Homeopatix
-- 7 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- define size of the window
------------------------------------------------------------------------------------------
local windowWidth = 0;
local windowHeight = 0;
local positionInitiale = 0;

if(playerAlignement == 1)then
	windowWidth = 400;
	windowHeight = 620;
	positionInitiale = 40;
else
	windowWidth = 400;
	windowHeight = 300;
	positionInitiale = 50;
end
------------------------------------------------------------------------------------------
-- create the options window
------------------------------------------------------------------------------------------
function GenerateOptionsWindow()
		OptionsWindow=Turbine.UI.Lotro.GoldWindow(); 
		OptionsWindow:SetSize(windowWidth, windowHeight); 
		OptionsWindow:SetText(Strings.PluginOptionsText); 

		OptionsWindow.Message=Turbine.UI.Label(); 
		OptionsWindow.Message:SetParent(OptionsWindow); 
		OptionsWindow.Message:SetSize(150,10); 
		OptionsWindow.Message:SetPosition(windowWidth/2 - 75, windowHeight - 17 ); 
		OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		OptionsWindow.Message:SetText(Strings.PluginText); 

		OptionsWindow:SetZOrder(0);
		OptionsWindow:SetWantsKeyEvents(true);

		OptionsWindow:SetPosition((Turbine.UI.Display:GetWidth()-OptionsWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-OptionsWindow:GetHeight())/2);
		--[[
		if(settings["optionsWindowPosition"]["xPos"] == 100 and settings["optionsWindowPosition"]["yPos"] == 100)then
			OptionsWindow:SetPosition((Turbine.UI.Display:GetWidth()-OptionsWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-OptionsWindow:GetHeight())/2);
		else
			OptionsWindow:SetPosition(settings["optionsWindowPosition"]["xPos"], settings["optionsWindowPosition"]["yPos"]);
		end
		]]--
		OptionsWindow:SetVisible(false);

		------------------------------------------------------------------------------------------
		-- center window
		------------------------------------------------------------------------------------------
		OptionsWindow.Message=Turbine.UI.Label(); 
		OptionsWindow.Message:SetParent(OptionsWindow); 
		OptionsWindow.Message:SetSize(300, 20); 
		OptionsWindow.Message:SetPosition(windowWidth/2 - 150, positionInitiale ); 
		OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		OptionsWindow.Message:SetText(Strings.PluginOption1); 

		OptionsWindow.Message=Turbine.UI.Label(); 
		OptionsWindow.Message:SetParent(OptionsWindow); 
		OptionsWindow.Message:SetSize(300, 20); 
		OptionsWindow.Message:SetPosition(windowWidth/2 - 150, positionInitiale + 15 ); 
		OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		OptionsWindow.Message:SetText("Max 10"); 
  
		textBoxLines = Turbine.UI.Lotro.TextBox();
		textBoxLines:SetParent( OptionsWindow );
		textBoxLines:SetSize(100, 30); 
		textBoxLines:SetText(settings["nbrLine"]["nbr"]); 
		textBoxLines:SetPosition(windowWidth/2 - 50, positionInitiale + 30);
		textBoxLines:SetVisible(true);
		textBoxLines:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		textBoxLines:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		textBoxLines:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));

		OptionsWindow.Message=Turbine.UI.Label(); 
		OptionsWindow.Message:SetParent(OptionsWindow); 
		OptionsWindow.Message:SetSize(300, 20); 
		OptionsWindow.Message:SetPosition(windowWidth/2 - 150, positionInitiale + 85 ); 
		OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
		OptionsWindow.Message:SetText(Strings.PluginOption2); 

		OptionsWindow.Message=Turbine.UI.Label(); 
		OptionsWindow.Message:SetParent(OptionsWindow); 
		OptionsWindow.Message:SetSize(300, 20); 
		OptionsWindow.Message:SetPosition(windowWidth/2 - 150, positionInitiale + 100 ); 
		OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana12);
		OptionsWindow.Message:SetText("Min 3 - Max 20"); 

		textBoxSlots = Turbine.UI.Lotro.TextBox();
		textBoxSlots:SetParent( OptionsWindow );
		textBoxSlots:SetSize(100, 30); 
		textBoxSlots:SetText(settings["nbrSlots"]["nbr"]); 
		textBoxSlots:SetPosition(windowWidth/2 - 50, positionInitiale + 120);
		textBoxSlots:SetVisible(true);
		textBoxSlots:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		textBoxSlots:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
		textBoxSlots:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));		
		------------------------------------------------------------------------------------------
		-- -- free people option panel --
		------------------------------------------------------------------------------------------
		if(playerAlignement == 1)then 
			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(390, 20); 
			OptionsWindow.Message:SetPosition(windowWidth/2 - 195, 210 ); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(Strings.PluginOption3); 

			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(390, 20); 
			OptionsWindow.Message:SetPosition(windowWidth/2 - 195, 225 ); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana12);
			OptionsWindow.Message:SetText("Min 0 - Max 11"); 

			textBoxTeleport = Turbine.UI.Lotro.TextBox();
			textBoxTeleport:SetParent( OptionsWindow );
			textBoxTeleport:SetSize(100, 30); 
			textBoxTeleport:SetText(settings["teleport"]["nbr"]); 
			textBoxTeleport:SetPosition(windowWidth/2 - 50, 240);
			textBoxTeleport:SetVisible(true);
			textBoxTeleport:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			textBoxTeleport:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
			textBoxTeleport:SetBackColor( Turbine.UI.Color( .9, .5, .7, .5));

			------------------------------------------------------------------------------------------
			-- teleport button --
			------------------------------------------------------------------------------------------
			buttonTP = {};
			centerLabelTP = {};
			TPButtonLabel= {};
			centerLabelTP = {};

			positionTP = 60 ;
			distToAdd = 25;

			CreateButtonTP(positionTP, 1, Strings.PluginDefinTeleport);
			positionTP = positionTP + distToAdd;
			CreateButtonTP(positionTP, 2, Strings.PluginDefinTeleport);
			positionTP = positionTP + distToAdd;
			CreateButtonTP(positionTP, 3, Strings.PluginDefinTeleport);
			positionTP = positionTP + distToAdd;
			CreateButtonTP(positionTP, 4, Strings.PluginDefinTeleport);
			positionTP = positionTP + distToAdd;
			CreateButtonTP(positionTP, 5, Strings.PluginDefinTeleport);
			positionTP = positionTP + distToAdd;
			CreateButtonTP(positionTP, 6, Strings.PluginDefinTeleport);
			positionTP = positionTP + distToAdd;
			CreateButtonTP(positionTP, 7, Strings.PluginDefinTeleport);
			positionTP = positionTP + distToAdd;
			CreateButtonTP(positionTP, 8, Strings.PluginDefinTeleport);
			positionTP = positionTP + distToAdd;
			CreateButtonTP(positionTP, 9, Strings.PluginDefinTeleport);
			positionTP = positionTP + distToAdd;
			CreateButtonTP(positionTP, 10, Strings.PluginDefinTeleport);
			positionTP = positionTP + distToAdd;
			CreateButtonTP(positionTP, 11, Strings.PluginDefinTeleport);
			positionTP = positionTP + distToAdd;

			------------------------------------------------------------------------------------------
			-- end teleport button
			------------------------------------------------------------------------------------------

			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 20); 
			OptionsWindow.Message:SetPosition(windowWidth/2 - 150, 320 ); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(Strings.PluginOption4); 

			checkBoxPersonal = Turbine.UI.Lotro.CheckBox();
			checkBoxPersonal:SetParent( OptionsWindow );
			checkBoxPersonal:SetSize(200, 20); 
			checkBoxPersonal:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxPersonal:SetText(Strings.PluginOption5);
			checkBoxPersonal:SetPosition(90, 345);
			checkBoxPersonal:SetVisible(true);
			if(settings["displayPersonal"]["value"] == true)then
				checkBoxPersonal:SetChecked(true);
			else
				checkBoxPersonal:SetChecked(false);
			end
			checkBoxPersonal:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
			if (settings["keepShortcuts"]["value"] == true) then
				checkBoxPersonal:SetEnabled(false);
			else
				checkBoxPersonal:SetEnabled(true);
			end


			buttonDefineHouseLocationPersonal = Turbine.UI.Extensions.SimpleWindow();
			buttonDefineHouseLocationPersonal:SetParent( OptionsWindow );
			buttonDefineHouseLocationPersonal:SetPosition(windowWidth - 40, 345);
			buttonDefineHouseLocationPersonal:SetSize( 20, 20 );
			buttonDefineHouseLocationPersonal:SetVisible(true);

			centerLabelB = Turbine.UI.Label();
			centerLabelB:SetParent(buttonDefineHouseLocationPersonal);
			centerLabelB:SetPosition( 0, 0 );
			centerLabelB:SetSize( 20, 20  );
			centerLabelB:SetZOrder(-1);
			centerLabelB:SetMouseVisible(false);

			if(settings["personalHouseMap"]["value"] ~= 0)then
				if(settings["displayPersonal"]["value"] == true)then
					centerLabelB:SetBackground(ResourcePath .. "HouseValidated.tga");
				else
					centerLabelB:SetBackground(ResourcePath .. "House_undefined.tga");
					buttonDefineHouseLocationPersonal:SetMouseVisible(false);
					settings["personalHouseMap"]["value"] = 0;
					settings["displayPersonal"]["value"] = false;
				end
			else
				if(settings["displayPersonal"]["value"] == true)then
					centerLabelB:SetBackground(ResourcePath .. "House.tga");
				else
					centerLabelB:SetBackground(ResourcePath .. "House_undefined.tga");
					buttonDefineHouseLocationPersonal:SetMouseVisible(false);
					settings["personalHouseMap"]["value"] = 0;
					settings["displayPersonal"]["value"] = false;
				end
			end

			personalButtonLabel = Turbine.UI.Extensions.SimpleWindow();
			personalButtonLabel:SetParent( OptionsWindow );
			personalButtonLabel:SetPosition(windowWidth - 10 , 335);
			personalButtonLabel:SetSize( 180, 30 );
			personalButtonLabel:SetZOrder(10000);
			personalButtonLabel:SetVisible(false);
			personalButtonLabel:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

			centerLabelBLabel = Turbine.UI.Label();
			centerLabelBLabel:SetParent(personalButtonLabel);
			centerLabelBLabel:SetPosition( 2, 2 );
			centerLabelBLabel:SetSize( 176, 26  );
			centerLabelBLabel:SetText( Strings.PluginLabel1 );
			centerLabelBLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			centerLabelBLabel:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );
			centerLabelBLabel:SetZOrder(-1);



			checkBoxConfrerie = Turbine.UI.Lotro.CheckBox();
			checkBoxConfrerie:SetParent( OptionsWindow );
			checkBoxConfrerie:SetSize(200, 20); 
			checkBoxConfrerie:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxConfrerie:SetText(Strings.PluginOption6);
			checkBoxConfrerie:SetPosition(90, 370);
			checkBoxConfrerie:SetVisible(true);
			if(settings["displayConfrerie"]["value"] == true)then
				checkBoxConfrerie:SetChecked(true);
			else
				checkBoxConfrerie:SetChecked(false);
			end
			checkBoxConfrerie:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
			if (settings["keepShortcuts"]["value"] == true) then
				checkBoxConfrerie:SetEnabled(false);
			else
				checkBoxConfrerie:SetEnabled(true);
			end


			buttonDefineHouseLocationPersonal2 = Turbine.UI.Extensions.SimpleWindow();
			buttonDefineHouseLocationPersonal2:SetParent( OptionsWindow );
			buttonDefineHouseLocationPersonal2:SetPosition(windowWidth - 40, 370);
			buttonDefineHouseLocationPersonal2:SetSize( 20, 20 );
			buttonDefineHouseLocationPersonal2:SetVisible(true);

			centerLabelB2 = Turbine.UI.Label();
			centerLabelB2:SetParent(buttonDefineHouseLocationPersonal2);
			centerLabelB2:SetPosition( 0, 0 );
			centerLabelB2:SetSize( 20, 20  );
			centerLabelB2:SetZOrder(-1);
			centerLabelB2:SetMouseVisible(false);

			if(settings["confrerieHouseMap"]["value"] ~= 0)then
				if(settings["displayConfrerie"]["value"] == true)then
					centerLabelB2:SetBackground(ResourcePath .. "HouseValidated.tga");
				else
					centerLabelB2:SetBackground(ResourcePath .. "House_undefined.tga");
					buttonDefineHouseLocationPersonal2:SetMouseVisible(false);
					settings["confrerieHouseMap"]["value"] = 0;
					settings["displayConfrerie"]["value"] = false;
				end
			else
				if(settings["displayConfrerie"]["value"] == true)then
					centerLabelB2:SetBackground(ResourcePath .. "House.tga");
				else
					centerLabelB2:SetBackground(ResourcePath .. "House_undefined.tga");
					buttonDefineHouseLocationPersonal2:SetMouseVisible(false);
					settings["confrerieHouseMap"]["value"] = 0;
					settings["displayConfrerie"]["value"] = false;
				end
			end

			personalButtonLabel2 = Turbine.UI.Extensions.SimpleWindow();
			personalButtonLabel2:SetParent( OptionsWindow );
			personalButtonLabel2:SetPosition(windowWidth - 10 , 365);
			personalButtonLabel2:SetSize( 180, 30 );
			personalButtonLabel2:SetZOrder(10000);
			personalButtonLabel2:SetVisible(false);
			personalButtonLabel2:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

			centerLabelBLabel2 = Turbine.UI.Label();
			centerLabelBLabel2:SetParent(personalButtonLabel2);
			centerLabelBLabel2:SetPosition( 2, 2 );
			centerLabelBLabel2:SetSize( 176, 26  );
			centerLabelBLabel2:SetText( Strings.PluginLabel2 );
			centerLabelBLabel2:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			centerLabelBLabel2:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );
			centerLabelBLabel2:SetZOrder(-1);

			checkBoxConfrerieFriend = Turbine.UI.Lotro.CheckBox();
			checkBoxConfrerieFriend:SetParent( OptionsWindow );
			checkBoxConfrerieFriend:SetSize(280, 20); 
			checkBoxConfrerieFriend:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxConfrerieFriend:SetText(Strings.PluginOption11);
			checkBoxConfrerieFriend:SetPosition(90, 395);
			checkBoxConfrerieFriend:SetVisible(true);
			if(settings["displayConfrerieFriend"]["value"] == true)then
				checkBoxConfrerieFriend:SetChecked(true);
			else
				checkBoxConfrerieFriend:SetChecked(false);
			end
			checkBoxConfrerieFriend:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
			if (settings["keepShortcuts"]["value"] == true) then
				checkBoxConfrerieFriend:SetEnabled(false);
			else
				checkBoxConfrerieFriend:SetEnabled(true);
			end



			buttonDefineHouseLocationPersonal3 = Turbine.UI.Extensions.SimpleWindow();
			buttonDefineHouseLocationPersonal3:SetParent( OptionsWindow );
			buttonDefineHouseLocationPersonal3:SetPosition(windowWidth - 40, 395);
			buttonDefineHouseLocationPersonal3:SetSize( 20, 20 );
			buttonDefineHouseLocationPersonal3:SetVisible(true);

			centerLabelB3 = Turbine.UI.Label();
			centerLabelB3:SetParent(buttonDefineHouseLocationPersonal3);
			centerLabelB3:SetPosition( 0, 0 );
			centerLabelB3:SetSize( 20, 20  );
			centerLabelB3:SetZOrder(-1);
			centerLabelB3:SetMouseVisible(false);

			if(settings["confrerieFriendHouseMap"]["value"] ~= 0)then
				if(settings["displayConfrerieFriend"]["value"] == true)then
					centerLabelB3:SetBackground(ResourcePath .. "HouseValidated.tga");
				else
					centerLabelB3:SetBackground(ResourcePath .. "House_undefined.tga");
					buttonDefineHouseLocationPersonal3:SetMouseVisible(false);
					settings["confrerieFriendHouseMap"]["value"] = 0;
					settings["displayConfrerieFriend"]["value"] = false;
				end
			else
				if(settings["displayConfrerieFriend"]["value"] == true)then
					centerLabelB3:SetBackground(ResourcePath .. "House.tga");
				else
					centerLabelB3:SetBackground(ResourcePath .. "House_undefined.tga");
					buttonDefineHouseLocationPersonal3:SetMouseVisible(false);
					settings["confrerieFriendHouseMap"]["value"] = 0;
					settings["displayConfrerieFriend"]["value"] = false;
				end
			end

			personalButtonLabel3 = Turbine.UI.Extensions.SimpleWindow();
			personalButtonLabel3:SetParent( OptionsWindow );
			personalButtonLabel3:SetPosition(windowWidth - 10 , 390);
			personalButtonLabel3:SetSize( 180, 30 );
			personalButtonLabel3:SetZOrder(10000);
			personalButtonLabel3:SetVisible(false);
			personalButtonLabel3:SetBackground(ResourcePath .. "/Cadre_180_30.tga");
			

			centerLabelBLabel3 = Turbine.UI.Label();
			centerLabelBLabel3:SetParent(personalButtonLabel3);
			centerLabelBLabel3:SetPosition( 2, 2 );
			centerLabelBLabel3:SetSize( 176, 26  );
			centerLabelBLabel3:SetText( Strings.PluginLabel3 );
			centerLabelBLabel3:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			centerLabelBLabel3:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );
			centerLabelBLabel3:SetZOrder(-1);

			checkBoxPremium = Turbine.UI.Lotro.CheckBox();
			checkBoxPremium:SetParent( OptionsWindow );
			checkBoxPremium:SetSize(200, 20); 
			checkBoxPremium:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxPremium:SetText(Strings.PluginOption7);
			checkBoxPremium:SetPosition(90, 420);
			checkBoxPremium:SetVisible(true);
			if(settings["displayPremium"]["value"] == true)then
				checkBoxPremium:SetChecked(true);
			else
				checkBoxPremium:SetChecked(false);
			end
			checkBoxPremium:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
			if (settings["keepShortcuts"]["value"] == true) then
				checkBoxPremium:SetEnabled(false);
			else
				checkBoxPremium:SetEnabled(true);
			end

			buttonDefineHouseLocationPersonal4 = Turbine.UI.Extensions.SimpleWindow();
			buttonDefineHouseLocationPersonal4:SetParent( OptionsWindow );
			buttonDefineHouseLocationPersonal4:SetPosition(windowWidth - 40, 420);
			buttonDefineHouseLocationPersonal4:SetSize( 20, 20 );
			buttonDefineHouseLocationPersonal4:SetVisible(true);

			centerLabelB4 = Turbine.UI.Label();
			centerLabelB4:SetParent(buttonDefineHouseLocationPersonal4);
			centerLabelB4:SetPosition( 0, 0 );
			centerLabelB4:SetSize( 20, 20  );
			centerLabelB4:SetZOrder(-1);
			centerLabelB4:SetMouseVisible(false);

			if(settings["premiumHouseMap"]["value"] ~= 0)then
				if(settings["displayPremium"]["value"] == true)then
					centerLabelB4:SetBackground(ResourcePath .. "HouseValidated.tga");
				else
					centerLabelB4:SetBackground(ResourcePath .. "House_undefined.tga");
					buttonDefineHouseLocationPersonal4:SetMouseVisible(false);
					settings["premiumHouseMap"]["value"] = 0;
					settings["displayPremium"]["value"] = false;
				end
			else
				if(settings["displayPremium"]["value"] == true)then
					centerLabelB4:SetBackground(ResourcePath .. "House.tga");
				else
					centerLabelB4:SetBackground(ResourcePath .. "House_undefined.tga");
					buttonDefineHouseLocationPersonal4:SetMouseVisible(false);
					settings["premiumHouseMap"]["value"] = 0;
					settings["displayPremium"]["value"] = false;
				end
			end

			personalButtonLabel4 = Turbine.UI.Extensions.SimpleWindow();
			personalButtonLabel4:SetParent( OptionsWindow );
			personalButtonLabel4:SetPosition(windowWidth - 10 , 415);
			personalButtonLabel4:SetSize( 180, 30 );
			personalButtonLabel4:SetZOrder(10000);
			personalButtonLabel4:SetVisible(false);
			personalButtonLabel4:SetBackground(ResourcePath .. "/Cadre_180_30.tga");
			

			centerLabelBLabel4 = Turbine.UI.Label();
			centerLabelBLabel4:SetParent(personalButtonLabel4);
			centerLabelBLabel4:SetPosition( 2, 2 );
			centerLabelBLabel4:SetSize( 176, 26  );
			centerLabelBLabel4:SetText( Strings.PluginLabel4 );
			centerLabelBLabel4:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			centerLabelBLabel4:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );
			centerLabelBLabel4:SetZOrder(-1);

			OptionsWindow.Message=Turbine.UI.Label(); 
			OptionsWindow.Message:SetParent(OptionsWindow); 
			OptionsWindow.Message:SetSize(300, 20); 
			OptionsWindow.Message:SetPosition(windowWidth/2 - 150, 470 ); 
			OptionsWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			OptionsWindow.Message:SetText(Strings.PluginOption8); 

			checkBoxReput = Turbine.UI.Lotro.CheckBox();
			checkBoxReput:SetParent( OptionsWindow );
			checkBoxReput:SetSize(200, 20); 
			checkBoxReput:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxReput:SetText(Strings.PluginOption9);
			checkBoxReput:SetPosition(180, 495);
			if(settings["displayReput"]["value"] == true)then
				checkBoxReput:SetChecked(true);
			else
				checkBoxReput:SetChecked(false);
			end
			checkBoxReput:SetVisible(true);
			checkBoxReput:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			checkBoxKeep = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep:SetParent( OptionsWindow );
			checkBoxKeep:SetSize(350, 20); 
			checkBoxKeep:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep:SetText(Strings.PluginOption12);
			checkBoxKeep:SetPosition(windowWidth/2 - 100, 550);
			checkBoxKeep:SetVisible(true);
			if(settings["keepShortcuts"]["value"] == true)then
				checkBoxKeep:SetChecked(true);
			else
				checkBoxKeep:SetChecked(false);
			end
			checkBoxKeep:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			function checkBoxKeep:CheckedChanged()
				if (checkBoxKeep:IsChecked()) then
					settings["keepShortcuts"]["value"] = true;
					checkBoxPersonal:SetEnabled(false);
					checkBoxConfrerie:SetEnabled(false);
					checkBoxConfrerieFriend:SetEnabled(false);
					checkBoxPremium:SetEnabled(false);
				else
					settings["keepShortcuts"]["value"] = false;
					checkBoxPersonal:SetEnabled(true);
					checkBoxConfrerie:SetEnabled(true);
					checkBoxConfrerieFriend:SetEnabled(true);
					checkBoxPremium:SetEnabled(true);
				end
				SaveSettings();
			end

			buttonValider = Turbine.UI.Lotro.GoldButton();
			buttonValider:SetParent( OptionsWindow );
			buttonValider:SetPosition(windowWidth/2 - 125, 580);
			buttonValider:SetSize( 300, 20 );
			buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			buttonValider:SetText( Strings.PluginOption10 );
			buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			buttonValider:SetVisible(true);
			buttonValider:SetMouseVisible(true);

			ButtonLabel = Turbine.UI.Extensions.SimpleWindow();
			ButtonLabel:SetParent( buttonValider );
			ButtonLabel:SetPosition(-55, -windowHeight + 85);
			ButtonLabel:SetSize( 360, windowHeight - 90 );
			ButtonLabel:SetZOrder(10000);
			ButtonLabel:SetVisible(false);
			ButtonLabel:SetBackColor( Turbine.UI.Color( 0.8, 0, 0, 0 ) );

			WarningLabel = Turbine.UI.Extensions.SimpleWindow();
			WarningLabel:SetParent( ButtonLabel );
			WarningLabel:SetPosition(85, 70);
			WarningLabel:SetSize( 200, 200 );
			WarningLabel:SetZOrder(10001);
			WarningLabel:SetBackground("Homeopatix/Voyage/Resources/Warning.tga");
			WarningLabel:SetVisible(true);

			centerLabelBLabel = Turbine.UI.Label();
			centerLabelBLabel:SetParent(ButtonLabel);
			centerLabelBLabel:SetPosition( 0, 290 );
			centerLabelBLabel:SetSize( 380, 30  );
			centerLabelBLabel:SetForeColor(Turbine.UI.Color.Red);
			centerLabelBLabel:SetText( Strings.PluginOptionAlert );
			centerLabelBLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			centerLabelBLabel:SetZOrder(ButtonLabel:GetZOrder()-1);

		------------------------------------------------------------------------------------------
		-- monsterPlay option panel --
		------------------------------------------------------------------------------------------
		else
			checkBoxKeep = Turbine.UI.Lotro.CheckBox();
			checkBoxKeep:SetParent( OptionsWindow );
			checkBoxKeep:SetSize(350, 20); 
			checkBoxKeep:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBoxKeep:SetText(Strings.PluginOption12);
			checkBoxKeep:SetPosition(windowWidth/2 - 100, 230);
			checkBoxKeep:SetVisible(true);
			if(settings["keepShortcuts"]["value"] == true)then
				checkBoxKeep:SetChecked(true);
			else
				checkBoxKeep:SetChecked(false);
			end
			checkBoxKeep:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));

			function checkBoxKeep:CheckedChanged()
				if (checkBoxKeep:IsChecked()) then
					settings["keepShortcuts"]["value"] = true;
				else
					settings["keepShortcuts"]["value"] = false;
				end
				SaveSettings();
			end

			buttonValider = Turbine.UI.Lotro.GoldButton();
			buttonValider:SetParent( OptionsWindow );
			buttonValider:SetPosition(windowWidth/2 - 125, 260);
			buttonValider:SetSize( 300, 20 );
			buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			buttonValider:SetText( Strings.PluginOption10 );
			buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			buttonValider:SetVisible(true);
			buttonValider:SetMouseVisible(true);

			ButtonLabel = Turbine.UI.Extensions.SimpleWindow();
			ButtonLabel:SetParent( buttonValider );
			ButtonLabel:SetPosition(-55, -windowHeight + 75);
			ButtonLabel:SetSize( 360, windowHeight - 80 );
			ButtonLabel:SetZOrder(10000);
			ButtonLabel:SetVisible(false);
			ButtonLabel:SetBackColor( Turbine.UI.Color( 0.8, 0, 0, 0 ) );

			WarningLabel = Turbine.UI.Extensions.SimpleWindow();
			WarningLabel:SetParent( ButtonLabel );
			WarningLabel:SetPosition(85, 5);
			WarningLabel:SetSize( 200, 200 );
			WarningLabel:SetZOrder(10001);
			WarningLabel:SetBackground("Homeopatix/Voyage/Resources/Warning.tga");
			WarningLabel:SetVisible(true);

			centerLabelBLabel = Turbine.UI.Label();
			centerLabelBLabel:SetParent(ButtonLabel);
			centerLabelBLabel:SetPosition( 0, 195 );
			centerLabelBLabel:SetSize( 380, 30  );
			centerLabelBLabel:SetForeColor(Turbine.UI.Color.Red);
			centerLabelBLabel:SetText( Strings.PluginOptionAlert );
			centerLabelBLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			centerLabelBLabel:SetZOrder(ButtonLabel:GetZOrder()-1);

		end

		buttonDefineHelp = Turbine.UI.Extensions.SimpleWindow();
		buttonDefineHelp:SetParent( OptionsWindow );
		buttonDefineHelp:SetPosition(windowWidth - 380, 580);
		buttonDefineHelp:SetSize( 20, 20 );
		buttonDefineHelp:SetVisible(true);
		buttonDefineHelp:SetMouseVisible(true);

		centerLabelHelp = Turbine.UI.Label();
		centerLabelHelp:SetParent(buttonDefineHelp);
		centerLabelHelp:SetPosition( 0, 0 );
		centerLabelHelp:SetSize( 20, 20  );
		centerLabelHelp:SetBackground(ResourcePath .. "Help.tga");
		centerLabelHelp:SetZOrder(-1);
		centerLabelHelp:SetMouseVisible(false);

		helpButtonLabel = Turbine.UI.Extensions.SimpleWindow();
		helpButtonLabel:SetParent( OptionsWindow );
		helpButtonLabel:SetPosition (windowWidth - 360 , 575);
		helpButtonLabel:SetSize( 180, 30 );
		helpButtonLabel:SetZOrder(10000);
		helpButtonLabel:SetVisible(false);
		helpButtonLabel:SetBackground(ResourcePath .. "/Cadre_180_30.tga");
		

		centerLabelBLabel4 = Turbine.UI.Label();
		centerLabelBLabel4:SetParent(helpButtonLabel);
		centerLabelBLabel4:SetPosition( 2, 2 );
		centerLabelBLabel4:SetSize( 176, 26  );
		centerLabelBLabel4:SetText( Strings.PluginLabel5 );
		centerLabelBLabel4:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		centerLabelBLabel4:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );
		centerLabelBLabel4:SetZOrder(-1);

		if(playerAlignement == 1)then 
			DefineHouseLocation();
			SetTheMouseEnterForOptions();
			SetTheMouseEnterForButtonValider();
			ButtonTeleport();
			SetTheMouseEnterForTeleport();
		end

		ButtonHelp();
		ValidateChanges();
end
function CreateButtonTP(positionTP, value, labeltext)
		buttonTP[value] = Turbine.UI.Extensions.SimpleWindow();
		buttonTP[value]:SetParent( OptionsWindow );
		buttonTP[value]:SetPosition(positionTP , 280);
		buttonTP[value]:SetSize( 20, 20 );
		buttonTP[value]:SetVisible(true);
		buttonTP[value]:SetMouseVisible(true);

		centerLabelTP[value] = Turbine.UI.Label();
		centerLabelTP[value]:SetParent(buttonTP[value]);
		centerLabelTP[value]:SetPosition( 0, 0 );
		centerLabelTP[value]:SetSize( 20, 20  );

		if(settings["Teleport_" .. value]["value"] ~= 0)then
			if(settings["teleport"]["nbr"] >= value)then
				centerLabelTP[value]:SetBackground(ResourcePath .. "Teleport_validate.tga");
			else
				centerLabelTP[value]:SetBackground(ResourcePath .. "Teleport_undefined.tga");
				buttonTP[value]:SetMouseVisible(false);
				settings["Teleport_" .. value]["value"] = 0;
			end
		else
			if(settings["teleport"]["nbr"] >= value)then
				centerLabelTP[value]:SetBackground(ResourcePath .. "Teleport.tga");
			else
				centerLabelTP[value]:SetBackground(ResourcePath .. "Teleport_undefined.tga");
				buttonTP[value]:SetMouseVisible(false);
				settings["Teleport_" .. value]["value"] = 0;
			end
		end

		centerLabelTP[value]:SetZOrder(-1);
		--centerLabelTP[value]:SetText(tostring(value));
		centerLabelTP[value]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		centerLabelTP[value]:SetMouseVisible(false);

		TPButtonLabel[value] = Turbine.UI.Extensions.SimpleWindow();
		TPButtonLabel[value]:SetParent( OptionsWindow );
		TPButtonLabel[value]:SetPosition(positionTP + 20 , 280 - 20);
		TPButtonLabel[value]:SetSize( 180, 30 );
		TPButtonLabel[value]:SetZOrder(10000);
		TPButtonLabel[value]:SetVisible(false);
		TPButtonLabel[value]:SetBackground(ResourcePath .. "/Cadre_180_30.tga");

		centerLabelTP[value] = Turbine.UI.Label();
		centerLabelTP[value]:SetParent(TPButtonLabel[value]);
		centerLabelTP[value]:SetPosition( 2, 2 );
		centerLabelTP[value]:SetSize( 176, 26  );
		centerLabelTP[value]:SetText( labeltext .. " " .. value);
		centerLabelTP[value]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		centerLabelTP[value]:SetBackColor( Turbine.UI.Color( .9, .1, .4, .9) );
		centerLabelTP[value]:SetZOrder(-1);
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------
function DefineHouseLocation()
	buttonDefineHouseLocationPersonal.MouseClick = function(sender, args)
			GenerateOptionsWindowHousing("personal");
			OptionsWindow:SetVisible(false);
			OptionsWindowHousing:SetVisible(true);
	end
	buttonDefineHouseLocationPersonal2.MouseClick = function(sender, args)
			GenerateOptionsWindowHousing("confrerie");
			OptionsWindow:SetVisible(false);
			OptionsWindowHousing:SetVisible(true);
	end
	buttonDefineHouseLocationPersonal3.MouseClick = function(sender, args)
			GenerateOptionsWindowHousing("confrerieFriend");
			OptionsWindow:SetVisible(false);
			OptionsWindowHousing:SetVisible(true);
	end
	buttonDefineHouseLocationPersonal4.MouseClick = function(sender, args)
			GenerateOptionsWindowHousing("premium");
			OptionsWindow:SetVisible(false);
			OptionsWindowHousing:SetVisible(true);
	end
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------
function ValidateChanges()
	buttonValider.MouseClick = function(sender, args)
			local tmpLine = 0;
			tmpLine = tonumber(textBoxLines:GetText());

			if(tmpLine < 1 or tmpLine > 10)then
				tmpLine = 10;
				textBoxLines:SetText(tmpLine);
				settings["nbrLine"]["nbr"] =  tmpLine;
			else
				settings["nbrLine"]["nbr"] =  tmpLine;
			end

			local tmpSlots = 0;
			tmpSlots = tonumber(textBoxSlots:GetText());

			if(tmpSlots > 20 or tmpSlots < 3 or (tmpSlots*settings["nbrLine"]["nbr"]) > 100)then
				tmpSlots = 10;
				textBoxSlots:SetText(tmpSlots);
				settings["nbrSlots"]["nbr"] = tmpSlots;
			else
				settings["nbrSlots"]["nbr"] = tmpSlots;
			end

			if (checkBoxKeep:IsChecked()) then
				settings["keepShortcuts"]["value"] = true;
			else
				settings["keepShortcuts"]["value"] = false;
			end
			------------------------------------------------------------------------------------------
			-- free people option panel --
			------------------------------------------------------------------------------------------
			if(playerAlignement == 1)then -- free people option panel
				local tmpTeleport = 0;
				tmpTeleport = tonumber(textBoxTeleport:GetText());

				if(tmpTeleport < 0 or tmpTeleport > 11)then
					tmpTeleport = 6;
					textBoxTeleport:SetText(tmpTeleport);
					settings["teleport"]["nbr"] = tmpTeleport;
				else
					settings["teleport"]["nbr"] = tmpTeleport;
				end
				--Turbine.Shell.WriteLine(rgb["error"] .. Strings.PluginOptionAlert .. rgb["clear"]);
				------------------------------------------------------------------------------------------
				-- checking the checkbox --
				------------------------------------------------------------------------------------------
				local valHomeTemp = 0;

				if (checkBoxPersonal:IsChecked()) then
					settings["displayPersonal"]["value"] = true;
					valHomeTemp = valHomeTemp + 1;
				else
					settings["displayPersonal"]["value"] = false;
				end

				if (checkBoxConfrerie:IsChecked()) then
					settings["displayConfrerie"]["value"] = true;
					valHomeTemp = valHomeTemp + 1;
				else
					settings["displayConfrerie"]["value"] = false;
				end

				if (checkBoxConfrerieFriend:IsChecked()) then
					settings["displayConfrerieFriend"]["value"] = true;
					valHomeTemp = valHomeTemp + 1;
				else
					settings["displayConfrerieFriend"]["value"] = false;
				end

				if (checkBoxPremium:IsChecked()) then
					settings["displayPremium"]["value"] = true;
					valHomeTemp = valHomeTemp + 1;
				else
					settings["displayPremium"]["value"] = false;
				end

				if (checkBoxReput:IsChecked()) then
					settings["displayReput"]["value"] = true;
				else
					settings["displayReput"]["value"] = false;
				end

				settings["travelHome"]["nbr"] = valHomeTemp;
			end

			OptionsWindow:SetVisible(false);
			settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = false;

			if(settings["keepShortcuts"]["value"] == false)then
				ClearWindow();
			end
			SaveSettings();
			UpdateWindow();
			UpdateOptionsWindow();
			ClosingTheOptionsWindow();
		end
end

function SetTheMouseEnterForTeleport()
	for i=1, 11 do
		buttonTP[i].MouseEnter = function()
			TPButtonLabel[i]:SetVisible(true);
		end
		buttonTP[i].MouseLeave = function()
			TPButtonLabel[i]:SetVisible(false);
		end
	end
end

------------------------------------------------------------------------------------------
-- Closing window handler
------------------------------------------------------------------------------------------
function ClosingTheOptionsWindow()
	function OptionsWindow:Closing(sender, args)
		settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = false;
		SaveSettings();
	end
end
------------------------------------------------------------------------------------------
-- updating the options window
------------------------------------------------------------------------------------------
function UpdateOptionsWindow()
	GenerateOptionsWindow();
	EscapeKeyPressed();
	ClosingTheWindow();
	ClosingTheOptionsWindow();
end
------------------------------------------------------------------------------------------
-- mouseHover handling
------------------------------------------------------------------------------------------
function SetTheMouseEnterForButtonValider()
	buttonValider.MouseEnter = function()
		if(settings["keepShortcuts"]["value"] == false)then
			ButtonLabel:SetVisible(true);
		end
	end

	buttonValider.MouseLeave = function()
		ButtonLabel:SetVisible(false);
	end
end

function ButtonHelp()
	buttonDefineHelp.MouseClick = function(sender, args)
		------------------------------------------------------------------------------------------
		-- checking the checkbox --
		------------------------------------------------------------------------------------------
		if(playerAlignement == 1)then 
			 GenerateHelpWindow();
			 HelpWindow:SetVisible(true);
		end
	end
end


function ButtonTeleport()
	for i=1, 11 do
		buttonTP[i].MouseClick = function(sender, args)
			settings["Teleport_" .. i]["value"] = 0;
			------------------------------------------------------------------------------------------
			-- checking the checkbox --
			------------------------------------------------------------------------------------------
			if(playerAlignement == 1)then 
				 GenerateOptionsWindowRegion(i);
				 OptionsWindowRegion:SetVisible(true);
				 OptionsWindow:SetVisible(false);
			end
		end
	end
end