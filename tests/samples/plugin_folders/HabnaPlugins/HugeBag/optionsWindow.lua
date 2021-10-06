-- optionsWidget.lua
-- Written By Habna


-- View menu
local ViewMenu = Turbine.UI.MenuItem( L["OWidView"] );
ViewMenu.Items = ViewMenu:GetItems();

local MenuItems = { L["OWidBags"], L["OWidVault"], L["OWidStorage"] };
local op = { "bags", "vault", "storage" };
local max = #op;
ViewItems = {};
if PlayerAlign ~= 1 then max = 1; end --If in Monster Play then show only bags info

for i = 1, max do
	ViewItems[i] = Turbine.UI.MenuItem( MenuItems[i] );
	ViewItems[i].Click = function( sender, args )
		ViewVaultStorageBags( op[i] );
	end
	ViewMenu.Items:Add( ViewItems[i] );
end

-- Top section options menu
local topOptMenu = Turbine.UI.MenuItem( L["OWidTop"] );
topOptMenu.Items = topOptMenu:GetItems();

local MenuItem = { L["OWidTopT"], L["OWidTopI"], L["OWidTopN"] };
local op = { "title", "info", "nil" };
topOptItems = {};

for i = 1, 3 do
	topOptItems[i] = Turbine.UI.MenuItem( MenuItem[i] );
	if topbarinfo == op[i] then topOptItems[i]:SetChecked( true ); end
	topOptItems[i].Click = function( sender, args )
		if topbarinfo ~= op[i] then
			ToggleTopBarInfo(op[i]);
			topOptItems[1]:SetChecked( false );
			topOptItems[2]:SetChecked( false );
			topOptItems[3]:SetChecked( false );
		end
		topOptItems[i]:SetChecked( true );
		ShowOptionsMenu("nil");
	end
	
	topOptMenu.Items:Add( topOptItems[i] );
end


-- Bottom section options menu
local botOptMenu = Turbine.UI.MenuItem( L["OWidBot"] );
botOptMenuItems = botOptMenu:GetItems();

local MenuItem = { L["SC27"], L["SC10"], L["SC16"], L["SC17"], L["SC18"], L["SC24"], L["SC25"], L["SC26"] };
local ItemsOpt = { "butlt", "butvis", "sortvis", "mergevis", "searchvis", "bagsvis", "vaultvis", "ssvis" };

for i = 1, #MenuItem do
	local botOptItems = Turbine.UI.MenuItem( MenuItem[i] );
	botOptItems.Click = function( sender, args )
		ToggleBotBarInfo( ItemsOpt[i] );
		ShowOptionsMenu("nil");
	end
	
	botOptMenuItems:Add( botOptItems );
end


-- Language menu
local LocaleMenu = Turbine.UI.MenuItem( L["OWidL"] );
LocaleMenu.Items = LocaleMenu:GetItems();

local MenuItem = { L["OWidLen"], L["OWidLfr"], L["OWidLde"] };
local Lang = { "en", "fr", "de" };

for i = 1, 3 do
	local LocaleItems = Turbine.UI.MenuItem( MenuItem[i] );
	if HBLocale == Lang[i] then LocaleItems:SetChecked( true ); end
	LocaleItems.Click = function( sender, args )
		if HBLocale ~= Lang[i] then
			HBsettings.Language = Lang[i];
			HBsettings.WasVisible = wHugeBag:IsVisible();
			SaveSettings( false );
			ReloadHugeBag();
		end
		ShowOptionsMenu("nil");
	end
	
	LocaleMenu.Items:Add( LocaleItems );
end


menu = Turbine.UI.ContextMenu();
menu.items = menu:GetItems();

local option_line = Turbine.UI.MenuItem("--------------------------------------------------------------------------", false);
local opt_empty = Turbine.UI.MenuItem("", false);

local option_toggleshow = Turbine.UI.MenuItem( L["SC7"] );
option_toggleshow.Click = function( sender, args ) ToggleShow(); ShowOptionsMenu("nil"); end

