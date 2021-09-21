-- Main.lua
-- written by Habna

write = Turbine.Shell.WriteLine;

import "HabnaPlugins.HugeBag.Utility";
import "HabnaPlugins.HugeBag.Utility.frmMain";

frmMain = frmMain();

HugeBagUCommand = Turbine.ShellCommand()

function HugeBagUCommand:Execute( command, arguments )
	if ( arguments == "reload" ) then ReloadHugeBag();
	elseif ( arguments == "reset" ) then ResetLoc();
	end
end
Turbine.Shell.AddCommand('HugeBagU', HugeBagUCommand)