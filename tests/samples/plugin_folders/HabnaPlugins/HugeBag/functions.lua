-- functions.lua
-- Written By Habna


function AddCallback(object, event, callback)
    if (object[event] == nil) then
        object[event] = callback;
    else
        if (type(object[event]) == "table") then
            table.insert(object[event], callback);
        else
            object[event] = {object[event], callback};
        end
    end
    return callback;
end

function RemoveCallback(object, event, callback)
    if (object[event] == callback) then
        object[event] = nil;
    else
        if (type(object[event]) == "table") then
            local size = table.getn(object[event]);
            for i = 1, size do
                if (object[event][i] == callback) then
                    table.remove(object[event], i);
                    break;
                end
            end
        end
    end
end

-- For debug purpose
function ShowTableContent(args)
	for k,v in pairs(args) do
		write("key:"..tostring(k)..", value:"..tostring(v));
	end
end

-- **v Unload v**
function UnloadHugeBag()
	--write( "HugeBag: Unloaded" );
	--Turbine.PluginManager.UnloadScriptState( 'HugeBag' );
	Turbine.PluginManager.LoadPlugin( 'HugeBag Unloader' );
end
-- **^
-- **v Reload v**
function ReloadHugeBag()
	--write( "HugeBag: Reloaded" );
	--UnloadHugeBag();
	--Turbine.PluginManager.LoadPlugin( 'HugeBag' );
	Turbine.PluginManager.LoadPlugin( 'HugeBag Reloader' );
end
-- **^
-- **v Toggle the ability to hide are not HugeBag when the 'esc' key is press v**
function ToggleWEsc()
	HideWEsc = not HideWEsc;
	HBsettings.Options.HideWEsc = HideWEsc;
	SaveSettings( false );
	if HideWEsc then write( L["FEscH"] );
	else write( L["FEscS"] ); end
end
-- **^
-- **v Toggle Startup Visibility v**
function ToggleShow()
	StartVisible = not StartVisible;
	HBsettings.Options.StartVisible = StartVisible;
	SaveSettings( false );
	if StartVisible then write( L["FLoadS"] );
	else write( L["FLoadH"] ); end
end
-- **^
-- **v Toggle between window and widget mode v**
function ToggleMode()
	HugeBagMode = {};
	HugeBagMode.Widget = not Widget;
	Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagMode", HugeBagMode );
	ReloadHugeBag();
end
-- **^
-- **v Toggle ability to be always on top are not v**
function ToggleAlwaysOnTop()
	zOrder = not zOrder;
	HBsettings.Options.AlwaysOnTop = zOrder;
	SaveSettings( false );
	if zOrder then write( L["FAOTS"] );
	else write( L["FAOTH"] ); end
end
-- **^
-- **v Show Vault, Storage or Bags info v**
function ViewVaultStorageBags(value)
	if value == "bags" then
		ViewItems[1]:SetChecked( not ViewItems[1]:IsChecked() );
		if frmBI then wBagInfos:Close();
		else ViewBags(); end
	elseif value == "vault" then
		ViewItems[2]:SetChecked( not ViewItems[1]:IsChecked() );
		if frmVT then wVault:Close();
		else ViewVault(); end
	elseif value == "storage" then
		ViewItems[3]:SetChecked( not ViewItems[1]:IsChecked() );
		if frmSS then wSharedStorage:Close();
		else ViewSharedStorage(); end
	end
