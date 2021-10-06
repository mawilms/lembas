-- MainWindow.lua
-- Originally TheOneBagWindow.lua written by Rod, extended by Habna


import "HabnaPlugins.HugeBag.functionsWindow"; -- LUA functions file
import "HabnaPlugins.HugeBag.optionsWindow"; -- LUA options file

resources = {
	  Item = { Background = "HabnaPlugins/HugeBag/Resources/slotBackground.tga" },
	  Picker = { Background = "HabnaPlugins/HugeBag/Resources/picker.jpg" } --Color picker picture (240px x 71px)
};


if ShowTitle then frmMain = class( Turbine.UI.Lotro.Window ); --Window with skin & title
else frmMain = class( Turbine.UI.Window ); end --Window with no skin & no title

function frmMain()
	if ShowSkin then
		wHugeBag = Turbine.UI.Lotro.Window();
		--Turbine.UI.Lotro.Window.Constructor( wHugeBag ); --Window with skin & title
	else
		wHugeBag = Turbine.UI.Window();
		--Turbine.UI.Window.Constructor( wHugeBag ); --Window with no skin no title
	end

	--**v Set HugeBag window v**	
	wHugeBag:SetSize( WinWidth, WinHeight );
	wHugeBag:SetPosition( WinLocX, WinLocY );
	wHugeBag:SetWantsKeyEvents( true );
	if zOrder then wHugeBag:SetZOrder( 1 );	end --1 Always on top / 0 Not always on top
	--wHugeBag:Activate();
	wHugeBag.cursor = nil;
	--**^
	--**v Check for the Reloader & Unloader module v**
	Turbine.PluginManager.RefreshAvailablePlugins();
	loaded_plugins = Turbine.PluginManager.GetLoadedPlugins();

	HBChecker = Turbine.UI.Control();
	HBChecker:SetWantsUpdates( true );
		
	HBChecker.Update = function( sender, args )
		for k,v in pairs(loaded_plugins) do
			if v.Name == "HugeBag Reloader" then
				Turbine.PluginManager.UnloadScriptState( 'HugeBagReloader' );
				wHugeBag:SetVisible( WasVisible );
				--write("Bug detected, HugeBag was reloaded!");
				bfound = true;
				--break;
			end
			if v.Name == "HugeBag Unloader" then
				Turbine.PluginManager.UnloadScriptState( 'HugeBagUnloader' );
				--break;
			end
		end
		HBChecker:SetWantsUpdates( false );
		if not bfound then wHugeBag:SetVisible( StartVisible ); end
		HBsettings.WasVisible = wHugeBag:IsVisible();
		SaveSettings( false );
	end
	--**^

	LoadProfileSettings();

	--**v Skin v**
	HBSkin = Turbine.UI.Control();
	HBSkin:SetParent( wHugeBag );
	HBSkin:SetPosition( 0, 0 );
	HBSkin:SetSize( WinWidth, WinHeight );
	HBSkin:SetBackColor( Color["none"] );
	HBSkin:SetVisible( not ShowSkin );

	HBSkin.MouseMove = function( sender, args )
		wHugeBag.MouseMove( sender, args );
	end

	HBSkin.MouseDown = function( sender, args )
		wHugeBag.MouseDown( sender, args );
	end

	HBSkin.MouseUp = function( sender, args )
		wHugeBag.MouseUp( sender, args );
	end

	HBSkin.MouseLeave = function( sender, args )
		wHugeBag.MouseLeave( sender, args );
	end
	--**^
	--**v Lock Label v**
	LockLabel = Turbine.UI.Control();
	LockLabel:SetParent( wHugeBag );
	LockLabel:SetPosition( 23, 0 );
	LockLabel:SetSize( WinWidth - 50, 40 );
	LockLabel:SetVisible( true );
	LockLabel:SetZOrder( 2 );
	--LockLabel:SetBackColor( white );
	LockLabel.Enable = not LockPosition;

	LockLabel.MouseDoubleClick = function( sender, args )
		--write("HugeBag was reloaded");
		HBsettings.WasVisible = true;
		SaveSettings( false );
		ReloadHugeBag();
	end
	
	LockLabel.MouseMove = function( sender, args )
		CornerClick = "Title";
		wHugeBag.MouseMove( sender, args );
	end
	
	LockLabel.MouseDown = function( sender, args )
		if not LockPosition then
			CornerClick = "Title";
			wHugeBag.MouseDown( sender, args );
		end
	end

	LockLabel.MouseUp = function( sender, args )
		wHugeBag.MouseUp( sender, args );
	end

	LockLabel.MouseLeave = function( sender, args )
		CornerClick = "";
		wHugeBag.MouseLeave( sender, args );
	end
	--**^
	--**v Control of sort/search/merge buttons v**
	ButtonsCtr = Turbine.UI.Control();
	ButtonsCtr:SetParent( wHugeBag );
	ButtonsCtr:SetSize( wHugeBag:GetWidth() - 68, 14);
	ButtonsCtr:SetZOrder( 3 );
	--ButtonsCtr:SetBackColor( Color["red"] ); --debug purpose
	--**^
	-- **v Sort button v**
	SortButton = Turbine.UI.Button();
	SortButton:SetParent( ButtonsCtr );
	--SortButton:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	--SortButton:SetBackColor( Color["blue"] ); -- Debug purpose
	-- To set an image
	--SortButton:SetSize( 24, 30);
	--SortButton:SetBackground( 0x41008113 ); -- in-game icon 24x30
	--SortButton:SetStretchMode( 1 );
	--SortButton:SetSize( 12, 15);
	--SortButton:SetStretchMode( 3 );
	
	SortButton:SetOutlineColor( Color["black"] );
	SortButton:SetForeColor( Color["grey"] );
	SortButton:SetFontStyle( Turbine.UI.FontStyle.Outline );
	SortButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );

	SortButton.MouseClick = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			if not WasDrag then	Sort(); end
		elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
			if not WasDrag then	Mix(); end
		end
		WasDrag = false;
	end

	SortButton.MouseMove = function( sender, args )
		if dragging then
			local CtrLocX = SortButton:GetLeft();
			local CtrWidth = SortButton:GetWidth();
			CtrLocX = CtrLocX + ( args.X - dragStartX );
			if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > ButtonsCtr:GetWidth() then CtrLocX = ButtonsCtr:GetWidth() - CtrWidth; end

			SortButton:SetPosition( CtrLocX, 2 );
			WasDrag = true;
		else -- Enable if text
			SortButton:SetForeColor( Color["green"] ); -- Enable if text
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
	-- **^
	--**v Merge button on bottom bar v**
	MergeButton = Turbine.UI.Button();
	MergeButton:SetParent( ButtonsCtr );
	MergeButton:SetOutlineColor( Color["black"] );
	MergeButton:SetForeColor( Color["grey"] );
	MergeButton:SetFontStyle( Turbine.UI.FontStyle.Outline );
	MergeButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );

	MergeButton.MouseClick = function(sender, args)
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			if not WasDrag then	Merge(); end
		elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
			
		end
		WasDrag = false;
	end

	MergeButton.MouseMove = function(sender, args)
		if dragging then
			local CtrLocX = MergeButton:GetLeft();
			local CtrWidth = MergeButton:GetWidth();
			CtrLocX = CtrLocX + ( args.X - dragStartX );
			if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > ButtonsCtr:GetWidth() then CtrLocX = ButtonsCtr:GetWidth() - CtrWidth; end

			MergeButton:SetPosition( CtrLocX, 2 );
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
	-- **v Search button v**
	SearchButton = Turbine.UI.Button();
	SearchButton:SetParent( ButtonsCtr );
	SearchButton:SetForeColor( Color["grey"] );
	SearchButton:SetOutlineColor( Color["black"] );
	SearchButton:SetFontStyle( Turbine.UI.FontStyle.Outline );
	SearchButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );

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

			SearchButton:SetPosition( CtrLocX, 2 );
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
	-- **v Bags button v**
	BagsButton = Turbine.UI.Button();
	BagsButton:SetParent( ButtonsCtr );
	BagsButton:SetForeColor( Color["grey"] );
	BagsButton:SetOutlineColor( Color["black"] );
	BagsButton:SetFontStyle( Turbine.UI.FontStyle.Outline );
	BagsButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );

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

			BagsButton:SetPosition( CtrLocX, 2 );
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
	-- **v Vault button v**
	VaultButton = Turbine.UI.Button();
	VaultButton:SetParent( ButtonsCtr );
	VaultButton:SetForeColor( Color["grey"] );
	VaultButton:SetOutlineColor( Color["black"] );
	VaultButton:SetFontStyle( Turbine.UI.FontStyle.Outline );
	VaultButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );

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

			VaultButton:SetPosition( CtrLocX, 2 );
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
	-- **v Shared Storage button v**
	SSButton = Turbine.UI.Button();
	SSButton:SetParent( ButtonsCtr );
	SSButton:SetForeColor( Color["grey"] );
	SSButton:SetOutlineColor( Color["black"] );
	SSButton:SetFontStyle( Turbine.UI.FontStyle.Outline );
	SSButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );

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

			SSButton:SetPosition( CtrLocX, 2 );
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
	-- **v Set the itemlistbox v**
	wHugeBag.itemListBox = Turbine.UI.ListBox();
	wHugeBag.itemListBox:SetParent( wHugeBag );
	--wHugeBag.itemListBox:SetReverseFill( ReverseFill );
	wHugeBag.itemListBox:SetOrientation( Turbine.UI.Orientation.Vertical );
	if HorizontalOrientation then wHugeBag.itemListBox:SetOrientation( Turbine.UI.Orientation.Horizontal ); end
	wHugeBag.itemListBox:SetBackColor( Turbine.UI.Color( bcAlpha, bcRed, bcGreen, bcBlue ) );
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
	-- **v Set the scrollbar v**
	wHugeBag.itemListBoxScrollBar = Turbine.UI.Lotro.ScrollBar();
	wHugeBag.itemListBoxScrollBar:SetParent( wHugeBag );	
	-- **^
	-- **v Search box v**
	SearchInput = Turbine.UI.Lotro.TextBox();
	SearchInput:SetParent( wHugeBag );
	SearchInput.Text = "";
	SearchInput:SetSize( 150, 20 );
	SearchInput:SetMultiline( false );
	SearchInput:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );
	SearchInput:SetText( SearchInput.Text );
	SearchInput:SetVisible( false );
	
	SearchInput.FocusLost = function()
		SearchInput:SetText( "" );
		SearchInput:SetVisible( false );
		if ShowButton then
			ButtonsCtr:SetVisible( true );
			SearchInput.TextChanged( sender, args );
			AllVisible = true;
		end
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
	-- **^

	--**v Iconsize - invisible control v**
	SrollCtr = Turbine.UI.Control();
	SrollCtr:SetParent( wHugeBag );
	SrollCtr:SetPosition( 9, 40 ); --Need to be there so it can fit most skin
	SrollCtr:SetSize( 10, 29 );
	SrollCtr:SetVisible( false );
	--SrollCtr:SetBackColor( white ); --debug purpose

	SrollCtr.MouseMove = function( sender, args )
		SrollCtr:SetVisible( true );
	end

	SrollCtr.MouseLeave = function( sender, args )
		SrollCtr:SetVisible( false );
		lblIconSizeV:SetVisible( false );
		SrollCtr2:SetVisible( true );
	end
	--**^
	--**v Up button v**
	wIconUp = Turbine.UI.Control();
	wIconUp:SetParent( SrollCtr );
	wIconUp:SetPosition( 0, 0 );
	wIconUp:SetSize( 10, 10 );
	wIconUp:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	wIconUp:SetBackground( 0x4100028c );

	wIconUp.MouseMove = function( sender, args )
		wIconUp:SetBackground( 0x4100028d );
	end

	wIconUp.MouseLeave = function( sender, args )
		wIconUp:SetBackground( 0x4100028c );
	end

	wIconUp.MouseClick = function( sender, args )
		IconSize = IconSize + 1;
		ChangeIconSize();
	end

	wIconUp.MouseDoubleClick = function( sender, args )
		IconSize = IconSize + 2;
		ChangeIconSize();
	end
	--**^
	--**v Default button v**
	wDefault = Turbine.UI.Control();
	wDefault:SetParent( SrollCtr );
	wDefault:SetPosition( wIconUp:GetLeft(), wIconUp:GetTop()+wIconUp:GetHeight()+1 );
	wDefault:SetSize( 10, 7 );
	wDefault:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	wDefault:SetBackground( 0x41000282 );

	wDefault.MouseMove = function( sender, args )
		wDefault:SetBackground( 0x41000283 );
	end

	wDefault.MouseLeave = function( sender, args )
		wDefault:SetBackground( 0x41000282 );
	end

	wDefault.MouseClick = function( sender, args )
		IconSize = 35;
		ChangeIconSize();
	end
	--**^
	--**v Down button v**
	wIconDown = Turbine.UI.Control();
	wIconDown:SetParent( SrollCtr );
	wIconDown:SetPosition( wIconUp:GetLeft(), wDefault:GetTop()+wDefault:GetHeight()+1 );
	wIconDown:SetSize( 10, 10 );
	wIconDown:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	wIconDown:SetBackground( 0x4100028e );

	wIconDown.MouseMove = function( sender, args )
		wIconDown:SetBackground( 0x4100028f );
	end

	wIconDown.MouseLeave = function( sender, args )
		wIconDown:SetBackground( 0x4100028e );
	end

	wIconDown.MouseClick = function( sender, args )
		IconSize = IconSize - 1;
		ChangeIconSize();
	end

	wIconDown.MouseDoubleClick = function( sender, args )
		IconSize = IconSize - 2;
		ChangeIconSize();
	end
	--**^
	--**v Iconsize - invisible control 2 v**
	SrollCtr2 = Turbine.UI.Control();
	SrollCtr2:SetParent( wHugeBag );
	SrollCtr2:SetPosition( SrollCtr:GetLeft(), SrollCtr:GetTop() );
	SrollCtr2:SetSize( SrollCtr:GetWidth(), SrollCtr:GetHeight() );
	if not ISEnabled then SrollCtr2:SetVisible( false );
	else SrollCtr2:SetVisible( true ); end
	--SrollCtr2:SetBackColor( red );

	SrollCtr2.MouseMove = function( sender, args )
		SrollCtr:SetVisible( true );
		lblIconSizeV:SetVisible( true );
		SrollCtr2:SetVisible( false );
	end
	--**^
	--**v HugeBag Icon Size Value - label v**
	lblIconSizeV = Turbine.UI.Label();
	lblIconSizeV:SetParent( wHugeBag );
	lblIconSizeV:SetPosition( SrollCtr:GetLeft()-3, SrollCtr:GetTop()+SrollCtr:GetHeight() + 11 );
	lblIconSizeV:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	lblIconSizeV:SetText( IconSize-3 );
	lblIconSizeV:SetSize( 15, 15 );
	lblIconSizeV:SetVisible( fasle );
	lblIconSizeV:SetForeColor( Color["rustedgold"] );
	--**^
	
	wHugeBag.MouseDown = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			if CornerClick ~= "Title" then
				if ( args.X < 23 and args.Y > 15 and args.Y < 50 )then
					CornerClick = "TopLeft";
					--wHugeBag.cursor:SetVisible( false );
					ShowItemsMenu();
				elseif ( ( args.X < 23 ) and ( args.Y > ( wHugeBag:GetHeight() - 30 ) ) ) then
					CornerClick = "BottomLeft";
				elseif ( args.X > ( wHugeBag:GetWidth() -30 ) ) and ( args.Y > ( wHugeBag:GetHeight() - 30 ) ) then
					CornerClick = "BottomRight";
				elseif ( args.X > 50 ) and ( args.X < ( wHugeBag:GetWidth() - 50 ) ) and ( args.Y > ( wHugeBag:GetHeight() - 12 ) ) then
					CornerClick = "BottomBorder";
				elseif ( args.X < 6 ) and ( args.Y > 60 ) and ( args.Y < ( wHugeBag:GetHeight() - 45 ) ) then
					CornerClick = "LeftBorder";
				elseif ( args.X > ( wHugeBag:GetWidth() - 6 ) ) and ( args.Y > 60 ) and ( args.Y < ( wHugeBag:GetHeight() - 45 ) ) then
					CornerClick = "RightBorder";
				end
			end
			ClicX, ClicY = args.X + 23, args.Y;
			dragStartX = args.X;
			dragStartY = args.Y;
			dragging = true;
		elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
			if CornerClick ~= "Title" then
				if ( args.X < 23 and args.Y > 15 and args.Y < 50 )then 
					--TopLeft
					if frmOpt then
						wOptions:Close();
					else
						--frmOptions();
						ShowOptionsMenu("nil");
					end
				elseif ( ( args.X < 23 ) and ( args.Y > ( wHugeBag:GetHeight() - 30 ) ) ) then
					--BottomLeft
					
				end
			end
		end
		--write(tostring(CornerClick));
	end
	
	wHugeBag.MouseUp = function( sender, args )
		dragging = false;
		OutOfBound = false;
		CornerClick = "";
		SaveSettings( true );
	end
	
	wHugeBag.MouseMove = function( sender, args )
		--write(tostring(CornerClick));
		if dragging then
			wHugeBag.MouseLeave( sender, args );
			WinWidth, WinHeight = wHugeBag:GetSize();
			WinLocX, WinLocY = wHugeBag:GetPosition();
			local screenWidth = Turbine.UI.Display:GetWidth();
			local screenHeight = Turbine.UI.Display:GetHeight();
			local tempY = WinHeight + ( args.Y - dragStartY );
			local minH = 125; -- Minimum height

			if CornerClick == "BottomRight" then
				if not LockSize then
					-- **v Check horizontal v**
					local tempX = WinWidth + ( args.X - dragStartX );

					-- Prevent window to go out of bound (Right side)
					if ( WinLocX + tempX ) > screenWidth then
						dragging = false;
						wHugeBag:SetWidth( screenWidth - WinLocX );
					else
						wHugeBag:SetSize( tempX, tempY );
						dragStartX = dragStartX + (args.X - dragStartX);
						dragStartY = dragStartY + (args.Y - dragStartY);
					end
					
					if tempY < minH then -- Minimum height
						wHugeBag:SetHeight( minH );
					else
						wHugeBag:SetHeight( tempY );
					end
					
					ButtonsCtr:SetWidth( wHugeBag:GetWidth() - 68 );
					-- **^
				end
			elseif CornerClick == "BottomLeft" then
				if not LockSize then
					-- **v Check horizontal v**
					local tempX = WinWidth - ( args.X - dragStartX );

					--Prevent window to go out of bound (Left side)
					if WinLocX < 0 then
						dragging = false;
						wHugeBag:SetLeft( 0 );
					else
						wHugeBag:SetPosition( WinLocX + ( args.X - dragStartX ), WinLocY );
						wHugeBag:SetSize( tempX, tempY );
						dragStartY = dragStartY + ( args.Y - dragStartY );
					end

					if tempY < minH then -- Minimum height
						wHugeBag:SetHeight( minH );
					else
						wHugeBag:SetHeight( tempY );
					end

					ButtonsCtr:SetWidth( wHugeBag:GetWidth() - 68 );
					-- **^
				end
			elseif CornerClick == "Title" then
				local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
				wHugeBag:SetPosition( mouseX - ClicX, mouseY - ClicY);
			elseif CornerClick == "BottomBorder" then
				if not LockSize then
					if tempY < 125 then -- Minimum height
						wHugeBag:SetHeight( minH );
					else
						wHugeBag:SetHeight( tempY );
					end
					dragStartY = dragStartY + (args.Y - dragStartY);
				end
			elseif CornerClick == "LeftBorder" then
				if not LockSize then
					local tempX = WinWidth - ( args.X - dragStartX );
					if WinLocX < 0 then --Prevent window to go out of bound (Left side)
						dragging = false;
						wHugeBag:SetPosition( 0, WinLocY );
					elseif wHugeBag:GetWidth() <= 218 then
						dragging = false;
						wHugeBag:SetSize( 219, WinHeight );
					else
						wHugeBag:SetPosition( WinLocX + ( args.X - dragStartX ), WinLocY );
						wHugeBag:SetSize( tempX, WinHeight );
					end
					ButtonsCtr:SetWidth( wHugeBag:GetWidth() - 68 );
				end
			elseif CornerClick == "RightBorder" then
				if not LockSize then
					local tempX = WinWidth + ( args.X - dragStartX );
					if ( WinLocX + tempX ) > screenWidth then -- Prevent window to go out of bound (Right side)
						wHugeBag:SetSize( ( screenWidth - WinLocX ), WinHeight );
					else
						wHugeBag:SetSize( tempX, WinHeight );
						dragStartX = dragStartX + (args.X - dragStartX);
					end
					ButtonsCtr:SetWidth( wHugeBag:GetWidth() - 68 );
				end
			end
			--[[ Need to go out of bound when no skin on HugeBag
			-- **v Check vertical v**
			-- Prevent window to go out of bound (Bottom)
			if ( WinLocY + tempY ) > screenHeight then
				wHugeBag:SetSize( WinWidth, ( screenHeight - WinLocY ) );
			end
			-- **^
			]]
			PerformLayout();
		else
			if CornerClick == "Title" then
				ShowTitleResizeCursor();
			else
				if ( args.X < 23 and args.Y > 15 and args.Y < 50 )then
					-- "TopLeft"
					wHugeBag.cursor = leftrightclicCursor;
					local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
					wHugeBag.cursor:SetPosition( mouseX - wHugeBag.cursor.xOffset, mouseY - wHugeBag.cursor.yOffset);
					wHugeBag.cursor:SetVisible( true );
				elseif ( ( args.X < 23 ) and ( args.Y > ( wHugeBag:GetHeight() - 30 ) ) ) then
					-- "BottomLeft"
					ShowResizeCursor();
				elseif ( args.X > ( wHugeBag:GetWidth() - 30 ) ) and ( args.Y > ( wHugeBag:GetHeight() - 30 ) ) then
					-- "BottomRight"
					ShowResizeCursor();
				elseif ( args.X > 50 ) and ( args.X < ( wHugeBag:GetWidth() - 50 ) ) and ( args.Y > ( wHugeBag:GetHeight() - 12 ) ) then
					-- Bottom border
					ShowUpDownCursor();
				elseif ( args.X < 6 ) and ( args.Y > 60 ) and ( args.Y < ( wHugeBag:GetHeight() - 45 ) ) then
					-- Left border
					ShowLeftRightCursor();
				elseif ( args.X > ( wHugeBag:GetWidth() - 6 ) ) and ( args.Y > 60 ) and ( args.Y < ( wHugeBag:GetHeight() - 45 ) ) then
					--Right border
					ShowLeftRightCursor();
				else
					wHugeBag.MouseLeave( sender, args );
				end
			end
		end
	end

	wHugeBag.MouseLeave = function( sender, args )
		if wHugeBag.cursor ~= nil then
			wHugeBag.cursor:SetVisible( false );
			wHugeBag.cursor = nil;
		end
	end
	
	wHugeBag.Unload = function( sender, args )
		
	end

	wHugeBag.Closing = function( sender, args ) -- Function for the Upper right X icon
		--WasVisible = false;
		HBsettings.WasVisible = false;
		SaveSettings( false );
	end
	
	wHugeBag.PositionChanged = function(args)
		WinLocX, WinLocY = wHugeBag:GetPosition()
		HBsettings.Location.X = string.format("%.0f", WinLocX);
		HBsettings.Location.Y = string.format("%.0f", WinLocY);
		SaveSettings( false );
	end
	
	wHugeBag.KeyDown = function( sender, args )
		if ( args.Action == 145 ) then -- Hide if ESC key is press
			if HideWEsc then
				wHugeBag:SetVisible( false );
				--WasVisible = false;
				HBsettings.WasVisible = false;
				SaveSettings( false );
			end
		elseif ( args.Action == 268435635 ) then -- Hide if F12 key is pressed
			if not CSPress then	if wHugeBag:IsVisible() then wHugeBag:SetVisible( false ); else wHugeBag:SetVisible( WasVisible ); end end
			F12Press = not F12Press;
		elseif ( args.Action == 268435579 ) then -- Hide if (Ctrl + \) is pressed
			if not F12Press then if wHugeBag:IsVisible() then wHugeBag:SetVisible( false ); else wHugeBag:SetVisible( WasVisible ); end end
			CSPress = not CSPress;
		-- **v Show HugeBag if any key bound is press v**
		elseif ( args.Action == Turbine.UI.Lotro.Action.ToggleBags or args.Action == Turbine.UI.Lotro.Action.ToggleBag1 or
			 args.Action == Turbine.UI.Lotro.Action.ToggleBag2 or args.Action == Turbine.UI.Lotro.Action.ToggleBag3 or
			 args.Action == Turbine.UI.Lotro.Action.ToggleBag4 or args.Action == Turbine.UI.Lotro.Action.ToggleBag5 or
			 args.Action == Turbine.UI.Lotro.Action.ToggleBag6 ) then
			  -- **v show HugeBag only if F12 & (Ctrl + \) key was not pressed v**
			if not F12Press and not CSPress then
				wHugeBag:SetVisible( not wHugeBag:IsVisible() )
				wHugeBag:Activate();
				--WasVisible = wHugeBag:IsVisible();
				HBsettings.WasVisible = wHugeBag:IsVisible();
				SaveSettings( false );
			end
		end
	end

	--backpackSize = 60; --debug purpose
	SetBackPack(); --> ** Set the backpack **
	
	Backpack.SizeChanged = function( sender, args )
		backpackSize = Backpack:GetSize();
		SetBackPack();
	end

	--Backpack.ItemAdded = function( sender, args )
	HBItemAddedHandler = function( sender, args )
		--write("item added to index " .. args.Index);
		bAdd = true;
		AddTime = Turbine.Engine.GetGameTime();
		--write("AddTime: " .. tostring(AddTime));
		items[args.Index]:SetItem( Backpack:GetItem( args.Index ) );
		PrintTitle();
		RefreshImg();
	end
	
	-- Workaround for the ItemRemoved
	ItemRemovedTimer = Turbine.UI.Control();
	
	ItemRemovedTimer.Update = function( sender, args )
		ItemRemovedTimer:SetWantsUpdates( false );
		PrintTitle();
	end
	--

	--Backpack.ItemRemoved = function( sender, args )
	HBItemRemovedHandler = function( sender, args )
		--write("item removed from index " .. args.Index);
		--write("bAdd: " .. tostring(bAdd) .. " IsSorting: " .. tostring(IsSorting) .. " IsMixing: " .. tostring(IsMixing));
		if bAdd and not IsSorting and not IsMixing and not IsMerging then
			RemTime = Turbine.Engine.GetGameTime();
			--write("RemTime: " .. tostring(RemTime));
			elapsed = RemTime - AddTime;
			--write("elapsed: " .. tostring(elapsed));
			if elapsed == 0 then
				bGo = true;
				--write("HugeBag will be reloaded!");
			end
		end
		bAdd = false;

		items[args.Index]:SetItem( nil );
		--items[args.Index]:SetItem( Backpack:GetItem( args.Index ) ); -- Original line
		ItemRemovedTimer:SetWantsUpdates( true ); --wHugeBag:PrintTitle();
		RefreshImg();
		if bGo then ReloadHugeBag(); end
	end

	--Backpack.ItemMoved = function( sender, args )
	HBItemMovedHandler = function( sender, args )
		--write("item moved from index " .. args.OldIndex .. " to " .. args.NewIndex);
		items[args.OldIndex]:SetItem( Backpack:GetItem( args.OldIndex ) );
		items[args.NewIndex]:SetItem( Backpack:GetItem( args.NewIndex ) );

		RefreshImg();
	end

	-- register callbacks
	AddCallback(Backpack, "ItemAdded", HBItemAddedHandler);
	AddCallback(Backpack, "ItemRemoved", HBItemRemovedHandler);
	AddCallback(Backpack, "ItemMoved", HBItemMovedHandler);
