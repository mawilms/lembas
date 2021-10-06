-- VaultWindow.lua
-- written by Habna


function frmVault()
	frmVT = true;
	tvaultpack = vaultpack;
	SelCN = PN;
	import (AppClassD.."ComboBox");
	VaultCB = HabnaPlugins.HugeBag.Class.ComboBox();
	
	-- **v Set some window stuff v**
	wVault = Turbine.UI.Lotro.Window();
	wVault:SetText( L["OWidVault"] );
	wVault:SetPosition( VWLeft, VWTop );
	wVault:SetWidth( 390 );
	wVault:SetWantsKeyEvents( true );
	wVault:SetVisible( true );
	--wVault:SetZOrder( 2 );
	--wVault:Activate();

	wVault.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			wVault:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			wVault:SetVisible( not wVault:IsVisible() );
		end
	end

	wVault.MouseMove = function( sender, args )
		if dragging then VaultCB:CloseDropDown(); end
	end

	wVault.MouseDown = function( sender, args )
		dragging = true;
	end

	wVault.MouseUp = function( sender, args )
		dragging = false;
		HBsettings.Vault.L = string.format("%.0f", wVault:GetLeft());
		HBsettings.Vault.T = string.format("%.0f", wVault:GetTop());
		VWLeft, VWTop = wVault:GetPosition();
		SaveSettings();
	end

	wVault.Closing = function( sender, args ) -- Function for the Upper right X icon
		VaultCB.dropDownWindow:SetVisible(false);
		wVault:SetWantsKeyEvents( false );
		ViewItems[2]:SetChecked( false );
		RemoveCallback( tvaultpack, "CountChanged" );
		wVault = nil;
		frmVT = nil;
	end
	-- **^
	-- **v Create drop down box v**
	VaultCB:SetParent( wVault );
	VaultCB:SetSize( 159, 19 );
	VaultCB:SetPosition( 15, 35 );
	
	VaultCB.dropDownWindow:SetParent( wVault );
	VaultCB.dropDownWindow:SetPosition(VaultCB:GetLeft(), VaultCB:GetTop() + VaultCB:GetHeight()+2);

	VaultCB.ItemChanged = function(sender, args) -- The event that's executed when a menu item is clicked.
		wVault.SearchTextBox:SetText( "" );
		wVault.SearchTextBox.TextChanged( sender, args );
		SelCN = VaultCB.label:GetText();
		CountVaultItems();
	end

	CreateVaultComboBox();
	-- **^
	-- **v search label & text box v**
	wVault.searchLabel = Turbine.UI.Label();
    wVault.searchLabel:SetParent( wVault );
    wVault.searchLabel:SetText( L["VTSe"] );
    wVault.searchLabel:SetPosition( 15, 60 );
    wVault.searchLabel:SetSize( wVault.searchLabel:GetTextLength() * 8, 18 ); --Auto size with text lenght
    wVault.searchLabel:SetFont( Turbine.UI.Lotro.Font.TrajanPro15 );
    wVault.searchLabel:SetForeColor( Color["gold"] );
	 
    wVault.SearchTextBox = Turbine.UI.Lotro.TextBox();
    wVault.SearchTextBox:SetParent( wVault );
    wVault.SearchTextBox:SetPosition(  wVault.searchLabel:GetLeft() +  wVault.searchLabel:GetWidth(),  wVault.searchLabel:GetTop() );
    wVault.SearchTextBox:SetSize( wVault:GetWidth() - 150, 18 );
    wVault.SearchTextBox:SetFont( Turbine.UI.Lotro.Font.Verdana14 );
	wVault.SearchTextBox:SetMultiline( false );
	
    wVault.SearchTextBox.TextChanged = function( sender, args )
        wVault.searchText = string.lower( wVault.SearchTextBox:GetText() );
        if wVault.searchText == "" then wVault.searchText = nil; end
        CountVaultItems();
    end

	wVault.SearchTextBox.FocusLost = function( sender, args )
		
	end
	-- **^
	--**v clear search text box icon v**
	wVault.DelIcon = Turbine.UI.Label();
	wVault.DelIcon:SetParent( wVault );
	wVault.DelIcon:SetPosition( wVault.SearchTextBox:GetLeft() + wVault.SearchTextBox:GetWidth() + 5, wVault.SearchTextBox:GetTop() );
	wVault.DelIcon:SetSize( 16, 16 );
	wVault.DelIcon:SetBackground( 0x4101f893 );
	wVault.DelIcon:SetBlendMode( 4 );
	wVault.DelIcon:SetVisible( true );
				
	wVault.DelIcon.MouseClick = function( sender, args )
		wVault.SearchTextBox:SetText( "" );
		wVault.SearchTextBox.TextChanged( sender, args );
		wVault.SearchTextBox:Focus();
	end
	-- **^
	-- **v Set the itemlistbox border v**
	wVault.ListBoxBorder = Turbine.UI.Control();
	wVault.ListBoxBorder:SetParent( wVault );
	wVault.ListBoxBorder:SetWidth( wVault:GetWidth() - 30 );
	wVault.ListBoxBorder:SetBackColor( Color["grey"] );
	-- **^
	-- **v Set the itemlistbox v**
	wVault.ListBox = Turbine.UI.ListBox();
	wVault.ListBox:SetParent( wVault );
	wVault.ListBox:SetWidth( wVault.ListBoxBorder:GetWidth() - 4 );
	wVault.ListBox:SetMaxItemsPerLine( 1 );
	wVault.ListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	wVault.ListBox:SetBackColor( Color["black"] );
	-- **^
	-- **v Set the scrollbar v**
	wVault.ListBoxScrollBar = Turbine.UI.Lotro.ScrollBar();
	wVault.ListBoxScrollBar:SetParent( wVault.ListBox );
	wVault.ListBoxScrollBar:SetPosition( wVault.ListBox:GetWidth() - 10, 0 );
	wVault.ListBoxScrollBar:SetWidth( 10 );
	wVault.ListBoxScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	wVault.ListBox:SetVerticalScrollBar( wVault.ListBoxScrollBar );
	-- **^
	-- **v Delete character infos button v**
	wVault.ButtonDelete = Turbine.UI.Lotro.Button();
	wVault.ButtonDelete:SetParent( wVault );
	wVault.ButtonDelete:SetText( L["ButDel"] );
	wVault.ButtonDelete:SetSize( wVault.ButtonDelete:GetTextLength() * 11, 15 ); --Auto size with text lenght

	wVault.ButtonDelete.Click = function( sender, args )
		PlayerVault[SelCN] = nil;
		SavePlayerVault();
		write( SelCN .. L["VTID"] );
		SelCN = PN;
		VaultCB.selection = -1;
		CreateVaultComboBox();
		CountVaultItems();
	end
	-- **^

	AddCallback(tvaultpack, "CountChanged", 
		function(sender, args)
		if frmVT then
			if SelCN == PN or SelCN == L["VTAll"] then CountVaultItems(); end
		end
	end);

	CountVaultItems();
