-- TrackItemsWindow.lua
-- Written by Habna


local player = Turbine.Gameplay.LocalPlayer.GetInstance();
local backpack = player:GetBackpack();
local size = backpack:GetSize();

function frmTrackItemsWindow()
	-- **v Set some window stuff v**
	_G.wTI = Turbine.UI.Lotro.Window();
	_G.wTI:SetWidth( 390 );
    _G.wTI:SetPosition( BIWLeft, BIWTop );
	_G.wTI:SetText( L["BIIL"] );
	_G.wTI:SetVisible( true );
	_G.wTI:SetWantsKeyEvents( true );
	--_G.wTI:SetZOrder( 2 );
	_G.wTI:Activate();

	_G.wTI.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			_G.wTI:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			_G.wTI:SetVisible( not _G.wTI:IsVisible() );
		end
	end

	_G.wTI.MouseUp = function( sender, args )
		settings.BagInfos.L = string.format("%.0f", _G.wTI:GetLeft());
		settings.BagInfos.T = string.format("%.0f", _G.wTI:GetTop());
		BIWLeft, BIWTop = _G.wTI:GetPosition();
		SaveSettings( false );
	end

	_G.wTI.Closing = function( sender, args )
		_G.wTI:SetWantsKeyEvents( false );
		_G.wTI = nil;
		_G.frmTI = nil;
	end
	
	_G.wTI.lblBackPack = Turbine.UI.Label();
	_G.wTI.lblBackPack:SetParent( _G.wTI );
	_G.wTI.lblBackPack:SetText( L["BIT"] );
	_G.wTI.lblBackPack:SetPosition( 0, 35);
	_G.wTI.lblBackPack:SetSize( _G.wTI:GetWidth() , 15 );
	_G.wTI.lblBackPack:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	_G.wTI.lblBackPack:SetForeColor( Color["green"] );

	-- **v search label & text box v**
	_G.wTI.searchLabel = Turbine.UI.Label();
    _G.wTI.searchLabel:SetParent( _G.wTI );
    _G.wTI.searchLabel:SetText( L["VTSe"] );
    _G.wTI.searchLabel:SetPosition( 15, 60 );
    _G.wTI.searchLabel:SetSize( _G.wTI.searchLabel:GetTextLength() * 8, 18 ); --Auto size with text lenght
    _G.wTI.searchLabel:SetFont( Turbine.UI.Lotro.Font.TrajanPro15 );
    _G.wTI.searchLabel:SetForeColor( Color["gold"] );
	 
    _G.wTI.SearchTextBox = Turbine.UI.Lotro.TextBox();
    _G.wTI.SearchTextBox:SetParent( _G.wTI );
    _G.wTI.SearchTextBox:SetPosition(  _G.wTI.searchLabel:GetLeft() +  _G.wTI.searchLabel:GetWidth(),  _G.wTI.searchLabel:GetTop() );
    _G.wTI.SearchTextBox:SetSize( _G.wTI:GetWidth() - 150, 18 );
    _G.wTI.SearchTextBox:SetFont( Turbine.UI.Lotro.Font.Verdana14 );
	_G.wTI.SearchTextBox:SetMultiline( false );
	
    _G.wTI.SearchTextBox.TextChanged = function( sender, args )
        _G.wTI.searchText = string.lower( _G.wTI.SearchTextBox:GetText() );
        if _G.wTI.searchText == "" then _G.wTI.searchText = nil; end
        ShowStackableItems();
    end

	_G.wTI.SearchTextBox.FocusLost = function( sender, args )
		
	end
	-- **^
	--**v clear search text box icon v**
	_G.wTI.DelIcon = Turbine.UI.Label();
	_G.wTI.DelIcon:SetParent( _G.wTI );
	_G.wTI.DelIcon:SetPosition( _G.wTI.SearchTextBox:GetLeft() + _G.wTI.SearchTextBox:GetWidth() + 5, _G.wTI.SearchTextBox:GetTop() );
	_G.wTI.DelIcon:SetSize( 16, 16 );
	_G.wTI.DelIcon:SetBackground( 0x4101f893 );
	_G.wTI.DelIcon:SetBlendMode( 4 );
	_G.wTI.DelIcon:SetVisible( true );
				
	_G.wTI.DelIcon.MouseClick = function( sender, args )
		_G.wTI.SearchTextBox:SetText( "" );
		_G.wTI.SearchTextBox.TextChanged( sender, args );
		_G.wTI.SearchTextBox:Focus();
	end
	-- **^
	-- **v Set the item listbox border v**
	_G.wTI.ListBoxBorder = Turbine.UI.Control();
	_G.wTI.ListBoxBorder:SetParent( _G.wTI );
	_G.wTI.ListBoxBorder:SetWidth( _G.wTI:GetWidth() - 30 );
	_G.wTI.ListBoxBorder:SetBackColor( Color["grey"] );
	-- **^
	-- **v Set the item listbox v**
	_G.wTI.ListBox = Turbine.UI.ListBox();
	_G.wTI.ListBox:SetParent( _G.wTI );
	_G.wTI.ListBox:SetWidth( _G.wTI.ListBoxBorder:GetWidth() - 4 );
	_G.wTI.ListBox:SetMaxItemsPerLine( 1 );
	_G.wTI.ListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	_G.wTI.ListBox:SetBackColor( Color["black"] );
	-- **^
	-- **v Set the listbox scrollbar v**
	_G.wTI.ListBoxScrollBar = Turbine.UI.Lotro.ScrollBar();
	_G.wTI.ListBoxScrollBar:SetParent( _G.wTI.ListBox );
	_G.wTI.ListBoxScrollBar:SetPosition( _G.wTI.ListBox:GetWidth() - 10, 0 );
	_G.wTI.ListBoxScrollBar:SetWidth( 12 );
	_G.wTI.ListBoxScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	_G.wTI.ListBox:SetVerticalScrollBar( _G.wTI.ListBoxScrollBar );
	-- **^

	CheckForStackableItems();
