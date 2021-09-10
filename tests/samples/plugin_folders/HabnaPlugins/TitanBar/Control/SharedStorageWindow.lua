-- SharedStorageWindow.lua
-- written by Habna


function frmSharedStorage()
	tsspack = sspack;
	_G.wSS = Turbine.UI.Lotro.Window()

	-- **v Set some window stuff v**
	_G.wSS:SetText( L["MStorage"] );
	_G.wSS:SetPosition( SSWLeft, SSWTop );
	_G.wSS:SetWidth( 390 );
	_G.wSS:SetWantsKeyEvents( true );
	_G.wSS:SetVisible( true );
	--_G.wSS:SetZOrder( 2 );
	_G.wSS:Activate();

	_G.wSS.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			_G.wSS:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			_G.wSS:SetVisible( not _G.wSS:IsVisible() );
		end
	end

	_G.wSS.MouseUp = function( sender, args )
		settings.SharedStorage.L = string.format("%.0f", _G.wSS:GetLeft());
		settings.SharedStorage.T = string.format("%.0f", _G.wSS:GetTop());
		SSWLeft, SSWTop = _G.wSS:GetPosition();
		SaveSettings( false );
	end

	_G.wSS.Closing = function( sender, args ) -- Function for the Upper right X icon
		_G.wSS:SetWantsKeyEvents( false );
		RemoveCallback( tsspack, "CountChanged" );
		_G.wSS = nil;
		_G.frmSS = nil;
	end
	-- **^

	-- **v search label & text box v**
	_G.wSS.searchLabel = Turbine.UI.Label();
    _G.wSS.searchLabel:SetParent( _G.wSS );
    _G.wSS.searchLabel:SetText( L["VTSe"] );
    _G.wSS.searchLabel:SetPosition( 15, 40 );
    _G.wSS.searchLabel:SetSize( _G.wSS.searchLabel:GetTextLength() * 8, 18 ); --Auto size with text lenght
    _G.wSS.searchLabel:SetFont( Turbine.UI.Lotro.Font.TrajanPro15 );
    _G.wSS.searchLabel:SetForeColor( Color["gold"] );
	 
    _G.wSS.SearchTextBox = Turbine.UI.Lotro.TextBox();
    _G.wSS.SearchTextBox:SetParent( _G.wSS );
    _G.wSS.SearchTextBox:SetPosition(  _G.wSS.searchLabel:GetLeft() +  _G.wSS.searchLabel:GetWidth(),  _G.wSS.searchLabel:GetTop() );
    _G.wSS.SearchTextBox:SetSize( _G.wSS:GetWidth() - 150, 18 );
    _G.wSS.SearchTextBox:SetFont( Turbine.UI.Lotro.Font.Verdana14 );
	_G.wSS.SearchTextBox:SetMultiline( false );
	
    _G.wSS.SearchTextBox.TextChanged = function( sender, args )
        _G.wSS.searchText = string.lower( _G.wSS.SearchTextBox:GetText() );
        if _G.wSS.searchText == "" then _G.wSS.searchText = nil; end
        SetSharedStoragePack();
    end

	_G.wSS.SearchTextBox.FocusLost = function( sender, args )
		
	end
	-- **^
	--**v clear search text box icon v**
	_G.wSS.DelIcon = Turbine.UI.Label();
	_G.wSS.DelIcon:SetParent( _G.wSS );
	_G.wSS.DelIcon:SetPosition( _G.wSS.SearchTextBox:GetLeft() + _G.wSS.SearchTextBox:GetWidth() + 5, _G.wSS.SearchTextBox:GetTop() );
	_G.wSS.DelIcon:SetSize( 16, 16 );
	_G.wSS.DelIcon:SetBackground( 0x4101f893 );
	_G.wSS.DelIcon:SetBlendMode( 4 );
	_G.wSS.DelIcon:SetVisible( true );
				
	_G.wSS.DelIcon.MouseClick = function( sender, args )
		_G.wSS.SearchTextBox:SetText( "" );
		_G.wSS.SearchTextBox.TextChanged( sender, args );
		_G.wSS.SearchTextBox:Focus();
	end
	-- **^
	-- **v Set the item listbox border v**
	_G.wSS.ListBoxBorder = Turbine.UI.Control();
	_G.wSS.ListBoxBorder:SetParent( _G.wSS );
	_G.wSS.ListBoxBorder:SetSize( _G.wSS:GetWidth() - 30, 392 );
	_G.wSS.ListBoxBorder:SetPosition( 15, _G.wSS.SearchTextBox:GetTop() + _G.wSS.SearchTextBox:GetHeight()+5 );
	_G.wSS.ListBoxBorder:SetBackColor( Color["grey"] );
	-- **^
	-- **v Set the item listbox v**
	_G.wSS.ListBox = Turbine.UI.ListBox();
	_G.wSS.ListBox:SetParent( _G.wSS );
	_G.wSS.ListBox:SetSize( _G.wSS.ListBoxBorder:GetWidth() - 4, _G.wSS.ListBoxBorder:GetHeight() - 4 );
	_G.wSS.ListBox:SetPosition( _G.wSS.ListBoxBorder:GetLeft() + 2, _G.wSS.ListBoxBorder:GetTop() + 2 );
	_G.wSS.ListBox:SetMaxItemsPerLine( 1 );
	_G.wSS.ListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	_G.wSS.ListBox:SetBackColor( Color["black"] );
	-- **^
	-- **v Set the listbox scrollbar v**
	_G.wSS.ListBoxScrollBar = Turbine.UI.Lotro.ScrollBar();
	_G.wSS.ListBoxScrollBar:SetParent( _G.wSS.ListBox );
	_G.wSS.ListBoxScrollBar:SetPosition( _G.wSS.ListBox:GetWidth() - 10, 0 );
	_G.wSS.ListBoxScrollBar:SetSize( 12, _G.wSS.ListBox:GetHeight() );
	_G.wSS.ListBoxScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	_G.wSS.ListBox:SetVerticalScrollBar( _G.wSS.ListBoxScrollBar );
	-- **^
	
	sspackCount = 0;
	if PlayerSharedStorage ~= nil then for k, v in pairs(PlayerSharedStorage) do sspackCount = sspackCount + 1; end end

	if sspackCount == 0 then --Shared storage is empty
		_G.wSS.ListBoxBorder:SetVisible( false );
		_G.wSS.ListBox:SetVisible( false );
		_G.wSS.searchLabel:SetVisible( false );
		_G.wSS.SearchTextBox:SetVisible( false );
		_G.wSS.DelIcon:SetVisible( false );
		
		local lblmgs = Turbine.UI.Label();
		lblmgs:SetParent( _G.wSS );
		lblmgs:SetText( L["SSnd"] );
		lblmgs:SetPosition( 17, 40 );
		lblmgs:SetSize( _G.wSS:GetWidth()-32, 39 );
		lblmgs:SetForeColor( Color["green"] );
		lblmgs:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		
		_G.wSS:SetHeight( lblmgs:GetHeight() + 65 );
		_G.wSS.ListBoxScrollBar:SetVisible( false );
	else
		_G.wSS:SetHeight( 475 );
		SetSharedStoragePack();
	end

	AddCallback(tsspack, "CountChanged", function(sender, args) if frmSS then sspackCount = tsspack:GetCount(); SetSharedStoragePack(); end end);
