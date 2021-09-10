-- profile.lua
-- Written by Habna


function frmProfile()
	TB["win"].MouseLeave();

	-- **v Set some window stuff v**
	wProfile = Turbine.UI.Lotro.Window();	
	wProfile:SetText( L["MPP"] );
	wProfile:SetWidth( 250 );
	wProfile:SetVisible( true );
	wProfile:SetWantsKeyEvents( true );
	--wProfile:SetZOrder( 2 );
	--wProfile:Activate();

	wProfile.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			wProfile:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			wProfile:SetVisible( not wProfile:IsVisible() );
		end
	end

	wProfile.MouseUp = function( sender, args )
		settings.Profile.L = string.format("%.0f", wProfile:GetLeft());
		settings.Profile.T = string.format("%.0f", wProfile:GetTop());
		PPWLeft, PPWTop = wProfile:GetPosition();
		SaveSettings( false );
	end

	wProfile.Closing = function( sender, args )
		wProfile:SetWantsKeyEvents( false );
		wProfile = nil;
		opt_profile:SetEnabled( true );
	end

	ListBox = Turbine.UI.ListBox();
	ListBox:SetParent( wProfile );
	ListBox:SetPosition( 20, 40 );
	ListBox:SetSize( wProfile:GetWidth() - 40, 20 );
	ListBox:SetMaxItemsPerLine( 1 );
	ListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	--ListBox:SetBackColor( Color["darkgrey"] ); --debug purpose

	buttonLoad = Turbine.UI.Lotro.Button();
	buttonLoad:SetParent( wProfile );
	buttonLoad:SetText( L["PWLoad"] );
	buttonLoad:SetSize( buttonLoad:GetTextLength() * 11, 15 ); --Auto size with text lenght
	buttonLoad:SetEnabled( false );

	buttonLoad.Click = function( sender, args )
		local LProfile = false; --Load profile
		local PLang = nil; --Profile Language
		PLang = vPProfileSettings[PrevItemClic].TitanBar.L;
		
		if PLang == "en" then if GLocale == "en" then LProfile = true; end
		else if GLocale ~= "en" then LProfile = true; end end

		if LProfile then
			write("TitanBar: " .. L["PWProfil"] .. " '" .. lblName[PrevItemClic]:GetText() .. "' " .. L["PWLoaded"]);
			settings = vPProfileSettings[PrevItemClic];
			settings.PlayerLoc.L = pLLoc;
			settings.TitanBar.ZT = "Profile";
			SaveSettings( false );
			ReloadTitanBar();
		else
			write("TitanBar: " .. L["PWFail"]);
		end
	end

	buttonCreate = Turbine.UI.Lotro.Button();
	buttonCreate:SetParent( wProfile );
	buttonCreate:SetText( L["PWCreate"] );
	buttonCreate:SetSize( buttonCreate:GetTextLength() * 10, 15 ); --Auto size with text lenght
	buttonCreate:SetEnabled( true );

	buttonCreate.Click = function( sender, args )
		CreateCtr:SetVisible( true );
		InputBox:SetText( L["PWEPN"] );
		InputBox:Focus();
		buttonLoad:SetVisible( false );
		buttonCreate:SetVisible( false );
		wProfile:SetHeight( wProfile:GetHeight() + 25 );
	end

	CreateCtr = Turbine.UI.Control();
	CreateCtr:SetParent( wProfile );
	CreateCtr:SetSize( ListBox:GetWidth(), 45 );
	CreateCtr:SetBlendMode( 4 );
	CreateCtr:SetVisible( false );
	--CreateCtr:SetBackColor( Color["red"] ); -- Debug purpose

	InputBox = Turbine.UI.Lotro.TextBox();
	InputBox:SetParent( CreateCtr );
	InputBox:SetSize( CreateCtr:GetWidth(), 20 );
	InputBox:SetPosition( 0, 0 );
	InputBox:SetMultiline( false );
	InputBox:SetFont( Turbine.UI.Lotro.Font.TrajanPro14 );

	InputBox.FocusGained = function( sender, args )
		InputBox:SelectAll();
	end
	
	buttonSave = Turbine.UI.Lotro.Button();
	buttonSave:SetParent( CreateCtr );
	buttonSave:SetText( L["PWSave"] );
	buttonSave:SetSize( buttonSave:GetTextLength() * 10, 15 ); --Auto size with text lenght
	buttonSave:SetPosition( 0, 25 );
	buttonSave:SetEnabled( true );

	buttonSave.Click = function( sender, args )
		if InputBox:GetText() == "" then
			InputBox:SetText( L["PWEPN"] );
			InputBox:Focus();
			return
		elseif InputBox:GetText() == L["PWEPN"] then
			InputBox:Focus();
			return
		end

		settings.PlayerLoc.L = L["PLMsg"];

		local vProfile = {};
		vProfile[InputBox:GetText()] = settings;
		table.insert( PProfile, vProfile );
		
		settings.TitanBar.ZT = "Profile";
		SavePlayerProfile();
		SaveSettings( false );
		settings.PlayerLoc.L = pLLoc;
		ReloadTitanBar(); -- Need to reload, because if create more then 1 profile, previous profile will be lost!
		--[[
		CreateCtr:SetVisible( false );
		buttonLoad:SetVisible( true );
		buttonLoad:SetEnabled( false );
		buttonCreate:SetVisible( true );
		RefreshListBox();
		]]
	end

	buttonCancel = Turbine.UI.Lotro.Button();
	buttonCancel:SetParent( CreateCtr );
	buttonCancel:SetText( L["PWCancel"] );
	buttonCancel:SetSize( buttonCancel:GetTextLength() * TM, 15 ); --Auto size with text lenght
	buttonCancel:SetPosition( buttonSave:GetLeft() + buttonSave:GetWidth() + 5, 25 );
	buttonCancel:SetEnabled( true );

	buttonCancel.Click = function( sender, args )
		CreateCtr:SetVisible( false );
		buttonLoad:SetVisible( true );
		buttonCreate:SetVisible( true );
		wProfile:SetHeight( wProfile:GetHeight() - 25 );
	end

	RefreshListBox();

    wProfile:SetPosition( PPWLeft, PPWTop );
