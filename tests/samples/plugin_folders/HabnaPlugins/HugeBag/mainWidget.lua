-- mainWidget.lua
-- Originally TheOneBagWindow.lua written by Rod, extended by Habna


import "HabnaPlugins.HugeBag.functionsWidget"; -- LUA functions file
import "HabnaPlugins.HugeBag.optionsWidget"; -- LUA options file
import "HabnaPlugins.HugeBag.moveWidget"; -- LUA MoveWidget file


resources = {
	  Item = { Background = "HabnaPlugins/HugeBag/Resources/slotBackground.tga" },
	  HugeBagEmpty = { Image = "HabnaPlugins/HugeBag/Resources/empty.tga" },
	  HugeBagName = { Image = "HabnaPlugins/HugeBag/Resources/label.tga" },
	  TopLeftCorner = { Background = "HabnaPlugins/HugeBag/Resources/topLeftCorner.tga" },
	  TopLeftCorner_over = { Background = "HabnaPlugins/HugeBag/Resources/topLeftCorner_over.tga" },
	  TopBar = { Background = "HabnaPlugins/HugeBag/Resources/TopBar.tga" },
	  TopRightCorner = { Background = "HabnaPlugins/HugeBag/Resources/topRightCorner.tga" },
	  TopRightCorner_over = { Background = "HabnaPlugins/HugeBag/Resources/topRightCorner_over.tga" },
	  MidLeftBar = { Background = "HabnaPlugins/HugeBag/Resources/midLeftBar.tga" },
	  MidLeftBar_over = { Background = "HabnaPlugins/HugeBag/Resources/midLeftBar_over.tga" },
	  MidRightBar = { Background = "HabnaPlugins/HugeBag/Resources/midRightBar.tga" },
	  MidRightBar_over = { Background = "HabnaPlugins/HugeBag/Resources/midRightBar_over.tga" },
	  BotLeftCorner = { Background = "HabnaPlugins/HugeBag/Resources/botLeftCorner.tga" },
	  BotLeftCorner_over = { Background = "HabnaPlugins/HugeBag/Resources/botLeftCorner_over.tga" },
	  BotBar = { Background = "HabnaPlugins/HugeBag/Resources/BotBar.tga" }, 
	  BotRightCorner = { Background = "HabnaPlugins/HugeBag/Resources/botRightCorner.tga" },
	  BotRightCorner_over = { Background = "HabnaPlugins/HugeBag/Resources/botRightCorner_over.tga" },

	  Picker = { Background = "HabnaPlugins/HugeBag/Resources/picker.jpg" } --Color picker picture (240px x 71px)
};

frmMain = class( Turbine.UI.Window );
--frmMain = class( Turbine.UI.Lotro.Window );