end

function SetSharedStoragePack()
	_G.wSS.ListBox:ClearItems();
	itemCtl = {};

	for i = 1, sspackCount do
		local itemName = PlayerSharedStorage[tostring(i)].T;
		if not _G.wSS.searchText or string.find(string.lower( itemName ), _G.wSS.searchText, 1, true) then
			-- Item control
			itemCtl[i] = Turbine.UI.Control();
			itemCtl[i]:SetSize( _G.wSS.ListBox:GetWidth() - 10, 35 );
		
			-- Item Background
			local itemBG = Turbine.UI.Control();
			itemBG:SetParent( itemCtl[i] );
			itemBG:SetSize( 32, 32 );
			itemBG:SetPosition( 3, 3 );
			if PlayerSharedStorage[tostring(i)].B ~= "0" then itemBG:SetBackground( tonumber(PlayerSharedStorage[tostring(i)].B) ); end
			itemBG:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		
			-- Item Underlay
			local itemU = Turbine.UI.Control();
			itemU:SetParent( itemCtl[i] );
			itemU:SetSize( 32, 32 );
			itemU:SetPosition( 3, 3 );
			if PlayerSharedStorage[tostring(i)].U ~= "0" then itemU:SetBackground( tonumber(PlayerSharedStorage[tostring(i)].U) ); end
			itemU:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		
			-- Item Shadow
			local itemS = Turbine.UI.Control();
			itemS:SetParent( itemCtl[i] );
			itemS:SetSize( 32, 32 );
			itemS:SetPosition( 3, 3 );
			if PlayerSharedStorage[tostring(i)].S ~= "0" then itemS:SetBackground(tonumber(PlayerSharedStorage[tostring(i)].S)); end
			itemS:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		
			-- Item Image
			local item = Turbine.UI.Control();
			item:SetParent( itemCtl[i] );
			item:SetSize( 32, 32 );
			item:SetPosition( 3, 3 );
			if PlayerSharedStorage[tostring(i)].I ~= "0" then item:SetBackground( tonumber(PlayerSharedStorage[tostring(i)].I) ); end
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
			itemQTE:SetText( tonumber(PlayerSharedStorage[tostring(i)].N) );

			-- Item name
			local itemLbl = Turbine.UI.Label();
			itemLbl:SetParent( itemCtl[i] );
			itemLbl:SetSize( itemCtl[i]:GetWidth() - 35, 35 );
			itemLbl:SetPosition( 37, 2 );
			itemLbl:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
			itemLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			itemLbl:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
			itemLbl:SetForeColor( Color["white"] );
			itemLbl:SetText( PlayerSharedStorage[tostring(i)].T );

			_G.wSS.ListBox:AddItem( itemCtl[i] );
		end
	end
end