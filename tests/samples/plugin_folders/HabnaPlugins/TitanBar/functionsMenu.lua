-- functionsMenu.lua
-- Written By Habna


--**v Functions for the menu v**

-- **v Show/Hide Wallet v**
function ShowHideWallet()
	ShowWallet = not ShowWallet;
	settings.Wallet.V = ShowWallet;
	SaveSettings( false );
	if ShowWallet then
		--write( "TitanBar: Showing wallet control");
		ImportCtr( "WI" );
		WI["Ctr"]:SetBackColor( Turbine.UI.Color( WIbcAlpha, WIbcRed, WIbcGreen, WIbcBlue ) );
	else
		--write( "TitanBar: Hiding wallet control");
		if _G.frmWI then wWI:Close(); end
	end
	WI["Ctr"]:SetVisible( ShowWallet );
	opt_WI:SetChecked( ShowWallet );
end
-- **^
-- **v Show/Hide Money v**
function ShowHideMoney()
	ShowMoney = not ShowMoney;
	settings.Money.V = ShowMoney;
	settings.Money.W = string.format("%.0f", _G.MIWhere);
	SaveSettings( false );
	ImportCtr( "MI" );
	if ShowMoney then
		--write( "TitanBar: Showing money");
		--ImportCtr( "MI" );
		MI["Ctr"]:SetBackColor( Turbine.UI.Color( MIbcAlpha, MIbcRed, MIbcGreen, MIbcBlue ) );
	else
		--write( "TitanBar: Hiding money");
		if _G.frmMI then wMI:Close(); end
	end
	MI["Ctr"]:SetVisible( ShowMoney );
end
-- **^
-- **v Show/Hide Destiny Points v**
function ShowHideDestinyPoints()
	ShowDestinyPoints = not ShowDestinyPoints;
	settings.DestinyPoints.V = ShowDestinyPoints;
	settings.DestinyPoints.W = string.format("%.0f", _G.DPWhere);
	SaveSettings( false );
	ImportCtr( "DP" );
	if ShowDestinyPoints then
		--write( "TitanBar: Showing Destiny Points");
		--ImportCtr( "DP" );
		DP["Ctr"]:SetBackColor( Turbine.UI.Color( DPbcAlpha, DPbcRed, DPbcGreen, DPbcBlue ) );
	--else
		--write( "TitanBar: Hiding Destiny Points");
	end
	DP["Ctr"]:SetVisible( ShowDestinyPoints );
end
-- **^
-- **v Show/Hide Shards v**
function ShowHideShards()
	ShowShards = not ShowShards;
	settings.Shards.V = ShowShards;
	settings.Shards.W = string.format("%.0f", _G.SPWhere);
	SaveSettings( false );
	ImportCtr( "SP" );
	if ShowShards then
		--write( "TitanBar: Showing Shards");
		--ImportCtr( "SP" );
		SP["Ctr"]:SetBackColor( Turbine.UI.Color( SPbcAlpha, SPbcRed, SPbcGreen, SPbcBlue ) );
	--else
		--write( "TitanBar: Hiding Shards");
	end
	SP["Ctr"]:SetVisible( ShowShards );
end
-- **^
-- **v Show/Hide Skirmish marks v**
function ShowHideSkirmishMarks()
	ShowSkirmishMarks = not ShowSkirmishMarks;
	settings.SkirmishMarks.V = ShowSkirmishMarks;
	settings.SkirmishMarks.W = string.format("%.0f", _G.SMWhere);
	SaveSettings( false );
	ImportCtr( "SM" );
	if ShowSkirmishMarks then
		--write( "TitanBar: Showing Skirmish marks");
		--ImportCtr( "SM" );
		SM["Ctr"]:SetBackColor( Turbine.UI.Color( SMbcAlpha, SMbcRed, SMbcGreen, SMbcBlue ) );
	--else
		--write( "TitanBar: Hiding Skirmish marks");
	end
	SM["Ctr"]:SetVisible( ShowSkirmishMarks );