end
-- **^
-- **v Toggle bottom bar info v**
function ToggleBotBarInfo(value)
	if IsSorting or IsMixing or IsMerging or IsSearching then
		write( L["FWidActive"] );
		return
	end

	if value == "butlt" then --Show button short/long text
		ButtonLongText = not ButtonLongText
		HBsettings.Button.LongText = ButtonLongText;
		ShowBT("options");
	elseif value == "butvis" then -- Show/Hide buttons
		ShowButton = not ShowButton;
		HBsettings.Button.Show = ShowButton;
		if ShowButton then write( L["FButVis"] );
		else write( L["FButNVis"] ); end
	elseif value == "sortvis" then --Show/Hide Sort button
		ShowSort = not ShowSort;
		HBsettings.Button.ShowSort = ShowSort;
		if ShowSort then write( L["FSortVis"] );
		else write( L["FSortNVis"] ); end
	elseif value == "mergevis" then --Show/Hide Merge button
		ShowMerge = not ShowMerge;
		HBsettings.Button.ShowMerge = ShowMerge;
		if ShowMerge then write( L["FMergeVis"] );
		else write( L["FMergeNVis"] ); end
	elseif value == "searchvis" then --Show/Hide Search button
		ShowSearch = not ShowSearch;
		HBsettings.Button.ShowSearch = ShowSearch;
		if ShowSearch then write( L["FSearchVis"] );
		else write( L["FSearchNVis"] ); end
	elseif value == "bagsvis" then --Show/Hide Bag button
		ShowBags = not ShowBags;
		HBsettings.Button.ShowBags = ShowBags;
		if ShowBags then write( L["FBagsVis"] );
		else write( L["FBagsNVis"] ); end
	elseif value == "vaultvis" then --Show/Hide Vault button
		ShowVault = not ShowVault;
		HBsettings.Button.ShowVault = ShowVault;
		if ShowVault then write( L["FVaultVis"] );
		else write( L["FVaultNVis"] ); end
	elseif value == "ssvis" then --Show/Hide Shared Storage button
		ShowSS = not ShowSS;
		HBsettings.Button.ShowSS = ShowSS;
		if ShowSS then write( L["FSSVis"] );
		else write( L["FSSNVis"] ); end
	end

	PrintTitle();
	SaveSettings( false );
end
-- **^
-- **
function ShowBT(value)
	if ButtonLongText then
		--write("long text");
		SortButton:SetText( L["OWidSort"] );
		MergeButton:SetText( L["OWidMerge"] );
		SearchButton:SetText( L["OWidSearch"] );
		BagsButton:SetText( L["OWidBags"] );
		VaultButton:SetText( L["OWidVault"] );
		SSButton:SetText( L["OWidStorage"] );
	else
		--write("short text");
		SortButton:SetText( L["Sort"] );
		MergeButton:SetText( L["Merge"] );
		SearchButton:SetText( L["Search"] );
		BagsButton:SetText( L["Bags"] );
		VaultButton:SetText( L["Vault"] );
		SSButton:SetText( L["SStorage"] );
	end

	if value == "options" then
		if ButtonLongText then write( L["BLT"] ); else write( L["BST"] ); end
	end

	SortButton:SetSize( string.len(SortButton:GetText()) * 7.5, 14 );
	MergeButton:SetSize( string.len(MergeButton:GetText()) * 7.5, 14 );
	SearchButton:SetSize( string.len(SearchButton:GetText()) * 7.5, 14 );
	BagsButton:SetSize( string.len(BagsButton:GetText()) * 7.5, 14 );
	VaultButton:SetSize( string.len(VaultButton:GetText()) * 7.5, 14 );
	SSButton:SetSize( string.len(SSButton:GetText()) * 7.5, 14 );
end

-- **v Toggle inverse merge function v**
function InvMerge()
	InverseMerge = not InverseMerge;
	HBsettings.Options.InverseMerge = InverseMerge;
	SaveSettings( false );
	if InverseMerge then write( L["FMergeD"] .. backpackSize .. L["FMerge1"] );
	else write( L["FMergeU"] .. backpackSize ); end
end
-- **^
-- **v Toggle top bar info v**
function ToggleTopBarInfo(value)
	if value == "title" then
		write( L["FWidTBTitle"] );
	elseif value == "info" then
		write( L["FWidTBInfo"] );
	elseif value == "nil" then
		write( L["FWidTBNot"] );
	end
	topbarinfo = value;
	HBsettings.Options.TopSection = value;
	SaveSettings( false );
	PrintTitle();
end
-- **^
-- **v Searching v**
function Searching()
	SearchInput:SetVisible( not SearchInput:IsVisible() );
	ButtonsCtr:SetVisible( false );
	ResetAllCheck(); --Reset all itemsmenu check
	SearchInput:Focus();
end
-- **^
-- **v Vault v**
function ViewVault()
	import "HabnaPlugins.HugeBag.vault"; -- LUA vault file
	frmVault();
