-- GameTimesWindow.lua
-- written by Habna


function frmGameTimeWindow()
	-- **v Set some window stuff v**
	_G.wGT = Turbine.UI.Lotro.Window()
	_G.wGT:SetPosition( GTWLeft, GTWTop );
	_G.wGT:SetHeight( 120 );
	_G.wGT:SetText( L["GTWTitle"] );
	_G.wGT:SetWantsKeyEvents( true );
	_G.wGT:SetVisible( true );
	--_G.wGT:SetZOrder( 2 );
	_G.wGT:Activate();

	_G.wGT.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			_G.wGT:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			_G.wGT:SetVisible( not _G.wGT:IsVisible() );
		end
	end

	_G.wGT.MouseUp = function( sender, args )
		settings.GameTime.L = string.format("%.0f", _G.wGT:GetLeft());
		settings.GameTime.T = string.format("%.0f", _G.wGT:GetTop());
		GTWLeft, GTWTop = _G.wGT:GetPosition();
		SaveSettings( false );
	end

	_G.wGT.Closing = function( sender, args ) -- Function for the Upper right X icon
		_G.wGT:SetWantsKeyEvents( false );
		_G.wGT = nil;
		_G.frmGT = nil;
	end
	-- **^
	-- **v 24h clock - Check box v**
	local GMT = Turbine.UI.Lotro.TextBox();
	local ShowSTcb = Turbine.UI.Lotro.CheckBox();
	local Clock24Ctr = Turbine.UI.Lotro.CheckBox();
	Clock24Ctr:SetParent( _G.wGT );
	Clock24Ctr:SetPosition( 35, 40 );
	Clock24Ctr:SetText( L["GTW24h"] );
	Clock24Ctr:SetSize( Clock24Ctr:GetTextLength() * 8, 20 );
	--Clock24Ctr:SetVisible( true );
	--Clock24Ctr:SetEnabled( false );
	Clock24Ctr:SetChecked( _G.Clock24h );
	Clock24Ctr:SetForeColor( Color["rustedgold"] );

	Clock24Ctr.CheckedChanged = function( sender, args )
		_G.Clock24h = Clock24Ctr:IsChecked();
		settings.GameTime.H = _G.Clock24h;
		SaveSettings( false );
		if _G.ShowBT then ShowSTcb:SetChecked(ShowBT); UpdateGameTime("bt");
		elseif _G.ShowST then UpdateGameTime("st");
		else UpdateGameTime("gt") end
	end
	-- **^
	-- **v Show server time - Check box v**
	ShowSTcb:SetParent( _G.wGT );
	ShowSTcb:SetPosition( 35, Clock24Ctr:GetTop() + 20 );
	ShowSTcb:SetText( L["GTWSST"] );
	ShowSTcb:SetSize( ShowSTcb:GetTextLength() * 8, 20 );
	--ShowSTcb:SetVisible( true );
	--ShowSTcb:SetEnabled( false );
	ShowSTcb:SetChecked( _G.ShowST );
	ShowSTcb:SetForeColor( Color["rustedgold"] );

	ShowSTcb.CheckedChanged = function( sender, args )
		_G.ShowST = ShowSTcb:IsChecked();
		if not _G.ShowST then ShowBTcb:SetChecked(false); end
		settings.GameTime.S = _G.ShowST;
		_G.UserGMT = GMT:GetText();
		SaveSettings( false );
		if not _G.ShowBT then UpdateGameTime("st"); end
	end
	-- **^
	-- **v GMT - Text box v**
	GMT:SetParent( ShowSTcb );
	GMT:SetText( _G.UserGMT );
	GMT:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	GMT:SetSize( 30, 20 );
	--GMT:SetVisible( true );
	--GMT:SetEnabled( false );
	GMT:SetForeColor( Color["white"] );

	GMT.FocusGained = function( sender, args )
		GMT:SetWantsUpdates( true );
	end

	GMT.FocusLost = function( sender, args )
		GMT:SetWantsUpdates( false );
	end

	GMT.Update = function( sender, args )
		local parsed_text = GMT:GetText();

		if parsed_text == "" or parsed_text == "-" or parsed_text == "+" then
			return
		elseif tonumber(parsed_text) == nil or string.find(parsed_text,"%.") ~= nil or parsed_text == "-0" or parsed_text == "+0" or parsed_text == "00" then
			GMT:SetText( string.sub( parsed_text, 1, string.len(parsed_text)-1 ) );
			return
		elseif string.len(parsed_text) == 2 and string.sub(parsed_text,1,1) == "0" then
			GMT:SetText( string.sub( parsed_text, 2 ) );
			return
		end
		_G.UserGMT = GMT:GetText();
		settings.GameTime.M = string.format("%.0f",_G.UserGMT);
		SaveSettings( false );
		if _G.ShowST then
			if _G.ShowBT then UpdateGameTime("bt");
			elseif _G.ShowST then UpdateGameTime("st");
			else UpdateGameTime("gt") end
		end
	end
	-- **^
	-- **v Show both time - Check box v**
	ShowBTcb = Turbine.UI.Lotro.CheckBox();
	ShowBTcb:SetParent( _G.wGT );
	ShowBTcb:SetPosition( 35, ShowSTcb:GetTop() + 20 );
	ShowBTcb:SetText( L["GTWSBT"] );
	ShowBTcb:SetSize( ShowBTcb:GetTextLength() * 8.5, 20 );
	--ShowBTcb:SetVisible( true );
	--ShowBTcb:SetEnabled( false );
	ShowBTcb:SetChecked( _G.ShowBT );
	ShowBTcb:SetForeColor( Color["rustedgold"] );

	ShowBTcb.CheckedChanged = function( sender, args )
		_G.ShowBT = ShowBTcb:IsChecked();
		settings.GameTime.O = _G.ShowBT;
		SaveSettings( false );
		ShowSTcb:SetChecked(ShowBT);
				
		if _G.ShowBT then UpdateGameTime("bt");
		elseif _G.ShowST then UpdateGameTime("st");
		else UpdateGameTime("gt") end
	end
	-- **^

	GMT:SetPosition( ShowSTcb:GetWidth() - 65, 0 );
	_G.wGT:SetWidth( Clock24Ctr:GetWidth() + 60 );
	if TBLocale == "fr" then
		GMT:SetPosition( ShowSTcb:GetWidth() - 70, 0 );
		_G.wGT:SetWidth( ShowSTcb:GetWidth() + 85 );
	end
end