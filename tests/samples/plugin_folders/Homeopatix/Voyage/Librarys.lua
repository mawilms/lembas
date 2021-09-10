------------------------------------------------------------------------------------------
-- _init_ file
-- Written by Homeopatix
-- 7 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- import librarys
------------------------------------------------------------------------------------------
import "Turbine";
import "Turbine.UI"; 
import "Turbine.UI.Lotro";
import "Turbine.UI.Extensions";
import "Turbine.Gameplay";
import "Turbine.Gameplay.Attributes";
------------------------------------------------------------------------------------------
-- Import Globals --
------------------------------------------------------------------------------------------
if Turbine.Engine.GetLanguage() == Turbine.Language.German then
	import "Homeopatix.Voyage.GlobalsDE";
elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
	import "Homeopatix.Voyage.GlobalsFR";
elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
	import "Homeopatix.Voyage.GlobalsEN";
end
------------------------------------------------------------------------------------------
-- Import Utility --
------------------------------------------------------------------------------------------
import "Homeopatix.Voyage.VindarPatch";
import "Homeopatix.Voyage.Notification";
import "Homeopatix.Voyage.LoadAndSave";
import "Homeopatix.Voyage.MinimizedIcon";
import "Homeopatix.Voyage.FCT";
------------------------------------------------------------------------------------------
-- Import initialization --
------------------------------------------------------------------------------------------
import "Homeopatix.Voyage.Init";

if Turbine.Engine.GetLanguage() == Turbine.Language.German then
	import "Homeopatix.Voyage.DATA_DE";
elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
	import "Homeopatix.Voyage.DATA_FR";
elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
	import "Homeopatix.Voyage.DATA_EN";
end

import "Homeopatix.Voyage.Activation";
------------------------------------------------------------------------------------------
-- Import Scripts --
------------------------------------------------------------------------------------------
import "Homeopatix.Voyage.Main";
------------------------------------------------------------------------------------------
-- Import UI elements --
------------------------------------------------------------------------------------------
import "Homeopatix.Voyage.UI";
import "Homeopatix.Voyage.OptionsWindow";
import "Homeopatix.Voyage.OptionsWindowHousing";
import "Homeopatix.Voyage.MapWindow";
import "Homeopatix.Voyage.HelpWindow";
import "Homeopatix.Voyage.OptionsWindowTeleport";
import "Homeopatix.Voyage.OptionsWindowRegion";
------------------------------------------------------------------------------------------
-- Import Commands --
------------------------------------------------------------------------------------------
import "Homeopatix.Voyage.Commands";