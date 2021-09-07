
AnimalerieCommand = Turbine.ShellCommand();

------------------------------------------------------------------------------------------
-- commands
------------------------------------------------------------------------------------------
function AnimalerieCommand:Execute( command, arguments )

	if ( arguments == "help" ) then
		Turbine.Shell.WriteLine(Strings.PluginHelp);
	elseif ( arguments == "show" ) then
		--Turbine.Shell.WriteLine("Show the Animalerie Window");
		HelloWindow:SetVisible(true);
		settings.isWindowVisible = true;
		SaveSettings(4);
	elseif ( arguments == "hide" ) then
		--Turbine.Shell.WriteLine("Hide the Animalerie Window");
		HelloWindow:SetVisible(false);
		settings.isWindowVisible = false;
		SaveSettings(4);
	elseif ( arguments == "esc" ) then
		if(settings.escEnable == "true") then
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginEscDesable);
			settings.escEnable = false;
		else
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginEscEnable);
			settings.escEnable = true;
		end
		SaveSettings(4);
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
	------------------------------------------------------------------------------------------
	-- alt command--
	------------------------------------------------------------------------------------------
	elseif ( arguments == "alt" ) then
		if(settings.altEnable == "true") then
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginAltDesable);
			settings.altEnable = "false";
		else
			Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginAltEnable);
			settings.altEnable = "true";
		end
		SaveSettings(4);
	elseif ( arguments == "default" ) then
		--Turbine.Shell.WriteLine("default the Animalerie Window");
		Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginDefault);
		settings.shortcutData_1 = "0x70003EB5"; -- Raven
		settings.shortcutData_2 = "0x70003EB8"; -- Bear
		settings.shortcutData_3 = "0x7000B8D3"; -- Lynx
		settings.shortcutData_4 = "0x70000FB2"; -- Eagle
		settings.shortcutData_5 = "0x7000F530"; -- Saber Tooth
		settings.shortcutData_6 = "0x7000F54D"; -- Bog Guardian
		settings.shortcutData_7 = "0x7002A706"; -- Spirit of Nature
		centerQS1:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_1, settings.shortcutData_1 ) );
		centerQS2:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_2, settings.shortcutData_2 ) );
		centerQS3:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_3, settings.shortcutData_3 ) );
		centerQS4:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_4, settings.shortcutData_4 ) );
		centerQS5:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_5, settings.shortcutData_5 ) );
		centerQS6:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_6, settings.shortcutData_6 ) );
		centerQS7:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_7, settings.shortcutData_7 ) );
		SaveSettings(3);
	elseif ( arguments == "defaultluxe" ) then
		-- debut des familier de luxe dans asset browser --- 0x4110CA40
		--Turbine.Shell.WriteLine("defaultluxe the Animalerie Window");
		Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginDefaultLuxe);
		settings.shortcutData_1 = "0x70024A63"; -- Blood Raven
		settings.shortcutData_2 = "0x70024A6C"; -- Polar Bear
		settings.shortcutData_3 = "0x70024A74"; -- Tundra Lynx
		settings.shortcutData_4 = "0x70024A80"; -- Eagle of the cimes
		settings.shortcutData_5 = "0x70024A89"; -- Saber Tooth -- to be done
		settings.shortcutData_6 = "0x70024A95"; -- Bog Guardian -- to be done
		settings.shortcutData_7 = "0x7002A706"; -- Spirit of Nature -- to be done
		centerQS1:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_1, settings.shortcutData_1 ) );
		centerQS2:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_2, settings.shortcutData_2 ) );
		centerQS3:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_3, settings.shortcutData_3 ) );
		centerQS4:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_4, settings.shortcutData_4 ) );
		centerQS5:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_5, settings.shortcutData_5 ) );
		centerQS6:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_6, settings.shortcutData_6 ) );
		centerQS7:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_7, settings.shortcutData_7 ) );
		SaveSettings(3);
	elseif ( arguments == "clear" ) then
		--Turbine.Shell.WriteLine("clear the Animalerie Window");
		Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " - " .. Strings.PluginClear);
		settings.shortcutData_1 = tostring("");
		settings.shortcutData_2 = tostring(""); 
		settings.shortcutData_3 = tostring(""); 
		settings.shortcutData_4 = tostring(""); 
		settings.shortcutData_5 = tostring(""); 
		settings.shortcutData_6 = tostring(""); 
		settings.shortcutData_7 = tostring("");
		settings.shortcutData_8 = tostring("");
		settings.shortcutData_9 = tostring(""); 
		settings.shortcutData_10 = tostring(""); 
		settings.shortcutData_11 = tostring(""); 
		settings.shortcutData_12 = tostring(""); 
		settings.shortcutData_13 = tostring(""); 
		settings.shortcutData_14 = tostring(""); 
		centerQS1:SetShortcut(Turbine.UI.Lotro.Shortcut()); 
		centerQS2:SetShortcut(Turbine.UI.Lotro.Shortcut());
		centerQS3:SetShortcut(Turbine.UI.Lotro.Shortcut());
		centerQS4:SetShortcut(Turbine.UI.Lotro.Shortcut());
		centerQS5:SetShortcut(Turbine.UI.Lotro.Shortcut());
		centerQS6:SetShortcut(Turbine.UI.Lotro.Shortcut());
		centerQS7:SetShortcut(Turbine.UI.Lotro.Shortcut());
		centerQS8:SetShortcut(Turbine.UI.Lotro.Shortcut());
		centerQS9:SetShortcut(Turbine.UI.Lotro.Shortcut());
		centerQS10:SetShortcut(Turbine.UI.Lotro.Shortcut());
		centerQS11:SetShortcut(Turbine.UI.Lotro.Shortcut());
		centerQS12:SetShortcut(Turbine.UI.Lotro.Shortcut());
		centerQS13:SetShortcut(Turbine.UI.Lotro.Shortcut());
		centerQS14:SetShortcut(Turbine.UI.Lotro.Shortcut());
		SaveSettings(3);
	end

end

Turbine.Shell.AddCommand( "An;Animalerie", AnimalerieCommand );