end

function RefreshListBox()
	local PosY = 20;
	Ctr, DelIcon, lblName, vPProfile = {}, {}, {}, {};
	PrevItemClic, i = 0, 1;
	ListBox:ClearItems();

	vPProfile = {};
	vPProfileSettings = {};

	-- Convert the table key that is in string format into a number, so it can be viewed by lua correctly.
	local newt = {}
	for i, v in pairs(PProfile) do newt[tonumber(i)] = v; end
	PProfile = newt;

	if #PProfile == 0 then
		local Ctr = Turbine.UI.Control();
		Ctr:SetParent( ListBox );
		Ctr:SetSize( ListBox:GetWidth(), 20 );
		Ctr:SetBlendMode( 4 );
		--Ctr:SetBackColor( Color["red"] ); -- Debug purpose

		--**v Profil name v**
		local lblName = Turbine.UI.Label();
		lblName:SetParent( Ctr );
		--lblName:SetFont ( 12 );
		lblName:SetText( L["PWNFound"] );
		lblName:SetPosition( 0, 0 );
		lblName:SetSize( Ctr:GetWidth(), Ctr:GetHeight() );
		lblName:SetForeColor( Color["green"] );
		lblName:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		--lblName:SetBackColor( Color["red"] ); -- debug purpose
		--**^

		ListBox:AddItem( Ctr );
	else
		for i = 1, #PProfile do
			for k,v in pairs(PProfile[i]) do
				vPProfile[i] = k;
				vPProfileSettings[i] = v;
			end

			Ctr[i] = Turbine.UI.Control();
			Ctr[i]:SetParent( wProfile );
			Ctr[i]:SetSize( ListBox:GetWidth(), 20 );
			Ctr[i]:SetBlendMode( 4 );
			--Ctr[i]:SetBackColor( Color["red"] ); -- Debug purpose

			--**v Delete icon v**
			DelIcon[i] = Turbine.UI.Label();
			DelIcon[i]:SetParent( Ctr[i] );
			DelIcon[i]:SetPosition( 0, 1 );
			DelIcon[i]:SetSize( 16, 16 );
			DelIcon[i]:SetBackground( 0x4101f893 );
			DelIcon[i]:SetBlendMode( 4 );
			DelIcon[i]:SetVisible( true );
			--DelIcon[i]:SetBackColor( Color["blue"] ); -- debug purpose
				
			DelIcon[i].MouseClick = function( sender, args )
				if ( args.Button == Turbine.UI.MouseButton.Left ) then
					write("TitanBar: " .. L["PWProfil"] .. " '" .. lblName[i]:GetText() .. "' " .. L["PWDeleted"]);
					table.remove( PProfile, i );

					local newt = {};
					for i, v in pairs(PProfile) do newt[tostring(i)] = v; end
					PProfile = newt;

					SavePlayerProfile();
					RefreshListBox();
				end
			end
			--**^

			--**v Profil name v**
			lblName[i] = Turbine.UI.Label();
			lblName[i]:SetParent( Ctr[i] );
			lblName[i]:SetText( vPProfile[i] );
			lblName[i]:SetPosition( 21, 0 );
			lblName[i].Id = i;
			lblName[i].Sel = false;
			lblName[i]:SetSize( ListBox:GetWidth() - 21, 20 );
			lblName[i]:SetForeColor( Color["white"] );
			lblName[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
			lblName[i]:SetBackColorBlendMode( 5 );
			--lblName[i]:SetBackColor( Color["red"] ); -- debug purpose
			--**^
		
			lblName[i].MouseClick = function( sender, args )
				if PrevItemClic ~= 0 then
					lblName[PrevItemClic]:SetForeColor( Color["white"] );
					lblName[PrevItemClic]:SetBackColor( Color["black"] );
					lblName[PrevItemClic].Sel = false;
				end
				PrevItemClic = lblName[i].Id;
				lblName[PrevItemClic]:SetForeColor( Color["green"] );
				--lblName[PrevItemClic]:SetBackColor( Color["darkgrey"] );
				lblName[i].Sel = true;
				buttonLoad:SetEnabled( true );
			end

			lblName[i].MouseHover = function(sender, args)
				lblName[i]:SetBackColor( Color["lightgrey"] );
			end

			lblName[i].MouseLeave = function(sender, args)
				if lblName[i].Sel then lblName[i]:SetBackColor( Color["darkgrey"] ); else lblName[i]:SetBackColor( Color["black"] ); end
			end

			ListBox:AddItem( Ctr[i] );
			ListBox:SetHeight( PosY );

			PosY = PosY + 20;
		end
	end

	PerformLayout();
end

function PerformLayout()
	buttonLoad:SetPosition( 20, ListBox:GetTop() + ListBox:GetHeight() + 5 );
	buttonCreate:SetPosition( buttonLoad:GetLeft() + buttonLoad:GetWidth() + 15, ListBox:GetTop() + ListBox:GetHeight() + 5 );

	CreateCtr:SetPosition( 20, buttonLoad:GetTop() );

	wProfile:SetHeight( ListBox:GetHeight() + buttonLoad:GetHeight() + 60 );
	if CreateCtr:IsVisible() then wProfile:SetHeight( wProfile:GetHeight() + 25 ); end
end