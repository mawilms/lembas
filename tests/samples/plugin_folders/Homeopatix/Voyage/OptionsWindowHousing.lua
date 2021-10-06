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

if(playerAlignement == 1)then
	windowWidth = 400;
	windowHeight = 300;
end
------------------------------------------------------------------------------------------
-- create the options window
------------------------------------------------------------------------------------------
function GenerateOptionsWindowHousing(value)
		OptionsWindowHousing=Turbine.UI.Lotro.GoldWindow(); 
		OptionsWindowHousing:SetSize(windowWidth, windowHeight); 
		OptionsWindowHousing:SetText(Strings.PluginHouseText); 

		OptionsWindowHousing.Message=Turbine.UI.Label(); 
		OptionsWindowHousing.Message:SetParent(OptionsWindowHousing); 
		OptionsWindowHousing.Message:SetSize(150,10); 
		OptionsWindowHousing.Message:SetPosition(windowWidth/2 - 75, windowHeight - 17 ); 
		OptionsWindowHousing.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		OptionsWindowHousing.Message:SetText(Strings.PluginText); 

		OptionsWindowHousing:SetZOrder(1);
		OptionsWindowHousing:SetWantsKeyEvents(true);
		OptionsWindowHousing:SetVisible(false);

		local offset = math.floor(OptionsWindowHousing:GetWidth() / 4);

		OptionsWindowHousing:SetPosition((Turbine.UI.Display:GetWidth()-OptionsWindowHousing:GetWidth())/2,(Turbine.UI.Display:GetHeight()-OptionsWindowHousing:GetHeight())/2);
		------------------------------------------------------------------------------------------
		-- center window
		------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------
		-- -- personal house location --
		------------------------------------------------------------------------------------------

			OptionsWindowHousing.Message=Turbine.UI.Label(); 
			OptionsWindowHousing.Message:SetParent(OptionsWindowHousing); 
			OptionsWindowHousing.Message:SetSize(300, 20); 
			OptionsWindowHousing.Message:SetPosition(windowWidth/2 - 150, 40 ); 
			OptionsWindowHousing.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
			OptionsWindowHousing.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			 
			if(value == "personal")then
				OptionsWindowHousing.Message:SetText(Strings.PluginHousePersonal);
			end
			if(value == "confrerie")then
				OptionsWindowHousing.Message:SetText(Strings.PluginHouseConfrerie);
			end
			if(value == "confrerieFriend")then
				OptionsWindowHousing.Message:SetText(Strings.PluginHouseConfrerieFriend);
			end
			if(value == "premium")then
				OptionsWindowHousing.Message:SetText(Strings.PluginHousePremium);
			end

			checkBox1 = Turbine.UI.Lotro.CheckBox();
			checkBox1:SetParent( OptionsWindowHousing );
			checkBox1:SetSize(200, 20); 
			checkBox1:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBox1:SetText(Strings.PluginHouse1);
			checkBox1:SetPosition(120, 65);
			checkBox1:SetVisible(true);
			checkBox1:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
			if(value == "personal")then
				if(settings["personalHouseMap"]["value"] == 1)then
					checkBox1:SetChecked(true);
				else
					checkBox1:SetChecked(false);
				end
			end
			if(value == "confrerie")then
				if(settings["confrerieHouseMap"]["value"] == 1)then
					checkBox1:SetChecked(true);
				else
					checkBox1:SetChecked(false);
				end
			end
			if(value == "confrerieFriend")then
				if(settings["confrerieFriendHouseMap"]["value"] == 1)then
					checkBox1:SetChecked(true);
				else
					checkBox1:SetChecked(false);
				end
			end
			if(value == "premium")then
				if(settings["premiumHouseMap"]["value"] == 1)then
					checkBox1:SetChecked(true);
				else
					checkBox1:SetChecked(false);
				end
			end

			checkBox2 = Turbine.UI.Lotro.CheckBox();
			checkBox2:SetParent( OptionsWindowHousing );
			checkBox2:SetSize(200, 20); 
			checkBox2:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBox2:SetText(Strings.PluginHouse2);
			checkBox2:SetPosition(120, 90);
			checkBox2:SetVisible(true);
			checkBox2:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
			if(value == "personal")then
				if(settings["personalHouseMap"]["value"] == 2)then
					checkBox2:SetChecked(true);
				else
					checkBox2:SetChecked(false);
				end
			end
			if(value == "confrerie")then
				if(settings["confrerieHouseMap"]["value"] == 2)then
					checkBox2:SetChecked(true);
				else
					checkBox2:SetChecked(false);
				end
			end
			if(value == "confrerieFriend")then
				if(settings["confrerieFriendHouseMap"]["value"] == 2)then
					checkBox2:SetChecked(true);
				else
					checkBox2:SetChecked(false);
				end
			end
			if(value == "premium")then
				if(settings["premiumHouseMap"]["value"] == 2)then
					checkBox2:SetChecked(true);
				else
					checkBox2:SetChecked(false);
				end
			end

			checkBox3 = Turbine.UI.Lotro.CheckBox();
			checkBox3:SetParent( OptionsWindowHousing );
			checkBox3:SetSize(280, 20); 
			checkBox3:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBox3:SetText(Strings.PluginHouse3);
			checkBox3:SetPosition(120, 115);
			checkBox3:SetVisible(true);
			checkBox3:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
			if(value == "personal")then
				if(settings["personalHouseMap"]["value"] == 3)then
					checkBox3:SetChecked(true);
				else
					checkBox3:SetChecked(false);
				end
			end
			if(value == "confrerie")then
				if(settings["confrerieHouseMap"]["value"] == 3)then
					checkBox3:SetChecked(true);
				else
					checkBox3:SetChecked(false);
				end
			end
			if(value == "confrerieFriend")then
				if(settings["confrerieFriendHouseMap"]["value"] == 3)then
					checkBox3:SetChecked(true);
				else
					checkBox3:SetChecked(false);
				end
			end
			if(value == "premium")then
				if(settings["premiumHouseMap"]["value"] == 3)then
					checkBox3:SetChecked(true);
				else
					checkBox3:SetChecked(false);
				end
			end

			checkBox4 = Turbine.UI.Lotro.CheckBox();
			checkBox4:SetParent( OptionsWindowHousing );
			checkBox4:SetSize(200, 20); 
			checkBox4:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBox4:SetText(Strings.PluginHouse4);
			checkBox4:SetPosition(120, 140);
			checkBox4:SetVisible(true);
			checkBox4:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
			if(value == "personal")then
				if(settings["personalHouseMap"]["value"] == 4)then
					checkBox4:SetChecked(true);
				else
					checkBox4:SetChecked(false);
				end
			end
			if(value == "confrerie")then
				if(settings["confrerieHouseMap"]["value"] == 4)then
					checkBox4:SetChecked(true);
				else
					checkBox4:SetChecked(false);
				end
			end
			if(value == "confrerieFriend")then
				if(settings["confrerieFriendHouseMap"]["value"] == 4)then
					checkBox4:SetChecked(true);
				else
					checkBox4:SetChecked(false);
				end
			end
			if(value == "premium")then
				if(settings["premiumHouseMap"]["value"] == 4)then
					checkBox4:SetChecked(true);
				else
					checkBox4:SetChecked(false);
				end
			end

			checkBox5 = Turbine.UI.Lotro.CheckBox();
			checkBox5:SetParent( OptionsWindowHousing );
			checkBox5:SetSize(200, 20); 
			checkBox5:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBox5:SetText(Strings.PluginHouse5);
			checkBox5:SetPosition(120, 165);
			checkBox5:SetVisible(true);
			checkBox5:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
			if(value == "personal")then
				if(settings["personalHouseMap"]["value"] == 5)then
					checkBox5:SetChecked(true);
				else
					checkBox5:SetChecked(false);
				end
			end
			if(value == "confrerie")then
				if(settings["confrerieHouseMap"]["value"] == 5)then
					checkBox5:SetChecked(true);
				else
					checkBox5:SetChecked(false);
				end
			end
			if(value == "confrerieFriend")then
				if(settings["confrerieFriendHouseMap"]["value"] == 5)then
					checkBox5:SetChecked(true);
				else
					checkBox5:SetChecked(false);
				end
			end
			if(value == "premium")then
				if(settings["premiumHouseMap"]["value"] == 5)then
					checkBox5:SetChecked(true);
				else
					checkBox5:SetChecked(false);
				end
			end

			checkBox6 = Turbine.UI.Lotro.CheckBox();
			checkBox6:SetParent( OptionsWindowHousing );
			checkBox6:SetSize(200, 20); 
			checkBox6:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBox6:SetText(Strings.PluginHouse6);
			checkBox6:SetPosition(120, 190);
			checkBox6:SetVisible(true);
			checkBox6:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
			if(value == "personal")then
				if(settings["personalHouseMap"]["value"] == 6)then
					checkBox6:SetChecked(true);
				else
					checkBox6:SetChecked(false);
				end
			end
			if(value == "confrerie")then
				if(settings["confrerieHouseMap"]["value"] == 6)then
					checkBox6:SetChecked(true);
				else
					checkBox6:SetChecked(false);
				end
			end
			if(value == "confrerieFriend")then
				if(settings["confrerieFriendHouseMap"]["value"] == 6)then
					checkBox6:SetChecked(true);
				else
					checkBox6:SetChecked(false);
				end
			end
			if(value == "premium")then
				if(settings["premiumHouseMap"]["value"] == 6)then
					checkBox6:SetChecked(true);
				else
					checkBox6:SetChecked(false);
				end
			end

			checkBox7 = Turbine.UI.Lotro.CheckBox();
			checkBox7:SetParent( OptionsWindowHousing );
			checkBox7:SetSize(200, 20); 
			checkBox7:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			checkBox7:SetText(Strings.PluginHouse7);
			checkBox7:SetPosition(120, 215);
			checkBox7:SetVisible(true);
			checkBox7:SetForeColor( Turbine.UI.Color( 0.7, 0.6, 0.2 ));
			if(value == "personal")then
				if(settings["personalHouseMap"]["value"] == 7)then
					checkBox7:SetChecked(true);
				else
					checkBox7:SetChecked(false);
				end
			end
			if(value == "confrerie")then
				if(settings["confrerieHouseMap"]["value"] == 7)then
					checkBox7:SetChecked(true);
				else
					checkBox7:SetChecked(false);
				end
			end
			if(value == "confrerieFriend")then
				if(settings["confrerieFriendHouseMap"]["value"] == 7)then
					checkBox7:SetChecked(true);
				else
					checkBox7:SetChecked(false);
				end
			end
			if(value == "premium")then
				if(settings["premiumHouseMap"]["value"] == 7)then
					checkBox7:SetChecked(true);
				else
					checkBox7:SetChecked(false);
				end
			end

			buttonValiderHousing = Turbine.UI.Lotro.GoldButton();
			buttonValiderHousing:SetParent( OptionsWindowHousing );
			buttonValiderHousing:SetPosition(windowWidth/2 - 125, 260);
			buttonValiderHousing:SetSize( 300, 20 );
			buttonValiderHousing:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			buttonValiderHousing:SetText( Strings.PluginOption10 );
			buttonValiderHousing:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			buttonValiderHousing:SetVisible(true);
			buttonValiderHousing:SetMouseVisible(true);

			ValidateChangesHousing(value);
			CheckerTester();
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------
function ValidateChangesHousing(value)
		buttonValiderHousing.MouseClick = function(sender, args)
				------------------------------------------------------------------------------------------
				-- checking the checkbox --
				------------------------------------------------------------------------------------------
				if(value == "personal")then
					if (checkBox1:IsChecked()) then
						settings["personalHouseMap"]["value"] = 1;
					elseif (checkBox2:IsChecked()) then
						settings["personalHouseMap"]["value"] = 2;
					elseif (checkBox3:IsChecked()) then
						settings["personalHouseMap"]["value"] = 3;
					elseif (checkBox4:IsChecked()) then
						settings["personalHouseMap"]["value"] = 4;
					elseif (checkBox5:IsChecked()) then
						settings["personalHouseMap"]["value"] = 5;
					elseif (checkBox6:IsChecked()) then
						settings["personalHouseMap"]["value"] = 6;
					elseif (checkBox7:IsChecked()) then
						settings["personalHouseMap"]["value"] = 7;
					else
						settings["personalHouseMap"]["value"] = 0;
					end
				end
				if(value == "confrerie")then
					if (checkBox1:IsChecked()) then
						settings["confrerieHouseMap"]["value"] = 1;
					elseif (checkBox2:IsChecked()) then
						settings["confrerieHouseMap"]["value"] = 2;
					elseif (checkBox3:IsChecked()) then
						settings["confrerieHouseMap"]["value"] = 3;
					elseif (checkBox4:IsChecked()) then
						settings["confrerieHouseMap"]["value"] = 4;
					elseif (checkBox5:IsChecked()) then
						settings["confrerieHouseMap"]["value"] = 5;
					elseif (checkBox6:IsChecked()) then
						settings["confrerieHouseMap"]["value"] = 6;
					elseif (checkBox7:IsChecked()) then
						settings["confrerieHouseMap"]["value"] = 7;
					else
						settings["confrerieHouseMap"]["value"] = 0;
					end
				end
				if(value == "confrerieFriend")then
					if (checkBox1:IsChecked()) then
						settings["confrerieFriendHouseMap"]["value"] = 1;
					elseif (checkBox2:IsChecked()) then
						settings["confrerieFriendHouseMap"]["value"] = 2;
					elseif (checkBox3:IsChecked()) then
						settings["confrerieFriendHouseMap"]["value"] = 3;
					elseif (checkBox4:IsChecked()) then
						settings["confrerieFriendHouseMap"]["value"] = 4;
					elseif (checkBox5:IsChecked()) then
						settings["confrerieFriendHouseMap"]["value"] = 5;
					elseif (checkBox6:IsChecked()) then
						settings["confrerieFriendHouseMap"]["value"] = 6;
					elseif (checkBox7:IsChecked()) then
						settings["confrerieFriendHouseMap"]["value"] = 7;
					else	
						settings["confrerieFriendHouseMap"]["value"] = 0;
					end
				end
				if(value == "premium")then
					if (checkBox1:IsChecked()) then
						settings["premiumHouseMap"]["value"] = 1;
					elseif (checkBox2:IsChecked()) then
						settings["premiumHouseMap"]["value"] = 2;
					elseif (checkBox3:IsChecked()) then
						settings["premiumHouseMap"]["value"] = 3;
					elseif (checkBox4:IsChecked()) then
						settings["premiumHouseMap"]["value"] = 4;
					elseif (checkBox5:IsChecked()) then
						settings["premiumHouseMap"]["value"] = 5;
					elseif (checkBox6:IsChecked()) then
						settings["premiumHouseMap"]["value"] = 6;
					elseif (checkBox7:IsChecked()) then
						settings["premiumHouseMap"]["value"] = 7;
					else
						settings["premiumHouseMap"]["value"] = 0;
					end
				end

				SaveSettings();
				OptionsWindowHousing:SetVisible(false);
				GenerateOptionsWindow();
				OptionsWindow:SetVisible(true);
				ClosingTheOptionsWindowHousing();
		end