end
-- **^
-- **v Save Vault v**
function SavePlayerVault()
	if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play character

	vaultpackSize = vaultpack:GetCapacity();
	vaultpackCount = vaultpack:GetCount();

	PlayerVault[PN] = {};

	for ii = 1, vaultpackCount do
		PlayerVault[PN][tostring(ii)] = vaultpack:GetItem( ii );
		local iteminfo = PlayerVault[PN][tostring(ii)]:GetItemInfo();
			
		PlayerVault[PN][tostring(ii)].Q = tostring(iteminfo:GetQualityImageID());
		PlayerVault[PN][tostring(ii)].B = tostring(iteminfo:GetBackgroundImageID());
		PlayerVault[PN][tostring(ii)].U = tostring(iteminfo:GetUnderlayImageID());
		PlayerVault[PN][tostring(ii)].S = tostring(iteminfo:GetShadowImageID());
		PlayerVault[PN][tostring(ii)].I = tostring(iteminfo:GetIconImageID());
		PlayerVault[PN][tostring(ii)].T = tostring(iteminfo:GetName());
		local tq = tostring(PlayerVault[PN][tostring(ii)]:GetQuantity());
		if tq == "1" then tq = ""; end
		PlayerVault[PN][tostring(ii)].N = tq;
		PlayerVault[PN][tostring(ii)].Z = tostring(vaultpackSize);
	end

	Turbine.PluginData.Save( Turbine.DataScope.Server, "HugeBagVault", PlayerVault );
end
-- **^
-- **v Shared Storage v**
function ViewSharedStorage()
	import "HabnaPlugins.HugeBag.sharedstorage"; -- LUA shared storage file
	frmSharedStorage();
end
-- **^
-- **v Save Shared Storage v**
function SavePlayerSharedStorage()
	if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play character

	sspackSize = sspack:GetCapacity();
	sspackCount = sspack:GetCount();

	PlayerSharedStorage = {};
	--PlayerSharedStorage["Size"] = tostring(sspackSize);

	for ii = 1, sspackCount do
		PlayerSharedStorage[tostring(ii)] = sspack:GetItem( ii );
		local iteminfo = PlayerSharedStorage[tostring(ii)]:GetItemInfo();
			
		PlayerSharedStorage[tostring(ii)].Q = tostring(iteminfo:GetQualityImageID());
		PlayerSharedStorage[tostring(ii)].B = tostring(iteminfo:GetBackgroundImageID());
		PlayerSharedStorage[tostring(ii)].U = tostring(iteminfo:GetUnderlayImageID());
		PlayerSharedStorage[tostring(ii)].S = tostring(iteminfo:GetShadowImageID());
		PlayerSharedStorage[tostring(ii)].I = tostring(iteminfo:GetIconImageID());
		PlayerSharedStorage[tostring(ii)].T = tostring(iteminfo:GetName());
		local tq = tostring(PlayerSharedStorage[tostring(ii)]:GetQuantity());
		if tq == "1" then tq = ""; end
		PlayerSharedStorage[tostring(ii)].N = tq;
		PlayerSharedStorage[tostring(ii)].Z = tostring(sspackSize);
	end

	Turbine.PluginData.Save( Turbine.DataScope.Server, "HugeBagSharedStorage", PlayerSharedStorage );
end
-- **^
-- **^
-- **v Bags v**
function ViewBags()
	import "HabnaPlugins.HugeBag.bags"; -- LUA bags file
	frmBagInfos();
