-- TurbinePointsWindow.lua
-- written by Habna


function frmTurbinePointsWindow()
	-- **v Set some window stuff v**
	_G.wTP = Turbine.UI.Lotro.Window()
	_G.wTP:SetPosition( TPWLeft, TPWTop );
	--_G.wTP:SetSize( 300, 80 );
	_G.wTP:SetText( L["MTP"] );
	_G.wTP:SetWantsKeyEvents( true );
	_G.wTP:SetVisible( true );
	--_G.wTP:SetZOrder( 2 );
	_G.wTP:Activate();

	_G.wTP.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			_G.wTP:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			_G.wTP:SetVisible( not _G.wTP:IsVisible() );
		elseif ( args.Action == 162 ) then --Enter key was pressed
			buttonSave.Click( sender, args );
		end
	end

	_G.wTP.MouseUp = function( sender, args )
		settings.TurbinePoints.L = string.format("%.0f", _G.wTP:GetLeft());
		settings.TurbinePoints.T = string.format("%.0f", _G.wTP:GetTop());
		TPWLeft, TPWTop = _G.wTP:GetPosition();
		SaveSettings( false );
	end

	_G.wTP.Closing = function( sender, args ) -- Function for the Upper right X icon
		_G.wTP:SetWantsKeyEvents( false );
		_G.wTP = nil;
		_G.frmTP = nil;
	end
	-- **^

	local TPWCtr = Turbine.UI.Control();
	TPWCtr:SetParent( _G.wTP );
	TPWCtr:SetPosition( 15, 50 );
	TPWCtr:SetZOrder( 2 );
	--TPWCtr:SetBackColor( Color["red"] ); -- debug purpose

	local lblTurbinePTS = Turbine.UI.Label();
	lblTurbinePTS:SetParent( TPWCtr );
	--lblTurbinePTS:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	lblTurbinePTS:SetText( L["MTP"] );
	lblTurbinePTS:SetPosition( 0, 2 );
	lblTurbinePTS:SetSize( lblTurbinePTS:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	lblTurbinePTS:SetForeColor( Color["rustedgold"] );
	lblTurbinePTS:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	--lblTurbinePTS:SetBackColor( Color["red"] ); -- debug purpose

	local txtTurbinePTS = Turbine.UI.Lotro.TextBox();
	txtTurbinePTS:SetParent( TPWCtr );
	txtTurbinePTS:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	txtTurbinePTS:SetText( _G.TurbinePTS );
	txtTurbinePTS:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	txtTurbinePTS:SetPosition( lblTurbinePTS:GetLeft()+lblTurbinePTS:GetWidth()+5, lblTurbinePTS:GetTop()-2 );
	txtTurbinePTS:SetSize( 80, 20 );
	txtTurbinePTS:SetMultiline( false );
	if PlayerAlign == 2 then txtTurbinePTS:SetBackColor( Color["red"] ); end

	txtTurbinePTS.FocusGained = function( sender, args )
		txtTurbinePTS:SelectAll();
		txtTurbinePTS:SetWantsUpdates( true );
	end

	txtTurbinePTS.FocusLost = function( sender, args )
		txtTurbinePTS:SetWantsUpdates( false );
	end

	txtTurbinePTS.Update = function( sender, args )
		local parsed_text = txtTurbinePTS:GetText();

		if tonumber(parsed_text) == nil or string.find(parsed_text,"%.") ~= nil then
			txtTurbinePTS:SetText( string.sub( parsed_text, 1, string.len(parsed_text)-1 ) );
			return
		elseif string.len(parsed_text) > 1 and string.sub(parsed_text,1,1) == "0" then
			txtTurbinePTS:SetText( string.sub( parsed_text, 2 ) );
			return
		end
	end

	buttonSave = Turbine.UI.Lotro.Button();
	buttonSave:SetParent( TPWCtr );
	buttonSave:SetText( L["PWSave"] );
	buttonSave:SetSize( buttonSave:GetTextLength() * 10, 15 ); --Auto size with text lenght
	buttonSave:SetPosition( txtTurbinePTS:GetLeft()+txtTurbinePTS:GetWidth()+5, txtTurbinePTS:GetTop() );
	--buttonSave:SetEnabled( true );

	buttonSave.Click = function( sender, args )
		local parsed_text = txtTurbinePTS:GetText();

		if parsed_text == "" then
			txtTurbinePTS:SetText( "0" );
			txtTurbinePTS:Focus();
			return
		elseif parsed_text == _G.TurbinePTS then
			txtTurbinePTS:Focus();
			return
		end
			
		_G.TurbinePTS = txtTurbinePTS:GetText();
		UpdateTurbinePoints();
		SavePlayerTurbinePoints();
		txtTurbinePTS:Focus();
	end

	TPWCtr:SetSize( lblTurbinePTS:GetWidth()+txtTurbinePTS:GetWidth()+buttonSave:GetWidth()+10, 20 );
	_G.wTP:SetSize( TPWCtr:GetWidth()+30, 80 );

	txtTurbinePTS:Focus();
end