-- settingsWidget.lua
-- Written by Habna


-- **v Load / update / set default settings v**
function LoadSettings()
	InitXPos, InitYPos = 30, 30; --> ** Initial X & Y position of the first Item in the HugeBag **
	WinWidth, WinHeight = 449, 309; --> ** HugeBag initial size **
	winRate = 30; --> ** rate in screen pixel used to do the slide effect **
	windowOpen = false; --> ** Does widget is hidden are not ( true = showing, false = hidden ) **
	tL, tT = 100, 100; --> Default position for window
	
	if GLocale == "de" then	HBsettings = Turbine.PluginData.Load( Turbine.DataScope.Character, "HugeBagWidgetSettingsDE" );
	elseif GLocale == "en" then HBsettings = Turbine.PluginData.Load( Turbine.DataScope.Character, "HugeBagWidgetSettingsEN" );
	elseif GLocale == "fr" then	HBsettings = Turbine.PluginData.Load( Turbine.DataScope.Character, "HugeBagWidgetSettingsFR" ); end
	
	if GLocale == "en" then	tA, tR, tG, tB = 0.3, 0.3, 0.3, 0.3;
	else tA, tR, tG, tB = "0,3", "0,3", "0,3", "0,3"; end

	if HBsettings == nil then HBsettings = {}; end
	
	if HBsettings.Language == nil then HBsettings.Language = GLocale; end
	HBLocale = HBsettings.Language;
	import ("HabnaPlugins.HugeBag.Locale."..HBLocale);
	

	if HBsettings.Location == nil then HBsettings.Location = {}; end
	if HBsettings.Location.Y == nil then HBsettings.Location.Y = string.format("%.3f", screenHeight - WinHeight - 69); end
	if HBsettings.Location.Loc == nil then HBsettings.Location.Loc = L["OWidLocR"]; end
	WinLocY = tonumber(HBsettings.Location.Y);
	WidgetLoc = HBsettings.Location.Loc;
	if WidgetLoc == "left" or WidgetLoc == "gauche" or WidgetLoc == "links" then WidgetLoc = L["OWidLocL"]; end
	if WidgetLoc == "right" or WidgetLoc == "droite" or WidgetLoc == "rechts" then WidgetLoc = L["OWidLocR"]; end

	-- **v Replace HugeBag if out of the screen on load v**
	if ( WinLocY + WinHeight ) > screenHeight then WinLocY = screenHeight - WinHeight end
	-- **^

	if HBsettings.BackColor == nil then HBsettings.BackColor = {}; end
	if HBsettings.BackColor.A == nil then HBsettings.BackColor.A = string.format("%.3f", tA); end
	if HBsettings.BackColor.R == nil then HBsettings.BackColor.R = string.format("%.3f", tR); end
	if HBsettings.BackColor.G == nil then HBsettings.BackColor.G = string.format("%.3f", tG); end
	if HBsettings.BackColor.B == nil then HBsettings.BackColor.B = string.format("%.3f", tB); end
	bcAlpha = tonumber(HBsettings.BackColor.A);
	bcRed = tonumber(HBsettings.BackColor.R);
	bcGreen = tonumber(HBsettings.BackColor.G);
	bcBlue = tonumber(HBsettings.BackColor.B);


	if HBsettings.Options == nil then	HBsettings.Options = {}; end
	if HBsettings.Options.StartVisible == nil then HBsettings.Options.StartVisible = false; end
	if HBsettings.Options.HideWEsc == nil then HBsettings.Options.HideWEsc = true; end
	if HBsettings.Options.AlwaysOnTop == nil then HBsettings.Options.AlwaysOnTop = false; end
	if HBsettings.Options.ShowSideBarInfo ~= nil then HBsettings.Options.SideSection = HBsettings.Options.ShowSideBarInfo; HBsettings.Options.ShowSideBarInfo = nil; end --Remove after May 1st 2013
	if HBsettings.Options.SideSection == nil then HBsettings.Options.SideSection = "image"; end
	if HBsettings.Options.ShowTopBarInfo ~= nil then HBsettings.Options.TopSection = HBsettings.Options.ShowTopBarInfo; HBsettings.Options.ShowTopBarInfo = nil; end --Remove after May 1st 2013
	if HBsettings.Options.TopSection == nil then HBsettings.Options.TopSection = "info"; end
	StartVisible = HBsettings.Options.StartVisible;
	HideWEsc = HBsettings.Options.HideWEsc;
	zOrder = HBsettings.Options.AlwaysOnTop;
	sidebarinfo = HBsettings.Options.SideSection;
	topbarinfo = HBsettings.Options.TopSection;


	if HBsettings.Button == nil then HBsettings.Button = {}; end
	if HBsettings.Button.LongText == nil then HBsettings.Button.LongText = true; end
	if HBsettings.Button.InverseMerge == nil then HBsettings.Button.InverseMerge = false; end
	if HBsettings.Button.ShowButton ~= nil then HBsettings.Button.Show = HBsettings.Button.ShowButton; HBsettings.Button.ShowButton = nil; end --Remove after May 1st 2013
	if HBsettings.Button.Show == nil then HBsettings.Button.Show = true; end
	if HBsettings.Button.ShowSort == nil then HBsettings.Button.ShowSort = true; end
	if HBsettings.Button.ShowMerge == nil then HBsettings.Button.ShowMerge = true; end
	if HBsettings.Button.ShowSearch == nil then HBsettings.Button.ShowSearch = true; end
	if HBsettings.Button.ShowBags == nil then HBsettings.Button.ShowBags = true; end
	if HBsettings.Button.ShowVault == nil then HBsettings.Button.ShowVault = true; end
	if HBsettings.Button.ShowSS == nil then HBsettings.Button.ShowSS = true; end
	ButtonLongText = HBsettings.Button.LongText;
	InverseMerge = HBsettings.Button.InverseMerge;
	ShowButton = HBsettings.Button.Show;
	ShowSort = HBsettings.Button.ShowSort;
	ShowMerge = HBsettings.Button.ShowMerge;
	ShowSearch = HBsettings.Button.ShowSearch;
	ShowBags = HBsettings.Button.ShowBags;
	ShowVault = HBsettings.Button.ShowVault;
	ShowSS = HBsettings.Button.ShowSS;
		

	if HBsettings.Button.Position == nil then HBsettings.Button.Position = {}; end
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


	if HBsettings.WasOpen == nil then HBsettings.WasOpen = false; end
	WasOpen = HBsettings.WasOpen;
	

	if GLocale == "de" then Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagWidgetSettingsDE", HBsettings ); end
	if GLocale == "en" then Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagWidgetSettingsEN", HBsettings ); end
	if GLocale == "fr" then Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagWidgetSettingsFR", HBsettings ); end