end

--**v Set the backpack v**
function SetBackPack()
	wHugeBag.itemListBox:ClearItems();

	itemsCtl = nil;
	itemsBG = nil;
	itemsLbl = nil;
	items = nil;

	itemsCtl = {};
	itemsBG = {};
	itemsLbl = {};
	items = {};
	--ISEnabled = true; --debug purpose
	for i = 1, backpackSize do
		-- Item control
		itemsCtl[i] = Turbine.UI.Control();
		itemsCtl[i]:SetSize( IconSize, IconSize );
		
		-- Item background
		itemsBG[i] = Turbine.UI.Control();
		itemsBG[i]:SetParent( itemsCtl[i] );
		itemsBG[i]:SetBackground( resources.Item.Background );
		if not ISEnabled then itemsBG[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay ); end --Need to be off if using StretchMode
		if ISEnabled then
			itemsBG[i]:SetSize( 35, 35 );
			itemsBG[i]:SetStretchMode( 1 );
			--itemsBG[i]:SetStretchMode( 2 );
			itemsBG[i]:SetSize( IconSize, IconSize );
			itemsBG[i]:SetStretchMode( 3 );
		end

		--vv ** debug purpose **
		if debug then
			-- Slot num in background
			itemsLbl[i] = Turbine.UI.Label();
			itemsLbl[i]:SetParent( itemsCtl[i] );
			itemsLbl[i]:SetSize( 15, 15 );
			itemsLbl[i]:SetPosition( 10, 10 );
			itemsLbl[i]:SetText( i );
			itemsLbl[i]:SetForeColor( Color["lightgrey"] );
			itemsLbl[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		end
		--^^
				
		-- Item
		items[i] = Turbine.UI.Lotro.ItemControl( Backpack:GetItem( i ) );
		items[i]:SetParent( itemsCtl[i] );
		--items[i]:SetSize( 35, 35 );
		if ISEnabled then
			--items[i]:SetStretchMode( 1 );
			items[i]:SetStretchMode( 2 );
			items[i]:SetSize( IconSize, IconSize );
			--items[i]:SetStretchMode( 3 );
		end

		wHugeBag.itemListBox:AddItem( itemsCtl[i] );
	end

	PerformLayout();
	PrintTitle();
end
-- **^
-- **v Layout of the items in the listbox v**
function PerformLayout()
	WinWidth, WinHeight = wHugeBag:GetSize();
	WinLocX, WinLocY = wHugeBag:GetPosition();
	itemWidth, itemHeight = IconSize, IconSize;--items[1]:GetSize();
	
	listWidth = WinWidth - 37;
	listHeight = WinHeight - 55

	wHugeBag.itemListBox:SetSize( listWidth, listHeight );
	wHugeBag.itemListBox:SetPosition( InitXPos, InitYPos );
	
	wHugeBag.itemListBox:SetOrientation( Turbine.UI.Orientation.Vertical );
	if HorizontalOrientation then wHugeBag.itemListBox:SetOrientation( Turbine.UI.Orientation.Horizontal ); end
	
	if HorizontalOrientation then -- 0 => Horizontal /  1=> Vertical
		itemsPerRow = listWidth / itemWidth;
		--if ReverseFill then
			
		--else
			wHugeBag.itemListBoxScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
			wHugeBag.itemListBox:SetVerticalScrollBar( wHugeBag.itemListBoxScrollBar );

			wHugeBag.itemListBoxScrollBar:SetPosition( WinWidth - 20, 40 );
			wHugeBag.itemListBoxScrollBar:SetSize( 10, listHeight - 15 );
		--end
	else
		itemsPerRow = math.floor(listHeight / itemHeight);
		--if ReverseFill then

		--else
			wHugeBag.itemListBoxScrollBar:SetOrientation( Turbine.UI.Orientation.Horizontal );
			wHugeBag.itemListBox:SetHorizontalScrollBar( wHugeBag.itemListBoxScrollBar );

			wHugeBag.itemListBoxScrollBar:SetPosition( wHugeBag.itemListBox:GetLeft(), WinHeight - 23);
			wHugeBag.itemListBoxScrollBar:SetSize( listWidth, 10 );
		--end
	end
	
	wHugeBag.itemListBox:SetMaxItemsPerLine( itemsPerRow );
	
	if ( wHugeBag:GetWidth() <= 218 ) then wHugeBag:SetSize( 218, wHugeBag:GetHeight()); end -- Limit to minimum width

	LockLabel:SetSize(WinWidth - 50, 33 ); --> ** Resize the LockLabel with HugeBag width **
	HBSkin:SetSize( WinWidth, WinHeight ); --> ** Resize the HBSkin with HugeBag width an height **

	if ButtonAtTop then TopPos = 23;
	else TopPos = WinHeight - 20; end--22

	ButtonsCtr:SetPosition( 35, TopPos - 4 );
	SortButton:SetPosition( SortLeft,  2 ); --> ** Replace 'Sort' button with HugeBag height **
	MergeButton:SetPosition( MergeLeft, 2 ); --> ** Replace 'Merge' button with HugeBag height **
	SearchButton:SetPosition( SearchLeft,  2 ); --> ** Replace 'Search' button with HugeBag height **
	BagsButton:SetPosition( BagsLeft,  2 ); --> ** Replace 'Bags' button with HugeBag height **
	VaultButton:SetPosition( VaultLeft,  2 ); --> ** Replace 'Vault' button with HugeBag height **
	SSButton:SetPosition( SSLeft,  2 ); --> ** Replace 'Shared Storage' button with HugeBag height **
	SearchInput:SetPosition( 20,  TopPos - 7 ); --> ** Replace 'Search Box' with HugeBag height **
	
	ShowBT("main"); -- Show buttons text

	PrintTitle();
end
-- **^
-- **v Print the title with the free/used/max info v**
function PrintTitle()
	local freeslots = 0;
		
	for i = 1, backpackSize do
		if ( Backpack:GetItem( i ) == nil ) then freeslots = freeslots + 1; end
	end
		
	local usedslots = backpackSize - freeslots;

	--top section
	if topbarinfo == "title" then
		wHugeBag:SetText( L["HugeBag"] );
	elseif topbarinfo == "info" then
		if WinWidth < 265 then
			wHugeBag:SetText( freeslots .. "/" .. usedslots .. "/" .. backpackSize );
		elseif WinWidth < 315 then
			wHugeBag:SetText( L["F"] .. freeslots .. L["U"] .. usedslots .. L["M"] .. backpackSize );
		elseif WinWidth < 365 then
			wHugeBag:SetText( L["HB--"] .. L["F"] .. freeslots .. L["U"] .. usedslots .. L["M"] .. backpackSize );
		elseif WinWidth < 430 then
			wHugeBag:SetText( L["HugeBag--"] .. L["F"] .. freeslots .. L["U"] .. usedslots .. L["M"] .. backpackSize );
		else
			wHugeBag:SetText( L["HugeBag--"] .. L["Free"] .. freeslots .. L["Used"] .. usedslots .. L["Max"] .. backpackSize );
		end
	elseif topbarinfo == "nil" then
		wHugeBag:SetText( "" );
	end
		
	--IsMoving = false;
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
-- **^

function RefreshImg()
	for i = 1, backpackSize do
		if ISEnabled then
			itemsCtl[i]:SetSize( IconSize, IconSize );

			--items[i]:SetSize( 35, 35 );
			items[i]:SetStretchMode( 2 );
			items[i]:SetSize( IconSize, IconSize );
		end
	end
end