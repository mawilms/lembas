-- Main.lua
-- Originally written by Rod, extended by Habna


import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.Gameplay";

Version = Plugins["HugeBag"]:GetVersion();--> ** HugeBag current version **

AllVisible = true; --> All items are visible by default
IsSorting, IsMixing, IsMerging, IsMoving = false, false, false, false;
screenWidth, screenHeight = Turbine.UI.Display.GetSize(); --> ** Get the display size **
write = Turbine.Shell.WriteLine; --> To shorten the writeline command
debug = false; --Enable some stuff for debug purpose

--**v Detect Game Language v**
-- Legend: 0 = invalid / 2 = English / 268435457 = EnglishGB / 268435459 = Francais / 268435460 = Deutsch / 268435463 = Russian
GLocale = Turbine.Engine.GetLanguage();
if GLocale == 0 or GLocale == 2 or GLocale == 268435457 then GLocale = "en";
elseif GLocale == 268435459 then GLocale = "fr";
elseif GLocale == 268435460 then GLocale = "de"; end
--elseif GLocale == 268435463 then GLocale = "ru"; end
--GLocale = "de"; --debug purpose
--**^

HugeBagMode = Turbine.PluginData.Load( Turbine.DataScope.Character, "HugeBagMode" );
if HugeBagMode == nil then	HugeBagMode = {}; end
if HugeBagMode.Widget == nil then HugeBagMode.Widget = true; end
Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagMode", HugeBagMode );

Widget = HugeBagMode.Widget;


AppDir = "HabnaPlugins.HugeBag";
AppDirD = AppDir..".";

AppClassD = AppDirD.."Class.";
AppCtrD = AppDirD.."Control.";
AppLocaleD = AppDirD.."Locale.";
AppRes = "HabnaPlugins/TitanBar/Resources/";

-- import for both mode
import (AppDir);
import (AppClassD.."Class");

--**v Get player instance v**
Player = Turbine.Gameplay.LocalPlayer.GetInstance();
vaultpack = Player:GetVault();
sspack = Player:GetSharedStorage();
--bankpack = Player:GetBank();
Backpack = Player:GetBackpack();
backpackSize = Backpack:GetSize();
PN = Player:GetName();
PlayerAlign = Player:GetAlignment(); --1: Free People / 2: Monster Play
--**

PlayerVault = Turbine.PluginData.Load( Turbine.DataScope.Server, "HugeBagVault" );
if PlayerVault == nil then PlayerVault = {}; end
if PlayerVault[PN] == nil then PlayerVault[PN] = {}; end

PlayerSharedStorage = Turbine.PluginData.Load( Turbine.DataScope.Server, "HugeBagSharedStorage" );
if PlayerSharedStorage == nil then PlayerSharedStorage = {}; end

PlayerBags = Turbine.PluginData.Load( Turbine.DataScope.Server, "HugeBagBags" );
if PlayerBags == nil then PlayerBags = {}; end
if PlayerBags[PN] == nil then PlayerBags[PN] = {}; end


if Widget then import "HabnaPlugins.HugeBag.settingsWidget";
else import "HabnaPlugins.HugeBag.settingsWindow"; end
LoadSettings();

import (AppDirD.."color"); -- LUA color file
import (AppDirD.."functions"); -- LUA functions file
import (AppDirD.."sortingList"); -- LUA sorting list file
import (AppDirD.."sort"); -- LUA Sort file
import (AppDirD.."mix"); -- LUA Mix file
import (AppDirD.."merge"); -- LUA Merge file
import (AppDirD.."itemsmenu"); -- LUA items Menu file
import (AppDirD.."OptionPanel"); -- LUA option panel file (for in-game plugin manage options tab)

AddCallback(vaultpack, "CountChanged", function(sender, args) SavePlayerVault(); end);
AddCallback(sspack, "CountChanged", function(sender, args) SavePlayerSharedStorage(); end);

if Widget then import (AppDirD.."mainWidget");
else import (AppDirD.."mainWindow"); end
frmMain();

HugeBagCommand = Turbine.ShellCommand();

