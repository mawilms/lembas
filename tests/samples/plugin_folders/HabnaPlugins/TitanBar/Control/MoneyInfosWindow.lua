-- MoneyInfosWindow.lua
-- written by Habna


function frmMoneyInfosWindow()
	-- **v Set some window stuff v**
	_G.wMI = Turbine.UI.Lotro.Window()
	_G.wMI:SetText( L["MIWTitle"] );
	_G.wMI:SetWantsKeyEvents( true );
	_G.wMI:SetVisible( true );
	_G.wMI:SetWidth( 325 );
	--_G.wMI:SetZOrder( 2 );
	_G.wMI:Activate();

	_G.wMI.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			_G.wMI:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			_G.wMI:SetVisible( not _G.wMI:IsVisible() );
		end
	end

	_G.wMI.MouseUp = function( sender, args )
		settings.Money.L = string.format("%.0f", _G.wMI:GetLeft());
		settings.Money.T = string.format("%.0f", _G.wMI:GetTop());
		MIWLeft, MIWTop = _G.wMI:GetPosition();
		SaveSettings( false );
	end

	_G.wMI.Closing = function( sender, args ) -- Function for the Upper right X icon
		_G.wMI:SetWantsKeyEvents( false );
		_G.wMI = nil;
		_G.frmMI = nil;
	end
	-- **^

	MIListBox = Turbine.UI.ListBox();
	MIListBox:SetParent( _G.wMI );
	MIListBox:SetPosition( 20, 35 );
	MIListBox:SetWidth( _G.wMI:GetWidth() - 40 );
	MIListBox:SetMaxItemsPerLine( 1 );
	MIListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	--MIListBox:SetBackColor( Color["darkgrey"] ); --debug purpose
	
	-- **v Display total money - check box v**
	AllCharCB = Turbine.UI.Lotro.CheckBox();
	AllCharCB:SetParent( _G.wMI );
	AllCharCB:SetText( L["MIWAll"] );
	AllCharCB:SetSize( _G.wMI:GetWidth(), 30 );
	AllCharCB:SetChecked( _G.STM );
	AllCharCB:SetForeColor( Color["rustedgold"] );

	AllCharCB.CheckedChanged = function( sender, args )
		_G.STM = AllCharCB:IsChecked();
		settings.Money.S = _G.STM;
		SaveSettings( false );
		UpdateMoney();
	end
	-- **^
	-- **v Display character money - check box v**
	ThisCharCB = Turbine.UI.Lotro.CheckBox();
	ThisCharCB:SetParent( _G.wMI );
	ThisCharCB:SetText( L["MIWCM"] );
	ThisCharCB:SetSize( _G.wMI:GetWidth(), 30 );
	ThisCharCB:SetChecked( _G.SCM );
	ThisCharCB:SetForeColor( Color["rustedgold"] );

	ThisCharCB.CheckedChanged = function( sender, args )
		_G.SCM = ThisCharCB:IsChecked();
		if _G.STM then AllCharCB:SetChecked( false ); SavePlayerMoney(true); AllCharCB:SetChecked( true );
		else SavePlayerMoney(true); end
		RefreshMIListBox();
	end
	-- **^
	-- **v Display to all character - check box v**
	ToAllCharCB = Turbine.UI.Lotro.CheckBox();
	ToAllCharCB:SetParent( _G.wMI );
	ToAllCharCB:SetText( L["MIWCMAll"] );
	ToAllCharCB:SetSize( _G.wMI:GetWidth(), 30 );
	ToAllCharCB:SetChecked( _G.SCMA );
	ToAllCharCB:SetForeColor( Color["rustedgold"] );

	ToAllCharCB.CheckedChanged = function( sender, args )
		_G.SCMA = ToAllCharCB:IsChecked();
		SavePlayerMoney( false );
	end
	-- **^
	-- **v Display session statistics - check box v**
	SSSCB = Turbine.UI.Lotro.CheckBox();
	SSSCB:SetParent( _G.wMI );
	SSSCB:SetText( L["MIWSSS"] );
	SSSCB:SetSize( _G.wMI:GetWidth(), 30 );
	SSSCB:SetChecked( _G.SSS );
	SSSCB:SetForeColor( Color["rustedgold"] );

	SSSCB.CheckedChanged = function( sender, args )
		_G.SSS = SSSCB:IsChecked();
		settings.Money.SS = _G.SSS;
		SaveSettings( false );
	end
	-- **^
	-- **v Display session statistics - check box v**
	STSCB = Turbine.UI.Lotro.CheckBox();
	STSCB:SetParent( _G.wMI );
	STSCB:SetText( L["MIWSTS"] );
	STSCB:SetSize( _G.wMI:GetWidth(), 30 );
	STSCB:SetChecked( _G.STS );
	STSCB:SetForeColor( Color["rustedgold"] );

	STSCB.CheckedChanged = function( sender, args )
		_G.STS = STSCB:IsChecked();
		settings.Money.TS = _G.STS;
		SaveSettings( false );
	end
	-- **^

	RefreshMIListBox();

	_G.wMI:SetPosition( MIWLeft, MIWTop );