end
-- **^
-- **v Show/Hide Medallions v**
function ShowHideMedallions()
	ShowMedallions = not ShowMedallions;
	settings.Medallions.V = ShowMedallions;
	settings.Medallions.W = string.format("%.0f", _G.MPWhere);
	SaveSettings( false );
	ImportCtr( "MP" );
	if ShowMedallions then
		--write( "TitanBar: Showing Medallions");
		--ImportCtr( "MP" );
		MP["Ctr"]:SetBackColor( Turbine.UI.Color( MPbcAlpha, MPbcRed, MPbcGreen, MPbcBlue ) );
	--else
		--write( "TitanBar: Hiding Medallions");
	end
	MP["Ctr"]:SetVisible( ShowMedallions );
end
-- **^
-- **v Show/Hide Seals v**
function ShowHideSeals()
	ShowSeals = not ShowSeals;
	settings.Seals.V = ShowSeals;
	settings.Seals.W = string.format("%.0f", _G.SLWhere);
	SaveSettings( false );
	ImportCtr( "SL" );
	if ShowSeals then
		--write( "TitanBar: Showing ShowSeals");
		--ImportCtr( "SL" );
		SL["Ctr"]:SetBackColor( Turbine.UI.Color( SLbcAlpha, SLbcRed, SLbcGreen, SLbcBlue ) );
	--else
		--write( "TitanBar: Hiding ShowSeals");
	end
	SL["Ctr"]:SetVisible( ShowSeals );
end
-- **^
-- **v Show/Hide Commendations v**
function ShowHideCommendations()
	ShowCommendations = not ShowCommendations;
	settings.Commendations.V = ShowCommendations;
	settings.Commendations.W = string.format("%.0f", _G.CPWhere);
	SaveSettings( false );
	ImportCtr( "CP" );
	if ShowCommendations then
		--write( "TitanBar: Showing Commendations");
		--ImportCtr( "CP" );
		CP["Ctr"]:SetBackColor( Turbine.UI.Color( CPbcAlpha, CPbcRed, CPbcGreen, CPbcBlue ) );
	--else
		--write( "TitanBar: Hiding Commendations");
	end
	CP["Ctr"]:SetVisible( ShowCommendations );
end
-- **^
-- **v Show/Hide Turbine Points v**
function ShowHideTurbinePoints()
	ShowTurbinePoints = not ShowTurbinePoints;
	settings.TurbinePoints.V = ShowTurbinePoints;
	settings.TurbinePoints.W = string.format("%.0f", _G.TPWhere);
	SaveSettings( false );
	ImportCtr( "TP" );
	if ShowTurbinePoints then
		--write( "TitanBar: Showing Trubine Points");
		--ImportCtr( "TP" );
		TP["Ctr"]:SetBackColor( Turbine.UI.Color( TPbcAlpha, TPbcRed, TPbcGreen, TPbcBlue ) );
	else
		--write( "TitanBar: Hiding Turbine Points");
		if _G.frmTP then wTP:Close(); end
	end
	TP["Ctr"]:SetVisible( ShowTurbinePoints );
end
-- **^
-- **v Show/Hide backpack Infos v**
function ShowHideBackpackInfos()
	ShowBagInfos = not ShowBagInfos;
	settings.BagInfos.V = ShowBagInfos;
	SaveSettings( false );
	if ShowBagInfos then
		--write( "TitanBar: Showing backpack infos");
		ImportCtr( "BI" );
		BI["Ctr"]:SetBackColor( Turbine.UI.Color( BIbcAlpha, BIbcRed, BIbcGreen, BIbcBlue ) );
	else
		--write( "TitanBar: Hiding backpack infos");
		RemoveCallback(backpack, "ItemAdded");
		RemoveCallback(backpack, "ItemRemoved");
		if _G.frmBI then wBI:Close(); end
	end
	BI["Ctr"]:SetVisible( ShowBagInfos );
	opt_BI:SetChecked( ShowBagInfos );
end
--**^
-- **v Show/Hide backpack Infos v**
function ShowHidePlayerInfos()
	ShowPlayerInfos = not ShowPlayerInfos;
	settings.PlayerInfos.V = ShowPlayerInfos;
	SaveSettings( false );
	if ShowPlayerInfos then
		--write( "TitanBar: Showing player infos");
		ImportCtr( "PI" );
		PI["Ctr"]:SetBackColor( Turbine.UI.Color( PIbcAlpha, PIbcRed, PIbcGreen, PIbcBlue ) );
	else
		--write( "TitanBar: Hiding player infos");
		RemoveCallback(Player, "LevelChanged");
		RemoveCallback(Player, "NameChanged");
		RemoveCallback(Turbine.Chat, "Received", XPcb);
	end
	PI["Ctr"]:SetVisible( ShowPlayerInfos );
	opt_PI:SetChecked( ShowPlayerInfos );
