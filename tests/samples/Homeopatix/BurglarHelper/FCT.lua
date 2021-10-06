------------------------------------------------------------------------------------------
-- Closing window handler
------------------------------------------------------------------------------------------
function ClosingWindow()
	function BurglarHelperWindow:Closing(sender, args)
		settings.isWindowVisible = "false";
		SaveSettings();
	end
end
------------------------------------------------------------------------------------------
-- setting the shortcuts
------------------------------------------------------------------------------------------
function SetTheShortCuts()
	if(settings.shortcutData_1 ~= "") then
		centerQS1:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_1, settings.shortcutData_1 ) );
	end
	if(settings.shortcutData_2 ~= "") then
		centerQS2:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_2, settings.shortcutData_2 ) );
	end
	if(settings.shortcutData_3 ~= "") then
		centerQS3:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_3, settings.shortcutData_3 ) );
	end

	settings.shortcutData_1 = "0x70003212"; -- devient fufu
	settings.shortcutData_2 = "0x70003F16"; -- pick pocket
	settings.shortcutData_3 = "0x7000D446"; -- farce
	centerQS1:SetShortcut( Turbine.UI.Lotro.Shortcut( 6, settings.shortcutData_1 ) );
	centerQS2:SetShortcut( Turbine.UI.Lotro.Shortcut( 6, settings.shortcutData_2 ) );
	centerQS3:SetShortcut( Turbine.UI.Lotro.Shortcut( 6, settings.shortcutData_3 ) );
end
------------------------------------------------------------------------------------------
-- display the list of command
------------------------------------------------------------------------------------------
function commandsHelp()
	notification(
		rgb["start"] .. 
		Strings.PluginHelp1 ..
		rgb["clear"] ..
		Strings.PluginHelp2 ..
		Strings.PluginHelp3 ..
		Strings.PluginHelp4 ..
		Strings.PluginHelp5 ..
		Strings.PluginHelp6 ..
		Strings.PluginHelp7 ..
		Strings.PluginHelp8
	);
end
------------------------------------------------------------------------------------------
-- setting the shortcuts for drag and drop
------------------------------------------------------------------------------------------
function DragAndDrop()
	centerQS1.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS1:GetShortcut();
		tmp = tmp:GetData();
	
		local tmp2 = Turbine.UI.Lotro.Quickslot();
		tmp2 = centerQS1:GetShortcut();
		tmp2 = tmp2:GetType();

	
		--Turbine.Shell.WriteLine("Data : " .. tmp); -- display the ID of the schortcut
		--Turbine.Shell.WriteLine("Type : " .. tmp2); -- display the Type of the schortcut

		settings.shortcutData_1 = tmp;
		settings.shortcutType_1 = tmp2;

		SaveSettings();
	end
	centerQS2.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS2:GetShortcut();
		tmp = tmp:GetData();
	
		local tmp2 = Turbine.UI.Lotro.Quickslot();
		tmp2 = centerQS1:GetShortcut();
		tmp2 = tmp2:GetType();

		settings.shortcutData_2 = tmp;
		settings.shortcutType_1 = tmp2;

		SaveSettings();
	end
	centerQS3.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS3:GetShortcut();
		tmp = tmp:GetData();
	
		local tmp2 = Turbine.UI.Lotro.Quickslot();
		tmp2 = centerQS1:GetShortcut();
		tmp2 = tmp2:GetType();

		settings.shortcutData_3 = tmp;
		settings.shortcutType_1 = tmp2;

		SaveSettings();
	end
end
------------------------------------------------------------------------------------------
-- deUpdate the shortcuts
------------------------------------------------------------------------------------------
function MouseEnterHandler()
	centerQS1.MouseEnter = function(sender, args)
		BurglarHelperWindow.Message:SetText(""); 
		BurglarHelperWindow.Message:SetText(Strings.PluginBurglarHelper1); 
	end

	centerQS2.MouseEnter = function(sender, args)
		BurglarHelperWindow.Message:SetText("");
		BurglarHelperWindow.Message:SetText(Strings.PluginBurglarHelper2); 
	end

	centerQS3.MouseEnter = function(sender, args)
		BurglarHelperWindow.Message:SetText("");
		BurglarHelperWindow.Message:SetText(Strings.PluginBurglarHelper3); 
	end

	centerQS1.MouseLeave = function(sender, args)
		BurglarHelperWindow.Message:SetText(Strings.PluginText);
	end

	centerQS2.MouseLeave = function(sender, args)
		BurglarHelperWindow.Message:SetText(Strings.PluginText);
	end

	centerQS3.MouseLeave = function(sender, args)
		BurglarHelperWindow.Message:SetText(Strings.PluginText);
	end
end
------------------------------------------------------------------------------------------
-- delete the shortcut with mouse wheel
------------------------------------------------------------------------------------------
function DeleteShortCuts()
	centerQS1.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_1 = tostring(""); 
			centerQS1:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings();
		end
	end
	centerQS2.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_2 = tostring(""); 
			centerQS2:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings();
		end
	end
	centerQS3.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_3 = tostring(""); 
			centerQS3:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings();
		end
	end
end

------------------------------------------------------------------------------------------
-- event handling
------------------------------------------------------------------------------------------
function EscapeKeyHandler()
	BurglarHelperWindow.KeyDown=function(sender, args)
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			if(settings.escEnable == true) then
				BurglarHelperWindow:SetVisible(false);
				settings.isWindowVisible = "false";
				BurglarHelperWindow:SetZOrder(-1);
				SaveSettings();
			end
		end
	
		-- https://www.lotro.com/forums/showthread.php?493466-How-to-hide-a-window-on-F12&p=6581962#post6581962
		if ( args.Action == 268435635 ) then
			hudVisible=not hudVisible;
			if hudVisible then
				BurglarHelperWindow:SetVisible(false);
				MainMinimizedIcon:SetVisible(false);
			else
				if(settings.isWindowVisible == "true")then
					BurglarHelperWindow:SetVisible(true);
				else
					BurglarHelperWindow:SetVisible(false);
				end
				MainMinimizedIcon:SetVisible(true);
			end
		end
	end
end