end

function RefreshMIListBox()
	MIListBox:ClearItems();
	MIPosY = 0;
	iFound = false;
	
	--Create an array of character name, sort it, then use it as a reference.
	local a = {};
    for n in pairs(wallet) do table.insert(a, n) end
    table.sort(a);
    --for i,n in ipairs(a) do write(n) end --degug purpose

	--for k,v in pairs(wallet) do
	for i = 1, #a do
		DecryptMoney(wallet[a[i]].Money);

		if a[i] == Player:GetName() then
			if wallet[a[i]].Show then MIShowData(a[i]); end
		else
			if wallet[a[i]].ShowToAll or wallet[a[i]].ShowToAll == nil then MIShowData(a[i]); end
		end
	end
	
	if not iFound then--No wallet info found, show a message
		--**v Control of message v**
		local MsgCtr = Turbine.UI.Control();
		MsgCtr:SetParent( MIListBox );
		MsgCtr:SetSize( MIListBox:GetWidth(), 19 );
		MsgCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		--MsgCtr:SetBackColor( Color["red"] ); -- Debug purpose
		--**^
		--**v Message v**
		local MsgLbl = Turbine.UI.Label();
		MsgLbl:SetParent( MsgCtr );
		--MsgLbl:SetForeColor( Color["white"] );
		MsgLbl:SetPosition( 0, 0 );
		MsgLbl:SetText( L["MIMsg"] );
		MsgLbl:SetSize( MsgCtr:GetWidth(), MsgCtr:GetHeight() );
		--MsgLbl:SetFontStyle( Turbine.UI.FontStyle.Outline );
		MsgLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		MsgLbl:SetForeColor( Color["red"] );
		--MsgLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^

		MIListBox:AddItem( MsgCtr );
		MIPosY = MIPosY + 19;
	end

	--**v Line Control v**
	local LineCtr = Turbine.UI.Control();
	LineCtr:SetParent( MIListBox );
	LineCtr:SetSize( MIListBox:GetWidth(), 7 );
	--LineCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );

	local LineLbl = Turbine.UI.Label();
	LineLbl:SetParent( LineCtr );
	LineLbl:SetText( "" );
	LineLbl:SetPosition( 0, 2 );
	LineLbl:SetSize( MIListBox:GetWidth(), 1 );
	LineLbl:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	LineLbl:SetBackColor( Color["trueblue"] );

	MIListBox:AddItem( LineCtr );
	MIPosY = MIPosY + 7;
	--**^
	
	--**v Control of total Gold/Silver/Copper v**
	local TotMoneyCtr = Turbine.UI.Control();
	TotMoneyCtr:SetParent( MIListBox );
	--TotMoneyCtr:SetPosition( 0, _G.wMI:GetWidth() );
	TotMoneyCtr:SetSize( MIListBox:GetWidth(), 19 );
	TotMoneyCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	--TotMoneyCtr:SetBackColor( Color["red"] ); -- Debug purpose
	--**^
	--**v Total label v**
	local TotLbl = Turbine.UI.Label();
	TotLbl:SetParent( TotMoneyCtr );
	--TotLbl:SetFont ( 12 );
	TotLbl:SetText( L["MIWTotal"] );
	TotLbl:SetPosition( 21, 0 );
	TotLbl:SetSize( 65, TotMoneyCtr:GetHeight() );
	TotLbl:SetForeColor( Color["white"] );
	TotLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	--TotLbl:SetBackColor( Color["red"] ); -- debug purpose
	--**^
	--**v Copper icon & amount v**
	local CopperIcon = Turbine.UI.Control();
	CopperIcon:SetParent( TotMoneyCtr );
	CopperIcon:SetSize( 27, 21 );
	CopperIcon:SetPosition( TotMoneyCtr:GetWidth() - 30, -2 );
	CopperIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	CopperIcon:SetBackground( 0x41007e7d ); -- in-game copper icon
	--CopperIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
	local CopperLbl = Turbine.UI.Label();
	CopperLbl:SetParent( TotMoneyCtr );
	--CopperLbl:SetForeColor( Color["white"] );
	CopperLbl:SetText( string.format("%.0f", CopperTot) );
	CopperLbl:SetSize( 20, TotMoneyCtr:GetHeight() );
	CopperLbl:SetPosition( CopperIcon:GetLeft() - 18, 0 );
	CopperLbl:SetFontStyle( Turbine.UI.FontStyle.Outline );
	CopperLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	--CopperLbl:SetBackColor( Color["white"] ); -- Debug purpose
	--**^
	--**v Silver icon & amount v**
	local SilverIcon = Turbine.UI.Control();
	SilverIcon:SetParent( TotMoneyCtr );
	SilverIcon:SetSize( 27, 21 );
	SilverIcon:SetPosition( CopperLbl:GetLeft() - 34, -2 );
	SilverIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	SilverIcon:SetBackground( 0x41007e7c ); -- in-game silver icon
	--SilverIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
	local SilverLbl = Turbine.UI.Label();
	SilverLbl:SetParent( TotMoneyCtr );
	--SilverLbl:SetForeColor( Color["white"] );
	SilverLbl:SetText( string.format("%.0f", SilverTot) );
	SilverLbl:SetSize( 20, TotMoneyCtr:GetHeight() );
	SilverLbl:SetPosition( SilverIcon:GetLeft() - 18, 0 );
	SilverLbl:SetFontStyle( Turbine.UI.FontStyle.Outline );
	SilverLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	--SilverLbl:SetBackColor( Color["white"] ); -- Debug purpose
	--**^
	--**v Gold icon & amount v**
	local GoldIcon = Turbine.UI.Control();
	GoldIcon:SetParent( TotMoneyCtr );
	GoldIcon:SetSize( 27, 21 );
	GoldIcon:SetPosition( SilverLbl:GetLeft() - 34, -2 );
	GoldIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	GoldIcon:SetBackground( 0x41007e7b ); -- in-game gold icon
	--GoldIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
	local GoldLbl = Turbine.UI.Label();
	GoldLbl:SetParent( TotMoneyCtr );
	--GoldLbl:SetForeColor( Color["white"] );
	GoldLbl:SetText( string.format("%.0f", GoldTot) );
	GoldLbl:SetSize( 50, TotMoneyCtr:GetHeight() );
	GoldLbl:SetPosition( GoldIcon:GetLeft() - 48, 0 );
	GoldLbl:SetFontStyle( Turbine.UI.FontStyle.Outline );
	GoldLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	--GoldLbl:SetBackColor( Color["white"] ); -- Debug purpose
	--**^
	
	MIListBox:AddItem( TotMoneyCtr );
	MIPosY = MIPosY + 19;
	MIListBox:SetHeight( MIPosY );

	MIPosY = MIPosY + 50;
	AllCharCB:SetPosition( MIListBox:GetLeft(), MIPosY );
	MIPosY = MIPosY + 20;
	ThisCharCB:SetPosition( MIListBox:GetLeft(), MIPosY );
	MIPosY = MIPosY + 20;
	ToAllCharCB:SetPosition( MIListBox:GetLeft(), MIPosY );
	MIPosY = MIPosY + 20;
	SSSCB:SetPosition( MIListBox:GetLeft(), MIPosY );
	MIPosY = MIPosY + 20;
	STSCB:SetPosition( MIListBox:GetLeft(), MIPosY );
	
	_G.wMI:SetHeight( MIPosY + 45 );
