-- OptionPanel.lua
-- written by Habna


plugin.GetOptionsPanel = function( self )
	optPanel = Turbine.UI.Control();
	--optPanel:SetBackColor( Turbine.UI.Color( 0.3, 0.3, 0.3 ) );
	--optPanel:SetSize( 200, 30 );

	optLabel = Turbine.UI.Label();
	optLabel:SetParent( optPanel );
	optLabel:SetText( L["TBOpt"] );
	optLabel:SetSize( optLabel:GetTextLength() * 9, 30 );
	optLabel:SetForeColor( Color["green"] );

	return optPanel
end