end
--**^
-- **v Show/Hide equipment Infos v**
function ShowHideEquipInfos()
	ShowEquipInfos = not ShowEquipInfos;
	settings.EquipInfos.V = ShowEquipInfos;
	SaveSettings( false );
	if ShowEquipInfos then
		--write( "TitanBar: Showing equipment infos");
		GetEquipmentInfos();
		AddCallback(PlayerEquipment, "ItemEquipped", function(sender, args) if ShowEquipInfos then GetEquipmentInfos(); UpdateEquipsInfos(); end end);
		AddCallback(PlayerEquipment, "ItemUnequipped", function(sender, args) ItemUnEquippedTimer:SetWantsUpdates( true ); end); --Workaround
		--AddCallback(PlayerEquipment, "ItemUnequipped", function(sender, args) if ShowEquipInfos then GetEquipmentInfos(); UpdateEquipsInfos(); end if ShowDurabilityInfos then GetEquipmentInfos(); UpdateDurabilityInfos(); end end);
		ImportCtr( "EI" );
		EI["Ctr"]:SetBackColor( Turbine.UI.Color( EIbcAlpha, EIbcRed, EIbcGreen, EIbcBlue ) );
	else
		--write( "TitanBar: Hiding equipment infos");
		RemoveCallback(PlayerEquipment, "ItemEquipped");
		RemoveCallback(PlayerEquipment, "ItemUnequipped");
		if _G.frmEI then wEI:Close(); end
	end
	EI["Ctr"]:SetVisible( ShowEquipInfos );
	opt_EI:SetChecked( ShowEquipInfos );
end
--**^
-- **v Show/Hide durability Infos v**
function ShowHideDurabilityInfos()
	ShowDurabilityInfos = not ShowDurabilityInfos;
	settings.DurabilityInfos.V = ShowDurabilityInfos;
	SaveSettings( false );
	if ShowDurabilityInfos then
		--write( "TitanBar: Showing durability infos");
		GetEquipmentInfos();
		AddCallback(PlayerEquipment, "ItemEquipped", function(sender, args) if ShowEquipInfos then GetEquipmentInfos(); UpdateEquipsInfos(); end if ShowDurabilityInfos then GetEquipmentInfos(); UpdateDurabilityInfos(); end end);
		AddCallback(PlayerEquipment, "ItemUnequipped", function(sender, args) ItemUnEquippedTimer:SetWantsUpdates( true ); end); --Workaround
		--AddCallback(PlayerEquipment, "ItemUnequipped", function(sender, args) if ShowEquipInfos then GetEquipmentInfos(); UpdateEquipsInfos(); end if ShowDurabilityInfos then GetEquipmentInfos(); UpdateDurabilityInfos(); end end);
		ImportCtr( "DI" );
		DI["Ctr"]:SetBackColor( Turbine.UI.Color( DIbcAlpha, DIbcRed, DIbcGreen, DIbcBlue ) );
	else
		--write( "TitanBar: Hiding durability infos");
		RemoveCallback(PlayerEquipment, "ItemEquipped");
		RemoveCallback(PlayerEquipment, "ItemUnequipped");
		if _G.frmDI then wDI:Close(); end
	end
	DI["Ctr"]:SetVisible( ShowDurabilityInfos );
	opt_DI:SetChecked( ShowDurabilityInfos );
end
--**^
-- **v Show/Hide Tracked Items Infos v**
function ShowHideTrackItems()
	ShowTrackItems = not ShowTrackItems;
	settings.TrackItems.V = ShowTrackItems;
	SaveSettings( false );
	if ShowTrackItems then
		--write( "TitanBar: Showing tracked items");
		ImportCtr( "TI" );
		TI["Ctr"]:SetBackColor( Turbine.UI.Color( TIbcAlpha, TIbcRed, TIbcGreen, TIbcBlue ) );
	else
		--write( "TitanBar: Hiding tracked items");
		if _G.frmTI then wTI:Close(); end
	end
	TI["Ctr"]:SetVisible( ShowTrackItems );
	opt_TI:SetChecked( ShowTrackItems );