end

function MIShowData(k)
	iFound = true;
	--**v Control of Gold/Silver/Copper currencies v**
	local MoneyCtr = Turbine.UI.Control();
	MoneyCtr:SetParent( MIListBox );
	MoneyCtr:SetSize( MIListBox:GetWidth(), 19 );
	MoneyCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	--MoneyCtr:SetBackColor( Color["red"] ); -- Debug purpose
	--**^
	--**v Delete icon v**
	local DelIcon = Turbine.UI.Label();
	DelIcon:SetParent( MoneyCtr );
	DelIcon:SetPosition( 0, 0 );
	DelIcon:SetSize( 16, 16 );
	DelIcon:SetBackground( 0x4101f893 );
	DelIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	DelIcon:SetVisible( true );
	if k == Player:GetName() then DelIcon:SetVisible( false ); end
				
	DelIcon.MouseClick = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Left ) then
			write(k .. L["MIWID"]);
			--wallet[k].Show = false;
			wallet[k].ShowToAll = false;
			if _G.STM then AllCharCB:SetChecked( false ); SavePlayerMoney(true); AllCharCB:SetChecked( true ); else SavePlayerMoney(true); end
			RefreshMIListBox();
		end
	end
	--**^
	--**v Player name v**
	local lblName = Turbine.UI.Label();
	lblName:SetParent( MoneyCtr );
	--lblName:SetFont ( 12 );
	lblName:SetText( k );
	lblName:SetPosition( DelIcon:GetLeft() + DelIcon:GetWidth() + 5, 0 );
	lblName:SetSize( lblName:GetTextLength() * 7.5, MoneyCtr:GetHeight() );
	if k == Player:GetName() then lblName:SetForeColor( Color["green"] );
	else lblName:SetForeColor( Color["white"] ); end
	lblName:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	--lblName:SetBackColor( Color["red"] ); -- debug purpose
	--**^
	--**v Copper icon & amount v**
	local CopperIcon = Turbine.UI.Control();
	CopperIcon:SetParent( MoneyCtr );
	CopperIcon:SetSize( 27, 21 );
	CopperIcon:SetPosition( MoneyCtr:GetWidth() - 30, -2 );
	CopperIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	CopperIcon:SetBackground( 0x41007e7d ); -- in-game copper icon
	--CopperIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
	local CopperLbl = Turbine.UI.Label();
	CopperLbl:SetParent( MoneyCtr );
	--CopperLbl:SetForeColor( Color["white"] );
	CopperLbl:SetText( string.format("%.0f", copper) );
	CopperLbl:SetSize(20, MoneyCtr:GetHeight() );
	CopperLbl:SetPosition( CopperIcon:GetLeft() - 18, 0 );
	CopperLbl:SetFontStyle( Turbine.UI.FontStyle.Outline );
	CopperLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	--CopperLbl:SetBackColor( Color["white"] ); -- Debug purpose
	--**^
	--**v Silver icon & amount v**
	local SilverIcon = Turbine.UI.Control();
	SilverIcon:SetParent( MoneyCtr );
	SilverIcon:SetSize( 27, 21 );
	SilverIcon:SetPosition( CopperLbl:GetLeft() - 34, -2 );
	SilverIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	SilverIcon:SetBackground( 0x41007e7c ); -- in-game silver icon
	--SilverIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
	local SilverLbl = Turbine.UI.Label();
	SilverLbl:SetParent( MoneyCtr );
	--SilverLbl:SetForeColor( Color["white"] );
	SilverLbl:SetText( string.format("%.0f", silver) );
	SilverLbl:SetSize(20, MoneyCtr:GetHeight() );
	SilverLbl:SetPosition( SilverIcon:GetLeft() - 18, 0 );
	SilverLbl:SetFontStyle( Turbine.UI.FontStyle.Outline );
	SilverLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	--SilverLbl:SetBackColor( Color["white"] ); -- Debug purpose
	--**^
	--**v Gold icon & amount v**
	local GoldIcon = Turbine.UI.Control();
	GoldIcon:SetParent( MoneyCtr );
	GoldIcon:SetSize( 27, 21 );
	GoldIcon:SetPosition( SilverLbl:GetLeft() - 34, -2 );
	GoldIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	GoldIcon:SetBackground( 0x41007e7b ); -- in-game gold icon
	--GoldIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
	local GoldLbl = Turbine.UI.Label();
	GoldLbl:SetParent( MoneyCtr );
	--GoldLbl:SetForeColor( Color["white"] );
	GoldLbl:SetText( string.format("%.0f", gold) );
	GoldLbl:SetSize(50, MoneyCtr:GetHeight() );
	GoldLbl:SetPosition( GoldIcon:GetLeft() - 48, 0 );
	GoldLbl:SetFontStyle( Turbine.UI.FontStyle.Outline );
	GoldLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	--GoldLbl:SetBackColor( Color["white"] ); -- Debug purpose
	--**^

	MIListBox:AddItem( MoneyCtr );
	MIListBox:SetHeight( MIPosY );
		
	MIPosY = MIPosY + 19;
end