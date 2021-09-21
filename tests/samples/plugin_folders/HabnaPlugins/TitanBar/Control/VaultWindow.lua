-- VaultWindow.lua
-- written by Habna


function frmVault()
	tvaultpack = vaultpack;
	SelCN = PN;
	import (AppClassD.."ComboBox");
	VICB = HabnaPlugins.TitanBar.Class.ComboBox();

	-- **v Set some window stuff v**
	_G.wVT = Turbine.UI.Lotro.Window()
	_G.wVT:SetText( L["MVault"] );
	_G.wVT:SetPosition( VTWLeft, VTWTop );
	_G.wVT:SetWidth( 390 );
	_G.wVT:SetWantsKeyEvents( true );
	_G.wVT:SetVisible( true );
	--_G.wVT:SetZOrder( 2 );
	_G.wVT:Activate();

	_G.wVT.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			_G.wVT:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			_G.wVT:SetVisible( not _G.wVT:IsVisible() );
		end
	end

	_G.wVT.MouseMove = function( sender, args )
		if dragging then VICB:CloseDropDown(); end
	end

	_G.wVT.MouseDown = function( sender, args )
		dragging = true;
	end

	_G.wVT.MouseUp = function( sender, args )
		dragging = false;
		settings.Vault.L = string.format("%.0f", _G.wVT:GetLeft());
		settings.Vault.T = string.format("%.0f", _G.wVT:GetTop());
		VTWLeft, VTWTop = _G.wVT:GetPosition();
		SaveSettings( false );
	end

	_G.wVT.Closing = function( sender, args ) -- Function for the Upper right X icon
		VICB.dropDownWindow:SetVisible(false);
		_G.wVT:SetWantsKeyEvents( false );
		RemoveCallback( tvaultpack, "CountChanged" );
		_G.wVT = nil;
		_G.frmVT = nil;
	end
	-- **^
	-- **v Create drop down box v**
	VICB:SetParent( _G.wVT );
	VICB:SetSize( 159, 19 );
	VICB:SetPosition( 15, 35 );

	VICB.dropDownWindow:SetParent( _G.wVT );
	VICB.dropDownWindow:SetPosition(VICB:GetLeft(), VICB:GetTop() + VICB:GetHeight()+2);

	VICB.ItemChanged = function( sender, args ) -- The event that's executed when a menu item is clicked.
		_G.wVT.SearchTextBox:SetText( "" );
		_G.wVT.SearchTextBox.TextChanged( sender, args );
		SelCN = VICB.label:GetText();
		CountVIItems();
	end

	CreateVIComboBox();
	-- **^
	-- **v search label & text box v**
	_G.wVT.searchLabel = Turbine.UI.Label();
    _G.wVT.searchLabel:SetParent( _G.wVT );
    _G.wVT.searchLabel:SetText( L["VTSe"] );
    _G.wVT.searchLabel:SetPosition( 15, 60 );
    _G.wVT.searchLabel:SetSize( _G.wVT.searchLabel:GetTextLength() * 8, 18 ); --Auto size with text lenght
    _G.wVT.searchLabel:SetFont( Turbine.UI.Lotro.Font.TrajanPro15 );
    _G.wVT.searchLabel:SetForeColor( Color["gold"] );
	 
    _G.wVT.SearchTextBox = Turbine.UI.Lotro.TextBox();
    _G.wVT.SearchTextBox:SetParent( _G.wVT );
    _G.wVT.SearchTextBox:SetPosition(  _G.wVT.searchLabel:GetLeft() +  _G.wVT.searchLabel:GetWidth(),  _G.wVT.searchLabel:GetTop() );
    _G.wVT.SearchTextBox:SetSize( _G.wVT:GetWidth() - 150, 18 );
    _G.wVT.SearchTextBox:SetFont( Turbine.UI.Lotro.Font.Verdana14 );
	_G.wVT.SearchTextBox:SetMultiline( false );
	
    _G.wVT.SearchTextBox.TextChanged = function( sender, args )
        _G.wVT.searchText = string.lower( _G.wVT.SearchTextBox:GetText() );
        if _G.wVT.searchText == "" then _G.wVT.searchText = nil; end
        CountVIItems();
    end

	_G.wVT.SearchTextBox.FocusLost = function( sender, args )
		
	end
	-- **^
	--**v clear search text box icon v**
	_G.wVT.DelIcon = Turbine.UI.Label();
	_G.wVT.DelIcon:SetParent( _G.wVT );
	_G.wVT.DelIcon:SetPosition( _G.wVT.SearchTextBox:GetLeft() + _G.wVT.SearchTextBox:GetWidth() + 5, _G.wVT.SearchTextBox:GetTop() );
	_G.wVT.DelIcon:SetSize( 16, 16 );
	_G.wVT.DelIcon:SetBackground( 0x4101f893 );
	_G.wVT.DelIcon:SetBlendMode( 4 );
	_G.wVT.DelIcon:SetVisible( true );
				
	_G.wVT.DelIcon.MouseClick = function( sender, args )
		_G.wVT.SearchTextBox:SetText( "" );
		_G.wVT.SearchTextBox.TextChanged( sender, args );
		_G.wVT.SearchTextBox:Focus();
	end
	-- **^
	-- **v Set the item listbox border v**
	_G.wVT.ListBoxBorder = Turbine.UI.Control();
	_G.wVT.ListBoxBorder:SetParent( _G.wVT );
	_G.wVT.ListBoxBorder:SetWidth( _G.wVT:GetWidth() - 30 );
	_G.wVT.ListBoxBorder:SetBackColor( Color["grey"] );
	-- **^
	-- **v Set the item listbox v**
	_G.wVT.ListBox = Turbine.UI.ListBox();
	_G.wVT.ListBox:SetParent( _G.wVT );
	_G.wVT.ListBox:SetWidth( _G.wVT.ListBoxBorder:GetWidth() - 4 );
	_G.wVT.ListBox:SetMaxItemsPerLine( 1 );
	_G.wVT.ListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	_G.wVT.ListBox:SetBackColor( Color["black"] );
	-- **^
	-- **v Set the listbox scrollbar v**
	_G.wVT.ListBoxScrollBar = Turbine.UI.Lotro.ScrollBar();
	_G.wVT.ListBoxScrollBar:SetParent( _G.wVT.ListBox );
	_G.wVT.ListBoxScrollBar:SetPosition( _G.wVT.ListBox:GetWidth() - 10, 0 );
	_G.wVT.ListBoxScrollBar:SetWidth( 12 );
	_G.wVT.ListBoxScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	_G.wVT.ListBox:SetVerticalScrollBar( _G.wVT.ListBoxScrollBar );
	-- **^
	-- **v Delete character infos button v**
	_G.wVT.ButtonDelete = Turbine.UI.Lotro.Button();
	_G.wVT.ButtonDelete:SetParent( _G.wVT );
	_G.wVT.ButtonDelete:SetText( L["ButDel"] );
	_G.wVT.ButtonDelete:SetSize( _G.wVT.ButtonDelete:GetTextLength() * 11, 15 ); --Auto size with text lenght

	_G.wVT.ButtonDelete.Click = function( sender, args )
		PlayerVault[SelCN] = nil;
		SavePlayerVault();
		write( SelCN .. L["VTID"] );
		SelCN = PN;
		VICB.selection = -1;
		CreateVIComboBox();
		CountVIItems();
	end
	-- **^

	AddCallback(tvaultpack, "CountChanged", 
		function(sender, args)
		if frmVT then
			if SelCN == PN or SelCN == L["VTAll"] then CountVIItems(); end
		end
	end);

	CountVIItems();
