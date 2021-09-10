
BurglarHelperCommand = Turbine.ShellCommand();

------------------------------------------------------------------------------------------
-- commands
------------------------------------------------------------------------------------------
function BurglarHelperCommand:Execute( command, arguments )

	if ( arguments == "help" ) then
		commandsHelp();
	elseif ( arguments == "show" ) then
		--Turbine.Shell.WriteLine("Show the BurglarHelper Window");
		BurglarHelperWindow:SetVisible(true);
		settings.isWindowVisible = true;
		SaveSettings();
	elseif ( arguments == "hide" ) then
		--Turbine.Shell.WriteLine("Hide the BurglarHelper Window");
		BurglarHelperWindow:SetVisible(false);
		settings.isWindowVisible = false;
		SaveSettings();
	elseif ( arguments == "lock" ) then
		--Turbine.Shell.WriteLine("Hide the PopoHelper Window");
		if(settings.isLocked == false)then
			settings.isLocked = true;
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " : " .. Strings.PluginLocked);
		else
			settings.isLocked = false;
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " : " .. Strings.PluginUnlocked);
		end
		SaveSettings();
	elseif ( arguments == "default" ) then
		--Turbine.Shell.WriteLine("default the YulHelperWindow");
		settings.shortcutData_1 = "0x70003212"; -- morceaux de fruit pourrit non theatre
		settings.shortcutData_2 = "0x70003F16"; -- pétale de fleurs de rivegel
		settings.shortcutData_3 = "0x7000D446"; -- morceaux de fruit pourri pour le theatre
		centerQS1:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_1, settings.shortcutData_1 ) );
		centerQS2:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_2, settings.shortcutData_2 ) );
		centerQS3:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_3, settings.shortcutData_3 ) );
		SaveSettings();
	elseif ( arguments == "esc" ) then
		if(settings.escEnable == true) then
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginEscDesable);
			settings.escEnable = false;
		else
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginEscEnable);
			settings.escEnable = true;
		end
		SaveSettings();
	------------------------------------------------------------------------------------------
	-- alt command--
	------------------------------------------------------------------------------------------
	elseif ( arguments == "alt" ) then
		if(settings.altEnable == true) then
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginAltDesable);
			settings.altEnable = false;
		else
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginAltEnable);
			settings.altEnable = true;
		end
		SaveSettings();
	end
end

Turbine.Shell.AddCommand( "Bu;BurglarHelper", BurglarHelperCommand );