local option_togglewesc = Turbine.UI.MenuItem( L["SC6"] );
option_togglewesc.Click = function( sender, args ) ToggleWEsc(); ShowOptionsMenu("nil"); end

local option_togglewidget = Turbine.UI.MenuItem( L["SC8"] );
option_togglewidget.Click = function( sender, args ) ToggleMode(); ShowOptionsMenu("nil"); end

local option_toggleaot = Turbine.UI.MenuItem( L["OWidAOT"] );
option_toggleaot.Click = function( sender, args ) ToggleAlwaysOnTop(); ShowOptionsMenu("nil"); end

local option_toggleinversemerge = Turbine.UI.MenuItem( L["OWidIM"] );
option_toggleinversemerge.Click = function( sender, args ) InvMerge(); ShowOptionsMenu("nil"); end

local option_locksize = Turbine.UI.MenuItem( L["WinSC4"] );
option_locksize.Click = function( sender, args ) LockHugeBagSize(); ShowOptionsMenu("nil"); end

local option_lockposition = Turbine.UI.MenuItem( L["WinSC5"] );
option_lockposition.Click = function( sender, args ) LockHugeBagPosition(); ShowOptionsMenu("nil"); end

local option_skin = Turbine.UI.MenuItem( L["WinSC2"] );
option_skin.Click = function( sender, args ) ToggleSkin(); ShowOptionsMenu("nil"); end

local option_orientation = Turbine.UI.MenuItem( L["WinSC3"] );
option_orientation.Click = function( sender, args ) ToggleItemsOrientation(); ShowOptionsMenu("nil"); end

local option_IconSize = Turbine.UI.MenuItem( L["WinSC6"] );
option_IconSize.Click = function( sender, args ) ToggleIconSize(); ShowOptionsMenu("nil"); end

local option_LoadProfileSettings = Turbine.UI.MenuItem( L["OWinLP"] );
option_LoadProfileSettings.Click = function( sender, args ) ApplyProfileSettings(); end

local option_SaveProfileSettings = Turbine.UI.MenuItem( L["OWinSP"] );
option_SaveProfileSettings.Click = function( sender, args ) SaveProfileSettings( true ); end

option_help = Turbine.UI.MenuItem( L["SC14"] );
option_help.Click = function( sender, args ) HelpInfo(); option_help:SetEnabled( false ); end

local option_resetls = Turbine.UI.MenuItem( L["WinSC1"] );
option_resetls.Click = ResetLSSettings;

local option_resetall = Turbine.UI.MenuItem( L["SC5"] );
option_resetall.Click = ResetSettings;

option_backcolor = Turbine.UI.MenuItem( L["OWidBC"] );
option_backcolor.Click = function( sender, args ) SetBackgroundColor(); option_backcolor:SetEnabled( false ); end

local option_reload = Turbine.UI.MenuItem( L["SC4"] .. " " .. Version);
option_reload.Click = ReloadHugeBag;

local option_unload = Turbine.UI.MenuItem( L["SC3"] .. " " .. Version);
option_unload.Click = UnloadHugeBag;



menu.items:Add(option_togglewidget);
menu.items:Add(option_toggleshow);
menu.items:Add(option_togglewesc);
menu.items:Add(option_toggleaot);
menu.items:Add(option_toggleinversemerge);
menu.items:Add(option_locksize);
menu.items:Add(option_lockposition);
menu.items:Add(option_skin);
menu.items:Add(option_orientation);
menu.items:Add(option_IconSize);
menu.items:Add(option_line); ------
menu.items:Add(ViewMenu);
menu.items:Add(opt_empty);
menu.items:Add(option_LoadProfileSettings);
menu.items:Add(option_SaveProfileSettings);
menu.items:Add(opt_empty);
menu.items:Add(topOptMenu);
menu.items:Add(botOptMenu);
menu.items:Add(option_line); ------
menu.items:Add(option_backcolor);
menu.items:Add(LocaleMenu);
menu.items:Add(option_help);
menu.items:Add(opt_empty);
menu.items:Add(option_resetls);
menu.items:Add(option_resetall);
menu.items:Add(opt_empty);
menu.items:Add(option_unload);
menu.items:Add(option_reload);