end

function CreateVIComboBox()
	-- **v Create an array of character name, sort it, then use it as a reference - label & DropDown box v**
	local newt = {}
	for i in pairs(PlayerVault) do
		if string.sub( i, 1, 1 ) == "~" then PlayerVault[i] = nil; else table.insert(newt,i); end --Delete session play character
	end
	table.sort(newt);
	VICB.listBox:ClearItems();
	VICB:AddItem( L["VTAll"], 0 );
	for k,v in pairs(newt) do
		VICB:AddItem(v, k);
		if v == PN then VICB:SetSelection(k); end
	end
	-- **^
end

function CountVIItems()
	vaultpackCount = 0;
	_G.wVT.ListBox:ClearItems();
	itemCtl = {};

	if SelCN == L["VTAll"] then
		_G.wVT.ButtonDelete:SetEnabled( false );
        for i in pairs(PlayerVault) do
			for k, v in pairs(PlayerVault[i]) do vaultpackCount = vaultpackCount + 1; end
            AddVaultPack(i, true);
			vaultpackCount = 0;
        end
    else
		if SelCN == PN then _G.wVT.ButtonDelete:SetEnabled( false );
		else _G.wVT.ButtonDelete:SetEnabled( true ); end
		for k, v in pairs(PlayerVault[SelCN]) do vaultpackCount = vaultpackCount + 1; end
		if vaultpackCount == 0 then SetEmptyVault();
		else AddVaultPack(SelCN, false); end
    end
 
    _G.wVT.ButtonDelete:SetPosition( _G.wVT:GetWidth()/2 - _G.wVT.ButtonDelete:GetWidth()/2, _G.wVT.ListBox:GetTop()+_G.wVT.ListBox:GetHeight()+10 );