function frmMain:Constructor()
	Turbine.UI.Window.Constructor( wHugeBag );
	--Turbine.UI.Lotro.Window.Constructor( wHugeBag );
	
	--**v Set some settings of HugeBag window v**
	wHugeBag = Turbine.UI.Window();
	wHugeBag:SetWantsKeyEvents( true );
	wHugeBag:SetVisible( true );
	wHugeBag:Activate();
	wHugeBag.cursor = nil;

	if StartVisible then
		windowOpen = true;
		if WidgetLoc == L["OWidLocR"] then wHugeBag:SetLeft( screenWidth - WinWidth - 1);
		else wHugeBag:SetLeft( 1 ); end
	else
		windowOpen = false;
		if WidgetLoc == L["OWidLocR"] then wHugeBag:SetLeft( screenWidth - 30 );
		else wHugeBag:SetLeft( -419 ); end
	end
	
	wHugeBag:SetTop( WinLocY );
	
	--1 Always on top / 0 Not always on top
	if zOrder then wHugeBag:SetZOrder( 1 );
	else wHugeBag:SetZOrder( 0 ); end
	--**^
	--**v Check for the Unloader/Reloader module v**
	Turbine.PluginManager.RefreshAvailablePlugins();
	loaded_plugins = Turbine.PluginManager.GetLoadedPlugins();

	HBLBChecker = Turbine.UI.Control();
	HBLBChecker:SetWantsUpdates( true );

	HBLBChecker.Update = function( sender, args )
		for k,v in pairs(loaded_plugins) do
			if v.Name == "HugeBag Reloader" then
				Turbine.PluginManager.UnloadScriptState( 'HugeBagReloader' );
				if WasOpen then
					windowOpen = true;
					if WidgetLoc == L["OWidLocR"] then wHugeBag:SetLeft( screenWidth - WinWidth - 1);
					else wHugeBag:SetLeft( 1 ); end
				else
					windowOpen = false;
					if WidgetLoc == L["OWidLocR"] then wHugeBag:SetLeft( screenWidth - 30 );
					else wHugeBag:SetLeft( -419 ); end
				end
				--write("Bug detected, HugeBag was reloaded!");
				--break;
			end
			if v.Name == "HugeBag Unloader" then
				Turbine.PluginManager.UnloadScriptState( 'HugeBagUnloader' );
				--break;
			end
		end
		HBLBChecker:SetWantsUpdates( false );
		WasOpen = windowOpen;
		HBsettings.WasOpen = windowOpen;
		SaveSettings( false );
	end
	--**^
	
	--**v Set size of window v** --
	--I'm showing 11 slots per row
	--backpackSize = 60; --debug purpose

	if (backpackSize >= 45) and (backpackSize <= 55) then wHugeBag:SetSize( WinWidth, WinHeight - 71 ); -- to show 45 to 55 slots
	elseif (backpackSize >= 56) and (backpackSize <= 66) then wHugeBag:SetSize( WinWidth, WinHeight - 36 ); -- to show 56 to 66 slots
	elseif (backpackSize >= 67) and (backpackSize <= 77) then wHugeBag:SetSize( WinWidth, WinHeight - 1); -- to show 67 to 77 slots
	elseif (backpackSize >= 78) and (backpackSize <= 88) then wHugeBag:SetSize( WinWidth, WinHeight + 34 ); -- to show 78 to 88 slots
	elseif (backpackSize >= 89) and (backpackSize <= 99) then wHugeBag:SetSize( WinWidth, WinHeight + 69 ); -- to show 89 to 99 slots
	elseif (backpackSize >= 100) and (backpackSize <= 110) then wHugeBag:SetSize( WinWidth, WinHeight + 104 ); end -- to show 100 to 110 slots
	--**^

	--**v Slide control v**
	slideCtr = Turbine.UI.Control();

	slideCtr.Update = function( sender, args )
		-- ** Replace if display size has changed
		tscreenWidth, tscreenHeight = Turbine.UI.Display.GetSize();

		if ( tscreenWidth ~= screenWidth ) then
			screenWidth = tscreenWidth;
			if windowOpen then
				if WidgetLoc == L["OWidLocR"] then wHugeBag:SetLeft( screenWidth - WinWidth - 1 );
				else wHugeBag:SetLeft( 1 ); end
			else
				if WidgetLoc == L["OWidLocR"] then wHugeBag:SetLeft( screenWidth - 30 );
				else wHugeBag:SetLeft( -419 ); end
			end
		end
		-- **
		local bDone = false;
		
		if WidgetLoc == L["OWidLocR"] then
			if windowOpen then
				if ( wHugeBag:GetLeft() == ( screenWidth - 30 ) ) then windowOpen = false; bDone = true;
				else wHugeBag:SetLeft( wHugeBag:GetLeft() + winRate ); end
			else
				if ( wHugeBag:GetLeft() == ( screenWidth - ( winRate * 15 ) ) ) then windowOpen = true; bDone = true;
				else wHugeBag:SetLeft( wHugeBag:GetLeft() - winRate ); end
			end
			midLeftBar.MouseLeave();
		else
			if windowOpen then
				if ( wHugeBag:GetLeft() + wHugeBag:GetWidth() == 30 ) then windowOpen = false; bDone = true;
				else wHugeBag:SetLeft( wHugeBag:GetLeft() - winRate ); end
			else
				if ( wHugeBag:GetLeft() + wHugeBag:GetWidth() == winRate * 15 ) then windowOpen = true; bDone = true;
				else wHugeBag:SetLeft( wHugeBag:GetLeft() + winRate ); end
			end
			midRightBar.MouseLeave();
		end

		if bDone then slideCtr:SetWantsUpdates( false ); WasOpen = windowOpen; HBsettings.WasOpen = windowOpen; SaveSettings( false ); end --Save setting when done
	end
	--**^
	--**v Top left corner v**
	topLeftCorner = Turbine.UI.Control();
	topLeftCorner:SetParent( wHugeBag );
	topLeftCorner:SetPosition( 0, 0 );
	topLeftCorner:SetSize( 30, 20 );
	topLeftCorner:SetBackground( resources.TopLeftCorner.Background );

	topLeftCorner.MouseClick = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then
			if ( args.Button == Turbine.UI.MouseButton.Right ) then ShowOptionsMenu("nil");	end
		end
	end

	topLeftCorner.MouseHover = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then MouseHover(); end
	end

	topLeftCorner.MouseLeave = function ( args )
		if WidgetLoc == L["OWidLocR"] then MouseLeave(); end
	end

	topLeftCorner.MouseDown = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then MouseDown( sender, args ); end
	end

	topLeftCorner.MouseUp = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then MouseUp( sender, args ); end
	end

	topLeftCorner.MouseMove = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then MouseMove( sender, args ); end
	end
	--**^
	--**v Middle left bar **
	midLeftBar = Turbine.UI.Control();
	midLeftBar:SetParent( wHugeBag );
	midLeftBar:SetPosition( 0, 20 );
	midLeftBar:SetSize( 30, wHugeBag:GetHeight() - 40 );
	midLeftBar:SetBackground( resources.MidLeftBar.Background );

	midLeftBar.MouseEnter = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then
			topLeftCorner:SetBackground( resources.TopLeftCorner_over.Background );
			midLeftBar:SetBackground( resources.MidLeftBar_over.Background );
			botLeftCorner:SetBackground( resources.BotLeftCorner_over.Background );
		end
	end
	
	midLeftBar.MouseLeave = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then
			topLeftCorner:SetBackground( resources.TopLeftCorner.Background );
			midLeftBar:SetBackground( resources.MidLeftBar.Background );
			botLeftCorner:SetBackground( resources.BotLeftCorner.Background );
		end
	end

	midLeftBar.MouseClick = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then
			if ( args.Button == Turbine.UI.MouseButton.Left ) then
				slideCtr:SetWantsUpdates(true);
				SearchInput.FocusLost();
			elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
				ReloadHugeBag();
			end
		end
	end
	--**^
	--**v Bottom left corner v**
	botLeftCorner = Turbine.UI.Control();
	botLeftCorner:SetParent( wHugeBag );
	botLeftCorner:SetPosition( 0, wHugeBag:GetHeight() - 20 );
	botLeftCorner:SetSize( 30, 20 );
	botLeftCorner:SetBackground( resources.BotLeftCorner.Background );

	botLeftCorner.MouseClick = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then
			if ( args.Button == Turbine.UI.MouseButton.Right ) then	itemsmenu:ShowMenuAt(wHugeBag:GetLeft() - 200, wHugeBag:GetTop()); end
		end
	end
	
	botLeftCorner.MouseHover = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then MouseHover(); end
	end

	botLeftCorner.MouseLeave = function ( args )
		if WidgetLoc == L["OWidLocR"] then MouseLeave(); end
	end

	botLeftCorner.MouseDown = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then MouseDown( sender, args ); end
	end

	botLeftCorner.MouseUp = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then MouseUp( sender, args ); end
	end

	botLeftCorner.MouseMove = function( sender, args )
		if WidgetLoc == L["OWidLocR"] then MouseMove( sender, args ); end
	end
	--**^
	--**v Top right corner v**
	topRightCorner = Turbine.UI.Control();
	topRightCorner:SetParent( wHugeBag );
	topRightCorner:SetPosition( wHugeBag:GetWidth() - 30, 0 );
	topRightCorner:SetSize( 30, 20 );
	topRightCorner:SetBackground( resources.TopRightCorner.Background );

	topRightCorner.MouseClick = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then
			if ( args.Button == Turbine.UI.MouseButton.Right ) then ShowOptionsMenu("left"); end
		end
	end

	topRightCorner.MouseHover = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then MouseHover(); end
	end

	topRightCorner.MouseLeave = function ( args )
		if WidgetLoc == L["OWidLocL"] then	MouseLeave(); end
	end

	topRightCorner.MouseDown = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then	MouseDown( sender, args ); end
	end

	topRightCorner.MouseUp = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then	MouseUp( sender, args ); end
	end

	topRightCorner.MouseMove = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then	MouseMove( sender, args ); end
	end
	--**^
	--**v Middle right bar v**
	midRightBar = Turbine.UI.Control();
	midRightBar:SetParent( wHugeBag );
	midRightBar:SetPosition( wHugeBag:GetWidth() - 30, 20 );
	midRightBar:SetSize( 30, wHugeBag:GetHeight() - 40 );
	midRightBar:SetBackground( resources.MidRightBar.Background );

	midRightBar.MouseEnter = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then
			topRightCorner:SetBackground( resources.TopRightCorner_over.Background );
			midRightBar:SetBackground( resources.MidRightBar_over.Background );
			botRightCorner:SetBackground( resources.BotRightCorner_over.Background );
		end
	end

	midRightBar.MouseLeave = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then
			topRightCorner:SetBackground( resources.TopRightCorner.Background );
			midRightBar:SetBackground( resources.MidRightBar.Background );
			botRightCorner:SetBackground( resources.BotRightCorner.Background );
		end
	end

	midRightBar.MouseClick = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then
			if ( args.Button == Turbine.UI.MouseButton.Left ) then slideCtr:SetWantsUpdates(true);
			elseif ( args.Button == Turbine.UI.MouseButton.Right ) then ReloadHugeBag(); end
		end
	end
	--**^
	--**v Bottom right corner v**
	botRightCorner = Turbine.UI.Control();
	botRightCorner:SetParent( wHugeBag );
	botRightCorner:SetPosition( wHugeBag:GetWidth() - 30, wHugeBag:GetHeight() - 20 );
	botRightCorner:SetSize( 30, 20 );
	botRightCorner:SetBackground( resources.BotRightCorner.Background );

	botRightCorner.MouseClick = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then
			if ( args.Button == Turbine.UI.MouseButton.Right ) then	itemsmenu:ShowMenuAt(wHugeBag:GetLeft() + wHugeBag:GetWidth() + 5, wHugeBag:GetTop()); end
		end
	end

	botRightCorner.MouseHover = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then	MouseHover(); end
	end

	botRightCorner.MouseLeave = function ( args )
		if WidgetLoc == L["OWidLocL"] then	MouseLeave(); end
	end

	botRightCorner.MouseDown = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then	MouseDown( sender, args ); end
	end

	botRightCorner.MouseUp = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then	MouseUp( sender, args ); end
	end

	botRightCorner.MouseMove = function( sender, args )
		if WidgetLoc == L["OWidLocL"] then	MouseMove( sender, args ); end
	end
	--**^
	--**v Top bar v**
	TopBar = Turbine.UI.Control();
	TopBar:SetParent( wHugeBag );
	TopBar:SetPosition( 30, 0 );
	TopBar:SetSize( wHugeBag:GetWidth() - 60, 30 );
	TopBar:SetBackground( resources.TopBar.Background );
	--**^
	--**v Bottom bar V**
	BotBar = Turbine.UI.Control();
	BotBar:SetParent( wHugeBag );
	BotBar:SetPosition( 30, wHugeBag:GetHeight() - 30);
	BotBar:SetSize( wHugeBag:GetWidth() - 60, 30 );
	BotBar:SetBackground( resources.BotBar.Background );

	BotBar.MouseClick = function( sender, args )
		SearchInput.FocusLost();
	end
	-- **^
	--**v Label on left bar v**
	llabel = Turbine.UI.Label();
	llabel:SetParent( midLeftBar );
	llabel:SetPosition( 6, ( midRightBar:GetHeight() / 2 ) - 75 );
	llabel:SetSize( 19, 150 );
	llabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	llabel:SetFont( Turbine.UI.Lotro.Font.TrajanPro19 );
	llabel:SetForeColor( Color["rustedgold"] );
	llabel:SetOutlineColor( Color["black"] );
	llabel:SetFontStyle( Turbine.UI.FontStyle.Outline );
	llabel:SetBlendMode( Turbine.UI.BlendMode.Overlay );
	llabel:SetMouseVisible( false );
	--**^
	--**v Label on right bar v**
	rlabel = Turbine.UI.Label();
	rlabel:SetParent( midRightBar );
	rlabel:SetPosition( 6, ( midLeftBar:GetHeight() / 2 ) - 75 );
	rlabel:SetSize( 19, 150 );
	rlabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	rlabel:SetFont( Turbine.UI.Lotro.Font.TrajanPro19 );
	rlabel:SetForeColor( Color["rustedgold"] );
	rlabel:SetOutlineColor( Color["black"] );
	rlabel:SetFontStyle( Turbine.UI.FontStyle.Outline );
	rlabel:SetBlendMode( Turbine.UI.BlendMode.Overlay );
	rlabel:SetMouseVisible( false );
	--**^
	--**v Control of sort/search/merge buttons v**
	ButtonsCtr = Turbine.UI.Control();
	ButtonsCtr:SetParent( BotBar );
	ButtonsCtr:SetPosition( 0, 0 )
	ButtonsCtr:SetSize(BotBar:GetWidth(), BotBar:GetHeight());
	--ButtonsCtr:SetBackColor( Color["red"] ); --debug purpose
	--**^
	--**v Sort button on bottom bar v**
	SortButton = Turbine.UI.Button();
	SortButton:SetParent( ButtonsCtr );
	SortButton:SetPosition( SortLeft, 8 );
	SortButton:SetOutlineColor( Color["black"] );
	SortButton:SetForeColor( Color["grey"] );
	SortButton:SetFontStyle( Turbine.UI.FontStyle.Outline );

	SortButton.MouseClick = function(sender, args)
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			if not WasDrag then	Sort();	end
		elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
			if not WasDrag then	Mix(); end
		end
		WasDrag = false;
	end

	SortButton.MouseMove = function(sender, args)
		if dragging then
			local CtrLocX = SortButton:GetLeft();
			local CtrWidth = SortButton:GetWidth();
			CtrLocX = CtrLocX + ( args.X - dragStartX );
			if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > ButtonsCtr:GetWidth() then CtrLocX = ButtonsCtr:GetWidth() - CtrWidth; end

			SortButton:SetPosition( CtrLocX, 8 );
			WasDrag = true;
		else
			SortButton:SetForeColor( Color["green"] );
		end
	end

	SortButton.MouseLeave = function(sender, args)
		SortButton:SetForeColor( Color["grey"] );
	end

	SortButton.MouseDown = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			dragStartX = args.X;
			dragStartY = args.Y;
			dragging = true;
		end
	end

	SortButton.MouseUp = function( sender, args )
		dragging = false;
		SortLeft = SortButton:GetLeft();
		HBsettings.Button.Position.Sort = string.format("%.0f", SortLeft);
		SaveSettings( false );
	end
	--**^
	--**v Merge button on bottom bar v**
	MergeButton = Turbine.UI.Button();
	MergeButton:SetParent( ButtonsCtr );
	MergeButton:SetPosition( MergeLeft, 8 );
	MergeButton:SetOutlineColor( Color["black"] );
	MergeButton:SetForeColor( Color["grey"] );
	MergeButton:SetFontStyle( Turbine.UI.FontStyle.Outline );

	MergeButton.MouseClick = function(sender, args)
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			if not WasDrag then	Merge(); end
		end
		WasDrag = false;
	end

	MergeButton.MouseMove = function(sender, args)
		if dragging then
			local CtrLocX = MergeButton:GetLeft();
			local CtrWidth = MergeButton:GetWidth();
			CtrLocX = CtrLocX + ( args.X - dragStartX );
			if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > ButtonsCtr:GetWidth() then CtrLocX = ButtonsCtr:GetWidth() - CtrWidth; end

			MergeButton:SetPosition( CtrLocX, 8 );
			WasDrag = true;
		else
			MergeButton:SetForeColor( Color["green"] );
		end
	end

	MergeButton.MouseLeave = function(sender, args)
		MergeButton:SetForeColor( Color["grey"] );
	end

	MergeButton.MouseDown = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			dragStartX = args.X;
			dragStartY = args.Y;
			dragging = true;
		end
	end

	MergeButton.MouseUp = function( sender, args )
		dragging = false;
		MergeLeft = MergeButton:GetLeft();
		HBsettings.Button.Position.Merge = string.format("%.0f", MergeLeft);
		SaveSettings( false );
	end
	--**^
	--**v Search button on bottom bar v**
	SearchButton = Turbine.UI.Button();
	SearchButton:SetParent( ButtonsCtr );
	SearchButton:SetPosition( SearchLeft, 8 );
	SearchButton:SetOutlineColor( Color["black"] );
	SearchButton:SetForeColor( Color["grey"] );
	SearchButton:SetFontStyle( Turbine.UI.FontStyle.Outline );

	SearchButton.MouseClick = function(sender, args)
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			if not WasDrag then
				AllItems:SetChecked(true);
				AllItems:SetEnabled(false);
				Searching();
			end
		end
		WasDrag = false;
	end

	SearchButton.MouseMove = function(sender, args)
		if dragging then
			local CtrLocX = SearchButton:GetLeft();
			local CtrWidth = SearchButton:GetWidth();
			CtrLocX = CtrLocX + ( args.X - dragStartX );
			if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > ButtonsCtr:GetWidth() then CtrLocX = ButtonsCtr:GetWidth() - CtrWidth; end

			SearchButton:SetPosition( CtrLocX, 8 );
			WasDrag = true;
		else
			SearchButton:SetForeColor( Color["green"] );
		end
	end

	SearchButton.MouseLeave = function(sender, args)
		SearchButton:SetForeColor( Color["grey"] );
	end

	SearchButton.MouseDown = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			dragStartX = args.X;
			dragStartY = args.Y;
			dragging = true;
		end
	end

	SearchButton.MouseUp = function( sender, args )
		dragging = false;
		SearchLeft = SearchButton:GetLeft();
		HBsettings.Button.Position.Search = string.format("%.0f", SearchLeft);
		SaveSettings( false );
	end
	--**^
	--**v Bags button on bottom bar v**
	BagsButton = Turbine.UI.Button();
	BagsButton:SetParent( ButtonsCtr );
	BagsButton:SetPosition( BagsLeft, 8 );
	BagsButton:SetOutlineColor( Color["black"] );
	BagsButton:SetForeColor( Color["grey"] );
	BagsButton:SetFontStyle( Turbine.UI.FontStyle.Outline );

	BagsButton.MouseClick = function(sender, args)
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			if not WasDrag then
				ViewVaultStorageBags( "bags" );
			end
		end
		WasDrag = false;
	end

	BagsButton.MouseMove = function(sender, args)
		if dragging then
			local CtrLocX = BagsButton:GetLeft();
			local CtrWidth = BagsButton:GetWidth();
			CtrLocX = CtrLocX + ( args.X - dragStartX );
			if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > ButtonsCtr:GetWidth() then CtrLocX = ButtonsCtr:GetWidth() - CtrWidth; end

			BagsButton:SetPosition( CtrLocX, 8 );
			WasDrag = true;
		else
			BagsButton:SetForeColor( Color["green"] );
		end
	end

	BagsButton.MouseLeave = function(sender, args)
		BagsButton:SetForeColor( Color["grey"] );
	end

	BagsButton.MouseDown = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			dragStartX = args.X;
			dragStartY = args.Y;
			dragging = true;
		end
	end

	BagsButton.MouseUp = function( sender, args )
		dragging = false;
		BagsLeft = BagsButton:GetLeft();
		HBsettings.Button.Position.Bags = string.format("%.0f", BagsLeft);
		SaveSettings( false );
	end
	--**^
	--**v Vault button on bottom bar v**
	VaultButton = Turbine.UI.Button();
	VaultButton:SetParent( ButtonsCtr );
	VaultButton:SetPosition( VaultLeft, 8 );
	VaultButton:SetOutlineColor( Color["black"] );
	VaultButton:SetForeColor( Color["grey"] );
	VaultButton:SetFontStyle( Turbine.UI.FontStyle.Outline );

	VaultButton.MouseClick = function(sender, args)
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			if not WasDrag then
				ViewVaultStorageBags( "vault" );
			end
		end
		WasDrag = false;
	end

	VaultButton.MouseMove = function(sender, args)
		if dragging then
			local CtrLocX = VaultButton:GetLeft();
			local CtrWidth = VaultButton:GetWidth();
			CtrLocX = CtrLocX + ( args.X - dragStartX );
			if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > ButtonsCtr:GetWidth() then CtrLocX = ButtonsCtr:GetWidth() - CtrWidth; end

			VaultButton:SetPosition( CtrLocX, 8 );
			WasDrag = true;
		else
			VaultButton:SetForeColor( Color["green"] );
		end
	end

	VaultButton.MouseLeave = function(sender, args)
		VaultButton:SetForeColor( Color["grey"] );
	end

	VaultButton.MouseDown = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			dragStartX = args.X;
			dragStartY = args.Y;
			dragging = true;
		end
	end

	VaultButton.MouseUp = function( sender, args )
		dragging = false;
		VaultLeft = VaultButton:GetLeft();
		HBsettings.Button.Position.Vault = string.format("%.0f", VaultLeft);
		SaveSettings( false );
	end
	--**^
	--**v Shared Storage button on bottom bar v**
	SSButton = Turbine.UI.Button();
	SSButton:SetParent( ButtonsCtr );
	SSButton:SetPosition( SSLeft, 8 );
	SSButton:SetOutlineColor( Color["black"] );
	SSButton:SetForeColor( Color["grey"] );
	SSButton:SetFontStyle( Turbine.UI.FontStyle.Outline );

	SSButton.MouseClick = function(sender, args)
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			if not WasDrag then
				ViewVaultStorageBags( "storage" );
			end
		end
		WasDrag = false;
	end

	SSButton.MouseMove = function(sender, args)
		if dragging then
			local CtrLocX = SSButton:GetLeft();
			local CtrWidth = SSButton:GetWidth();
			CtrLocX = CtrLocX + ( args.X - dragStartX );
			if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > ButtonsCtr:GetWidth() then CtrLocX = ButtonsCtr:GetWidth() - CtrWidth; end

			SSButton:SetPosition( CtrLocX, 8 );
			WasDrag = true;
		else
			SSButton:SetForeColor( Color["green"] );
		end
	end

	SSButton.MouseLeave = function(sender, args)
		SSButton:SetForeColor( Color["grey"] );
	end

	SSButton.MouseDown = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			dragStartX = args.X;
			dragStartY = args.Y;
			dragging = true;
		end
	end

	SSButton.MouseUp = function( sender, args )
		dragging = false;
		SSLeft = SSButton:GetLeft();
		HBsettings.Button.Position.SS = string.format("%.0f", SSLeft);
		SaveSettings( false );
	end
	--**^
	--**v Text box on bottom bar v**
	SearchInput = Turbine.UI.Lotro.TextBox();
	SearchInput:SetParent( BotBar );
	SearchInput:SetPosition( SortLeft, 4 );
	SearchInput:SetSize( 160, 20 );
	SearchInput:SetMultiline( false );
	SearchInput:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	SearchInput.Text = "";
	SearchInput:SetText( SearchInput.Text );
	SearchInput:SetVisible( false );

	SearchInput.FocusGained = function()
		SearchInput:SetWantsUpdates( true );
	end
	
	SearchInput.FocusLost = function()
		SearchInput:SetWantsUpdates( false );
		SearchInput:SetText( "" );
		SearchInput:SetVisible( false );
		if ShowButton then ButtonsCtr:SetVisible( true ); end
		AllVisible = true;
	end

	SearchInput.TextChanged = function( sender, args )
		searchString = string.lower( SearchInput:GetText() );

		for i = 1, backpackSize do
			Item = Backpack:GetItem( i );
			if Item ~= nil then
				items[i]:SetVisible( false );
				if string.find( string.lower( Item:GetName() ), searchString ) or ( searchString == "" ) then items[i]:SetVisible( true ); end
			end
		end
	end
	--**^
	--**v Slots informations on top bar v**
	lblTitle = Turbine.UI.Label();
	lblTitle:SetParent( wHugeBag );
	lblTitle:SetSize( wHugeBag:GetWidth() - 60, 30 );
	lblTitle:SetPosition( 30, 2 );
	lblTitle:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	lblTitle:SetFont( Turbine.UI.Lotro.Font.TrajanPro19 );
	lblTitle:SetForeColor( Color["rustedgold"] );
	lblTitle:SetOutlineColor( Color["black"] );
	lblTitle:SetFontStyle( Turbine.UI.FontStyle.Outline );
	lblTitle:SetBlendMode( Turbine.UI.BlendMode.Overlay );
	--**^
	--**v Set some settings of the itemlistbox v**
	wHugeBag.itemListBox = Turbine.UI.ListBox();
	wHugeBag.itemListBox:SetParent( wHugeBag );
	wHugeBag.itemListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	wHugeBag.itemListBox:SetPosition( InitXPos, InitYPos );
	wHugeBag.itemListBox:SetBackColor( Turbine.UI.Color( bcAlpha, bcRed, bcGreen, bcBlue ) );
	wHugeBag.itemListBox:SetMaxItemsPerLine( 11 );
	--wHugeBag.itemListBox:SetBlendMode( Turbine.UI.BlendMode.Overlay );
	wHugeBag.itemListBox:SetAllowDrop( true );

	wHugeBag.itemListBox.DragDrop = function( sender, args )
		--write("drag/drop");
		local shortcut = args.DragDropInfo:GetShortcut();
		local destinationItemControl = wHugeBag.itemListBox:GetItemAt( args.X, args.Y );
		
		if ( destinationItemControl ~= nil ) and ( shortcut ~= nil ) then -- ** if nil, then it's out of range, so don't do anything **
			local destinationIndex = wHugeBag.itemListBox:IndexOfItem( destinationItemControl );
			Backpack:PerformShortcutDrop(shortcut, destinationIndex, Turbine.UI.Control.IsShiftKeyDown() );
		end
	end
	-- **^
	
	LoadProfileSettings();
	
	wHugeBag.KeyDown = function( sender, args )
		if ( args.Action == 145 ) then -- Escape
			if HideWEsc then if windowOpen then slideCtr:SetWantsUpdates(true); end
			else wHugeBag:SetVisible( true ); end -- **v DO NOT Hide if ESC key is pressed v**
		elseif ( args.Action == 268435635 ) then -- Hide if F12 key is pressed
			if not CSPress then wHugeBag:SetVisible( not wHugeBag:IsVisible() );	end
			F12Press = not F12Press;
		elseif ( args.Action == 268435579 ) then -- Hide if (Ctrl + \) is pressed
			if not F12Press then wHugeBag:SetVisible( not wHugeBag:IsVisible() ); end
			CSPress = not CSPress;
		-- **v Show HugeBag if any key bound is pressed v**
		elseif ( args.Action == 268435604 or args.Action == 268435478 or args.Action == 268435486 or args.Action == 268435493 or
			 args.Action == 268435501 or args.Action == 268435513 or args.Action == 268436015 ) then
			 -- **v show HugeBag only if F12 & (Ctrl + \) key was not pressed v**
			if not F12Press and not CSPress then slideCtr:SetWantsUpdates(true); wHugeBag:Activate(); end
		end
	end

	--**v Backpack v**
	--I'm showing 11 slots per row
	--backpackSize = 60; --debug purpose

	if (backpackSize >= 45) and (backpackSize <= 55) then wHugeBag.itemListBox:SetSize( 389, 178 ); -- to show 45 to 55 slots
	elseif (backpackSize >= 56) and (backpackSize <= 66) then wHugeBag.itemListBox:SetSize( 389, 213 ); -- to show 56 to 66 slots
	elseif (backpackSize >= 67) and (backpackSize <= 77) then wHugeBag.itemListBox:SetSize( 389, 248 ); -- to show 67 to 77 slots
	elseif (backpackSize >= 78) and (backpackSize <= 88) then wHugeBag.itemListBox:SetSize( 389, 283 ); -- to show 78 to 88 slots
	elseif (backpackSize >= 89) and (backpackSize <= 99) then wHugeBag.itemListBox:SetSize( 389, 318 ); -- to show 89 to 99 slots
	elseif (backpackSize >= 100) and (backpackSize <= 110) then wHugeBag.itemListBox:SetSize( 389, 353 ); end -- to show 100 to 110 slots

	SetBackPack(); --> ** Set the backpack **

	Backpack.ItemAdded = function( sender, args )
		bAdd = true;
		AddTime = Turbine.Engine.GetGameTime();

		items[args.Index]:SetItem( Backpack:GetItem( args.Index ) );
		PrintTitle();
	end
	
	-- Workaround for the ItemRemoved
	ItemRemovedTimer = Turbine.UI.Control();
	
	ItemRemovedTimer.Update = function( sender, args )
		ItemRemovedTimer:SetWantsUpdates( false );
		PrintTitle();
	end
	--

	Backpack.ItemRemoved = function( sender, args )
		if bAdd and not IsSorting and not IsMixing and not IsMerging then
			RemTime = Turbine.Engine.GetGameTime();
			elapsed = RemTime - AddTime;
			if elapsed == 0 then
				bGo = true;
			end
		end
		bAdd = false;

		items[args.Index]:SetItem( nil );
		--items[args.Index]:SetItem( Backpack:GetItem( args.Index ) ); -- Original line
		ItemRemovedTimer:SetWantsUpdates( true ); --PrintTitle();

		if bGo then ReloadHugeBag(); end
	end
	
	Backpack.ItemMoved = function( sender, args )
		items[args.OldIndex]:SetItem( Backpack:GetItem( args.OldIndex ) );
		items[args.NewIndex]:SetItem( Backpack:GetItem( args.NewIndex ) );
	end
