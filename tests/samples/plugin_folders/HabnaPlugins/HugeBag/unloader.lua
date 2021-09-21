-- unloader.lua
-- written by Habna


import "Turbine.UI";

UnloadHugeBag = Turbine.UI.Control();
UnloadHugeBag:SetWantsUpdates( true );

UnloadHugeBag.Update = function( sender, args )
	UnloadHugeBag:SetWantsUpdates( false );
	Turbine.PluginManager.UnloadScriptState( 'HugeBag' );
end