------------------------------------------------------------------------------------------
-- Closing window handler
------------------------------------------------------------------------------------------
function ClosingWindow()
	function HelloWindow:Closing(sender, args)
		settings.isWindowVisible = false;
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
	if(settings.shortcutData_4 ~= "") then
		centerQS4:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_4, settings.shortcutData_4 ) );
	end
	if(settings.shortcutData_5 ~= "") then
		centerQS5:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_5, settings.shortcutData_5 ) );
	end
	if(settings.shortcutData_6 ~= "") then
		centerQS6:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_6, settings.shortcutData_6 ) );
	end
	if(settings.shortcutData_7 ~= "") then
		centerQS7:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_7, settings.shortcutData_7 ) );
	end
	if(settings.shortcutData_8 ~= "") then
		centerQS8:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_8, settings.shortcutData_8 ) );
	end
	if(settings.shortcutData_9 ~= "") then
		centerQS9:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_9, settings.shortcutData_9 ) );
	end
	if(settings.shortcutData_10 ~= "") then
		centerQS10:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_10, settings.shortcutData_10 ) );
	end
	if(settings.shortcutData_11 ~= "") then
		centerQS11:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_11, settings.shortcutData_11 ) );
	end
	if(settings.shortcutData_12 ~= "") then
		centerQS12:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_12, settings.shortcutData_12 ) );
	end
	if(settings.shortcutData_13 ~= "") then
		centerQS13:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_13, settings.shortcutData_13 ) );
	end
	if(settings.shortcutData_14 ~= "") then
		centerQS14:SetShortcut( Turbine.UI.Lotro.Shortcut( settings.shortcutType_14, settings.shortcutData_14 ) );
	end
end

------------------------------------------------------------------------------------------
-- setting the shortcuts for drag and drop
------------------------------------------------------------------------------------------
function SetTheDragAndDrop()
	centerQS1.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS1:GetShortcut();
		tmp = tmp:GetData();
	
		--Turbine.Shell.WriteLine(tmp); -- display the ID of the schortcut

		settings.shortcutData_1 = tmp;

		SaveSettings(3);
	end
	centerQS2.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS2:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_2 = tmp;

		SaveSettings(3);
	end
	centerQS3.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS3:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_3 = tmp;

		SaveSettings(3);
	end
	centerQS4.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS4:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_4 = tmp;

		SaveSettings(3);
	end
	centerQS5.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS5:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_5 = tmp;

		SaveSettings(3);
	end
	centerQS6.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS6:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_6 = tmp;

		SaveSettings(3);
	end
	centerQS7.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS7:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_7 = tmp;

		SaveSettings(3);
	end

	centerQS8.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS8:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_8 = tmp;

		SaveSettings(3);
	end

	centerQS9.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS9:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_9 = tmp;

		SaveSettings(3);
	end

	centerQS10.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS10:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_10 = tmp;

		SaveSettings(3);
	end

	centerQS11.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS11:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_11 = tmp;

		SaveSettings(3);
	end

	centerQS12.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS12:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_12 = tmp;

		SaveSettings(3);
	end

	centerQS13.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS13:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_13 = tmp;

		SaveSettings(3);
	end

	centerQS14.DragDrop = function(sender, args)
		local tmp = Turbine.UI.Lotro.Quickslot();
		
		tmp = centerQS14:GetShortcut();
		tmp = tmp:GetData();
	
		settings.shortcutData_14 = tmp;

		SaveSettings(3);
	end
end

------------------------------------------------------------------------------------------
-- close the window with the mousr click on the food
------------------------------------------------------------------------------------------
function SetTheMouseClick()
	centerQS8.MouseClick = function(sender, args)
		HelloWindow:SetVisible(false);
		settings.isWindowVisible = false;
		SaveSettings(4);
	end
	centerQS9.MouseClick = function(sender, args)
		HelloWindow:SetVisible(false);
		settings.isWindowVisible = false;
		SaveSettings(4);
	end
	centerQS10.MouseClick = function(sender, args)
		HelloWindow:SetVisible(false);
		settings.isWindowVisible = false;
		SaveSettings(4);
	end
	centerQS11.MouseClick = function(sender, args)
		HelloWindow:SetVisible(false);
		settings.isWindowVisible = false;
		SaveSettings(4);
	end
	centerQS12.MouseClick = function(sender, args)
		HelloWindow:SetVisible(false);
		settings.isWindowVisible = false;
		SaveSettings(4);
	end
	centerQS13.MouseClick = function(sender, args)
		HelloWindow:SetVisible(false);
		settings.isWindowVisible = false;
		SaveSettings(4);
	end
	centerQS14.MouseClick = function(sender, args)
		HelloWindow:SetVisible(false);
		settings.isWindowVisible = false;
		SaveSettings(4);
	end

end

------------------------------------------------------------------------------------------
-- delete the shortcut with mouse wheel
------------------------------------------------------------------------------------------
function DeleteTheSHortCuts()
	centerQS1.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_1 = tostring(""); 
			centerQS1:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS2.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_2 = tostring(""); 
			centerQS2:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS3.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_3 = tostring(""); 
			centerQS3:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS4.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_4 = tostring(""); 
			centerQS4:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS5.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_5 = tostring(""); 
			centerQS5:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS6.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_6 = tostring(""); 
			centerQS6:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS7.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_7 = tostring(""); 
			centerQS7:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS8.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_8 = tostring(""); 
			centerQS8:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS9.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_9 = tostring(""); 
			centerQS9:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS10.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_10 = tostring(""); 
			centerQS10:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS11.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_11 = tostring(""); 
			centerQS11:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS12.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_12 = tostring(""); 
			centerQS12:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS13.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_13 = tostring(""); 
			centerQS13:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
	centerQS14.MouseWheel = function(sender, args)
		if(settings.isLocked == false)then
			settings.shortcutData_14 = tostring(""); 
			centerQS14:SetShortcut(Turbine.UI.Lotro.Shortcut());
			SaveSettings(3);
		end
	end
end