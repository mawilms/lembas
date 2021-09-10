-- WalletWindow.lua
-- Written by Habna


function frmWalletWindow()
	wcur = nil;
	import (AppClassD.."ComboBox");
	WIDD = HabnaPlugins.TitanBar.Class.ComboBox();

	-- **v Set some window stuff v**
	_G.wWI = Turbine.UI.Lotro.Window();
	_G.wWI:SetSize( 280, 260 );
    _G.wWI:SetPosition( WIWLeft, WIWTop );
	_G.wWI:SetText( L["MBag"] );
	_G.wWI:SetVisible( true );
	_G.wWI:SetWantsKeyEvents( true );
	--_G.wWI:SetZOrder( 2 );
	_G.wWI:Activate();

	_G.wWI.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			_G.wWI:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key or 'ctrl + \' is press
			_G.wWI:SetVisible( not _G.wWI:IsVisible() );
		elseif ( args.Action == 162 ) then --Enter key was pressed
			WIbutSave.Click( sender, args );
		end
	end

	_G.wWI.MouseDown = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then dragging = true; end
	end

	_G.wWI.MouseMove = function( sender, args )
		if dragging then if WIDD.dropped then WIDD:CloseDropDown(); end end
	end

	_G.wWI.MouseUp = function( sender, args )
		dragging = false;
		settings.Wallet.L = string.format("%.0f", _G.wWI:GetLeft());
		settings.Wallet.T = string.format("%.0f", _G.wWI:GetTop());
		WIWLeft, WIWTop = _G.wWI:GetPosition();
		SaveSettings( false );
	end

	_G.wWI.Closing = function( sender, args )
		WIDD.dropDownWindow:SetVisible(false);
		_G.wWI:SetWantsKeyEvents( false );
		_G.wWI = nil;
		_G.frmWI = nil;
	end
	-- **^
	
	local WIlbltext = Turbine.UI.Label();
	WIlbltext:SetParent( _G.wWI );
	WIlbltext:SetText( L["WIt"] );
	WIlbltext:SetPosition( 20, 35);
	WIlbltext:SetSize( _G.wWI:GetWidth()-40 , 35 );
	WIlbltext:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	WIlbltext:SetForeColor( Color["green"] );

	-- **v Set the Wallet listbox v**
	WIListBox = Turbine.UI.ListBox();
	WIListBox:SetParent( _G.wWI );
	WIListBox:SetZOrder( 1 );
	WIListBox:SetPosition( 20, WIlbltext:GetTop()+WIlbltext:GetHeight()+5 );
	WIListBox:SetSize( _G.wWI:GetWidth()-40, _G.wWI:GetHeight()-95 );
	WIListBox:SetMaxItemsPerLine( 1 );
	WIListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	--WIListBox:SetBackColor( Color["red"] ); --debug purpose
	-- **^
	-- **v Set the listbox scrollbar v**
	WIListBoxScrollBar = Turbine.UI.Lotro.ScrollBar();
	WIListBoxScrollBar:SetParent( WIListBox );
	WIListBoxScrollBar:SetZOrder( 1 );
	WIListBoxScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	WIListBox:SetVerticalScrollBar( WIListBoxScrollBar );
	WIListBoxScrollBar:SetPosition( WIListBox:GetWidth() - 10, 0 );
	WIListBoxScrollBar:SetSize( 12, WIListBox:GetHeight() );
	-- **^

	WIWCtr = Turbine.UI.Control();
	WIWCtr:SetParent( _G.wWI );
	WIWCtr:SetPosition( WIListBox:GetLeft(), WIListBox:GetTop() );
	WIWCtr:SetSize( WIListBox:GetWidth(), WIListBox:GetHeight() );
	WIWCtr:SetZOrder( 0 );
	WIWCtr:SetVisible( false );
	WIWCtr:SetBlendMode( 5 );
	WIWCtr:SetBackground( 0x4100014c );

	WIWCtr.MouseClick = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Right ) then
			WIDD.Cleanup();
			WIWCtr:SetVisible( false );
			WIWCtr:SetZOrder( 0 );
		end
	end
	
	WIlblFN = Turbine.UI.Label();
	WIlblFN:SetParent( WIWCtr );
	WIlblFN:SetPosition( 0 , WIWCtr:GetHeight()/2 - 40 );
	WIlblFN:SetSize( WIWCtr:GetWidth() , 15 );
	WIlblFN:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
	WIlblFN:SetFontStyle( Turbine.UI.FontStyle.Outline );
	WIlblFN:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	WIlblFN:SetForeColor( Color["rustedgold"] );

	WICBO = { L["WIot"], L["WIiw"], L["WIds"] } --Combobox options
	
	-- **v Create drop down box v**
	WIDD:SetParent( WIWCtr );
	WIDD:SetSize( 170, 19 );
	WIDD:SetPosition( WIWCtr:GetWidth()/2 - WIDD:GetWidth()/2, WIlblFN:GetTop()+WIlblFN:GetHeight()+10 );

	WIDD.dropDownWindow:SetParent( WIWCtr );
	WIDD.dropDownWindow:SetPosition(WIDD:GetLeft(), WIDD:GetTop() + WIDD:GetHeight()+2);
	-- **^
	
	for k,v in pairs(WICBO) do WIDD:AddItem(v, k); end

	--** Turbine Point box
	TPWCtr = Turbine.UI.Control();
	TPWCtr:SetParent( WIWCtr );
	TPWCtr:SetPosition( WIListBox:GetLeft(), WIDD:GetTop()+WIDD:GetHeight()+10 );
	TPWCtr:SetZOrder( 2 );
	--TPWCtr:SetBackColor( Color["red"] ); -- debug purpose

	local WIlblTurbinePTS = Turbine.UI.Label();
	WIlblTurbinePTS:SetParent( TPWCtr );
	--WIlblTurbinePTS:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	WIlblTurbinePTS:SetText( L["MTP"] );
	WIlblTurbinePTS:SetPosition( 0, 2 );
	WIlblTurbinePTS:SetSize( WIlblTurbinePTS:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	WIlblTurbinePTS:SetForeColor( Color["rustedgold"] );
	WIlblTurbinePTS:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	--WIlblTurbinePTS:SetBackColor( Color["red"] ); -- debug purpose

	WItxtTurbinePTS = Turbine.UI.Lotro.TextBox();
	WItxtTurbinePTS:SetParent( TPWCtr );
	WItxtTurbinePTS:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	--WItxtTurbinePTS:SetText( _G.TurbinePTS );
	WItxtTurbinePTS:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	WItxtTurbinePTS:SetPosition( WIlblTurbinePTS:GetLeft()+WIlblTurbinePTS:GetWidth()+5, WIlblTurbinePTS:GetTop()-2 );
	WItxtTurbinePTS:SetSize( 80, 20 );
	WItxtTurbinePTS:SetMultiline( false );
	if PlayerAlign == 2 then WItxtTurbinePTS:SetBackColor( Color["red"] ); end

	WItxtTurbinePTS.FocusGained = function( sender, args )
		WItxtTurbinePTS:SelectAll();
		WItxtTurbinePTS:SetWantsUpdates( true );
	end

	WItxtTurbinePTS.FocusLost = function( sender, args )
		WItxtTurbinePTS:SetWantsUpdates( false );
	end

	WItxtTurbinePTS.Update = function( sender, args )
		local parsed_text = WItxtTurbinePTS:GetText();

		if tonumber(parsed_text) == nil or string.find(parsed_text,"%.") ~= nil then
			WItxtTurbinePTS:SetText( string.sub( parsed_text, 1, string.len(parsed_text)-1 ) );
			return
		elseif string.len(parsed_text) > 1 and string.sub(parsed_text,1,1) == "0" then
			WItxtTurbinePTS:SetText( string.sub( parsed_text, 2 ) );
			return
		end
	end

	TPWCtr:SetSize( WIListBox:GetWidth(), 20 );
	--**

	WIbutSave = Turbine.UI.Lotro.Button();
	WIbutSave:SetParent( WIWCtr );
	WIbutSave:SetText( L["PWSave"] );
	WIbutSave:SetSize( WIbutSave:GetTextLength() * 10, 15 ); --Auto size with text lenght
	--WIbutSave:SetEnabled( true );

	WIbutSave.Click = function( sender, args )
		WIWCtr:SetVisible( false );
		WIWCtr:SetZOrder( 0 );

		SelIndex = WIDD:GetSelection();
		--Where-> 1: On TitanBar / 2: In wallet control tooltip / 3: Don't show
		if wcur == L["MGSC"] then
			_G.MIWhere = SelIndex; settings.Money.W = string.format("%.0f", SelIndex);
			if SelIndex == 1 then if not ShowMoney then ShowHideMoney(); end
			else if ShowMoney then ShowHideMoney(); end end
		elseif wcur == L["MDP"] then
			_G.DPWhere = SelIndex; settings.DestinyPoints.W = string.format("%.0f", SelIndex);
			if SelIndex == 1 then if not ShowDestinyPoints then ShowHideDestinyPoints(); end
			else if ShowDestinyPoints then ShowHideDestinyPoints(); end end
		elseif wcur == L["MSP"] then
			_G.SPWhere = SelIndex; settings.Shards.W = string.format("%.0f", SelIndex);
			if SelIndex == 1 then if not ShowShards then ShowHideShards(); end
			else if ShowShards then ShowHideShards(); end end
		elseif wcur == L["MSM"] then
			_G.SMWhere = SelIndex; settings.SkirmishMarks.W = string.format("%.0f", SelIndex);
			if SelIndex == 1 then if not ShowSkirmishMarks then ShowHideSkirmishMarks(); end
			else if ShowSkirmishMarks then ShowHideSkirmishMarks(); end end
		elseif wcur == L["MMP"] then
			_G.MPWhere = SelIndex; settings.Medallions.W = string.format("%.0f", SelIndex);
			if SelIndex == 1 then if not ShowMedallions then ShowHideMedallions(); end
			else if ShowMedallions then ShowHideMedallions(); end end
		elseif wcur == L["MSL"] then
			_G.SLWhere = SelIndex; settings.Seals.W = string.format("%.0f", SelIndex);
			if SelIndex == 1 then if not ShowSeals then ShowHideSeals(); end
			else if ShowSeals then ShowHideSeals(); end end
		elseif wcur == L["MCP"] then
			_G.CPWhere = SelIndex; settings.Commendations.W = string.format("%.0f", SelIndex);
			if SelIndex == 1 then if not ShowCommendations then ShowHideCommendations(); end
			else if ShowCommendations then ShowHideCommendations(); end end
		elseif wcur == L["MTP"] then
			_G.TPWhere = SelIndex; settings.TurbinePoints.W = string.format("%.0f", SelIndex);
			if SelIndex == 1 then if not ShowTurbinePoints then ShowHideTurbinePoints(); end
			else if ShowTurbinePoints then ShowHideTurbinePoints(); end end

			local parsed_text = WItxtTurbinePTS:GetText();

			if parsed_text == "" then
				WItxtTurbinePTS:SetText( "0" );
				WItxtTurbinePTS:Focus();
				return
			elseif parsed_text == _G.TurbinePTS then
				WItxtTurbinePTS:Focus();
				return
			end
			
			_G.TurbinePTS = WItxtTurbinePTS:GetText();
			if _G.TPWhere == 1 then UpdateTurbinePoints(); end
			SavePlayerTurbinePoints();
		end

		SaveSettings( false );
	end

	RefreshWIListBox();
end

function RefreshWIListBox()
	WIListBox:ClearItems();
	
	for i = 1, #MenuItem do		
		--**v Control of all data v**
		local RPCtr = Turbine.UI.Control();
		RPCtr:SetParent( WIListBox );
		RPCtr:SetSize( WIListBox:GetWidth(), 20 );
		--**^
		
		-- Wallet currency name
		local curLbl = Turbine.UI.Label();
		curLbl:SetParent( RPCtr );
		curLbl:SetText( MenuItem[WalletOrder[i]] );
		curLbl:SetSize( WIListBox:GetWidth(), 20 );
		curLbl:SetPosition( 0, 0 );
		curLbl:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
		curLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		curLbl:SetForeColor( Color["nicegold"] );
		--curLbl:SetBackColor( Color["blue"] ); --debug purpose

		curLbl.MouseClick = function( sender, args )
			if ( args.Button == Turbine.UI.MouseButton.Right ) then
				wcur = MenuItem[WalletOrder[i]];
				WIlblFN:SetText( wcur );
				TPWCtr:SetVisible( false );
				WIbutSave:SetPosition( WIWCtr:GetWidth()/2 - WIbutSave:GetWidth()/2, WIDD:GetTop()+WIDD:GetHeight()+10 );

				if wcur == L["MGSC"] then tw = _G.MIWhere;
				elseif wcur == L["MDP"] then tw = _G.DPWhere;
				elseif wcur == L["MSP"] then tw = _G.SPWhere;
				elseif wcur == L["MSM"] then tw = _G.SMWhere;
				elseif wcur == L["MMP"] then tw = _G.MPWhere;
				elseif wcur == L["MSL"] then tw = _G.SLWhere;
				elseif wcur == L["MCP"] then tw = _G.CPWhere;
				elseif wcur == L["MTP"] then tw = _G.TPWhere; TPWCtr:SetVisible( true ); WItxtTurbinePTS:SetText( _G.TurbinePTS ); WItxtTurbinePTS:Focus(); WIbutSave:SetPosition( WIWCtr:GetWidth()/2 - WIbutSave:GetWidth()/2, TPWCtr:GetTop()+TPWCtr:GetHeight()+10); end
				
				for k, v in pairs(WICBO) do if k == tonumber(tw) then WIDD:SetSelection(k); end end

				WIWCtr:SetVisible( true );
				WIWCtr:SetZOrder( 2 );
				WIWCtr:SetBackground( 0x4100013B );
			end
		end

		WIListBox:AddItem( RPCtr );
	end
end