end
-- **^
-- **v Save Bags v**
function SavePlayerBags()
	if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play character

	bagspackSize = Backpack:GetSize();

	PlayerBags[PN] = {};
	ii=1;
	for i = 1, bagspackSize do
		
		local items = Backpack:GetItem( i );
		
		if items ~= nil then
			PlayerBags[PN][tostring(ii)] = items;
			local iteminfo = PlayerBags[PN][tostring(ii)]:GetItemInfo();

			PlayerBags[PN][tostring(ii)].Q = tostring(iteminfo:GetQualityImageID());
			PlayerBags[PN][tostring(ii)].B = tostring(iteminfo:GetBackgroundImageID());
			PlayerBags[PN][tostring(ii)].U = tostring(iteminfo:GetUnderlayImageID());
			PlayerBags[PN][tostring(ii)].S = tostring(iteminfo:GetShadowImageID());
			PlayerBags[PN][tostring(ii)].I = tostring(iteminfo:GetIconImageID());
			PlayerBags[PN][tostring(ii)].T = tostring(iteminfo:GetName());
			local tq = tostring(PlayerBags[PN][tostring(ii)]:GetQuantity());
			if tq == "1" then tq = ""; end
			PlayerBags[PN][tostring(ii)].N = tq;
			PlayerBags[PN][tostring(ii)].Z = tostring(bagspackSize);

			ii = ii +1;
		end
	end

	Turbine.PluginData.Save( Turbine.DataScope.Server, "HugeBagBags", PlayerBags );
	--Turbine.PluginData.Save( Turbine.DataScope.Server, "HugeBagSharedStorage", PlayerBags[PN] ); --Debug purpose since i don't have a shared storage
end
-- **^
-- **v Load HugeBag profile settings v**
function LoadProfileSettings()
	if Widget then
		if GLocale == "de" then HBPsettings = Turbine.PluginData.Load( Turbine.DataScope.Server, "HugeBagWidgetProfileSettingsDE" );
		elseif GLocale == "en" then HBPsettings = Turbine.PluginData.Load( Turbine.DataScope.Server, "HugeBagWidgetProfileSettingsEN" );
		elseif GLocale == "fr" then HBPsettings = Turbine.PluginData.Load( Turbine.DataScope.Server, "HugeBagWidgetProfileSettingsFR" ); end
	else
		if GLocale == "de" then HBPsettings = Turbine.PluginData.Load( Turbine.DataScope.Server, "HugeBagWindowProfileSettingsDE" );
		elseif GLocale == "en" then HBPsettings = Turbine.PluginData.Load( Turbine.DataScope.Server, "HugeBagWindowProfileSettingsEN" );
		elseif GLocale == "fr" then HBPsettings = Turbine.PluginData.Load( Turbine.DataScope.Server, "HugeBagWindowProfileSettingsFR" ); end
	end

	if HBPsettings == nil then HBPsettings = {}; SaveProfileSettings( false ); end
end
-- **^
-- **v Apply HugeBag profile settings v**
function ApplyProfileSettings()
	write( L["FLP"] );
	HBsettings = HBPsettings;
	SaveSettings( false );
	ReloadHugeBag();
end
-- **^
-- **v Save HugeBag settings v**
function SaveProfileSettings(value)
	if Widget then
		if GLocale == "de" then Turbine.PluginData.Save( Turbine.DataScope.Server, "HugeBagWidgetProfileSettingsDE", HBsettings );
		elseif GLocale == "en" then Turbine.PluginData.Save( Turbine.DataScope.Server, "HugeBagWidgetProfileSettingsEN", HBsettings );
		elseif GLocale == "fr" then Turbine.PluginData.Save( Turbine.DataScope.Server, "HugeBagWidgetProfileSettingsFR", HBsettings ); end
	else
		if GLocale == "de" then Turbine.PluginData.Save( Turbine.DataScope.Server, "HugeBagWindowProfileSettingsDE", HBsettings );
		elseif GLocale == "en" then Turbine.PluginData.Save( Turbine.DataScope.Server, "HugeBagWindowProfileSettingsEN", HBsettings );
		elseif GLocale == "fr" then Turbine.PluginData.Save( Turbine.DataScope.Server, "HugeBagWindowProfileSettingsFR", HBsettings ); end
	end

	if value then write( L["FSP"] ); end
end
-- **^
-- **v Set background color v**
function SetBackgroundColor()
	import "HabnaPlugins.HugeBag.background"; -- LUA background file
	frmBackground();
end
-- **^
-- **v Show Shell Command window v**
function HelpInfo()
	import "HabnaPlugins.HugeBag.shellcmd"; -- LUA shell command file
	frmShellCmd();
