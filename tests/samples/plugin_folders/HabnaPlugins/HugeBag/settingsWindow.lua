-- HBsettings.lua
-- Written by Habna


-- **v Load / update / set default settings v**
function LoadSettings()
	InitXPos, InitYPos = 17, 33; --> ** Initial X & Y position of the first Item in the HugeBag **
	WinWidth, WinHeight = 460, 300;
	edgePadding = 15; --> ** HugeBag initial edgePadding value **
	LockLabel = self; --> ** Label that prevents from moving the window cause it's located at top
	ClicX, ClicY = 0, 0; --> To know the x,y coord when mouse button was clic
	tL, tT = 100, 100; --> Default position for window

	if GLocale == "de" then	HBsettings = Turbine.PluginData.Load( Turbine.DataScope.Character, "HugeBagWindowSettingsDE" );
	elseif GLocale == "en" then HBsettings = Turbine.PluginData.Load( Turbine.DataScope.Character, "HugeBagWindowSettingsEN" );
	elseif GLocale == "fr" then	HBsettings = Turbine.PluginData.Load( Turbine.DataScope.Character, "HugeBagWindowSettingsFR" ); end
	
	if HBsettings == nil then HBsettings = {}; end

	if HBsettings.Language == nil then HBsettings.Language = GLocale; end
	HBLocale = HBsettings.Language;
	import ("HabnaPlugins.HugeBag.Locale."..HBLocale);


	if HBsettings.Size == nil then HBsettings.Size = {}; end
	if HBsettings.Size.W == nil then HBsettings.Size.W = string.format("%.0f", 460); end
	if HBsettings.Size.H == nil then if backpackSize == 45 then HBsettings.Size.H = string.format("%.0f", 195);
	elseif backpackSize == 75 then HBsettings.Size.H = string.format("%.0f", 300);
	else HBsettings.Size.H = string.format("%.0f", 335); end end
	if HBsettings.Size.I == nil then HBsettings.Size.I = string.format("%.0f", 35); end--Default icon size
	if HBsettings.Size.E == nil then HBsettings.Size.E = false end--icon sizing enabled?
	WinWidth = tonumber(HBsettings.Size.W);
	WinHeight = tonumber(HBsettings.Size.H);
	IconSize = tonumber(HBsettings.Size.I);
	ISEnabled = HBsettings.Size.E;
	if not ISEnabled then IconSize = 35; end --Override icon size if user change it in the settings file.


	if HBsettings.Location == nil then HBsettings.Location = {}; end
	if HBsettings.Location.X == nil then HBsettings.Location.X = string.format("%.0f", Turbine.UI.Display.GetWidth() - edgePadding - WinWidth); end
	if HBsettings.Location.Y == nil then HBsettings.Location.Y = string.format("%.0f", Turbine.UI.Display.GetHeight() - edgePadding - WinHeight - 55); end
	WinLocX = tonumber(HBsettings.Location.X);
	WinLocY = tonumber(HBsettings.Location.Y);

	-- Need to go out of bound when no skin on HugeBag
	-- **v Replace HugeBag if out of the screen on load v**
	--if ( WinLocX + WinWidth ) > screenWidth then WinLocX = screenWidth - WinWidth end
	--if ( WinLocY + WinHeight ) > screenHeight then WinLocY = screenHeight - WinHeight end
	-- **^
	

	if HBsettings.BackColor == nil then HBsettings.BackColor = {}; end
	if HBsettings.BackColor.A == nil then HBsettings.BackColor.A = string.format("%.3f", 1); end
	if HBsettings.BackColor.R == nil then HBsettings.BackColor.R = string.format("%.3f", 0); end
	if HBsettings.BackColor.G == nil then HBsettings.BackColor.G = string.format("%.3f", 0); end
	if HBsettings.BackColor.B == nil then HBsettings.BackColor.B = string.format("%.3f", 0); end
	bcAlpha = tonumber(HBsettings.BackColor.A);
	bcRed = tonumber(HBsettings.BackColor.R);
	bcGreen = tonumber(HBsettings.BackColor.G);
	bcBlue = tonumber(HBsettings.BackColor.B);
	

	if HBsettings.Options == nil then	HBsettings.Options = {}; end
	if HBsettings.Options.StartVisible == nil then HBsettings.Options.StartVisible = false; end
	if HBsettings.Options.TopSection == nil then HBsettings.Options.TopSection = "info"; end
	if HBsettings.Options.HideWEsc == nil then HBsettings.Options.HideWEsc = true; end
	if HBsettings.Options.LockPosition == nil then HBsettings.Options.LockPosition = false; end
	if HBsettings.Options.LockSize == nil then HBsettings.Options.LockSize = false; end
	if HBsettings.Options.ShowSkin == nil then HBsettings.Options.ShowSkin = true; end
	if HBsettings.Options.AlwaysOnTop == nil then HBsettings.Options.AlwaysOnTop = false; end
	if HBsettings.Options.InverseMerge == nil then HBsettings.Options.InverseMerge = false; end -- True => Merge for slot 1 to last slot in bag
	if HBsettings.Options.HorizontalOrientation == nil then HBsettings.Options.HorizontalOrientation = true; end
	if HBsettings.Options.ReverseFill == nil then HBsettings.Options.ReverseFill = false; end
	StartVisible = HBsettings.Options.StartVisible;
	topbarinfo = HBsettings.Options.TopSection;
	HideWEsc = HBsettings.Options.HideWEsc;
	LockPosition = HBsettings.Options.LockPosition;
	LockSize = HBsettings.Options.LockSize;
	ShowSkin = HBsettings.Options.ShowSkin;
	zOrder = HBsettings.Options.AlwaysOnTop;
	InverseMerge = HBsettings.Options.InverseMerge;
	HorizontalOrientation = HBsettings.Options.HorizontalOrientation;
	ReverseFill = HBsettings.Options.ReverseFill;


	if HBsettings.Language == nil then HBsettings.Language = GLocale; end
	HBLocale = HBsettings.Language;
	import ("HabnaPlugins.HugeBag.Locale."..HBLocale);
	

	if HBsettings.Button == nil then HBsettings.Button = {}; end
	if HBsettings.Button.LongText == nil then HBsettings.Button.LongText = true; end
	if HBsettings.Button.Show == nil then HBsettings.Button.Show = true; end
	if HBsettings.Button.ShowSort == nil then HBsettings.Button.ShowSort = true; end
	if HBsettings.Button.ShowMerge == nil then HBsettings.Button.ShowMerge = true; end
	if HBsettings.Button.ShowSearch == nil then HBsettings.Button.ShowSearch = true; end
	if HBsettings.Button.ShowBags == nil then HBsettings.Button.ShowBags = true; end
	if HBsettings.Button.ShowVault == nil then HBsettings.Button.ShowVault = true; end
	if HBsettings.Button.ShowSS == nil then HBsettings.Button.ShowSS = true; end
	if HBsettings.Button.AtTop == nil then HBsettings.Button.AtTop = false; end
	if HBsettings.Button.AtLeft ~= nil then HBsettings.Button.AtLeft = nil; end -- Remove after october 4th, 2013
	ButtonLongText = HBsettings.Button.LongText;
	ShowButton = HBsettings.Button.Show;
	ShowSort = HBsettings.Button.ShowSort;
	ShowMerge = HBsettings.Button.ShowMerge;
	ShowSearch = HBsettings.Button.ShowSearch;
	ShowBags = HBsettings.Button.ShowBags;
	ShowVault = HBsettings.Button.ShowVault;
	ShowSS = HBsettings.Button.ShowSS;
	ButtonAtTop = HBsettings.Button.AtTop;
	

	if HBsettings.Button.Position == nil then	HBsettings.Button.Position = {}; end
	if HBsettings.Button.Position.Sort == nil then HBsettings.Button.Position.Sort = string.format("%.0f", 0); end
	if HBsettings.Button.Position.Merge == nil then HBsettings.Button.Position.Merge = string.format("%.0f", 50); end
	local ts=0;
	if GLocale == "fr" then ts=30;
	elseif GLocale == "de" then ts=50; end
	if HBsettings.Button.Position.Search == nil then HBsettings.Button.Position.Search = string.format("%.0f", 100+ts); end
	if HBsettings.Button.Position.Bags == nil then HBsettings.Button.Position.Bags = string.format("%.0f", 180); end
	if HBsettings.Button.Position.Vault == nil then HBsettings.Button.Position.Vault = string.format("%.0f", 230); end
	if HBsettings.Button.Position.SS == nil then HBsettings.Button.Position.SS = string.format("%.0f", 280); end
	SortLeft = tonumber(HBsettings.Button.Position.Sort);
	MergeLeft = tonumber(HBsettings.Button.Position.Merge);
	SearchLeft = tonumber(HBsettings.Button.Position.Search);
	BagsLeft = tonumber(HBsettings.Button.Position.Bags);
	VaultLeft = tonumber(HBsettings.Button.Position.Vault);
	SSLeft = tonumber(HBsettings.Button.Position.SS);


	if HBsettings.Vault == nil then HBsettings.Vault = {}; end
	if HBsettings.Vault.L == nil then HBsettings.Vault.L = string.format("%.0f", tL); end --X position of Vault window
	if HBsettings.Vault.T == nil then HBsettings.Vault.T = string.format("%.0f", tT); end --Y position of Vault window
	VWLeft = tonumber(HBsettings.Vault.L);
	VWTop = tonumber(HBsettings.Vault.T);


	if HBsettings.SharedStorage == nil then HBsettings.SharedStorage = {}; end
	if HBsettings.SharedStorage.L == nil then HBsettings.SharedStorage.L = string.format("%.0f", tL); end --X position of Shared Storage window
	if HBsettings.SharedStorage.T == nil then HBsettings.SharedStorage.T = string.format("%.0f", tT); end --Y position of Shared Storage window
	SSWLeft = tonumber(HBsettings.SharedStorage.L);
	SSWTop = tonumber(HBsettings.SharedStorage.T);


	if HBsettings.BagInfos == nil then HBsettings.BagInfos = {}; end
	if HBsettings.BagInfos.L == nil then HBsettings.BagInfos.L = string.format("%.0f", tL); end --X position of BagInfos window
	if HBsettings.BagInfos.T == nil then HBsettings.BagInfos.T = string.format("%.0f", tT); end --Y position of BagInfos window
	BIWLeft = tonumber(HBsettings.BagInfos.L);
	BIWTop = tonumber(HBsettings.BagInfos.T);
	

	if HBsettings.WasVisible == nil then HBsettings.WasVisible = StartVisible; end
	WasVisible = HBsettings.WasVisible;


	if GLocale == "de" then Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagWindowSettingsDE", HBsettings ); end
	if GLocale == "en" then Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagWindowSettingsEN", HBsettings ); end
	if GLocale == "fr" then Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagWindowSettingsFR", HBsettings ); end
