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
	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
		windowWidth = 400;
		windowHeight = 810;
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
		windowWidth = 400;
		windowHeight = 770;
	elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
		windowWidth = 400;
		windowHeight = 700;
	end
else
	windowWidth = 400;
	windowHeight = 500;
end
------------------------------------------------------------------------------------------
-- create the options window
------------------------------------------------------------------------------------------
function GenerateHelpWindow()
		HelpWindow=Turbine.UI.Lotro.GoldWindow(); 
		HelpWindow:SetSize(windowWidth, windowHeight); 
		HelpWindow:SetText(Strings.PluginTitreHelpWindow); 
		HelpWindow:SetPosition((Turbine.UI.Display:GetWidth()-HelpWindow:GetWidth())/2,(Turbine.UI.Display:GetHeight()-HelpWindow:GetHeight())/2);

		HelpWindow.Message=Turbine.UI.Label(); 
		HelpWindow.Message:SetParent(HelpWindow); 
		HelpWindow.Message:SetSize(150,10); 
		HelpWindow.Message:SetPosition(windowWidth/2 - 75, windowHeight - 17 ); 
		HelpWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
		HelpWindow.Message:SetText(Strings.PluginText); 

		HelpWindow:SetZOrder(10);
		HelpWindow:SetWantsKeyEvents(true);
		HelpWindow:SetVisible(false);
		------------------------------------------------------------------------------------------
		-- center window
		------------------------------------------------------------------------------------------
		------------------------------------------------------------------------------------------
		-- -- personal house location --
		------------------------------------------------------------------------------------------

			HelpWindow.Message=Turbine.UI.Label(); 
			HelpWindow.Message:SetParent(HelpWindow); 
			HelpWindow.Message:SetSize(370, 810); 
			HelpWindow.Message:SetPosition(15, 20 ); 
			HelpWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.TopLeft); 
			HelpWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			HelpWindow.Message:SetText( Strings.PluginHelp1 ..
										Strings.PluginHelp2 ..
										Strings.PluginHelp3 ..
										Strings.PluginHelp4 ..
										Strings.PluginHelp5 ..
										Strings.PluginHelp6 ..
										Strings.PluginHelp7 ..
										Strings.PluginHelp8 ..
										Strings.PluginHelp9 ..
										Strings.PluginHelp10 ..
										Strings.PluginHelp11 ..
										Strings.PluginHelp12 ..
										Strings.PluginHelp13 ..
										Strings.PluginHelp14 ..
										Strings.PluginHelp15 ..
										Strings.PluginHelp16 ..
										Strings.PluginHelp17 ..
										Strings.PluginHelp18 ..
										Strings.PluginHelp19 ..
										Strings.PluginHelp20 ..
										Strings.PluginHelp21 ..
										Strings.PluginHelp22 ..
										Strings.PluginHelp23);
			 
			HelpWindowButton = Turbine.UI.Lotro.GoldButton();
			HelpWindowButton:SetParent( HelpWindow );
			HelpWindowButton:SetPosition(windowWidth/2 - 125, windowHeight - 40);
			HelpWindowButton:SetSize( 300, 20 );
			HelpWindowButton:SetFont(Turbine.UI.Lotro.Font.Verdana16);
			HelpWindowButton:SetText( Strings.PluginButtonHelpWindow );
			HelpWindowButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			HelpWindowButton:SetVisible(true);
			HelpWindowButton:SetMouseVisible(true);

			CloseButtonHelp();
			ClosingTheHelpWindow();
end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------
function CloseButtonHelp()
		HelpWindowButton.MouseClick = function(sender, args)
				------------------------------------------------------------------------------------------
				-- checking the checkbox --
				------------------------------------------------------------------------------------------
				HelpWindow:SetVisible(false);
		end
end

------------------------------------------------------------------------------------------
-- Closing window handler
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Closing window handler
------------------------------------------------------------------------------------------
function ClosingTheHelpWindow()
	function HelpWindow:Closing(sender, args)
		HelpWindow:SetVisible(false);
	end
end