function HugeBagCommand:Execute( command, arguments )
	-- Commands for both mode
	if ( arguments == L["SCa1"] or arguments == "shb") then
		ShowHugeBag();
	elseif ( arguments == L["SCa2"] or arguments == "hhb") then
		HideHugeBag();
	elseif ( arguments == L["SCa3"] or arguments == "u") then
		UnloadHugeBag();
	elseif ( arguments == L["SCa4"] or arguments == "r") then
		ReloadHugeBag();
	elseif ( arguments == L["SCa5"] or arguments == "ra" ) then
		ResetSettings();
	elseif ( arguments == L["SCa6"] or arguments == "w" ) then
		ToggleWEsc();
	elseif ( arguments == L["SCa7"] or arguments == "v" ) then
		ToggleShow();
	elseif ( arguments == L["SCa8"] or arguments == "hbm" ) then
		ToggleMode();
	elseif ( arguments == L["SCa9"] or arguments == "aot" ) then
		ToggleAlwaysOnTop();
	elseif ( arguments == L["SCa10"] or arguments == "bv" ) then
		ToggleBotBarInfo("butvis");
	elseif ( arguments == L["SCa11"] or arguments == "si" ) then
		Sort();
	elseif ( arguments == L["SCa12"] or arguments == "mi" ) then
		Merge();
	elseif ( arguments == L["SCa13"] or arguments == "im" ) then
		InvMerge();
	elseif ( arguments == L["SCa14"] or arguments == "?" or arguments == "sc" ) then
		HelpInfo();
	elseif ( arguments == L["SCa15"] or arguments == "opt" ) then
		ShowOptionsMenu("nil");
	elseif ( arguments == L["SCa16"] or arguments == "sbv" ) then
		ToggleBotBarInfo("sortvis");
	elseif ( arguments == L["SCa17"] or arguments == "mbv" ) then
		ToggleBotBarInfo("mergevis");
	elseif ( arguments == L["SCa18"] or arguments == "ebv" ) then
		ToggleBotBarInfo("searchvis");
	elseif ( arguments == L["SCa24"] or arguments == "bbv" ) then
		ToggleBotBarInfo("bagsvis");
	elseif ( arguments == L["SCa25"] or arguments == "vbv" ) then
		ToggleBotBarInfo("vaultvis");
	elseif ( arguments == L["SCa26"] or arguments == "hbv" ) then
		ToggleBotBarInfo("ssvis");
	elseif ( arguments == L["SCa27"] or arguments == "sbb" ) then
		ToggleBotBarInfo("sbbit");
	elseif ( arguments == L["SCa19"] or arguments == "bp" ) then
		ViewVaultStorageBags( "bags" );
	elseif ( arguments == L["SCa20"] or arguments == "vt" ) then
		ViewVaultStorageBags( "vault" );
	elseif ( arguments == L["SCa21"] or arguments == "ss" ) then
		ViewVaultStorageBags( "storage" );
	elseif ( arguments == L["SCa22"] or arguments == "lp" ) then
		ApplyProfileSettings( true );
	elseif ( arguments == L["SCa23"] or arguments == "sp" ) then
		SaveProfileSettings( true );
	elseif ( arguments == "mix" ) then
		Mix();
	elseif ( arguments == "debug" ) then
		import (AppDirD.."debugwin");
		frmDebug();
	else
		SCNS = true;
	end

	if Widget then -- Commands for widget mode
		--if ( arguments == L["WidSCa1"] or arguments == "" ) then
			
		--else
			if SCNS then ShowNS = true; end
		--end
	else -- Commands for window mode
		if ( arguments == L["WinSCa1"] or arguments == "rls" ) then
			ResetLSSettings();
		elseif ( arguments == L["WinSCa2"] or arguments == "sk" ) then
			ToggleSkin();
		elseif ( arguments == L["WinSCa3"] or arguments == "io" ) then
			ToggleItemsOrientation();
		elseif ( arguments == L["WinSCa4"] or arguments == "ls" ) then
			LockHugeBagSize();
		elseif ( arguments == L["WinSCa5"] or arguments == "lp" ) then
			LockHugeBagPosition();
		elseif ( arguments == L["WinSCa6"] or arguments == "is" ) then
			ToggleIconSize();
		-- Disabled until i found a way to reverse the scrollbar in the same orientation (Top goes to bottom, bottom goes to top)
		--elseif ( arguments == "reversefill" ) then
			--ToggleItemsReverseFill();
		else
			if SCNS then ShowNS = true; end
		end
	end
	
	if ShowNS then write( "HugeBag: " .. L["SC0"] ); SCNS= nil; ShowNS = nil; end -- Command not supported
end

Turbine.Shell.AddCommand( "HugeBag", HugeBagCommand );

Turbine.UI.Lotro.LotroUI.SetEnabled( 1, false ); -- Backpack1
Turbine.UI.Lotro.LotroUI.SetEnabled( 2, false ); -- Backpack2
Turbine.UI.Lotro.LotroUI.SetEnabled( 3, false ); -- Backpack3
Turbine.UI.Lotro.LotroUI.SetEnabled( 4, false ); -- Backpack4
Turbine.UI.Lotro.LotroUI.SetEnabled( 5, false ); -- Backpack5
Turbine.UI.Lotro.LotroUI.SetEnabled( 6, false ); -- Backpack6

Turbine.Plugin.Load = function( self, sender, args )
	--write( L["HBLang"] ); --HugeBag Language
	--write( L["HBLoad"] ); --HugeBag version by Habna loaded!
end

Turbine.Plugin.Unload = function( self, sender, args )
	Turbine.UI.Lotro.LotroUI.SetEnabled( 1, true ); -- Backpack1
	Turbine.UI.Lotro.LotroUI.SetEnabled( 2, true ); -- Backpack2
	Turbine.UI.Lotro.LotroUI.SetEnabled( 3, true ); -- Backpack3
	Turbine.UI.Lotro.LotroUI.SetEnabled( 4, true ); -- Backpack4
	Turbine.UI.Lotro.LotroUI.SetEnabled( 5, true ); -- Backpack5
	Turbine.UI.Lotro.LotroUI.SetEnabled( 6, true ); -- Backpack6
	
	SavePlayerBags();
end