-- InfamyWindow.lua
-- written by Habna


function frmInfamyWindow()
	-- **v Set some window stuff v**
	_G.wIF = Turbine.UI.Lotro.Window()
	_G.wIF:SetPosition( IFWLeft, IFWTop );
	--_G.wIF:SetSize( 300, 80 );
	_G.wIF:SetText( L["IFWTitle"] );
	_G.wIF:SetWantsKeyEvents( true );
	_G.wIF:SetVisible( true );
	--_G.wIF:SetZOrder( 2 );
	_G.wIF:Activate();

	_G.wIF.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			_G.wIF:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			_G.wIF:SetVisible( not _G.wIF:IsVisible() );
		elseif ( args.Action == 162 ) then --Enter key was pressed
			buttonSave.Click( sender, args );
		end
	end

	_G.wIF.MouseUp = function( sender, args )
		settings.Infamy.L = string.format("%.0f", _G.wIF:GetLeft());
		settings.Infamy.T = string.format("%.0f", _G.wIF:GetTop());
		IFWLeft, IFWTop = _G.wIF:GetPosition();
		SaveSettings( false );
	end

	_G.wIF.Closing = function( sender, args ) -- Function for the Upper right X icon
		_G.wIF:SetWantsKeyEvents( false );
		_G.wIF = nil;
		_G.frmIF = nil;
	end
	-- **^

	local IFWCtr = Turbine.UI.Control();
	IFWCtr:SetParent( _G.wIF );
	IFWCtr:SetPosition( 15, 50 )
	IFWCtr:SetZOrder( 2 );
	--IFWCtr:SetBackColor( Color["red"] ); -- debug purpose

	local lblName = Turbine.UI.Label();
	lblName:SetParent( IFWCtr );
	--lblName:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	lblName:SetText( L["IFIF"] );
	lblName:SetPosition( 0, 2 );
	lblName:SetSize( lblName:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	lblName:SetForeColor( Color["rustedgold"] );
	lblName:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	--lblName:SetBackColor( Color["red"] ); -- debug purpose

	local txtInfamy = Turbine.UI.Lotro.TextBox();
	txtInfamy:SetParent( IFWCtr );
	txtInfamy:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	txtInfamy:SetText( InfamyPTS );
	txtInfamy:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	txtInfamy:SetPosition( lblName:GetLeft()+lblName:GetWidth()+5, lblName:GetTop()-2 );
	txtInfamy:SetSize( 80, 20 );
	txtInfamy:SetMultiline( false );
	if PlayerAlign == 2 then txtInfamy:SetBackColor( Color["red"] ); end

	txtInfamy.FocusGained = function( sender, args )
		txtInfamy:SelectAll();
		txtInfamy:SetWantsUpdates( true );
	end

	txtInfamy.FocusLost = function( sender, args )
		txtInfamy:SetWantsUpdates( false );
	end

	txtInfamy.Update = function( sender, args )
		local parsed_text = txtInfamy:GetText();

		if tonumber(parsed_text) == nil or string.find(parsed_text,"%.") ~= nil then
			txtInfamy:SetText( string.sub( parsed_text, 1, string.len(parsed_text)-1 ) );
			--txtInfamy:Focus();
			return
		elseif string.len(parsed_text) > 1 and string.sub(parsed_text,1,1) == "0" then
			txtInfamy:SetText( string.sub( parsed_text, 2 ) );
			return
		end
	end

	buttonSave = Turbine.UI.Lotro.Button();
	buttonSave:SetParent( IFWCtr );
	buttonSave:SetText( L["PWSave"] );
	buttonSave:SetSize( buttonSave:GetTextLength() * 10, 15 ); --Auto size with text lenght
	buttonSave:SetPosition( txtInfamy:GetLeft()+txtInfamy:GetWidth()+5, txtInfamy:GetTop() );
	--buttonSave:SetEnabled( true );

	buttonSave.Click = function( sender, args )
		local parsed_text = txtInfamy:GetText();

		if parsed_text == "" then
			txtInfamy:SetText( "0" );
			txtInfamy:Focus();
			return
		elseif parsed_text == _G.InfamyPTS then
			txtInfamy:Focus();
			return
		end
			
		InfamyPTS = txtInfamy:GetText();
		
		for i = 0, 14 do
			if tonumber(InfamyPTS) >= _G.InfamyRanks[i] and tonumber(InfamyPTS) < _G.InfamyRanks[i+1] then InfamyRank = i; break end
		end

		settings.Infamy.P = string.format("%.0f", InfamyPTS);
		settings.Infamy.K = string.format("%.0f", InfamyRank);
		SaveSettings( false );

		txtInfamy:Focus();

		UpdateInfamy();
	end

	IFWCtr:SetSize( lblName:GetWidth()+txtInfamy:GetWidth()+buttonSave:GetWidth()+10, 20 );
	_G.wIF:SetSize( IFWCtr:GetWidth()+30, 80 );

	txtInfamy:Focus();
end