end
-- **^
-- **v Save settings v**
function SaveSettings(str)
	if str then --True: get all variable and save settings
		HBsettings = {};
		HBsettings.WasVisible = WasVisible;

		HBsettings.Language = {};
		HBsettings.Language = HBLocale;

		HBsettings.Location = {};
		HBsettings.Location.X = string.format("%.0f", WinLocX);
		HBsettings.Location.Y = string.format("%.0f", WinLocY);

		HBsettings.Size = {};
		HBsettings.Size.W = string.format("%.0f", WinWidth);
		HBsettings.Size.H = string.format("%.0f", WinHeight);
		HBsettings.Size.I = string.format("%.0f", IconSize);
		HBsettings.Size.E = ISEnabled;

		HBsettings.Options = {};
		HBsettings.Options.StartVisible = StartVisible;
		--HBsettings.Options.ShowSlotsInfo = ShowSlotsInfo;
		HBsettings.Options.TopSection = topbarinfo;
		HBsettings.Options.HideWEsc = HideWEsc;
		HBsettings.Options.LockPosition = LockPosition;
		HBsettings.Options.LockSize = LockSize;
		HBsettings.Options.ShowSkin = ShowSkin;
		HBsettings.Options.AlwaysOnTop = zOrder;
		HBsettings.Options.InverseMerge = InverseMerge;
		HBsettings.Options.HorizontalOrientation = HorizontalOrientation;
		HBsettings.Options.ReverseFill = ReverseFill;

		HBsettings.Language = {};
		HBsettings.Language = HBLocale;

		HBsettings.BackColor = {};
		HBsettings.BackColor.A = string.format("%.3f", bcAlpha);
		HBsettings.BackColor.R = string.format("%.3f", bcRed);
		HBsettings.BackColor.G = string.format("%.3f", bcGreen);
		HBsettings.BackColor.B = string.format("%.3f", bcBlue);
	
		HBsettings.Button = {};
		HBsettings.Button.LongText = ButtonLongText;
		HBsettings.Button.Show = ShowButton;
		HBsettings.Button.ShowSort = ShowSort;
		HBsettings.Button.ShowMerge = ShowMerge;
		HBsettings.Button.ShowSearch = ShowSearch;
		HBsettings.Button.ShowBags = ShowBags;
		HBsettings.Button.ShowVault = ShowVault;
		HBsettings.Button.ShowSS = ShowSS;
		HBsettings.Button.AtTop = ButtonAtTop;
	
		HBsettings.Button.Position = {};
		HBsettings.Button.Position.Sort = string.format("%.0f", SortLeft);
		HBsettings.Button.Position.Merge = string.format("%.0f", MergeLeft);
		HBsettings.Button.Position.Search = string.format("%.0f", SearchLeft);
		HBsettings.Button.Position.Bags = string.format("%.0f", BagsLeft);
		HBsettings.Button.Position.Vault = string.format("%.0f", VaultLeft);
		HBsettings.Button.Position.SS = string.format("%.0f", SSLeft);

		HBsettings.Vault = {};
		HBsettings.Vault.L = string.format("%.0f", VWLeft);
		HBsettings.Vault.T = string.format("%.0f", VWTop);

		HBsettings.SharedStorage = {};
		HBsettings.SharedStorage.L = string.format("%.0f", SSWLeft);
		HBsettings.SharedStorage.T = string.format("%.0f", SSWTop);

		HBsettings.BagInfos = {};
		HBsettings.BagInfos.L = string.format("%.0f", BIWLeft);
		HBsettings.BagInfos.T = string.format("%.0f", BIWTop);
	end

	if GLocale == "de" then Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagWindowSettingsDE", HBsettings ); end
	if GLocale == "en" then Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagWindowSettingsEN", HBsettings ); end
	if GLocale == "fr" then Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagWindowSettingsFR", HBsettings ); end