end

function SetEmptyVault()
	itemCtl = Turbine.UI.Control();
	itemCtl:SetSize( _G.wVT.ListBox:GetWidth(), 35 );

	local lblmgs = Turbine.UI.Label();
	lblmgs:SetParent( itemCtl );
	lblmgs:SetText( L["VTnd"] );
	lblmgs:SetPosition( 0, 0 );
	lblmgs:SetSize( itemCtl:GetWidth(), itemCtl:GetHeight() );
	lblmgs:SetForeColor( Color["green"] );
	lblmgs:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );

	_G.wVT.ListBox:AddItem( itemCtl );
	_G.wVT.ButtonDelete:SetVisible( false );

	_G.wVT.ListBoxBorder:SetPosition( 15, 60 );
	_G.wVT.ListBoxBorder:SetHeight( lblmgs:GetHeight() + 4 );
	_G.wVT.ListBox:SetPosition( _G.wVT.ListBoxBorder:GetLeft() + 2, _G.wVT.ListBoxBorder:GetTop() + 2 );
	_G.wVT.ListBox:SetHeight( lblmgs:GetHeight() )
	_G.wVT.ListBoxScrollBar:SetVisible( false );
	_G.wVT:SetHeight( itemCtl:GetHeight() + 85 );
end

function AddVaultPack(n, addCharacterName)
	for i = 1, vaultpackCount do
		local itemName = PlayerVault[n][tostring(i)].T;
		if not _G.wVT.searchText or string.find(string.lower( itemName ), _G.wVT.searchText, 1, true) then
			-- Item control
			itemCtl[i] = Turbine.UI.Control();
			itemCtl[i]:SetSize( _G.wVT.ListBox:GetWidth() - 10, 35 );

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
			itemQTE:SetText( tonumber(PlayerVault[n][tostring(i)].N) );

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

			_G.wVT.ListBox:AddItem( itemCtl[i] );
			_G.wVT.ButtonDelete:SetVisible( true );
		end
	end
	
	_G.wVT.ListBoxBorder:SetPosition( 15, _G.wVT.SearchTextBox:GetTop() + _G.wVT.SearchTextBox:GetHeight() + 5 );
	_G.wVT.ListBoxBorder:SetHeight( 392 );
	_G.wVT.ListBox:SetPosition( _G.wVT.ListBoxBorder:GetLeft() + 2, _G.wVT.ListBoxBorder:GetTop() + 2 );
	_G.wVT.ListBox:SetHeight( _G.wVT.ListBoxBorder:GetHeight() - 4 );
	_G.wVT.ListBoxScrollBar:SetHeight( _G.wVT.ListBox:GetHeight() );
	_G.wVT:SetHeight( 520 );
end