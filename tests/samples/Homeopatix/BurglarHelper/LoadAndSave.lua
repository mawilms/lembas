------------------------------------------------------------------------------------------
-- create or load the settings
------------------------------------------------------------------------------------------
function LoadSettings()
	settings = PatchDataLoad(Turbine.DataScope.Character, "BurglarHelper_Settings", settings);

	if ( type( settings ) ~= "table" ) then
		settings = { };
	end
	
	if ( not settings.positionX) then		
		settings.positionX = ( Turbine.UI.Display:GetWidth()/2 - 200);		
	end
	
	if ( not settings.positionY) then	
		settings.positionY = ( Turbine.UI.Display.GetHeight()/2 - 200);
	end	
	
	if ( not settings.shortcutData_1) then	
		settings.shortcutData_1 = tostring("");
	end	
	
	if ( not settings.shortcutType_1) then	
		settings.shortcutType_1 = 6;
	end
	
	if ( not settings.shortcutData_2) then	
		settings.shortcutData_2 = tostring("");
	end	
	
	if ( not settings.shortcutType_2) then	
		settings.shortcutType_2 = 6;
	end

	if ( not settings.shortcutData_3) then	
		settings.shortcutData_3 = tostring("");
	end	
	
	if ( not settings.shortcutType_3) then	
		settings.shortcutType_3 = 6;
	end
		
	if ( not settings.minimizeX) then	
		settings.minimizeX = 0;
	end

	if ( not settings.minimizeY) then	
		settings.minimizeY = 0;
	end
	
	if ( not settings.isMinimizeEnabled) then	
		settings.isMinimizeEnabled = true;
	end

	if ( not settings.escEnable) then	
		settings.escEnable = false;
	end

	if ( not settings.altEnable) then	
		settings.altEnable = false;
	end

	if ( not settings.isLocked) then	
		settings.isLocked = true;
	end

	if ( not settings.isWindowVisible) then	
		settings.isWindowVisible = tostring("true");
	end

	rgb = {
    start = "<rgb=#DAA520>",
    error = "<rgb=#FF0000>",
    clear = "</rgb>"
	};
end
------------------------------------------------------------------------------------------
-- create the save settings
------------------------------------------------------------------------------------------
function SaveSettings()
	settings.positionX = tostring(settings.positionX);
   	settings.positionY = tostring(settings.positionY);
	settings.minimizeX = tostring(settings.minimizeX);
   	settings.minimizeY = tostring(settings.minimizeY);
	settings.isWindowVisible = tostring(settings.isWindowVisible);
	settings.shortcutData_1 = tostring(settings.shortcutData_1);
   	settings.shortcutData_2 = tostring(settings.shortcutData_2);
   	settings.shortcutData_3 = tostring(settings.shortcutData_3);
	settings.escEnable = settings.escEnable;
	settings.isLocked = settings.isLocked;
	settings.altEnable = settings.altEnable;
   
-- save the settings
	PatchDataSave( Turbine.DataScope.Character, "BurglarHelper_Settings", settings);
end