end
-- **^
-- **v Save settings v**
function SaveSettings(str)
	if str then --True: get all variable and save settings
		HBsettings = {};
		HBsettings.WasOpen = WasOpen;

		HBsettings.Language = {};
		HBsettings.Language = HBLocale;

		HBsettings.Options = {};
		HBsettings.Options.StartVisible = StartVisible;
		if HBW then HBsettings.Options.StartVisible = true; end
		HBsettings.Options.HideWEsc = HideWEsc;
		HBsettings.Options.AlwaysOnTop = zOrder;
		HBsettings.Options.SideSection = sidebarinfo;
		HBsettings.Options.TopSection = topbarinfo;

		HBsettings.Location = {};
		--HBsettings.Location.X = tostring(WinLocX);
		HBsettings.Location.Y = tostring(WinLocY);
		HBsettings.Location.Loc = WidgetLoc;

		HBsettings.BackColor = {};
		HBsettings.BackColor.A = string.format("%.3f", bcAlpha);
		HBsettings.BackColor.R = string.format("%.3f", bcRed);
		HBsettings.BackColor.G = string.format("%.3f", bcGreen);
		HBsettings.BackColor.B= string.format("%.3f", bcBlue);

		HBsettings.Button = {};
		HBsettings.Button.LongText = ButtonLongText;
		HBsettings.Button.InverseMerge = InverseMerge;
		HBsettings.Button.Show = ShowButton;
		HBsettings.Button.ShowSort = ShowSort;
		HBsettings.Button.ShowMerge = ShowMerge;
		HBsettings.Button.ShowSearch = ShowSearch;
		HBsettings.Button.ShowBags = ShowBags;
		HBsettings.Button.ShowVault = ShowVault;
		HBsettings.Button.ShowSS = ShowSS;

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

	if GLocale == "de" then Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagWidgetSettingsDE", HBsettings ); end
	if GLocale == "en" then Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagWidgetSettingsEN", HBsettings ); end
	if GLocale == "fr" then Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagWidgetSettingsFR", HBsettings ); end
end
-- **^
-- **v Reset All settings v**
function ResetSettings()
	WinLocX = screenWidth - WinWidth - 1;
	WinLocY = screenHeight - WinHeight - 69;
	wHugeBag:SetPosition( WinLocX, WinLocY );
	WidgetLoc = L["OWidLocR"];
	StartVisible = false;
	WasOpen = false;
	HideWEsc = true;
	InverseMerge = false;
	Widget = Widget;
	if GLocale == "en" then tA, tR, tG, tB, tX = 0.3, 0.3, 0.3, 0.3;
	else tA, tR, tG, tB = "0,3", "0,3", "0,3", "0,3"; end
	bcAlpha, bcRed, bcGreen, bcBlue = tA, tR, tG, tB;
	wHugeBag.itemListBox:SetBackColor( Turbine.UI.Color( bcAlpha, bcRed, bcGreen, bcBlue ) );
	if windowOpen and not StartVisible then
		wHugeBag:SetVisible( true );
		slideCtr:SetWantsUpdates(true);
	end

	SortLeft, MergeLeft, SearchLeft, BagsLeft, VaultLeft, SSLeft = 0, 50, 100, 180, 230, 280;
	if HBLocale == "fr" then SearchLeft = 130; end
	if HBLocale == "de" then SearchLeft = 150; end
	SortButton:SetPosition( SortLeft,  8 );
	MergeButton:SetPosition( MergeLeft, 8 );
	SearchButton:SetPosition( SearchLeft,  8 );
	BagsButton:SetPosition( BagsLeft,  8 );
	VaultButton:SetPosition( VaultLeft,  8 );
	SSButton:SetPosition( SSLeft,  8 );
	zOrder = false;
	ToggleSideBarInfo("image");
	sideOptItems[1]:SetChecked( false );
	sideOptItems[2]:SetChecked( false );
	sideOptItems[3]:SetChecked( false );
	sideOptItems[1]:SetChecked( true );
	ToggleTopBarInfo("info");
	topOptItems[1]:SetChecked( false );
	topOptItems[2]:SetChecked( false );
	topOptItems[3]:SetChecked( false );
	topOptItems[2]:SetChecked( true );
	ButtonLongText, ShowButton, ShowSort, ShowMerge, ShowSearch, ShowBags, ShowVault, ShowSS = true, true, true, true, true, true, true, true;
	ToggleBotBarInfo("butvis");
	SaveSettings( true );
	write( L["SWidRA"] );
end
-- **^