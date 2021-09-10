------------------------------------------------------------------------------------------
-- import librarys
------------------------------------------------------------------------------------------
import "Homeopatix.Animalerie.Librarys"

Turbine.Shell.WriteLine("<rgb=#DAA520>Animalerie</rgb> <rgb=#DDDDDD>".. plugin:GetVersion() .." par Homeo</rgb>")

CreateLocalizationInfo();
LoadSettings();

------------------------------------------------------------------------------------------
-- create the main window
------------------------------------------------------------------------------------------
CreateTheWindow();

------------------------------------------------------------------------------------------
-- set the functions
------------------------------------------------------------------------------------------
SetTheShortCuts();
SetTheDragAndDrop();
SetTheMouseClick();
DeleteTheSHortCuts();

------------------------------------------------------------------------------------------
-- Closing window handler
------------------------------------------------------------------------------------------
ClosingWindow();

------------------------------------------------------------------------------------------
-- handle minimizeIcon
------------------------------------------------------------------------------------------
if(settings.isWindowVisible == "true") then
	MainMinimizedIcon = MinimizedIcon(Images.MinimizedIcon, 32, 32, HelloWindow:SetVisible(true));
else
	MainMinimizedIcon = MinimizedIcon(Images.MinimizedIcon, 32, 32, HelloWindow:SetVisible(false));
end

MainMinimizedIcon:SetPosition(settings.minimizeX, settings.minimizeY);
MainMinimizedIcon:SetZOrder(0);

MainMinimizedIcon:SetBackground(ResourcePath .. "Animalerie.tga");
MainMinimizedIcon:SetBackColorBlendMode(Turbine.UI.BlendMode.Multiply);
MainMinimizedIcon:SetBackColor(Turbine.UI.Color(0, 0.5, 0.5, 0.5));
    
MainMinimizedIcon.PositionChanged = function()
	settings.minimizeX = MainMinimizedIcon:GetLeft();
	settings.minimizeY = MainMinimizedIcon:GetTop();
	SaveSettings(2);
end

------------------------------------------------------------------------------------------
-- event handling
------------------------------------------------------------------------------------------

HelloWindow.KeyDown=function(sender, args)
	if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
		if(settings.escEnable == "true") then
			HelloWindow:SetVisible(false);
			settings.isWindowVisible = "false";
			SaveSettings(4);
		end
	end
	
	-- https://www.lotro.com/forums/showthread.php?493466-How-to-hide-a-window-on-F12&p=6581962#post6581962
	if ( args.Action == 268435635 ) then
		hudVisible=not hudVisible;
		if hudVisible then
			HelloWindow:SetVisible(false);
			MainMinimizedIcon:SetVisible(false);
		else
			if(settings.isWindowVisible == "true")then
				HelloWindow:SetVisible(true);
			else
				HelloWindow:SetVisible(false);
			end
			MainMinimizedIcon:SetVisible(true);
		end
	end
end

function HelloWindow:Closing(sender, args)
	settings.isWindowVisible = "false";
	SaveSettings(4);
end

------------------------------------------------------------------------------------------
-- if the position changes, save the new window location
------------------------------------------------------------------------------------------
	HelloWindow.PositionChanged = function( sender, args )
    	local x,y = HelloWindow:GetPosition();
    	settings.positionX = x;
    	settings.positionY = y;
		SaveSettings(1);
	end

				
	