end

function CreateVaultComboBox()
	-- **v Create an array of character name, sort it, then use it as a reference - label & DropDown box v**
	local newt = {}
	for i in pairs(PlayerVault) do
		if string.sub( i, 1, 1 ) == "~" then PlayerVault[i] = nil; else table.insert(newt,i); end --Delete session play character
	end
	table.sort(newt);
	VaultCB.listBox:ClearItems();
	VaultCB:AddItem( L["VTAll"], 0 );
	for k,v in pairs(newt) do
		VaultCB:AddItem(v, k);
		if v == PN then VaultCB:SetSelection(k); end
	end
	-- **^
end

function CountVaultItems()
	vaultpackCount = 0;
	wVault.ListBox:ClearItems();
	itemCtl = {};

	if SelCN == L["VTAll"] then
		wVault.ButtonDelete:SetEnabled( false );
        for i in pairs(PlayerVault) do
			for k, v in pairs(PlayerVault[i]) do vaultpackCount = vaultpackCount + 1; end
            AddVaultPack(i, true);
			vaultpackCount = 0;
        end
    else
		if SelCN == PN then wVault.ButtonDelete:SetEnabled( false );
		else wVault.ButtonDelete:SetEnabled( true ); end
		for k, v in pairs(PlayerVault[SelCN]) do vaultpackCount = vaultpackCount + 1; end
		if vaultpackCount == 0 then SetEmptyVault();
		else AddVaultPack(SelCN, false); end
    end
 
    wVault.ButtonDelete:SetPosition( wVault:GetWidth()/2 - wVault.ButtonDelete:GetWidth()/2, wVault.ListBox:GetTop()+wVault.ListBox:GetHeight()+10 );
end

