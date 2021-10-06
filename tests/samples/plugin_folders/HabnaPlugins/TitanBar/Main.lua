-- Main.lua
-- written by Habna


import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.Gameplay";

AppDir = "HabnaPlugins.TitanBar";
AppDirD = AppDir..".";

AppClassD = AppDirD.."Class.";
AppCtrD = AppDirD.."Control.";
AppLocaleD = AppDirD.."Locale.";
AppRes = "HabnaPlugins/TitanBar/Resources/";

Version = Plugins["TitanBar"]:GetVersion(); --> ** TitanBar current version **
_G.TB = {};
FactionOrder = { 1,2,3,4,15,16,5,6,7,8,17,18,9,10,11,12,19,20,13,14,21,22,30,31,32,33,34,35,36,37,23,24,25,26,27,28,29 };
WalletOrder = { 1,2,3,4,5,6,7,8 };
maxfaction = 30; --number of faction in my db
maxgfaction = 7; --number of guild faction in my db
maxrank = 17; -- number of guild faction rank
windowOpen = true;
_G.Debug = false; -- True will enable some functions when i'm debuging

-- BlendMode 1: Color / 2: Normal / 3: Multiply / 4: AlphaBlend / 5: Overlay / 6: Grayscale / 7: Screen / 8: Undefined

-- [FontName]={[Fontzise]=pixel needed to show one number}
_G.FontN = {
	["Arial"] = {[12]=6},
	["TrajanPro"] = {[13]=7,[14]=7,[15]=7,[16]=8,[18]=9,[19]=10,[20]=10,[21]=11,[23]=11,[24]=11,[25]=7,[26]=12,[28]=13},
	["TrajanProBold"] = {[16]=9,[22]=11,[24]=12,[25]=13,[30]=15,[36]=18},
	["Verdana"] = {[10]=5,[12]=7,[14]=8,[16]=8,[18]=12,[20]=12,[22]=12,[23]=13}
	};

-- [FontName]={[Fontzise]=pixel needed to show one letter}
_G.FontT = {
	["Arial"] = {[12]=6},
	["TrajanPro"] = {[13]=8,[14]=9,[15]=9,[16]=10,[18]=11,[19]=12,[20]=12,[21]=13,[23]=14,[24]=15,[25]=7,[26]=16,[28]=17},
	["TrajanProBold"] = {[16]=10,[22]=14,[24]=15,[25]=16,[30]=19,[36]=22},
	["Verdana"] = {[10]=5.5,[12]=7,[14]=8,[16]=9,[18]=10,[20]=11,[22]=12,[23]=12}
	};

resources = {
	Ring = { Icon = AppRes.."ring.tga" },
	Picker = { Background = AppRes.."picker.jpg" }, --Color picker picture (240px x 71px)

	Seal = { Icon = AppRes.."seal.tga" }, -- Removed when found in-game 32x32 icon
	TP = { Icon = AppRes.."tp.tga" }, -- Removed when found in-game 32x32 icon

	RuneKeeper = { Icon = AppRes.."runekeeper.tga" }, -- Removed when found in-game icon
	RuneKeeper_Small = { Icon = AppRes.."runekeeper_small.tga" }, -- Removed when found in-game icon
	Warden = { Icon = AppRes.."warden.tga" }, -- Removed when found in-game icon
	Warden_Small = { Icon = AppRes.."warden_small.tga" }, -- Removed when found in-game icon
	Defiler = { Icon = AppRes.."defiler.tga" }, -- Removed when found in-game icon
	Defiler_Small = { Icon = AppRes.."defiler_small.tga" }, -- Removed when found in-game icon

	Item = { Background = AppRes.."slotBackground.tga" } -- Removed when found in-game icon
};

screenWidth, screenHeight = Turbine.UI.Display.GetSize();
write = Turbine.Shell.WriteLine;

