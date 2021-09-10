-- reloader.lua
-- written by Habna


import "Turbine.UI";

ReloadTitanBar = Turbine.UI.Control();
ReloadTitanBar:SetWantsUpdates( true );

ReloadTitanBar.Update = function( sender, args )
	ReloadTitanBar:SetWantsUpdates( false );
	Turbine.PluginManager.UnloadScriptState( 'TitanBar' );
	Turbine.PluginManager.LoadPlugin( 'TitanBar' );
end