end
-- **^
-- **v Show options menu v**
function ShowOptionsMenu(value)
	if value == "nil" then
		menu:ShowMenuAt(wHugeBag:GetLeft() - 350, wHugeBag:GetTop());
		if HBLocale == "fr" then menu:ShowMenuAt( wHugeBag:GetLeft() - 448, wHugeBag:GetTop() ); end
		if HBLocale == "de" then menu:ShowMenuAt( wHugeBag:GetLeft() - 419, wHugeBag:GetTop() ); end
	elseif value == "left" then
		menu:ShowMenuAt(wHugeBag:GetLeft() + wHugeBag:GetWidth() + 5, wHugeBag:GetTop());
	end
end
-- **^
-- **v Show ListBox items v**
function ShowItems(ItemsToShow)
	if ItemsToShow == "all" then
		SearchInput.FocusLost( sender, args );
	else
		if AllVisible then
			for i = 1, backpackSize do
				Item = Backpack:GetItem( i );
				if Item ~= nil then items[i]:SetVisible( false ); end
				AllVisible = false;
			end
		end
		for i = 1, backpackSize do
			Item = Backpack:GetItem( i );
			if Item ~= nil then
				ItemType = ItemCategory[Item:GetCategory()];
				if ItemsSel then
					if ItemType == ItemsToShow then	items[i]:SetVisible( true ); end
				else
					if ItemType == ItemsToShow then	items[i]:SetVisible( false ); end
				end
			end
		end
	end
end
-- **^
-- Create hacky resize cursors
function createCursor( MyCursorName, xOffset, yOffset, xSize, ySize, InGameCursor )
	cursor = Turbine.UI.Window();
	cursor:SetSize( xSize, ySize );
	if MyCursorName == nil then
		cursor:SetBackground( InGameCursor );
	else
		cursor:SetBackground( "HabnaPlugins/HugeBag/Resources/"..MyCursorName..".tga" );
	end
	cursor:SetMouseVisible( false );
	cursor:SetZOrder( 10 );
	
	cursor.xOffset = xOffset;
	cursor.yOffset = yOffset;
	
	return cursor;
end

-- Widget mode cursor
up_down_right_clic = createCursor( "up_down_right-click", 15, 12, 37, 23, nil );

-- Window mode cursor
resizeCursor = createCursor( nil, 14, 16, 32, 32, 0x410000dd ); -- in-game cursor 32x32: 0x410000dd
updownCursor = createCursor( nil, 18, 16, 32, 32, 0x410081c0 ); -- in-game cursor 32x32: 0x410081c0
leftrightCursor = createCursor( nil, 14, 16, 32, 32, 0x410081bf ); -- in-game cursor 32x32: 0x410081bf
leftrightclicCursor = createCursor( "left-right-click", 15, 15, 18, 22, nil );
--In-game normal cursor 32x32: 0x41007dc7

function ShowLeftRightCursor()
	if not LockSize then
		wHugeBag.cursor = leftrightCursor;
		local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
		wHugeBag.cursor:SetPosition( mouseX - wHugeBag.cursor.xOffset, mouseY - wHugeBag.cursor.yOffset);
		wHugeBag.cursor:SetVisible( true );
	end
end

function ShowUpDownCursor()
	if not LockSize then
		wHugeBag.cursor = updownCursor;
		local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
		wHugeBag.cursor:SetPosition( mouseX - wHugeBag.cursor.xOffset, mouseY - wHugeBag.cursor.yOffset);
		wHugeBag.cursor:SetVisible( true );
	end
end

function ShowTitleResizeCursor()
	if not LockPosition then
		wHugeBag.cursor = resizeCursor;
		local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
		wHugeBag.cursor:SetPosition( mouseX - wHugeBag.cursor.xOffset, mouseY - wHugeBag.cursor.yOffset);
		wHugeBag.cursor:SetVisible( true );
	end
end

function ShowResizeCursor()
	if not LockSize then
		wHugeBag.cursor = resizeCursor;
		local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
		wHugeBag.cursor:SetPosition( mouseX - wHugeBag.cursor.xOffset, mouseY - wHugeBag.cursor.yOffset);
		wHugeBag.cursor:SetVisible( true );
	end
end

