-- menu.lua
-- Written By Habna


-- Locale menu
local LocMenu = Turbine.UI.MenuItem( L["MCL"] );
LocMenu.Items = LocMenu:GetItems();

local MenuItem = { L["MCLen"], L["MCLfr"], L["MCLde"] };
local Lang = { "en", "fr", "de" };

for i = 1, 3 do
	local LocItems = Turbine.UI.MenuItem( MenuItem[i] );
	if TBLocale == Lang[i] then LocItems:SetChecked( true ); end
	LocItems.Click = function( sender, args )
		if TBLocale == Lang[i] then return end
		settings.TitanBar.L = Lang[i];
		SaveSettings( false );
		ReloadTitanBar();
	end
	
	LocMenu.Items:Add( LocItems );
end


-- Reset back color of... menu
local RBCMenu = Turbine.UI.MenuItem( L["MCRBG"] );
RBCMenu.Items = RBCMenu:GetItems();

local RBCMenu1 = Turbine.UI.MenuItem( L["MCABTTB"] );
RBCMenu1.Click = function( sender, args ) BGColor( "reset" , "TitanBar" ); end
RBCMenu.Items:Add( RBCMenu1 );

local RBCMenu2 = Turbine.UI.MenuItem( L["MCABTA"] );
RBCMenu2.Click = function( sender, args ) BGColor( "reset", "all" ); end
RBCMenu.Items:Add( RBCMenu2 );



--- Main menu
TitanBarMenu = Turbine.UI.ContextMenu();
TitanBarMenu.items = TitanBarMenu:GetItems();

local opt_line = Turbine.UI.MenuItem("---------------------------------------------", false);
local opt_empty = Turbine.UI.MenuItem("", false);

