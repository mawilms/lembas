-- functionsWidget.lua
-- Written By Habna


-- **v Save Widget Location v**
function WidLoc(ToSide)
	if ToSide == L["OWidLocR"] then
		if windowOpen then
			wHugeBag:SetLeft( screenWidth - ( winRate * 15 ) );
		else
			wHugeBag:SetLeft( screenWidth - 30 );
		end
	else
		if windowOpen then
			wHugeBag:SetLeft( 1 );
		else
			wHugeBag:SetLeft( -419 );
		end
	end
	WidgetLoc = ToSide;
	HBsettings.Location.Loc = ToSide;
	PrintTitle();
	SaveSettings( false );
end
-- **^
-- **v Show HugeBag v**
function ShowHugeBag()
	if windowOpen then
		write( L["FWidShow"] );
	else
		slideCtr:SetWantsUpdates(true);
	end
end
-- **^
-- **v Hide HugeBag v**
function HideHugeBag()
	if not windowOpen then
		write( L["FWidHide"] );
	else
		slideCtr:SetWantsUpdates(true);
	end
end
-- **^

-- **v Toggle side bar info v**
function ToggleSideBarInfo(value)
	if value == "image" then
		write( L["FWidSBImg"] );
	elseif value == "info" then
		write( L["FWidSBInfo"] );
	elseif value == "nil" then
		write( L["FWidSBNot"] );
	end
	sidebarinfo = value;
	HBsettings.Options.ShowSideBarInfo = value;
	PrintTitle();
	SaveSettings( false );
end
-- **^