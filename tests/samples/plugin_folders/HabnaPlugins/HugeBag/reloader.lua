-- LootBug.lua
-- written by Habna


--[[ 
** Legend **
workaround is handling this condition - Condition: (Additional explication)
		- Order of all events fired for this condition

** Condition **
ok-Loot bug: (Bug: occur when looting item/s that are not present in bag)
		- Add, remove, add

ok-Swapping: (Tools/Gears) (No Bug: If tool/gear is present on the character tool/gear slot, the old tool/gear icon will swap)
		- Move, add, remove

ok-Swapping: (Tools/Gears) (Bug: if tool/gear is not present on the character tool/gear slot, the old tool/gear icon stay in bag)
		- Remove

ok-Quest Item: (Bug: When looting Quest item/s)
		- Add, remove

ok-Trading: (No Bug: Donating item/s)
		- Remove

ok-Trading: (Bug: When receiving item/s)
		- Add, add, remove, add

??-Bartering: (Bug: When bartering barter item)
		- ??

??-Full Bag: (Bug ?? : When looting quest item/s when bag is full) (Need to check if there is a bug here)
		- ??

** Conclusion **
Reload HugeBag when an Add & remove events are fired instanly

** workaround **
I found that these event was fired all instantly, so i've added a timer to detect time between the add & remove events
So if time between does 2 events (except when items are moving, cause it's not a bug) is 0 sec then HugeBag will load "reloader.lua". That file will unload & reload HugeBag.
Then when HugeBag load it will unload "Reloaded" if it's already loaded.

]]

import "Turbine.UI";

ReloadHugeBag = Turbine.UI.Control();
ReloadHugeBag:SetWantsUpdates( true );

ReloadHugeBag.Update = function( sender, args )
	ReloadHugeBag:SetWantsUpdates( false );
	Turbine.PluginManager.UnloadScriptState( 'HugeBag' );
	Turbine.PluginManager.LoadPlugin( 'HugeBag' );
end