opt_WI = Turbine.UI.MenuItem(L["MBag"]);
opt_WI:SetChecked( ShowWallet );
opt_WI.Click = function( sender, args ) ShowHideWallet(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_BI = Turbine.UI.MenuItem(L["MBI"]);
opt_BI:SetChecked( ShowBagInfos );
opt_BI.Click = function( sender, args ) ShowHideBackpackInfos(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_PI = Turbine.UI.MenuItem(L["MPI"]);
opt_PI:SetChecked( ShowPlayerInfos );
opt_PI.Click = function( sender, args ) ShowHidePlayerInfos(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_EI = Turbine.UI.MenuItem(L["MEI"]);
opt_EI:SetChecked( ShowEquipInfos );
ShowEquipInfos = false;  -- Remove when GetEquipment() in API work properly
opt_EI:SetEnabled( ShowEquipInfos ); -- Remove when GetEquipment() in API work properly
opt_EI.Click = function( sender, args )	ShowHideEquipInfos(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_DI = Turbine.UI.MenuItem(L["MDI"]);
opt_DI:SetChecked( ShowDurabilityInfos );
ShowDurabilityInfos = false;  -- Remove when GetEquipment() in API work properly
opt_DI:SetEnabled( ShowDurabilityInfos ); -- Remove when GetEquipment() in API work properly
opt_DI.Click = function( sender, args )	ShowHideDurabilityInfos(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_PL = Turbine.UI.MenuItem(L["MPL"]);
opt_PL:SetChecked( ShowPlayerLoc );
opt_PL.Click = function( sender, args ) ShowHidePlayerLoc(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_TI = Turbine.UI.MenuItem(L["MTI"]);
opt_TI:SetChecked( ShowTrackItems );
opt_TI.Click = function( sender, args ) ShowHideTrackItems(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_IF = Turbine.UI.MenuItem(L["IFWTitle"]);
opt_IF:SetChecked( ShowInfamy );
opt_IF.Click = function( sender, args ) ShowHideInfamy(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_GT = Turbine.UI.MenuItem(L["MGT"]);
opt_GT:SetChecked( ShowGameTime );
opt_GT.Click = function( sender, args ) ShowHideGameTime(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_VT = Turbine.UI.MenuItem( L["MVault"] );
opt_VT:SetChecked( ShowVault );
opt_VT.Click = function( sender, args ) ShowHideVault(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_SS = Turbine.UI.MenuItem( L["MStorage"] );
opt_SS:SetChecked( ShowSharedStorage );
opt_SS.Click = function( sender, args ) ShowHideSharedStorage(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

--opt_BK = Turbine.UI.MenuItem( L["MBank"] );
--opt_BK:SetChecked( ShowBank );
--opt_BK.Click = function( sender, args ) ShowHideBank(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_DN = Turbine.UI.MenuItem( L["MDayNight"] );
opt_DN:SetChecked( ShowDayNight );
opt_DN.Click = function( sender, args ) ShowHideDayNight(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_RP = Turbine.UI.MenuItem( L["MReputation"] );
opt_RP:SetChecked( ShowReputation );
opt_RP.Click = function( sender, args ) ShowHideReputation(); TitanBarMenu:ShowMenuAt(mouseXPos, mouseYPos); end

opt_options = Turbine.UI.MenuItem(L["MOP"]);
opt_options.Click = function( sender, args ) import (AppDirD.."frmOptions"); frmOptions(); opt_options:SetEnabled( false ); end

option_backcolor = Turbine.UI.MenuItem(L["MBG"]);
option_backcolor.Click = function( sender, args ) import (AppDirD.."background"); frmBackground(); option_backcolor:SetEnabled( false ); end

opt_profile = Turbine.UI.MenuItem(L["MPP"]);
opt_profile.Click = function( sender, args ) import (AppDirD.."profile"); frmProfile(); opt_profile:SetEnabled( false ); end

opt_shellcmd = Turbine.UI.MenuItem(L["MSC"]);
opt_shellcmd.Click = function( sender, args ) HelpInfo(); end

local opt_ResetAllSet = Turbine.UI.MenuItem(L["MRA"]);
opt_ResetAllSet.Click = function( sender, args ) ResetSettings(); end

local opt_unload = Turbine.UI.MenuItem(L["MUTB"] .. " TitanBar " .. Version);
opt_unload.Click = function( sender, args ) UnloadTitanBar(); end

local opt_reload = Turbine.UI.MenuItem(L["MRTB"] .. " TitanBar " .. Version);
opt_reload.Click = function( sender, args ) ReloadTitanBar(); end

local opt_about = Turbine.UI.MenuItem(L["MATB"] .. " TitanBar " .. Version);
opt_about.Click = function( sender, args ) AboutTitanBar(); end



TitanBarMenu.items:Add(opt_WI);
TitanBarMenu.items:Add(opt_BI);
TitanBarMenu.items:Add(opt_PI);
if PlayerAlign == 1 then TitanBarMenu.items:Add(opt_EI); end -- only show if in Free People mode
if PlayerAlign == 1 then TitanBarMenu.items:Add(opt_DI); end -- only show if in Free People mode
TitanBarMenu.items:Add(opt_PL);
TitanBarMenu.items:Add(opt_TI);
TitanBarMenu.items:Add(opt_IF);
TitanBarMenu.items:Add(opt_GT);
if PlayerAlign == 1 then TitanBarMenu.items:Add(opt_VT); end -- only show if in Free People mode
if PlayerAlign == 1 then TitanBarMenu.items:Add(opt_SS); end -- only show if in Free People mode
--if PlayerAlign == 1 then TitanBarMenu.items:Add(opt_BK); end -- only show if in Free People mode
TitanBarMenu.items:Add(opt_DN);
if PlayerAlign == 1 then TitanBarMenu.items:Add(opt_RP); end -- only show if in Free People mode
TitanBarMenu.items:Add(opt_line);
TitanBarMenu.items:Add(opt_options);
TitanBarMenu.items:Add(option_backcolor);
TitanBarMenu.items:Add(RBCMenu);
TitanBarMenu.items:Add(opt_empty);
TitanBarMenu.items:Add(LocMenu);
TitanBarMenu.items:Add(opt_empty);
TitanBarMenu.items:Add(opt_profile);
TitanBarMenu.items:Add(opt_shellcmd);
TitanBarMenu.items:Add(opt_ResetAllSet);
TitanBarMenu.items:Add(opt_empty);
TitanBarMenu.items:Add(opt_unload);
TitanBarMenu.items:Add(opt_reload);
--TitanBarMenu.items:Add(opt_empty); --Add when about function in plugin manager is available
--TitanBarMenu.items:Add(opt_about); --Add when about function in plugin manager is available