-- menuControl.lua
-- Written By Habna


-- Apply TitanBar background to... menu
local ATBBMenu = Turbine.UI.MenuItem( L["MTBBG"] );
ATBBMenu.Items = ATBBMenu:GetItems();

local ATBBMenu1 = Turbine.UI.MenuItem( L["MTBBGC"] );
ATBBMenu1.Click = function( sender, args ) BGColor( "match", "this" ); end
ATBBMenu.Items:Add( ATBBMenu1 );

local ATBBMenu2 = Turbine.UI.MenuItem( L["MTBBGAC"] );
ATBBMenu2.Click = function( sender, args ) BGColor( "match", "ctr" ); end
ATBBMenu.Items:Add( ATBBMenu2 );


-- Reset back color of... menu
local RBGMenu = Turbine.UI.MenuItem( L["MCRBG"] );
RBGMenu.Items = RBGMenu:GetItems();

local RBGMenu1 = Turbine.UI.MenuItem( L["MTBBGC"] );
RBGMenu1.Click = function( sender, args ) BGColor( "reset", "this" ); end
RBGMenu.Items:Add( RBGMenu1 );

local RBGMenu2 = Turbine.UI.MenuItem( L["MTBBGAC"] );
RBGMenu2.Click = function( sender, args ) BGColor( "reset", "ctr"); end
RBGMenu.Items:Add( RBGMenu2 );

local RBGMenu3 = Turbine.UI.MenuItem( L["MCABTA"] );
RBGMenu3.Click = function( sender, args ) BGColor( "reset", "all"); end
RBGMenu.Items:Add( RBGMenu3 );


-- Apply control back color to ... menu
local ABGTMenu = Turbine.UI.MenuItem( L["MCABT"] );
ABGTMenu.Items = ABGTMenu:GetItems();

local ABGTMenu1 = Turbine.UI.MenuItem( L["MCABTA"] );
ABGTMenu1.Click = function( sender, args ) BGColor( "apply", "all" ); end
ABGTMenu.Items:Add( ABGTMenu1 );

local ABGTMenu2 = Turbine.UI.MenuItem( L["MTBBGAC"] );
ABGTMenu2.Click = function( sender, args ) BGColor( "apply", "ctr" ); end
ABGTMenu.Items:Add( ABGTMenu2 );

local ABGTMenu3 = Turbine.UI.MenuItem( L["MCABTTB"] );
ABGTMenu3.Click = function( sender, args ) BGColor( "apply", "TitanBar" ); end
ABGTMenu.Items:Add( ABGTMenu3 );


-- Unload ... menu
local UnloadMenu = Turbine.UI.MenuItem( L["MCU"] );
UnloadMenu.Items = UnloadMenu:GetItems();

local UnloadMenu1 = Turbine.UI.MenuItem( L["MTBBGC"] );
UnloadMenu1.Click = function( sender, args ) UnloadControl("this"); end
UnloadMenu.Items:Add( UnloadMenu1 );

local UnloadMenu2 = Turbine.UI.MenuItem( L["MTBBGAC"] );
UnloadMenu2.Click = function( sender, args ) UnloadControl("ctr"); end
UnloadMenu.Items:Add( UnloadMenu2 );


ControlMenu = Turbine.UI.ContextMenu();
ControlMenu.items = ControlMenu:GetItems();

local option_line = Turbine.UI.MenuItem("-------------------------------------------", false);
local option_empty = Turbine.UI.MenuItem("", false);

local option_Background = Turbine.UI.MenuItem(L["MCBG"]);
option_Background.Click = function( sender, args ) SetBackgroundColor(); end


ControlMenu.items:Add(option_Background);
ControlMenu.items:Add(ATBBMenu);
ControlMenu.items:Add(RBGMenu);
ControlMenu.items:Add(ABGTMenu);
ControlMenu.items:Add(UnloadMenu);