-- bags.lua
-- written by Habna


function frmBagInfos()
	frmBI = true;
	tbagspack = Backpack;
	SelCN = PN;
	import (AppClassD.."ComboBox");
	BagsCB = HabnaPlugins.HugeBag.Class.ComboBox();
	
	-- **v Set some window stuff v**
	wBagInfos = Turbine.UI.Lotro.Window();
	wBagInfos:SetText( L["BIh"] );
	wBagInfos:SetPosition( BIWLeft, BIWTop );
	wBagInfos:SetSize( 390, 520 );
	wBagInfos:SetWantsKeyEvents( true );
	wBagInfos:SetVisible( true );
	--wBagInfos:SetZOrder( 2 );
	--wBagInfos:Activate();

	wBagInfos.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			wBagInfos:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			wBagInfos:SetVisible( not wBagInfos:IsVisible() );
		end
	end

	wBagInfos.MouseMove = function( sender, args )
		if dragging then BagsCB:CloseDropDown(); end
	end

	wBagInfos.MouseDown = function( sender, args )
		dragging = true;
	end

	wBagInfos.MouseUp = function( sender, args )
		dragging = false;
		HBsettings.BagInfos.L = string.format("%.0f", wBagInfos:GetLeft());
		HBsettings.BagInfos.T = string.format("%.0f", wBagInfos:GetTop());
		BIWLeft, BIWTop = wBagInfos:GetPosition();
		SaveSettings( false );
	end

	wBagInfos.Closing = function( sender, args ) -- Function for the Upper right X icon
		BagsCB.dropDownWindow:SetVisible(false);
		wBagInfos:SetWantsKeyEvents( false );
		ViewItems[1]:SetChecked( false );
		RemoveCallback( tbagspack, "ItemAdded" );
		RemoveCallback( tbagspack, "ItemRemoved" );
		wBagInfos = nil;
		frmBI = nil;
	end
	-- **^
	-- **v Create drop down box v**
	BagsCB:SetParent( wBagInfos );
	BagsCB:SetSize( 159, 19 );
	BagsCB:SetPosition( 15, 35 );

	BagsCB.dropDownWindow:SetParent( wBagInfos );
	BagsCB.dropDownWindow:SetPosition(BagsCB:GetLeft(), BagsCB:GetTop() + BagsCB:GetHeight()+2);

	BagsCB.ItemChanged = function () -- The event that's executed when a menu item is clicked.
		wBagInfos.SearchTextBox:SetText( "" );
		wBagInfos.SearchTextBox.TextChanged( sender, args );
		SelCN = BagsCB.label:GetText();
		CountBagsItems();
	end

	CreateBagsComboBox();
	-- **^
	-- **v search label & text box v**
	wBagInfos.searchLabel = Turbine.UI.Label();
    wBagInfos.searchLabel:SetParent( wBagInfos );
    wBagInfos.searchLabel:SetText( L["VTSe"] );
    wBagInfos.searchLabel:SetPosition( 15, 60 );
    wBagInfos.searchLabel:SetSize( wBagInfos.searchLabel:GetTextLength() * 8, 18 ); --Auto size with text lenght
    wBagInfos.searchLabel:SetFont( Turbine.UI.Lotro.Font.TrajanPro15 );
    wBagInfos.searchLabel:SetForeColor( Color["gold"] );
	 
    wBagInfos.SearchTextBox = Turbine.UI.Lotro.TextBox();
    wBagInfos.SearchTextBox:SetParent( wBagInfos );
    wBagInfos.SearchTextBox:SetPosition(  wBagInfos.searchLabel:GetLeft() +  wBagInfos.searchLabel:GetWidth(),  wBagInfos.searchLabel:GetTop() );
    wBagInfos.SearchTextBox:SetSize( wBagInfos:GetWidth() - 150, 18 );
    wBagInfos.SearchTextBox:SetFont( Turbine.UI.Lotro.Font.Verdana14 );
	wBagInfos.SearchTextBox:SetMultiline( false );
	
    wBagInfos.SearchTextBox.TextChanged = function( sender, args )
        wBagInfos.searchText = string.lower( wBagInfos.SearchTextBox:GetText() );
        if wBagInfos.searchText == "" then wBagInfos.searchText = nil; end
        CountBagsItems();
    end

	wBagInfos.SearchTextBox.FocusLost = function( sender, args )
		
	end
	-- **^
	--**v clear search text box icon v**
	wBagInfos.DelIcon = Turbine.UI.Label();
	wBagInfos.DelIcon:SetParent( wBagInfos );
	wBagInfos.DelIcon:SetPosition( wBagInfos.SearchTextBox:GetLeft() + wBagInfos.SearchTextBox:GetWidth() + 5, wBagInfos.SearchTextBox:GetTop() );
	wBagInfos.DelIcon:SetSize( 16, 16 );
	wBagInfos.DelIcon:SetBackground( 0x4101f893 );
	wBagInfos.DelIcon:SetBlendMode( 4 );
	wBagInfos.DelIcon:SetVisible( true );
				
	wBagInfos.DelIcon.MouseClick = function( sender, args )
		wBagInfos.SearchTextBox:SetText( "" );
		wBagInfos.SearchTextBox.TextChanged( sender, args );
		wBagInfos.SearchTextBox:Focus();
	end
	-- **^
	-- **v Set the itemlistbox border v**
	wBagInfos.ListBoxBorder = Turbine.UI.Control();
	wBagInfos.ListBoxBorder:SetParent( wBagInfos );
	wBagInfos.ListBoxBorder:SetPosition( 15, wBagInfos.SearchTextBox:GetTop() + wBagInfos.SearchTextBox:GetHeight() + 5 );
	wBagInfos.ListBoxBorder:SetSize( wBagInfos:GetWidth()-30, 392 );
	wBagInfos.ListBoxBorder:SetBackColor( Color["grey"] );
	-- **^
	-- **v Set the itemlistbox v**
	wBagInfos.ListBox = Turbine.UI.ListBox();
	wBagInfos.ListBox:SetParent( wBagInfos );
	wBagInfos.ListBox:SetSize( wBagInfos.ListBoxBorder:GetWidth() - 4, wBagInfos.ListBoxBorder:GetHeight() - 4 );
	wBagInfos.ListBox:SetPosition( wBagInfos.ListBoxBorder:GetLeft() + 2, wBagInfos.ListBoxBorder:GetTop() + 2 );
	wBagInfos.ListBox:SetMaxItemsPerLine( 1 );
	wBagInfos.ListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	wBagInfos.ListBox:SetBackColor( Color["black"] );
	-- **^
	-- **v Set the scrollbar v**
	wBagInfos.ListBoxScrollBar = Turbine.UI.Lotro.ScrollBar();
	wBagInfos.ListBoxScrollBar:SetParent( wBagInfos.ListBox );
	wBagInfos.ListBoxScrollBar:SetPosition( wBagInfos.ListBox:GetWidth() - 10, 0 );
	wBagInfos.ListBoxScrollBar:SetSize( 10, wBagInfos.ListBox:GetHeight() );
	wBagInfos.ListBoxScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	wBagInfos.ListBox:SetVerticalScrollBar( wBagInfos.ListBoxScrollBar );
	-- **^
	-- **v Delete character infos button v**
	wBagInfos.ButtonDelete = Turbine.UI.Lotro.Button();
	wBagInfos.ButtonDelete:SetParent( wBagInfos );
	wBagInfos.ButtonDelete:SetText( L["ButDel"] );
	wBagInfos.ButtonDelete:SetSize( wBagInfos.ButtonDelete:GetTextLength() * 11, 15 ); --Auto size with text lenght
	wBagInfos.ButtonDelete:SetPosition( wBagInfos:GetWidth()/2 - wBagInfos.ButtonDelete:GetWidth()/2, wBagInfos.ListBox:GetTop()+ wBagInfos.ListBox:GetHeight()+5 );

	wBagInfos.ButtonDelete.Click = function( sender, args )
		PlayerBags[SelCN] = nil;
		SavePlayerBags();
		write(SelCN .. L["BID"]);
		SelCN = PN;
		BagsCB.selection = -1;
		CreateBagsComboBox();
		CountBagsItems();
	end
	-- **^
	
	AddCallback(tbagspack, "ItemAdded", 
		function(sender, args)
		if frmBI then
			if SelCN == PN then SavePlayerBags(); CountBagsItems();
			elseif SelCN == L["VTAll"] then CountBagsItems(); end
		end
	end);

	--**v Workaround for the ItemRemoved that fire before the backpack was updated (Turnine API issue) v**
	BIItemRemovedTimer = Turbine.UI.Control();
	BIItemRemovedTimer.Update = function( sender, args )
		BIItemRemovedTimer:SetWantsUpdates( false );
		if frmBI then
			if SelCN == PN then SavePlayerBags(); CountBagsItems();
			elseif SelCN == L["VTAll"] then CountBagsItems(); end
		end
	end

	AddCallback(tbagspack, "ItemRemoved", function(sender, args) BIItemRemovedTimer:SetWantsUpdates( true ); end); --Workaround

	CountBagsItems();