end

------------------------------------------------------------------------------------------
-- Closing window handler
------------------------------------------------------------------------------------------
function ClosingTheOptionsWindowHousing()
	function OptionsWindowHousing:Closing(sender, args)
		GenerateOptionsWindow();
		settings["isOptionsWindowVisible"]["isOptionsWindowVisible"] = true;
		SaveSettings();
	end
end

function CheckerTester()
	function checkBox1:CheckedChanged()
		if(checkBox1:IsChecked())then
			checkBox2:SetChecked(false);
			checkBox3:SetChecked(false);
			checkBox4:SetChecked(false);
			checkBox5:SetChecked(false);
			checkBox6:SetChecked(false);
			checkBox7:SetChecked(false);
		end
	end
	function checkBox2:CheckedChanged()
		if(checkBox2:IsChecked())then
			checkBox1:SetChecked(false);
			checkBox3:SetChecked(false);
			checkBox4:SetChecked(false);
			checkBox5:SetChecked(false);
			checkBox6:SetChecked(false);
			checkBox7:SetChecked(false);
		end
	end
	function checkBox3:CheckedChanged()
		if(checkBox3:IsChecked())then
			checkBox1:SetChecked(false);
			checkBox2:SetChecked(false);
			checkBox4:SetChecked(false);
			checkBox5:SetChecked(false);
			checkBox6:SetChecked(false);
			checkBox7:SetChecked(false);
		end
	end
	function checkBox4:CheckedChanged()
		if(checkBox4:IsChecked())then
			checkBox1:SetChecked(false);
			checkBox2:SetChecked(false);
			checkBox3:SetChecked(false);
			checkBox5:SetChecked(false);
			checkBox6:SetChecked(false);
			checkBox7:SetChecked(false);
		end
	end
	function checkBox5:CheckedChanged()
		if(checkBox5:IsChecked())then
			checkBox1:SetChecked(false);
			checkBox2:SetChecked(false);
			checkBox3:SetChecked(false);
			checkBox4:SetChecked(false);
			checkBox6:SetChecked(false);
			checkBox7:SetChecked(false);
		end
	end
	function checkBox6:CheckedChanged()
		if(checkBox6:IsChecked())then
			checkBox1:SetChecked(false);
			checkBox2:SetChecked(false);
			checkBox3:SetChecked(false);
			checkBox4:SetChecked(false);
			checkBox5:SetChecked(false);
			checkBox7:SetChecked(false);
		end
	end
	function checkBox7:CheckedChanged()
		if(checkBox7:IsChecked())then
			checkBox1:SetChecked(false);
			checkBox2:SetChecked(false);
			checkBox3:SetChecked(false);
			checkBox4:SetChecked(false);
			checkBox5:SetChecked(false);
			checkBox6:SetChecked(false);
		end
	end
end