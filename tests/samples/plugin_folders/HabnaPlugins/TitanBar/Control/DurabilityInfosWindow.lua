-- DurabilityInfosWindow.lua
-- written by Habna


function frmDurabilityInfosWindow()
	-- **v Set some window stuff v**
	_G.wDI = Turbine.UI.Lotro.Window()
	_G.wDI:SetSize( 300, 90 );
	if TBLocale == "fr" then
		_G.wDI:SetSize( 400, 90 );
	end
	_G.wDI:SetPosition( DIWLeft, DIWTop );
	_G.wDI:SetText( L["DWTitle"] );
	_G.wDI:SetWantsKeyEvents( true );
	_G.wDI:SetVisible( true );
	--_G.wDI:SetZOrder( 2 );
	_G.wDI:Activate();

	_G.wDI.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			_G.wDI:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			_G.wDI:SetVisible( not _G.wDI:IsVisible() );
		end
	end

	_G.wDI.MouseUp = function( sender, args )
		settings.DurabilityInfos.L = string.format("%.0f", _G.wDI:GetLeft());
		settings.DurabilityInfos.T = string.format("%.0f", _G.wDI:GetTop());
		DIWLeft, DIWTop = _G.wDI:GetPosition();
		SaveSettings( false );
	end

	_G.wDI.Closing = function( sender, args ) -- Function for the Upper right X icon
		_G.wDI:SetWantsKeyEvents( false );
		_G.wDI = nil;
		_G.frmDI = nil;
	end
	-- **^
	-- **v Show Icon in tooltip? v**
	local TTIcon = Turbine.UI.Lotro.CheckBox();
	TTIcon:SetParent( _G.wDI );
	TTIcon:SetPosition( 30, 40 );
	TTIcon:SetText( L["DIIcon"] );
	TTIcon:SetSize( TTIcon:GetTextLength() * 8.5, 20 );
	--TTIcon:SetVisible( true );
	--TTIcon:SetEnabled( false );
	TTIcon:SetChecked( DIIcon );
	TTIcon:SetForeColor( Color["rustedgold"] );

	TTIcon.CheckedChanged = function( sender, args )
		DIIcon = TTIcon:IsChecked();
		settings.DurabilityInfos.I = DIIcon;
		SaveSettings( false );
	end
	-- **^
	-- **v Show Item Name in tooltip? v**
	local TTItemName = Turbine.UI.Lotro.CheckBox();
	TTItemName:SetParent( _G.wDI );
	TTItemName:SetPosition( 30, TTIcon:GetTop() + TTIcon:GetHeight() );
	TTItemName:SetText( L["DIText"] );
	TTItemName:SetSize( TTItemName :GetTextLength() * 8.5, 20 );
	--TTItemName:SetVisible( true );
	--TTItemName:SetEnabled( false );
	TTItemName:SetChecked( DIText );
	TTItemName:SetForeColor( Color["rustedgold"] );

	TTItemName.CheckedChanged = function( sender, args )
		DIText = TTItemName:IsChecked();
		settings.DurabilityInfos.N = DIText;
		SaveSettings( false );
	end
	-- **^
end