end

function CreateBagsComboBox()
	-- **v Create an array of character name, sort it, then use it as a reference - label & DropDown box v**
	local newt = {}
	for i in pairs(PlayerBags) do
		if string.sub( i, 1, 1 ) == "~" then PlayerBags[i] = nil; else table.insert(newt, i); end --Delete session play character
	end
	table.sort(newt);
	BagsCB.listBox:ClearItems();
	BagsCB:AddItem( L["VTAll"], 0 );
	for k,v in pairs(newt) do
		BagsCB:AddItem(v, k);
		if v == PN then BagsCB:SetSelection(k); end
	end
	-- **^
end

function CountBagsItems()
	bagspackCount = 0;
	wBagInfos.ListBox:ClearItems();
	itemCtl = {};
	titem = nil;

	if SelCN == L["VTAll"] then
		wBagInfos.ButtonDelete:SetEnabled( false );
        for i in pairs(PlayerBags) do
			if i == PN then bagspackCount = tbagspack:GetSize();
			else for k, v in pairs(PlayerBags[i]) do bagspackCount = bagspackCount + 1; end end
            AddBagsPack(i, true);
			bagspackCount = 0;
        end
    else
		if SelCN == PN then wBagInfos.ButtonDelete:SetEnabled( false ); bagspackCount = tbagspack:GetSize();
		else wBagInfos.ButtonDelete:SetEnabled( true ); for k, v in pairs(PlayerBags[SelCN]) do bagspackCount = bagspackCount + 1; end end
		AddBagsPack(SelCN, false);
    end
 
    wBagInfos.ButtonDelete:SetPosition( wBagInfos:GetWidth()/2 - wBagInfos.ButtonDelete:GetWidth()/2, wBagInfos.ListBox:GetTop() + wBagInfos.ListBox:GetHeight()+10 );