end

function CheckForStackableItems()
	item = {};
	itemCtl = {};
	itemLbl = {};
	bFound = false;

	for i = 1, size do
		item[i] = backpack:GetItem( i );
		if item[i] ~= nil then
			local iteminfo = item[i]:GetItemInfo();
			item[i].Name = iteminfo:GetName();
			if iteminfo:GetMaxStackSize() > 1 then
				bFound = true
				item[i].Stackable = true;
			else
				item[i].Stackable = false;
			end
		else
			item[i] = "zEmpty";
		end
	end
	
	if bFound then ShowStackableItems();
	else SetEmptyTrackList(); end
end

function SetEmptyTrackList()
	itemCtl = Turbine.UI.Control();
	itemCtl:SetSize( _G.wTI.ListBox:GetWidth(), 35 );

	local lblmgs = Turbine.UI.Label();
	lblmgs:SetParent( itemCtl );
	lblmgs:SetText( L["BIMsg"] );
	lblmgs:SetPosition( 0, 0 );
	lblmgs:SetSize( itemCtl:GetWidth(), itemCtl:GetHeight() );
	lblmgs:SetForeColor( Color["red"] );
	lblmgs:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );

	_G.wTI.ListBoxBorder:SetPosition( 15, 60 );
	_G.wTI.ListBoxBorder:SetHeight( lblmgs:GetHeight() + 4 );
	_G.wTI.ListBox:SetPosition( _G.wTI.ListBoxBorder:GetLeft() + 2, _G.wTI.ListBoxBorder:GetTop() + 2 );
	_G.wTI.ListBox:SetHeight( lblmgs:GetHeight() );
	_G.wTI.ListBoxScrollBar:SetVisible( false );

	_G.wTI.ListBox:AddItem( itemCtl );
	_G.wTI:SetHeight( itemCtl:GetHeight() + 85 );
end