end
--**^
-- **v Show/Hide Infamy v**
function ShowHideInfamy()
	ShowInfamy = not ShowInfamy;
	settings.Infamy.V = ShowInfamy;
	SaveSettings( false );
	if ShowInfamy then
		--write( "TitanBar: Showing Infamy");
		ImportCtr( "IF" );
		IF["Ctr"]:SetBackColor( Turbine.UI.Color( IFbcAlpha, IFbcRed, IFbcGreen, IFbcBlue ) );
	else
		--write( "TitanBar: Hiding Infamy");
		RemoveCallback(Turbine.Chat, "Received", IFcb);
		if _G.frmIF then wIF:Close(); end
	end
	IF["Ctr"]:SetVisible( ShowInfamy );
	opt_IF:SetChecked( ShowInfamy );
end
-- **^
-- **v Show/Hide Vault v**
function ShowHideVault()
	ShowVault = not ShowVault;
	settings.Vault.V = ShowVault;
	SaveSettings( false );
	if ShowVault then
		--write( "TitanBar: Showing vault");
		ImportCtr( "VT" );
		VT["Ctr"]:SetBackColor( Turbine.UI.Color( VTbcAlpha, VTbcRed, VTbcGreen, VTbcBlue ) );
	else
		--write( "TitanBar: Hiding vault");
		RemoveCallback(vaultpack, "CountChanged");
		if _G.frmVT then wVT:Close(); end
	end
	VT["Ctr"]:SetVisible( ShowVault );
	opt_VT:SetChecked( ShowVault );
end
-- **^
-- **v Show/Hide SharedStorage v**
function ShowHideSharedStorage()
	ShowSharedStorage = not ShowSharedStorage;
	settings.SharedStorage.V = ShowSharedStorage;
	SaveSettings( false );
	if ShowSharedStorage then
		--write( "TitanBar: Showing Shared Storage");
		ImportCtr( "SS" );
		SS["Ctr"]:SetBackColor( Turbine.UI.Color( SSbcAlpha, SSbcRed, SSbcGreen, SSbcBlue ) );
	else
		--write( "TitanBar: Hiding Shared Storage");
		RemoveCallback(sspack, "CountChanged");
		if _G.frmSS then wSS:Close(); end
	end
	SS["Ctr"]:SetVisible( ShowSharedStorage );
	opt_SS:SetChecked( ShowSharedStorage );
end
-- **^
-- **v Show/Hide Bank v**
function ShowHideBank()
	ShowBank = not ShowBank;
	settings.Bank.V = ShowBank;
	SaveSettings( false );
	if ShowBank then
		--write( "TitanBar: Showing Bank");
		ImportCtr( "BK" );
		BK["Ctr"]:SetBackColor( Turbine.UI.Color( BKbcAlpha, BKbcRed, BKbcGreen, BKbcBlue ) );
	else
		--write( "TitanBar: Hiding Bank");
	end
	BK["Ctr"]:SetVisible( ShowBank );
	opt_BK:SetChecked( ShowBank );
end
-- **^
-- **v Show/Hide Day & Night time v**
function ShowHideDayNight()
	ShowDayNight = not ShowDayNight;
	settings.DayNight.V = ShowDayNight;
	SaveSettings( false );
	if ShowDayNight then
		--write( "TitanBar: Showing Day & Night");
		ImportCtr( "DN" );
		DN["Ctr"]:SetBackColor( Turbine.UI.Color( DNbcAlpha, DNbcRed, DNbcGreen, DNbcBlue ) );
	else
		--write( "TitanBar: Hiding Day & Night");
		if _G.frmDN then wDN:Close(); end
	end
	DN["Ctr"]:SetVisible( ShowDayNight );
	opt_DN:SetChecked( ShowDayNight );
end
-- **^
-- **v Show/Hide Reputation v**
function ShowHideReputation()
	ShowReputation = not ShowReputation;
	settings.Reputation.V = ShowReputation;
	SaveSettings( false );
	if ShowReputation then
		--write( "TitanBar: Showing reputation");
		ImportCtr( "RP" );
		RP["Ctr"]:SetBackColor( Turbine.UI.Color( RPbcAlpha, RPbcRed, RPbcGreen, RPbcBlue ) );
	else
		--write( "TitanBar: Hiding reputation");
		RemoveCallback(Turbine.Chat, "Received", RPcb);
		if _G.frmRP then wRP:Close(); end
	end
	RP["Ctr"]:SetVisible( ShowReputation );
	opt_RP:SetChecked( ShowReputation );