end

function AddBagsPack(n, addCharacterName)
	for i = 1, bagspackCount do
		if n == PN then titem = tbagspack:GetItem(i); if titem ~= nil then itemName = titem:GetName(); else itemName = ""; end
		else titem = PlayerBags[n][tostring(i)]; itemName = PlayerBags[n][tostring(i)].T; end

		if not wBagInfos.searchText or string.find(string.lower( itemName ), wBagInfos.searchText, 1, true) then
			-- Item control
			itemCtl[i] = Turbine.UI.Control();
			itemCtl[i]:SetSize( wBagInfos.ListBox:GetWidth() - 10, 35 );

			if n == PN then
				-- Item Background/Underlay/Shadow/Image
				local itemBG = Turbine.UI.Lotro.ItemControl( titem );
				itemBG:SetParent( itemCtl[i] );
				itemBG:SetSize( 34, 34 );
				itemBG:SetPosition( 0, 0 );
			else
				-- Item Background
				local itemBG = Turbine.UI.Control();
				itemBG:SetParent( itemCtl[i] );
				itemBG:SetSize( 32, 32 );
				itemBG:SetPosition( 3, 3 );
				if PlayerBags[n][tostring(i)].B ~= "0" then itemBG:SetBackground( tonumber(PlayerBags[n][tostring(i)].B) ); end
				itemBG:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			
				-- Item Underlay
				local itemU = Turbine.UI.Control();
				itemU:SetParent( itemCtl[i] );
				itemU:SetSize( 32, 32 );
				itemU:SetPosition( 3, 3 );
				if PlayerBags[n][tostring(i)].U ~= "0" then itemU:SetBackground( tonumber(PlayerBags[n][tostring(i)].U) ); end
				itemU:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			
				-- Item Shadow
				local itemS = Turbine.UI.Control();
				itemS:SetParent( itemCtl[i] );
				itemS:SetSize( 32, 32 );
				itemS:SetPosition( 3, 3 );
				if PlayerBags[n][tostring(i)].S ~= "0" then itemS:SetBackground( tonumber(PlayerBags[n][tostring(i)].S) ); end
				itemS:SetBlendMode( Turbine.UI.BlendMode.Overlay );
			
				-- Item
				local item = Turbine.UI.Control();
				item:SetParent( itemCtl[i] );
				item:SetSize( 32, 32 );
				item:SetPosition( 3, 3 );
				if PlayerBags[n][tostring(i)].I ~= "0" then item:SetBackground( tonumber(PlayerBags[n][tostring(i)].I) ); end
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
				itemQTE:SetText( tonumber(PlayerBags[n][tostring(i)].N) );
			end
		
			-- Item name
			local itemLbl = Turbine.UI.Label();
			itemLbl:SetParent( itemCtl[i] );
			itemLbl:SetSize( itemCtl[i]:GetWidth() - 35, 35 );
			itemLbl:SetPosition( 37, 2 );
			itemLbl:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
			itemLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			itemLbl:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
			itemLbl:SetForeColor( Color["white"] );

			if titem ~= nil then
				itemLbl:SetText( itemName );
				wBagInfos.ListBox:AddItem( itemCtl[i] );
			end

			if addCharacterName then itemLbl:AppendText( " (" .. n .. ")" ); end
		end
	end
end