end

--**v Set the backpack v**
function SetBackPack()
	items = nil;
	itemsCtl = nil;
	itemsLbl = nil;
	wHugeBag.itemListBox:ClearItems();
	freeslots = 0;
	
	items = {};
	itemsCtl = {};
	itemsLbl = {};
	
	for i = 1, backpackSize do
		-- Item background
		itemsCtl[i] = Turbine.UI.Control();
		itemsCtl[i]:SetSize( 35, 35 );
		itemsCtl[i]:SetBackground( resources.Item.Background );
		itemsCtl[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		if debug then
			-- Slot num in background
			itemsLbl[i] = Turbine.UI.Label();
			itemsLbl[i]:SetParent( itemsCtl[i] );
			itemsLbl[i]:SetSize( 35, 35 );
			itemsLbl[i]:SetPosition( 0, 0 );
			itemsLbl[i]:SetText( i );
			itemsLbl[i]:SetForeColor( Color["verylightgrey"] );
			itemsLbl[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
			itemsLbl[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		end

		-- Item
		items[i] = Turbine.UI.Lotro.ItemControl( Backpack:GetItem( i ) );
		items[i]:SetParent( itemsCtl[i] );

		--if ( Backpack:GetItem( i ) == nil ) then freeslots = freeslots + 1; end

		wHugeBag.itemListBox:AddItem( itemsCtl[i] );
	end
	
	ShowBT("main"); -- Show buttons text

	PrintTitle();
end
--**^
--**v Print the title with the free slots and the max v**
function PrintTitle()
	freeslots = 0;
	for i = 1, backpackSize do
		if ( Backpack:GetItem( i ) == nil ) then freeslots = freeslots + 1; end
	end

	local usedslots = backpackSize - freeslots;

	--top bar
	if topbarinfo == "title" then
		lblTitle:SetText( L["HugeBag"] );
	elseif topbarinfo == "info" then
		lblTitle:SetText( L["HugeBag--"] .. L["Free"] .. freeslots .. L["Used"] .. usedslots .. L["Max"] .. backpackSize );
	elseif topbarinfo == "nil" then
		lblTitle:SetText( "" );
	end

	--side bar
	if WidgetLoc == L["OWidLocR"] then
		if sidebarinfo == "info" then
			llabel:SetBackground( resources.HugeBagEmpty.Image );
			
			if freeslots <= 9 and usedslots <= 9 then
				llabel:SetText( L["FF"].. "\n" .. freeslots .. "\n\n" .. L["UU"] .. "\n" .. usedslots .. "\n\n" .. L["MM"] .. backpackSize );
			elseif freeslots <= 9 and usedslots >= 10 then
				llabel:SetText( L["FF"].. "\n" .. freeslots .. "\n\n" .. L["UU"] .. " " .. usedslots .. "\n" .. L["MM"] .. backpackSize );
			elseif freeslots >= 10 and usedslots <= 9 then
				llabel:SetText( L["FF"].. "\n" .. freeslots .. "\n" .. L["UU"] .. "\n" .. usedslots .. "\n\n" .. L["MM"] .. backpackSize );
			elseif freeslots >= 10 and usedslots >= 10 then
				llabel:SetText( L["FF"].. "\n" .. freeslots .. "\n" .. L["UU"] .. " " .. usedslots .. "\n" .. L["MM"] .. backpackSize );
			end
		elseif sidebarinfo == "image" then
			llabel:SetBackground( resources.HugeBagName.Image );
			llabel:SetText("");
		elseif sidebarinfo == "nil" then
			llabel:SetBackground( resources.HugeBagEmpty.Image );
			llabel:SetText("");
		end
		
		rlabel:SetText("");
		rlabel:SetBackground( resources.HugeBagEmpty.Image );
	else
		if sidebarinfo == "info" then
			rlabel:SetBackground( resources.HugeBagEmpty.Image );
			
			if freeslots <= 9 and usedslots <= 9 then
				rlabel:SetText( L["FF"] .. "\n" .. freeslots .. "\n\n".. L["UU"] .. "\n" .. usedslots .. "\n\n" .. L["MM"] .. backpackSize );
			elseif freeslots <= 9 and usedslots >= 10 then
				rlabel:SetText( L["FF"] .. "\n" .. freeslots .. "\n\n" .. L["UU"] .. " " .. usedslots .. "\n" .. L["MM"] .. backpackSize );
			elseif freeslots >= 10 and usedslots <= 9 then
				rlabel:SetText( L["FF"] .. "\n" .. freeslots .. "\n" .. L["UU"] .. "\n" .. usedslots .. "\n\n" .. L["MM"] .. backpackSize );
			elseif freeslots >= 10 and usedslots >= 10 then
				rlabel:SetText( L["FF"] .. "\n" .. freeslots .. "\n" .. L["UU"] .. " " .. usedslots .. "\n" .. L["MM"] .. backpackSize );
			end
		elseif sidebarinfo == "image" then
			rlabel:SetBackground( resources.HugeBagName.Image );
			rlabel:SetText("");
		elseif sidebarinfo == "nil" then
			rlabel:SetBackground( resources.HugeBagEmpty.Image );
			rlabel:SetText("");
		end

		llabel:SetText("");
		llabel:SetBackground( resources.HugeBagEmpty.Image );
	end

	--bottom bar
	if not IsSorting and not IsMixing and not IsMerging then
		ButtonsCtr:SetVisible( ShowButton );
		SortButton:SetVisible( ShowSort );
		MergeButton:SetVisible( ShowMerge );
		SearchButton:SetVisible( ShowSearch );
		BagsButton:SetVisible( ShowBags );
		VaultButton:SetVisible( ShowVault );
		SSButton:SetVisible( ShowSS );
	end
end
--**^