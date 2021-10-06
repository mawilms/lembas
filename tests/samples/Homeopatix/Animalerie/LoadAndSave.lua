
------------------------------------------------------------------------------------------
-- create the load settings
------------------------------------------------------------------------------------------
function LoadSettings()
	settings = PatchDataLoad(Turbine.DataScope.Character, "Animalerie_Settings", settings);

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

	if ( not settings.shortcutData_4) then	
		settings.shortcutData_4 = tostring("");
	end	
	
	if ( not settings.shortcutType_4) then	
		settings.shortcutType_4 = 6;
	end

	if ( not settings.shortcutData_5) then	
		settings.shortcutData_5 = tostring("");
	end	
	
	if ( not settings.shortcutType_5) then	
		settings.shortcutType_5 = 6;
	end

	if ( not settings.shortcutData_6) then	
		settings.shortcutData_6 = tostring("");
	end	
	
	if ( not settings.shortcutType_6) then	
		settings.shortcutType_6 = 6;
	end

	if ( not settings.shortcutData_7) then	
		settings.shortcutData_7 = tostring("");
	end	
	
	if ( not settings.shortcutType_7) then	
		settings.shortcutType_7 = 6;
	end
	
	if ( not settings.shortcutData_8) then	
		settings.shortcutData_8 = tostring("");
	end	
	
	if ( not settings.shortcutType_8) then	
		settings.shortcutType_8 = 2;
	end
	
	if ( not settings.shortcutData_9) then	
		settings.shortcutData_9 = tostring("");
	end	
	
	if ( not settings.shortcutType_9) then	
		settings.shortcutType_9 = 2;
	end

	if ( not settings.shortcutData_10) then	
		settings.shortcutData_10 = tostring("");
	end	
	
	if ( not settings.shortcutType_10) then	
		settings.shortcutType_10 = 2;
	end

	if ( not settings.shortcutData_11) then	
		settings.shortcutData_11 = tostring("");
	end	
	
	if ( not settings.shortcutType_11) then	
		settings.shortcutType_11 = 2;
	end

	if ( not settings.shortcutData_12) then	
		settings.shortcutData_12 = tostring("");
	end	
	
	if ( not settings.shortcutType_12) then	
		settings.shortcutType_12 = 2;
	end

	if ( not settings.shortcutData_13) then	
		settings.shortcutData_13 = tostring("");
	end	
	
	if ( not settings.shortcutType_13) then	
		settings.shortcutType_13 = 2;
	end

	if ( not settings.shortcutData_14) then	
		settings.shortcutData_14 = tostring("");
	end	
	
	if ( not settings.shortcutType_14) then	
		settings.shortcutType_14 = 2;
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

	if ( not settings.isWindowVisible) then	
		settings.isWindowVisible = tostring("true");
	end

	if ( not settings.isLocked) then	
		settings.isLocked = true;
	end

	if ( not settings.escEnable) then	
		settings.escEnable = tostring("false");
	end

	if ( not settings.altEnable) then	
		settings.altEnable = tostring("false");
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
function SaveSettings(value)
	if(value == 1) then
		settings.positionX = tostring(settings.positionX);
		settings.positionY = tostring(settings.positionY);
	elseif(value == 2) then
		settings.minimizeX = tostring(settings.minimizeX);
		settings.minimizeY = tostring(settings.minimizeY);
	elseif(value == 3) then
		settings.shortcutData_1 = tostring(settings.shortcutData_1);
		settings.shortcutData_2 = tostring(settings.shortcutData_2);
		settings.shortcutData_3 = tostring(settings.shortcutData_3);
		settings.shortcutData_4 = tostring(settings.shortcutData_4);
		settings.shortcutData_5 = tostring(settings.shortcutData_5);
		settings.shortcutData_6 = tostring(settings.shortcutData_6);
		settings.shortcutData_7 = tostring(settings.shortcutData_7);
		settings.shortcutData_8 = tostring(settings.shortcutData_8);
		settings.shortcutData_9 = tostring(settings.shortcutData_9);
		settings.shortcutData_10 = tostring(settings.shortcutData_10);
		settings.shortcutData_11 = tostring(settings.shortcutData_11);
		settings.shortcutData_12 = tostring(settings.shortcutData_12);
		settings.shortcutData_13 = tostring(settings.shortcutData_13);
		settings.shortcutData_14 = tostring(settings.shortcutData_14);
		settings.isLocked = settings.isLocked;

	elseif(value == 4) then
		settings.isWindowVisible = tostring(settings.isWindowVisible);
		settings.escEnable = tostring(settings.escEnable);
		settings.altEnable = tostring(settings.altEnable);
	end
   
   -- save the settings
	PatchDataSave( Turbine.DataScope.Character, "Animalerie_Settings", settings);
end