end
-- **^
-- **v Reset Location and Size settings v**
function ResetLSSettings()
	WinWidth = 460;
	if backpackSize == 45 then WinHeight = 198;
	elseif backpackSize == 75 then WinHeight = 303;
	elseif backpackSize == 90 then WinHeight = 338; end
	
	wHugeBag:SetSize( WinWidth, WinHeight );
	wHugeBag:SetPosition( Turbine.UI.Display.GetWidth() - edgePadding - WinWidth, Turbine.UI.Display.GetHeight() - edgePadding - WinHeight - 55 );
	WinLocX, WinLocY = wHugeBag:GetPosition();
	wHugeBag:SetVisible( true );
	ButtonsCtr:SetWidth( wHugeBag:GetWidth() - 68 );
	if ISEnabled then
		IconSize = 35;
		lblIconSizeV:SetText(IconSize-3);
		ISEnabled = false;
		RefreshImg("all");
		SrollCtr.MouseLeave( sender, args );
		SrollCtr2:SetVisible( false );
	end
	PerformLayout();
	PrintTitle();
	SaveSettings( true );
	Turbine.Shell.WriteLine( L["SWinRLS"] );
end
-- **^
-- **v Reset All settings v**
function ResetSettings()
	StartVisible = false;
	HBWasVisible = false;
	topbarinfo = "info";
	topOptItems[1]:SetChecked( false );
	topOptItems[2]:SetChecked( false );
	topOptItems[3]:SetChecked( false );
	topOptItems[2]:SetChecked( true );
	HideWEsc = true;
	LockPosition = false;
	LockLabel.Enable = false;
	LockSize = false;
	Widget = Widget;
	WinWidth = 425;
	--backpackSize = 60; --debug purpose
	if (backpackSize >= 45) and (backpackSize <= 55) then WinHeight = 233; -- to show 45 to 55 slots
	elseif (backpackSize >= 56) and (backpackSize <= 66) then WinHeight = 268; -- to show 56 to 66 slots
	elseif (backpackSize >= 67) and (backpackSize <= 77) then WinHeight = 303; -- to show 67 to 77 slots
	elseif (backpackSize >= 78) and (backpackSize <= 88) then WinHeight = 338; -- to show 78 to 88 slots
	elseif (backpackSize >= 89) and (backpackSize <= 99) then WinHeight = 373; -- to show 89 to 99 slots
	elseif (backpackSize >= 100) and (backpackSize <= 110) then WinHeight = 408; end -- to show 100 to 110 slots
	wHugeBag:SetSize( WinWidth, WinHeight );
	wHugeBag:SetPosition( Turbine.UI.Display.GetWidth() - edgePadding - WinWidth, Turbine.UI.Display.GetHeight() - edgePadding - WinHeight - 55 );
	WinLocX, WinLocY = wHugeBag:GetPosition();
	bcAlpha, bcRed, bcGreen, bcBlue = 1, 0, 0, 0;
	wHugeBag.itemListBox:SetBackColor( Turbine.UI.Color( bcAlpha, bcRed, bcGreen, bcBlue ) );
	ShowSkin = false;
	ToggleSkin();
	ButtonLongText, ShowButton, ShowSort, ShowMerge, ShowSearch, ShowBags, ShowVault, ShowSS = true, true, true, true, true, true, true, true;
	ButtonAtTop = false;
	InverseMerge = false;
	SortLeft, MergeLeft, SearchLeft, BagsLeft, VaultLeft, SSLeft = 0, 50, 100, 170, 210, 250;
	if HBLocale == "fr" then SearchLeft = 130; end
	if HBLocale == "de" then SearchLeft = 150; end
	HorizontalOrientation = true;
	--ReverseFill = false;
	zOrder = false;
	if ISEnabled then
		IconSize = 35;
		lblIconSizeV:SetText(IconSize-3);
		ISEnabled = false;
		RefreshImg("all");
		SrollCtr.MouseLeave( sender, args );
		SrollCtr2:SetVisible( false );
	end
	PerformLayout();
	PrintTitle();
	SaveSettings( true );
	write( L["SWidRA"] );
end
-- **^