function SetEmptyVault()
	itemCtl = Turbine.UI.Control();
	itemCtl:SetSize( wVault.ListBox:GetWidth(), 35 );

	local lblmgs = Turbine.UI.Label();
	lblmgs:SetParent( itemCtl );
	lblmgs:SetText( L["VTnd"] );
	lblmgs:SetPosition( 0, 0 );
	lblmgs:SetSize( itemCtl:GetWidth(), itemCtl:GetHeight() );
	lblmgs:SetForeColor( Color["green"] );
	lblmgs:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );

	wVault.ListBox:AddItem( itemCtl );
	wVault.ButtonDelete:SetVisible( false );

	wVault.ListBoxBorder:SetPosition( 15, 60 );
	wVault.ListBoxBorder:SetHeight( lblmgs:GetHeight() + 4 );
	wVault.ListBox:SetPosition( wVault.ListBoxBorder:GetLeft() + 2, wVault.ListBoxBorder:GetTop() + 2 );
	wVault.ListBox:SetHeight( lblmgs:GetHeight() )
	wVault.ListBoxScrollBar:SetVisible( false );
	wVault:SetHeight( itemCtl:GetHeight() + 85 );
end

function AddVaultPack(n, addCharacterName)
	for i = 1, vaultpackCount do
		local itemName = PlayerVault[n][tostring(i)].T;
		if not wVault.searchText or string.find(string.lower( itemName ), wVault.searchText, 1, true) then
			-- Item control
			itemCtl[i] = Turbine.UI.Control();
			itemCtl[i]:SetSize( wVault.ListBox:GetWidth() - 10, 35 );

			-- Item Background
			local itemBG = Turbine.UI.Control();
			itemBG:SetParent( itemCtl[i] );
			itemBG:SetSize( 32, 32 );
			itemBG:SetPosition( 3, 3 );
			if PlayerVault[n][tostring(i)].B ~= "0" then itemBG:SetBackground( tonumber(PlayerVault[n][tostring(i)].B) ); end
			itemBG:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			
			-- Item Underlay
			local itemU = Turbine.UI.Control();
			itemU:SetParent( itemCtl[i] );
			itemU:SetSize( 32, 32 );
			itemU:SetPosition( 3, 3 );
			if PlayerVault[n][tostring(i)].U ~= "0" then itemU:SetBackground( tonumber(PlayerVault[n][tostring(i)].U) ); end
			itemU:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			
			-- Item Shadow
			local itemS = Turbine.UI.Control();
			itemS:SetParent( itemCtl[i] );
			itemS:SetSize( 32, 32 );
			itemS:SetPosition( 3, 3 );
			if PlayerVault[n][tostring(i)].S ~= "0" then itemS:SetBackground( tonumber(PlayerVault[n][tostring(i)].S) ); end
			itemS:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			
			-- Item
			local item = Turbine.UI.Control();
			item:SetParent( itemCtl[i] );
			item:SetSize( 32, 32 );
			item:SetPosition( 3, 3 );
			if PlayerVault[n][tostring(i)].I ~= "0" then item:SetBackground( tonumber(PlayerVault[n][tostring(i)].I) ); end
			item:SetBlendMode( Turbine.UI.BlendMode.Overlay );

			-- Item Quantity
			local itemQTE = Turbine.UI.Label();
			itemQTE:SetParent( itemCtl[i] );
			itemQTE:SetSize( 32, 15 );
			itemQTE:SetPosition( -4, 16 );
			itemQTE:SetFont( Turbine.UI.Lotro.Font.Verdana12 );
			itemQTE:SetFontStyle( Turbine.UI.FontStyle.Outline );
			itemQTE:SetOutlineColor( Color["black"] );
			itemQTE:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
			itemQTE:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
			itemQTE:SetForeColor( Color["nicegold"] );
			itemQTE:SetText(tonumber(PlayerVault[n][tostring(i)].N));

			-- Item name
			local itemLbl = Turbine.UI.Label();
			itemLbl:SetParent( itemCtl[i] );
			itemLbl:SetSize( itemCtl[i]:GetWidth() - 35, 35 );
			itemLbl:SetPosition( 37, 2 );
			itemLbl:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
			itemLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			itemLbl:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
			itemLbl:SetForeColor( Color["white"] );
			itemLbl:SetText( PlayerVault[n][tostring(i)].T );
			if addCharacterName then itemLbl:AppendText( " (" .. n .. ")" ); end

			wVault.ListBox:AddItem( itemCtl[i] );
			wVault.ButtonDelete:SetVisible( true );
		end
	end

	wVault.ListBoxBorder:SetPosition( 15, wVault.SearchTextBox:GetTop() + wVault.SearchTextBox:GetHeight() + 5 );
	wVault.ListBoxBorder:SetHeight( 392 );
	wVault.ListBox:SetPosition( wVault.ListBoxBorder:GetLeft() + 2, wVault.ListBoxBorder:GetTop() + 2 );
	wVault.ListBox:SetHeight( wVault.ListBoxBorder:GetHeight() - 4 );
	wVault.ListBoxScrollBar:SetHeight( wVault.ListBox:GetHeight() );
	wVault:SetHeight( 520 );
end