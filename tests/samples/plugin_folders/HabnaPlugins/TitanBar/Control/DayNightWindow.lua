-- DayNightWindow.lua
-- written by Habna


function frmDayNightWindow()
	local prevTS = _G.TS;
	local bHelp = false;
	
	-- **v Set some window stuff v**
	_G.wDN = Turbine.UI.Lotro.Window()
	_G.wDN:SetPosition( DNWLeft, DNWTop );
	_G.wDN:SetText( L["MDayNight"] );
	_G.wDN:SetWantsKeyEvents( true );
	_G.wDN:SetVisible( true );
	--_G.wDN:SetZOrder( 2 );
	--_G.wDN:Activate();

	if TBLocale == "fr" then _G.wDN:SetWidth( 335 );
	else _G.wDN:SetSize( 290 ); end

	_G.wDN.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			_G.wDN:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			_G.wDN:SetVisible( not _G.wDN:IsVisible() );
		end
	end

	_G.wDN.MouseUp = function( sender, args )
		settings.DayNight.L = string.format("%.0f", _G.wDN:GetLeft());
		settings.DayNight.T = string.format("%.0f", _G.wDN:GetTop());
		DNWLeft, DNWTop = _G.wDN:GetPosition();
		SaveSettings( false );
	end

	_G.wDN.Closing = function( sender, args ) -- Function for the Upper right X icon
		_G.wDN:SetWantsKeyEvents( false );

		if tonumber(_G.TS) == 0 then _G.TS = tonumber(prevTS); end
		settings.DayNight.S = string.format("%.0f",_G.TS);
		SaveSettings( false );
		UpdateDayNight();

		_G.wDN = nil;
		_G.frmDN = nil;
	end
	-- **^
	
	-- **v Show/Hide Next time - Check box v**
	local NextTimeCB = Turbine.UI.Lotro.CheckBox();
	NextTimeCB:SetParent( _G.wDN );
	NextTimeCB:SetPosition( 35, 40 );
	NextTimeCB:SetText( L["NextT"] );
	NextTimeCB:SetSize( NextTimeCB:GetTextLength() * 8.5, 20 );
	NextTimeCB:SetChecked( _G.DNNextT );
	NextTimeCB:SetForeColor( Color["rustedgold"] );

	NextTimeCB.CheckedChanged = function( sender, args )
		_G.DNNextT = NextTimeCB:IsChecked();
		settings.DayNight.N = _G.DNNextT;
		SaveSettings( false );
		UpdateDayNight();
	end
	-- **^
	-- **v Timer seed - Label v**
	TAjustlbl = Turbine.UI.Label();
	TAjustlbl:SetParent( _G.wDN );
	TAjustlbl:SetPosition( NextTimeCB:GetLeft(), NextTimeCB:GetTop() + 30 );
	TAjustlbl:SetText( L["TAjustL"] );
	TAjustlbl:SetSize( TAjustlbl:GetTextLength() * 8.5, 20 );
	TAjustlbl:SetForeColor( Color["rustedgold"] );
	-- **^
	-- **v Timer seed - Text box v**
	local TAjustTB = Turbine.UI.Lotro.TextBox();
	TAjustTB:SetParent( _G.wDN );
	TAjustTB:SetPosition( TAjustlbl:GetLeft() + TAjustlbl:GetWidth(), TAjustlbl:GetTop() - 5 );
	TAjustTB:SetText( _G.TS );
	TAjustTB:SetMultiline( false );
	TAjustTB:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	TAjustTB:SetSize( 75, 20 );
	TAjustTB:SetForeColor( Color["white"] );

	TAjustTB.FocusGained = function( sender, args )
		TAjustTB:SetWantsUpdates( true );
	end

	TAjustTB.FocusLost = function( sender, args )
		TAjustTB:SetWantsUpdates( false );
	end

	TAjustTB.Update = function( sender, args )
		local parsed_text = TAjustTB:GetText();

		if tonumber(parsed_text) == nil or string.find(parsed_text,"%.") ~= nil or parsed_text == "-0" or parsed_text == "+0" or parsed_text == "00" then
			TAjustTB:SetText( string.sub( parsed_text, 1, string.len(parsed_text)-1 ) );
			return
		elseif string.len(parsed_text) == 2 and string.sub(parsed_text,1,1) == "0" then
			TAjustTB:SetText( string.sub( parsed_text, 2 ) );
			return
		end

		_G.TS = parsed_text;
		settings.DayNight.S = string.format("%.0f",_G.TS);
		SaveSettings( false );
		UpdateDayNight();
	end
	-- **^
	-- **v ? - Button v**
	local Help = Turbine.UI.Lotro.Button();
	Help:SetParent( _G.wDN );
	Help:SetPosition( TAjustTB:GetLeft()+TAjustTB:GetWidth() + 10, TAjustTB:GetTop() );
	Help:SetText( "?" );
	Help:SetSize( 10, 20 );
	Help:SetForeColor( Color["rustedgold"] );

	Help.Click = function( sender, args )
		bHelp = not bHelp;
		ShowHelpSection(bHelp);
	end
	-- **^
	-- **v ? - TextBox v**
	HelpTB = Turbine.UI.Label();
	HelpTB:SetParent( _G.wDN );
	
	HelpTB:SetPosition( TAjustlbl:GetLeft(), TAjustlbl:GetTop()+TAjustlbl:GetHeight()+10 );
	HelpTB:SetForeColor( Color["rustedgold"] );
	HelpTB:SetVisible( bHelp );
	HelpTB:SetSize( _G.wDN:GetWidth()-60, 250 );
	HelpTB:SetText( "Try using does value if time is not sync:\n\n* Arkenstone: ... 1295018461\n* Brandywine: ... 1295011363\n* Crickhollow: .. 1295013525\n* Dwarrowdelf: .. 1295019947\n* Elendilmir: ... 1295016509\n* Firefoot: ..... 1295018014\n* Gladden: ...... 1295020785\n* Imladris: ..... 1295032537\n* Landroval: .... 1295028066\n* Meneldor: ..... 1295035773\n* Nimrodel: ..... 1295030005\n* Riddermark: ... 1295038249\n* Silverlode: ... 1295039369\n* Vilya: ........ 1295040045\n* Windfola: ..... 1295037667" );
	-- **^
	
	ShowHelpSection(bHelp);
end

function ShowHelpSection(bHelp)
	if bHelp then
		_G.wDN:SetHeight( _G.wDN:GetHeight()+235 );
	else
		_G.wDN:SetHeight( 105 );
	end
	HelpTB:SetVisible( bHelp );
end