--**v Get player instance v**
Player = Turbine.Gameplay.LocalPlayer.GetInstance();
vaultpack = Player:GetVault();
sspack = Player:GetSharedStorage();
backpack = Player:GetBackpack();
PN = Player:GetName();
PlayerAlign = Player:GetAlignment(); --1: Free People / 2: Monster Play
--PlayerAlign = 2;--debug purpose
--bankpack = Player:GetBank();
--PlayerMount = Player:GetMount();
--PlayerPet = Player:GetPet();
--**

--**v Detect Game Language v**
-- Legend: 0 = invalid / 2 = English / 268435457 = EnglishGB / 268435459 = Francais / 268435460 = Deutsch / 268435463 = Russian
GLocale = Turbine.Engine.GetLanguage();
if GLocale == 0 or GLocale == 2 or GLocale == 268435457 then GLocale = "en";
elseif GLocale == 268435459 then GLocale = "fr";
elseif GLocale == 268435460 then GLocale = "de"; end
--elseif GLocale == 268435463 then GLocale = "ru"; end
--GLocale = "fr"; --debug purpose
--**^

import (AppClassD.."Class");
import (AppDir);
import (AppDirD.."color");
import (AppDirD.."settings");
LoadSettings();
import (AppDirD.."functions");
import (AppDirD.."functionsCtr");
import (AppDirD.."functionsMenu");
import (AppDirD.."functionsMenuControl");
import (AppDirD.."OptionPanel"); -- LUA option panel file (for in-game plugin manager options tab)
import (AppDirD.."menu");
import (AppDirD.."menuControl");
import (AppDirD.."frmMain");
frmMain();

if PlayerAlign == 1 then MenuItem = { L["MGSC"], L["MDP"], L["MSP"], L["MSM"], L["MMP"], L["MSL"], L["MCP"], L["MTP"] };
else MenuItem = { L["MCP"], L["MTP"] }; end

TitanBarCommand = Turbine.ShellCommand()

