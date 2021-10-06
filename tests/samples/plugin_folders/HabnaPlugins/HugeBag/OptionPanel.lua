--Option Panel


plugin.GetOptionsPanel = function( self )
	optionsPanel = Turbine.UI.Control();
	--optionsPanel:SetBackColor( Turbine.UI.Color( 0.3, 0.3, 0.3 ) );
	optionsPanel:SetSize( 200, 30 );

	optionsButton = Turbine.UI.Lotro.Button();
	optionsButton:SetText( L["SC15"] );
	optionsButton:SetSize( string.len(optionsButton:GetText()) * 9, 30 );
	optionsButton:SetParent( optionsPanel );

	if Widget then
		optionsButton.MouseClick = function( sender, args )
			if WidgetLoc == L["OWidLocR"] then
				ShowOptionsMenu("nil");
			else
				ShowOptionsMenu("left");
			end
		end
	else
		optionsButton.MouseClick = function( sender, args )
			--frmOptions();
			ShowOptionsMenu("nil");
		end
	end

	return optionsPanel
end