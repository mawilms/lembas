-- sharedstorage.lua
-- written by Habna


function frmSharedStorage()
	frmSS = true;
	tsspack = sspack;
	wSharedStorage = Turbine.UI.Lotro.Window()

	-- **v Set some window stuff v**
	wSharedStorage:SetText( L["OWidStorage"] );
	wSharedStorage:SetPosition( SSWLeft, SSWTop );
	wSharedStorage:SetWidth( 390 );
	wSharedStorage:SetWantsKeyEvents( true );
	wSharedStorage:SetVisible( true );
	--wSharedStorage:SetZOrder( 2 );
	--wSharedStorage:Activate();

	wSharedStorage.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			wSharedStorage:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			wSharedStorage:SetVisible( not wSharedStorage:IsVisible() );
		end
	end

	wSharedStorage.MouseUp = function( sender, args )
		HBsettings.SharedStorage.L = string.format("%.0f", wSharedStorage:GetLeft());
		HBsettings.SharedStorage.T = string.format("%.0f", wSharedStorage:GetTop());
		SSWLeft, SSWTop = wSharedStorage:GetPosition();
		SaveSettings();
	end

	wSharedStorage.Closing = function( sender, args ) -- Function for the Upper right X icon
		wSharedStorage:SetWantsKeyEvents( false );
		ViewItems[3]:SetChecked( false );
		RemoveCallback( tsspack, "CountChanged" );
		wSharedStorage = nil;
		frmSS = nil;
	end
	-- **^

	-- **v search label & text box v**
	wSharedStorage.searchLabel = Turbine.UI.Label();
    wSharedStorage.searchLabel:SetParent( wSharedStorage );
    wSharedStorage.searchLabel:SetText( L["VTSe"] );
    wSharedStorage.searchLabel:SetPosition( 15, 40 );
    wSharedStorage.searchLabel:SetSize( wSharedStorage.searchLabel:GetTextLength() * 8, 18 ); --Auto size with text lenght
    wSharedStorage.searchLabel:SetFont( Turbine.UI.Lotro.Font.TrajanPro15 );
    wSharedStorage.searchLabel:SetForeColor( Color["gold"] );
	 
    wSharedStorage.SearchTextBox = Turbine.UI.Lotro.TextBox();
    wSharedStorage.SearchTextBox:SetParent( wSharedStorage );
    wSharedStorage.SearchTextBox:SetPosition(  wSharedStorage.searchLabel:GetLeft() +  wSharedStorage.searchLabel:GetWidth(),  wSharedStorage.searchLabel:GetTop() );
    wSharedStorage.SearchTextBox:SetSize( wSharedStorage:GetWidth() - 150, 18 );
    wSharedStorage.SearchTextBox:SetFont( Turbine.UI.Lotro.Font.Verdana14 );
	wSharedStorage.SearchTextBox:SetMultiline( false );
	
    wSharedStorage.SearchTextBox.TextChanged = function( sender, args )
        wSharedStorage.searchText = string.lower( wSharedStorage.SearchTextBox:GetText() );
        if wSharedStorage.searchText == "" then wSharedStorage.searchText = nil; end
        SetSharedStoragePack();
    end

	wSharedStorage.SearchTextBox.FocusLost = function( sender, args )
		
	end
	-- **^
	--**v clear search text box icon v**
	wSharedStorage.DelIcon = Turbine.UI.Label();
	wSharedStorage.DelIcon:SetParent( wSharedStorage );
	wSharedStorage.DelIcon:SetPosition( wSharedStorage.SearchTextBox:GetLeft() + wSharedStorage.SearchTextBox:GetWidth() + 5, wSharedStorage.SearchTextBox:GetTop() );
	wSharedStorage.DelIcon:SetSize( 16, 16 );
	wSharedStorage.DelIcon:SetBackground( 0x4101f893 );
	wSharedStorage.DelIcon:SetBlendMode( 4 );
	wSharedStorage.DelIcon:SetVisible( true );
				
	wSharedStorage.DelIcon.MouseClick = function( sender, args )
		wSharedStorage.SearchTextBox:SetText( "" );
		wSharedStorage.SearchTextBox.TextChanged( sender, args );
		wSharedStorage.SearchTextBox:Focus();
	end
	-- **^
	-- **v Set the itemlistbox border v**
	wSharedStorage.ListBoxBorder = Turbine.UI.Control();
	wSharedStorage.ListBoxBorder:SetParent( wSharedStorage );
	wSharedStorage.ListBoxBorder:SetSize( wSharedStorage:GetWidth() - 30, 392 );
	wSharedStorage.ListBoxBorder:SetPosition( 15, wSharedStorage.SearchTextBox:GetTop() + wSharedStorage.SearchTextBox:GetHeight()+5 );
	wSharedStorage.ListBoxBorder:SetBackColor( Color["grey"] );
	-- **^
	-- **v Set the itemlistbox v**
	wSharedStorage.ListBox = Turbine.UI.ListBox();
	wSharedStorage.ListBox:SetParent( wSharedStorage );
	wSharedStorage.ListBox:SetSize( wSharedStorage.ListBoxBorder:GetWidth() - 4, wSharedStorage.ListBoxBorder:GetHeight() - 4 );
	wSharedStorage.ListBox:SetPosition( wSharedStorage.ListBoxBorder:GetLeft() + 2, wSharedStorage.ListBoxBorder:GetTop() + 2 );
	wSharedStorage.ListBox:SetMaxItemsPerLine( 1 );
	wSharedStorage.ListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	wSharedStorage.ListBox:SetBackColor( Color["black"] );
	-- **^
	-- **v Set the scrollbar v**
	wSharedStorage.ListBoxScrollBar = Turbine.UI.Lotro.ScrollBar();
	wSharedStorage.ListBoxScrollBar:SetParent( wSharedStorage.ListBox );
	wSharedStorage.ListBoxScrollBar:SetPosition( wSharedStorage.ListBox:GetWidth() - 10, 0 );
	wSharedStorage.ListBoxScrollBar:SetSize( 10, wSharedStorage.ListBox:GetHeight() );
	wSharedStorage.ListBoxScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	wSharedStorage.ListBox:SetVerticalScrollBar( wSharedStorage.ListBoxScrollBar );
	-- **^
	
	sspackCount = 0;
	if PlayerSharedStorage ~= nil then for k, v in pairs(PlayerSharedStorage) do sspackCount = sspackCount + 1; end end

	if sspackCount == 0 then --Shared storage is empty
		wSharedStorage.ListBoxBorder:SetVisible( false );
		wSharedStorage.ListBox:SetVisible( false );
		wSharedStorage.searchLabel:SetVisible( false );
		wSharedStorage.SearchTextBox:SetVisible( false );
		wSharedStorage.DelIcon:SetVisible( false );
		
		local lblmgs = Turbine.UI.Label();
		lblmgs:SetParent( wSharedStorage );
		lblmgs:SetText( L["SSnd"] );
		lblmgs:SetPosition( 17, 40 );
		lblmgs:SetSize( wSharedStorage:GetWidth()-32, 39 );
		lblmgs:SetForeColor( Color["green"] );
		lblmgs:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		
		wSharedStorage:SetHeight( lblmgs:GetHeight() + 65 );
		wSharedStorage.ListBoxScrollBar:SetVisible( false );
	else
		wSharedStorage:SetHeight( 475 );
		SetSharedStoragePack();
	end

	AddCallback(tsspack, "CountChanged", function(sender, args) if frmSS then sspackCount = tsspack:GetCount(); SetSharedStoragePack(); end end);
end

function SetSharedStoragePack()
	wSharedStorage.ListBox:ClearItems();
	itemCtl = {};

	for i = 1, sspackCount do
		local itemName = PlayerSharedStorage[tostring(i)].T;
		if not wSharedStorage.searchText or string.find(string.lower( itemName ), wSharedStorage.searchText, 1, true) then
			-- Item control
			itemCtl[i] = Turbine.UI.Control();
			itemCtl[i]:SetSize( wSharedStorage.ListBox:GetWidth() - 10, 35 );
		
			-- Item Background
			local itemBG = Turbine.UI.Control();
			itemBG:SetParent( itemCtl[i] );
			itemBG:SetSize( 32, 32 );
			itemBG:SetPosition( 3, 3 );
			itemBG:SetBackground(tonumber(PlayerSharedStorage[tostring(i)].B));
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
			if PlayerSharedStorage[tostring(i)].S ~= "0" then itemS:SetBackground( tonumber(PlayerSharedStorage[tostring(i)].S) ); end
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

			wSharedStorage.ListBox:AddItem( itemCtl[i] );
		end
	end
end