end
-- **^

-- **v Show/Hide Player Location v**
function ShowHidePlayerLoc()
	ShowPlayerLoc = not ShowPlayerLoc;
	settings.PlayerLoc.V = ShowPlayerLoc;
	SaveSettings( false );
	if ShowPlayerLoc then
		ImportCtr( "PL" );
		PL["Ctr"]:SetBackColor( Turbine.UI.Color( PLbcAlpha, PLbcRed, PLbcGreen, PLbcBlue ) );
	else
		--write( "TitanBar: Hiding player location");
		RemoveCallback(Turbine.Chat, "Received", PLcb);
	end
	PL["Ctr"]:SetVisible( ShowPlayerLoc );
	opt_PL:SetChecked( ShowPlayerLoc );
end
--**^
-- **v Show/Hide Time v**
function ShowHideGameTime()
	ShowGameTime = not ShowGameTime;
	settings.GameTime.V = ShowGameTime;
	SaveSettings( false );
	if ShowGameTime then
		--write( "TitanBar: Showing time");
		ImportCtr( "GT" );
		GT["Ctr"]:SetBackColor( Turbine.UI.Color( GTbcAlpha, GTbcRed, GTbcGreen, GTbcBlue ) );
	else
		--write( "TitanBar: Hiding time");
		if _G.frmGT then wGT:Close(); end
	end
	GT["Ctr"]:SetVisible( ShowGameTime );
	opt_GT:SetChecked( ShowGameTime );
end
--**^
-- **v Profile load/Save v**
function LoadPlayerProfile()
	PProfile = Turbine.PluginData.Load( Turbine.DataScope.Account, "TitanBarPlayerProfile" );
	if PProfile == nil then PProfile = {}; end
end

function SavePlayerProfile()
	-- The table key is saved with "," in DE & FR client. Ex. [1,000000]. This cause a parse error.
	-- If you change [1,000000] to [1.000000] error not there anymore. [1] would be easier! Why all does zero!
	-- So Turbine save the table key in the client language but lua is unable to read it since "," is a special character.
	-- Turbine just have to save the key in english and the value in the client language.

	-- So i'm converting the key [1,000000] into a string like this ["1"]
	-- That's VindarPatch is doing, it convert the hole table into string (key and value)
	-- Me I only need to convert the key since value are already in the correct language format.
	local newt = {};
	for i, v in pairs(PProfile) do newt[tostring(i)] = v; end
	PProfile = newt;

	Turbine.PluginData.Save( Turbine.DataScope.Account, "TitanBarPlayerProfile", PProfile );
end
--**^
-- **v Show Shell Command window v**
function HelpInfo()
	if frmSC then
		wShellCmd:Close();
	else
		import(AppDirD.."shellcmd"); -- LUA shell command file
		frmShellCmd();
	end
end
-- **^
--**v Unload TitanBar v**
function UnloadTitanBar()
	--write( "TitanBar was unloaded" );
	Turbine.PluginManager.LoadPlugin( 'TitanBar Unloader' ); --workaround
	--Turbine.PluginManager.UnloadScriptState( 'TitanBar' );
end
--**^
--**v Reload TitanBar v**
function ReloadTitanBar()
	settings.TitanBar.Z = true;
	SaveSettings( false );
	--write("TitanBar was reloaded"); --Debug purpose
	Turbine.PluginManager.LoadPlugin( 'TitanBar Reloader' ); --workaround
	--UnloadTitanBar();
	--Turbine.PluginManager.LoadPlugin( 'TitanBar' );
end
--**^
--**v About TitanBar v**
function AboutTitanBar()
	--write( "TitanBar: About!" );
	--Turbine.PluginManager.ShowAbouts(Plugins.TitanBar); -- Add this when About is available
	--Turbine.PluginManager.ShowOptions(Plugins.TitanBar); --This will open plugin manager and show TitanBar options (THIS IS AN EXAMLPE)
end
--**^