function TitanBarCommand:Execute( command, arguments )
	if ( arguments == L["SCa1"] or arguments == "opt") then
		TitanBarMenu:ShowMenu();
	elseif ( arguments == L["SCa2"] or arguments == "u" ) then
		UnloadTitanBar();
	elseif ( arguments == L["SCa3"] or arguments == "r" ) then
		ReloadTitanBar();
	elseif ( arguments == L["SCa4"] or arguments == "ra" ) then
		ResetSettings();
	elseif ( arguments == L["SCa5"] or arguments == "mi") then
		if PlayerAlign == 1 then if _G.MIWhere == 2 then _G.MIWhere = 1;
		else if ShowMoney then _G.MIWhere = 3; else _G.MIWhere = 1;	end end ShowHideMoney(); else ShowNS = true; end
	elseif ( arguments == L["SCa6"] or arguments == "dp") then
		if PlayerAlign == 1 then if _G.DPWhere == 2 then _G.DPWhere = 1;
		else if ShowDestinyPoints then _G.DPWhere = 3; else _G.DPWhere = 1;	end end ShowHideDestinyPoints(); else ShowNS = true; end
	elseif ( arguments == L["SCa7"] or arguments == "bi" ) then
		ShowHideBackpackInfos();
	elseif ( arguments == L["SCa8"] or arguments == "pi" ) then
		ShowHidePlayerInfos();
	elseif ( arguments == L["SCa9"] or arguments == "ei" ) then
		if PlayerAlign == 1 then ShowHideEquipInfos(); else ShowNS = true; end
	elseif ( arguments == L["SCa10"] or arguments == "di" ) then
		if PlayerAlign == 1 then  ShowHideDurabilityInfos(); else ShowNS = true; end
	elseif ( arguments == L["SCa11"] or arguments == "pl" ) then
		ShowHidePlayerLoc();
	elseif ( arguments == L["SCa12"] or arguments == "gt" ) then
		ShowHideGameTime();
	elseif ( arguments == L["SCa13"] or arguments == "?" or arguments == "sc" ) then
		HelpInfo();
	elseif ( arguments == L["SCa14"] or arguments == "sp") then
		if PlayerAlign == 1 then if _G.SPWhere == 2 then _G.SPWhere = 1;
		else if ShowShards then _G.SPWhere = 3; else _G.SPWhere = 1; end end ShowHideShards(); else ShowNS = true; end
	elseif ( arguments == L["SCa15"] or arguments == "sm") then
		if PlayerAlign == 1 then if _G.SMWhere == 2 then _G.SMWhere = 1;
		else if ShowSkirmishMarks then _G.SMWhere = 3; else _G.SMWhere = 1;	end end ShowHideSkirmishMarks(); else ShowNS = true; end
	elseif ( arguments == L["SCa16"] or arguments == "mp") then
		if PlayerAlign == 1 then if _G.MPWhere == 2 then _G.MPWhere = 1;
		else if ShowMedallions then _G.MPWhere = 3; else _G.MPWhere = 1; end end ShowHideMedallions(); else ShowNS = true; end
	elseif ( arguments == L["SCa17"] or arguments == "sl") then
		if PlayerAlign == 1 then if _G.SLWhere == 2 then _G.SLWhere = 1;
		else if ShowSeals then _G.SLWhere = 3; else _G.SLWhere = 1;	end end ShowHideSeals(); else ShowNS = true; end
	elseif ( arguments == L["SCa18"] or arguments == "cp") then
		if _G.CPWhere == 2 then _G.CPWhere = 1;
		else if ShowCommendations then _G.CPWhere = 3; else _G.CPWhere = 1;	end end
		ShowHideCommendations();
	elseif ( arguments == L["SCa19"] or arguments == "ir" ) then
		ShowHideInfamy();
	elseif ( arguments == L["SCa20"] or arguments == "vt" ) then
		if PlayerAlign == 1 then ShowHideVault(); else ShowNS = true; end
	elseif ( arguments == L["SCa21"] or arguments == "ss" ) then
		if PlayerAlign == 1 then ShowHideSharedStorage(); else ShowNS = true; end
	elseif ( arguments == L["SCa22"] or arguments == "dn" ) then
		ShowHideDayNight();
	elseif ( arguments == L["SCa23"] or arguments == "ti" ) then
		if PlayerAlign == 1 then ShowHideTrackItems(); else ShowNS = true; end
	elseif ( arguments == L["SCa24"] or arguments == "rp" ) then
		if PlayerAlign == 1 then ShowHideReputation(); else ShowNS = true; end
	elseif ( arguments == L["SCa25"] or arguments == "tp") then
		if _G.TPWhere == 2 then _G.TPWhere = 1;
		else if ShowTurbinePoints then _G.TPWhere = 3; else _G.TPWhere = 1;	end end
		ShowHideTurbinePoints();
	elseif ( arguments == L["SCa26"] or arguments == "wi") then
		ShowHideWallet();
	--elseif ( arguments == L["SCa??"] or arguments == "bk" ) then
		--if PlayerAlign == 1 then ShowHideBank(); else ShowNS = true; end
	--elseif ( arguments == L["SCa??"] or arguments == "ab") then
		--AboutTitanBar();
	elseif ( arguments == "pw" ) then
		write("");
		write("This is your currency:");
		write("-----v----------------------");
		ShowTableContent(PlayerCurrency);
		write("-----^----------------------");
		write("You may request to add a currency if it's not listed in the wallet menu! Give the 'key' string to Habna so it can be added into futur version of TitanBar thx!");
		write("");
	else
		ShowNS = true;
	end

	if ShowNS then write( "TitanBar: " .. L["SC0"] ); ShowNS = nil; end -- Command not supported
end

Turbine.Shell.AddCommand('TitanBar', TitanBarCommand)

Turbine.Plugin.Load = function( self, sender, args )
	--write( L["TBLang"] ); --TitanBar Language
	--write( L["TBLoad"] ); --TitanBar version by Habna loaded!
end

Turbine.Plugin.Unload = function( self, sender, args )
	--write("Unloading TitanBar");
	SavePlayerMoney( true );
	SavePlayerBags();
end