function ShowResizeRightClicCursor()
	if not LockSize then
		wHugeBag.cursor = resizeRightClicCursor;
	else
		wHugeBag.cursor = rightclicCursor;
	end
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
	wHugeBag.cursor:SetPosition( mouseX - wHugeBag.cursor.xOffset, mouseY - wHugeBag.cursor.yOffset);
	wHugeBag.cursor:SetVisible( true );
end

function mergetable(table1,list)
	for i = 1, #list do
		table2 = list[i];
		local LenTable1 = #table1;
		for a = LenTable1 + 1, #table1 + #table2 do
			table1[a] = table2[a - LenTable1];
		end
	end
end

function ChangeColor()
	wHugeBag.itemListBox:SetBackColor( Turbine.UI.Color( bcAlpha, curSelRed, curSelGreen, curSelBlue ) );
end

function CreateVirtualPack()
	VirtPack = {};

	for i = 1, backpackSize do
		VirtPack[i] = {};
		VirtPack[i].AtSlot = i;

		local item = Backpack:GetItem( i );

		VirtPack[i].Item = Turbine.UI.Lotro.ItemControl( item );

		if item == nil then
			VirtPack[i].Name = "zEmpty";
			VirtPack[i].StackSize = 0;
			VirtPack[i].Quality = 0;
			VirtPack[i].Quantity = 0;
			VirtPack[i].Durability = 0;
			VirtPack[i].WearState = 0;
			VirtPack[i].CategoryNo = 0;
			VirtPack[i].Type = "nil";
			VirtPack[i].Weight = 99999;
		else
			VirtPack[i].Name = item:GetName();
			
			local StackSize = item:GetMaxStackSize();
			if StackSize == nil then StackSize = 1; end
			VirtPack[i].StackSize = StackSize;

			local Quantity = item:GetQuantity();
			if Quantity == nil then Quantity = 1; end
			VirtPack[i].Quantity = Quantity;

			local Quality = item:GetQuality();
			if Quality == nil then Quality = 0; end
			VirtPack[i].Quality = Quality;

			local Durability = item:GetDurability();
			if Durability == nil then Durability = 0; end
			VirtPack[i].Durability = Durability;

			local WearState = item:GetWearState();
			if WearState == nil then WearState = 0; end
			VirtPack[i].WearState = WearState;
			
			local CategoryNo = item:GetCategory();
			if CategoryNo == nil then CategoryNo = 0; end
			VirtPack[i].CategoryNo = CategoryNo;
			
			local Type = ItemCategory[CategoryNo];
			if Type == nil then Type = "SpecialTrophy"; end
			VirtPack[i].Type = Type;

			local CatWeight = value[Type];

			VirtPack[i].Weight = CatWeight * 10 + Quality;
		end

		--VirtPack[i].WasMoved = false;
		VirtPack[i].Dupe = "no";
	end

	--Sort VirtPack. If the weight of two items is the same compare the Names, after removing some characters.
	--This way 2 Morale Potions will get sorted with "Morale Potions"
	table.sort(VirtPack, function (a,b)	
		if a.Weight == b.Weight then
			if a.Name == b.Name then
				if a.Quantity == b.Quantity then
					return (a.AtSlot < b.AtSlot)
				else
					return (a.Quantity > b.Quantity)
				end
			else  
				return strip(a.Name) < strip(b.Name)
			end
		else  
			return (a.Weight < b.Weight) 
		end
	end)

	--Tag duplicate item
	--local xDupe = 0; --debug purpose
	for x = 1, #VirtPack - 1 do
		if VirtPack[x].Name ~= "zEmpty" then
			if VirtPack[x].Name == VirtPack[x+1].Name then
				VirtPack[x].Dupe = "yes"; VirtPack[x+1].Dupe = "yes";
				--xDupe = xDupe + 1; --Debug purpose
			end
		end
	end
	--write(xDupe .. " duplicate item(s) was found."); --Debug purpose

	--Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagCharacterBagContentEN", VirtPack ); --Debug purpose
end

function strip(str)
	--Strip numbers first 7 characters to make the sort more logical
	local left=string.sub(str, 1, 7)
	local right=string.sub(str, 8)
	left=string.gsub(left,"[^%a]","")
	str= left .. right

	--Strip all spaces now!
	str=string.gsub(str,"[%s]","")
	
	return str
end