function ShowStackableItems()
	_G.wTI.ListBox:ClearItems();

	for i = 1, size do
		if item[i] ~= "zEmpty" and item[i].Stackable then -- Only show stackable item
			if not _G.wTI.searchText or string.find(string.lower( item[i].Name ), _G.wTI.searchText, 1, true) then
				-- Item control
				itemCtl[i] = Turbine.UI.Control();
				itemCtl[i]:SetSize( _G.wTI.ListBox:GetWidth() - 10, 35 );

				-- Item Background/Underlay/Shadow/Image
				local itemBG = Turbine.UI.Lotro.ItemControl( item[i] );
				itemBG:SetParent( itemCtl[i] );
				itemBG:SetSize( 34, 34 );
				itemBG:SetPosition( 0, 0 );

				-- Item name
				itemLbl[i] = Turbine.UI.Label();
				itemLbl[i]:SetParent( itemCtl[i] );
				itemLbl[i]:SetSize( _G.wTI.ListBox:GetWidth() - 48, 33 );
				itemLbl[i]:SetPosition( 36, 3 );
				itemLbl[i]:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
				itemLbl[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
				itemLbl[i]:SetBackColorBlendMode( 5 );
				itemLbl[i]:SetForeColor( Color["white"] );
				itemLbl[i]:SetText( item[i].Name );
				itemLbl[i].Sel = false;

				itemLbl[i].MouseClick = function( sender, args )
					if ( args.Button == Turbine.UI.MouseButton.Left ) then
						if not itemLbl[i].Sel then
							itemLbl[i].Sel = true;
							itemLbl[i]:SetForeColor( Color["green"] );

							local tITL = {};
							local iteminfo = item[i]:GetItemInfo();
							tITL[item[i].Name] = {};
							tITL[item[i].Name].Q = tostring(iteminfo:GetQualityImageID());
							tITL[item[i].Name].B = tostring(iteminfo:GetBackgroundImageID());
							tITL[item[i].Name].U = tostring(iteminfo:GetUnderlayImageID());
							tITL[item[i].Name].S = tostring(iteminfo:GetShadowImageID());
							tITL[item[i].Name].I = tostring(iteminfo:GetIconImageID());
							table.insert( ITL, tITL );
							
							SavePlayerItemTrackingList(ITL);

							--Check all listbox for identical item name
							for ii = 1, size do
								if item[ii] ~= "zEmpty" and item[ii].Stackable then
									if ii ~= i then
										if item[ii].Name == itemLbl[i]:GetText() then
											itemLbl[ii]:SetForeColor( Color["green"] );
											itemLbl[ii]:SetBackColor( Color["darkgrey"] );
											itemLbl[ii].Sel = true;
										end
									end
								end
							end
						else
							itemLbl[i].Sel = false;
							itemLbl[i]:SetForeColor( Color["white"] );

							local iFoundAt = 0;
							for ii = 1, #ITL do
								for k, v in pairs(ITL[ii]) do
									if k == itemLbl[i]:GetText() then iFoundAt = ii; break end
								end
							end
						
							table.remove( ITL, iFoundAt );
							SavePlayerItemTrackingList(ITL)

							--Check all listbox for identical item name
							for ii = 1, size do
								if item[ii] ~= "zEmpty" and item[ii].Stackable then
									if ii ~= i then
										if item[ii].Name == itemLbl[i]:GetText() then
											itemLbl[ii]:SetForeColor( Color["white"] );
											itemLbl[ii]:SetBackColor( Color["black"] );
											itemLbl[ii].Sel = false;
										end
									end
								end
							end
						end
					end
				end

				itemLbl[i].MouseHover = function(sender, args)
					itemLbl[i]:SetBackColor( Color["lightgrey"] );
				end

				itemLbl[i].MouseLeave = function(sender, args)
					if itemLbl[i].Sel then itemLbl[i]:SetBackColor( Color["darkgrey"] ); else itemLbl[i]:SetBackColor( Color["black"] ); end
				end

				_G.wTI.ListBox:AddItem( itemCtl[i] );
			end
		end
	end
	
	for i = 1, #ITL do
		for k, v in pairs(ITL[i]) do
			for ii = 1, size do
				if item[ii] ~= "zEmpty" and item[ii].Stackable then
					if k == itemLbl[ii]:GetText() then
						itemLbl[ii]:SetForeColor( Color["green"] );
						itemLbl[ii]:SetBackColor( Color["darkgrey"] );
						itemLbl[ii].Sel = true;
					end
				end
			end
		end
	end

	_G.wTI.ListBoxBorder:SetPosition( 15, _G.wTI.SearchTextBox:GetTop() + _G.wTI.SearchTextBox:GetHeight() + 5 );
	_G.wTI.ListBoxBorder:SetHeight( 392 );
	_G.wTI.ListBox:SetPosition( _G.wTI.ListBoxBorder:GetLeft() + 2, _G.wTI.ListBoxBorder:GetTop() + 2 );
	_G.wTI.ListBox:SetHeight( _G.wTI.ListBoxBorder:GetHeight() - 4 );
	_G.wTI.ListBoxScrollBar:SetHeight( _G.wTI.ListBox:GetHeight() );
	_G.wTI:SetHeight( 498 );
end