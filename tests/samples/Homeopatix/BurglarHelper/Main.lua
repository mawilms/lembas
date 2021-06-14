------------------------------------------------------------------------------------------
-- import librarys
------------------------------------------------------------------------------------------
import "Homeopatix.BurglarHelper.Librarys"


Turbine.Shell.WriteLine("<rgb=#DAA520>BurglarHelper</rgb> <rgb=#DDDDDD>".. plugin:GetVersion() .." par Homeo</rgb>")


CreateLocalizationInfo();
LoadSettings();

------------------------------------------------------------------------------------------
-- create the main window
------------------------------------------------------------------------------------------
CreateMainWindow();

------------------------------------------------------------------------------------------
-- setting the shortcuts
------------------------------------------------------------------------------------------
SetTheShortCuts();

------------------------------------------------------------------------------------------
-- mouse enter handler
------------------------------------------------------------------------------------------
MouseEnterHandler();

------------------------------------------------------------------------------------------
-- delete the shortcut with mouse wheel
------------------------------------------------------------------------------------------
DeleteShortCuts();

------------------------------------------------------------------------------------------
-- setting the shortcuts for drag and drop
------------------------------------------------------------------------------------------
DragAndDrop();

------------------------------------------------------------------------------------------
-- Closing window handler
------------------------------------------------------------------------------------------
ClosingWindow();
EscapeKeyHandler();
------------------------------------------------------------------------------------------
-- handle minimizeIcon
------------------------------------------------------------------------------------------
if(settings.isWindowVisible == "true") then
	MainMinimizedIcon = MinimizedIcon(Images.MinimizedIcon, 32, 32, BurglarHelperWindow:SetVisible(true));
else
	MainMinimizedIcon = MinimizedIcon(Images.MinimizedIcon, 32, 32, BurglarHelperWindow:SetVisible(false));
end

MainMinimizedIcon:SetPosition(settings.minimizeX, settings.minimizeY);
MainMinimizedIcon:SetZOrder(0);
MainMinimizedIcon.PositionChanged = function()
	settings.minimizeX = MainMinimizedIcon:GetLeft();
	settings.minimizeY = MainMinimizedIcon:GetTop();
	SaveSettings();
end
------------------------------------------------------------------------------------------
-- if the position changes, save the new window location
------------------------------------------------------------------------------------------
	BurglarHelperWindow.PositionChanged = function( sender, args )
    	local x,y = BurglarHelperWindow:GetPosition();
    	settings.positionX = x;
    	settings.positionY = y;
		SaveSettings();
	end