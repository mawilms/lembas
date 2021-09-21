-- MoneyInfosToolTip.lua
-- written by Habna


function ShowMIWindow()
	_G.ToolTipWin = Turbine.UI.Window();
	_G.ToolTipWin:SetZOrder( 1 );
	_G.ToolTipWin:SetWidth( 325 );
	_G.ToolTipWin:SetVisible( true );

	MITTListBox = Turbine.UI.ListBox();
	MITTListBox:SetParent( _G.ToolTipWin );
	MITTListBox:SetZOrder( 1 );
	MITTListBox:SetPosition( 15, 20 );
	MITTListBox:SetWidth( _G.ToolTipWin:GetWidth() - 30 );
	MITTListBox:SetMaxItemsPerLine( 1 );
	MITTListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	--MITTListBox:SetBackColor( Color["blue"] ); --debug purpose

	MIRefreshMITTListBox();

	ApplySkin();
end

function MIRefreshMITTListBox()	
	MITTListBox:ClearItems();
	MITTPosY = 0;
	iFound = false;

	--Create an array of character name, sort it, then use it as a reference.
	local a = {};
    for n in pairs(wallet) do table.insert(a, n) end
    table.sort(a);
    --for i,n in ipairs(a) do write(n) end --degug purpose

	for i = 1, #a do
		DecryptMoney(wallet[a[i]].Money);

		if a[i] == Player:GetName() then
			if wallet[a[i]].Show then MITTShowData(a[i]); end
		else
			if wallet[a[i]].ShowToAll or wallet[a[i]].ShowToAll == nil then MITTShowData(a[i]); end
		end
	end
	
	if not iFound then--No wallet info found, show a message
		--**v Control of message v**
		local MsgCtr = Turbine.UI.Control();
		MsgCtr:SetParent( MITTListBox );
		MsgCtr:SetSize( MITTListBox:GetWidth(), 19 );
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
		MsgLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		MsgLbl:SetForeColor( Color["red"] );
		--MsgLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^

		MITTListBox:AddItem( MsgCtr );
		MITTPosY = MITTPosY + 19;
	end

	--**v Line Control v**
	local LineCtr = Turbine.UI.Control();
	LineCtr:SetParent( MITTListBox );
	LineCtr:SetSize( MITTListBox:GetWidth(), 7 );
	--LineCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	--LineCtr:SetBackColor( Color["white"] ); -- Debug purpose

	local LineLbl = Turbine.UI.Label();
	LineLbl:SetParent( LineCtr );
	LineLbl:SetText( "" );
	LineLbl:SetPosition( 0, 2 );
	LineLbl:SetSize( MITTListBox:GetWidth(), 1 );
	LineLbl:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	LineLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	LineLbl:SetBackColor( Color["trueblue"] );

	MITTListBox:AddItem( LineCtr );
	MITTPosY = MITTPosY + 7;
	--**^

	--**v Control of total Gold/Silver/Copper v**
	local TotMoneyCtr = Turbine.UI.Control();
	TotMoneyCtr:SetParent( MITTListBox );
	--TotMoneyCtr:SetPosition( 0, _G.ToolTipWin:GetWidth() );
	TotMoneyCtr:SetSize( MITTListBox:GetWidth(), 19 );
	TotMoneyCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	--TotMoneyCtr:SetBackColor( Color["red"] ); -- Debug purpose
	--**^
	--**v Total label v**
	local TotLbl = Turbine.UI.Label();
	TotLbl:SetParent( TotMoneyCtr );
	TotLbl:SetText( L["MIWTotal"] );
	TotLbl:SetPosition( 5, 0 );
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
	GoldLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	--GoldLbl:SetBackColor( Color["white"] ); -- Debug purpose
	--**^
	
	MITTListBox:AddItem( TotMoneyCtr );
	MITTPosY = MITTPosY + 19;
	MITTListBox:SetHeight( MITTPosY );

	--**v Statistics section v**
	local PN = Player:GetName();
	
	if _G.SSS then --Show session statistics if true
		MITTPosY = MITTPosY + 25;
		local LblStat = Turbine.UI.Label();
		LblStat:SetParent( _G.ToolTipWin );
		LblStat:SetZOrder( 2 );
		LblStat:SetPosition( MITTListBox:GetLeft(), MITTPosY );
		LblStat:SetForeColor( Color["rustedgold"] );
		LblStat:SetSize( 140, 19 );
		LblStat:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		LblStat:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		LblStat:SetText( L["MISession"] .. " " .. L["Stats"] );
		if TBLocale == "fr" then LblStat:SetText( L["Stats"] .. " " .. L["MISession"] ); end
		--LblStat:SetBackColor( Color["white"] ); -- Debug purpose
		MITTPosY = MITTPosY + 19;

		local StatsSeparator = Turbine.UI.Control();
		StatsSeparator:SetParent( _G.ToolTipWin );
		StatsSeparator:SetZOrder( 2 );
		StatsSeparator:SetSize( LblStat:GetWidth(), 1 );
		StatsSeparator:SetPosition( LblStat:GetLeft(), MITTPosY );
		StatsSeparator:SetBackColor( Color["trueblue"] );
		MITTPosY = MITTPosY + 1;
		--[[
		-- Starting Gold/Silver/Copper
		local StartCtr = Turbine.UI.Control();
		StartCtr:SetParent( _G.ToolTipWin );
		StartCtr:SetZOrder( 2 );
		StartCtr:SetPosition( LblStat:GetLeft(), MITTPosY );
		StartCtr:SetSize( MITTListBox:GetWidth(), 19 );
		StartCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		--StartCtr:SetBackColor( Color["red"] ); -- Debug purpose
		
		local lblStart = Turbine.UI.Label();
		lblStart:SetParent( StartCtr );
		lblStart:SetPosition( 0, 3 );
		lblStart:SetForeColor( Color["rustedgold"] );
		lblStart:SetSize( LblStat:GetWidth(), StartCtr:GetHeight() );
		lblStart:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		lblStart:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		lblStart:SetText( L["MIStart"] );
		--lblStart:SetBackColor( Color["white"] ); -- Debug purpose

		--**v Copper icon & amount v**
		local CopperIcon = Turbine.UI.Control();
		CopperIcon:SetParent( StartCtr );
		CopperIcon:SetSize( 27, 21 );
		CopperIcon:SetPosition( TotMoneyCtr:GetWidth() - 30, -2 );
		CopperIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		CopperIcon:SetBackground( 0x41007e7d ); -- in-game copper icon
		--CopperIcon:SetBackColor( Color["blue"] ); -- Debug purpose

		DecryptMoney(walletStats[DOY][PN].Start);

		local CopperLbl = Turbine.UI.Label();
		CopperLbl:SetParent( StartCtr );
		--CopperLbl:SetForeColor( Color["white"] );
		CopperLbl:SetText( copper );
		CopperLbl:SetSize( 20, StartCtr:GetHeight() );
		CopperLbl:SetPosition( CopperIcon:GetLeft() - 18, 0 );
		CopperLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--CopperLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Silver icon & amount v**
		local SilverIcon = Turbine.UI.Control();
		SilverIcon:SetParent( StartCtr );
		SilverIcon:SetSize( 27, 21 );
		SilverIcon:SetPosition( CopperLbl:GetLeft() - 34, -2 );
		SilverIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		SilverIcon:SetBackground( 0x41007e7c ); -- in-game silver icon
		--SilverIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local SilverLbl = Turbine.UI.Label();
		SilverLbl:SetParent( StartCtr );
		--SilverLbl:SetForeColor( Color["white"] );
		SilverLbl:SetText( silver );
		SilverLbl:SetSize( 20, StartCtr:GetHeight() );
		SilverLbl:SetPosition( SilverIcon:GetLeft() - 18, 0 );
		SilverLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--SilverLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Gold icon & amount v**
		local GoldIcon = Turbine.UI.Control();
		GoldIcon:SetParent( StartCtr );
		GoldIcon:SetSize( 27, 21 );
		GoldIcon:SetPosition( SilverLbl:GetLeft() - 34, -2 );
		GoldIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		GoldIcon:SetBackground( 0x41007e7b ); -- in-game gold icon
		--GoldIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local GoldLbl = Turbine.UI.Label();
		GoldLbl:SetParent( StartCtr );
		--GoldLbl:SetForeColor( Color["white"] );
		GoldLbl:SetText( gold );
		GoldLbl:SetSize( 50, StartCtr:GetHeight() );
		GoldLbl:SetPosition( GoldIcon:GetLeft() - 48, 0 );
		GoldLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--GoldLbl:SetBackColor( Color["white"] ); -- Debug purpose

		MITTPosY = MITTPosY + 19;
		]]

		-- Earned Gold/Silver/Copper
		local EarnedCtr = Turbine.UI.Control();
		EarnedCtr:SetParent( _G.ToolTipWin );
		EarnedCtr:SetZOrder( 2 );
		EarnedCtr:SetPosition( LblStat:GetLeft(), MITTPosY );
		EarnedCtr:SetSize( MITTListBox:GetWidth(), 19 );
		EarnedCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		--EarnedCtr:SetBackColor( Color["red"] ); -- Debug purpose

		local lblEarned = Turbine.UI.Label();
		lblEarned:SetParent( EarnedCtr );
		lblEarned:SetPosition( 0, 0 );
		lblEarned:SetForeColor( Color["rustedgold"] );
		lblEarned:SetSize( LblStat:GetWidth(), EarnedCtr:GetHeight() );
		lblEarned:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		lblEarned:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		lblEarned:SetText( L["MIEarned"] );
		--lblStart:SetBackColor( Color["white"] ); -- Debug purpose

		--**v Copper icon & amount v**
		local CopperIcon = Turbine.UI.Control();
		CopperIcon:SetParent( EarnedCtr );
		CopperIcon:SetSize( 27, 21 );
		CopperIcon:SetPosition( TotMoneyCtr:GetWidth() - 30, -2 );
		CopperIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		CopperIcon:SetBackground( 0x41007e7d ); -- in-game copper icon
		--CopperIcon:SetBackColor( Color["blue"] ); -- Debug purpose

		DecryptMoney(walletStats[DOY][PN].Earned);

		local CopperLbl = Turbine.UI.Label();
		CopperLbl:SetParent( EarnedCtr );
		--CopperLbl:SetForeColor( Color["white"] );
		CopperLbl:SetText( copper );
		CopperLbl:SetSize( 20, EarnedCtr:GetHeight() );
		CopperLbl:SetPosition( CopperIcon:GetLeft() - 18, 0 );
		CopperLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--CopperLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Silver icon & amount v**
		local SilverIcon = Turbine.UI.Control();
		SilverIcon:SetParent( EarnedCtr );
		SilverIcon:SetSize( 27, 21 );
		SilverIcon:SetPosition( CopperLbl:GetLeft() - 34, -2 );
		SilverIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		SilverIcon:SetBackground( 0x41007e7c ); -- in-game silver icon
		--SilverIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local SilverLbl = Turbine.UI.Label();
		SilverLbl:SetParent( EarnedCtr );
		--SilverLbl:SetForeColor( Color["white"] );
		SilverLbl:SetText( silver );
		SilverLbl:SetSize( 20, EarnedCtr:GetHeight() );
		SilverLbl:SetPosition( SilverIcon:GetLeft() - 18, 0 );
		SilverLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--SilverLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Gold icon & amount v**
		local GoldIcon = Turbine.UI.Control();
		GoldIcon:SetParent( EarnedCtr );
		GoldIcon:SetSize( 27, 21 );
		GoldIcon:SetPosition( SilverLbl:GetLeft() - 34, -2 );
		GoldIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		GoldIcon:SetBackground( 0x41007e7b ); -- in-game gold icon
		--GoldIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local GoldLbl = Turbine.UI.Label();
		GoldLbl:SetParent( EarnedCtr );
		--GoldLbl:SetForeColor( Color["white"] );
		GoldLbl:SetText( gold );
		GoldLbl:SetSize( 50, EarnedCtr:GetHeight() );
		GoldLbl:SetPosition( GoldIcon:GetLeft() - 48, 0 );
		GoldLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--GoldLbl:SetBackColor( Color["white"] ); -- Debug purpose
		MITTPosY = MITTPosY + 19;


		-- Spent Gold/Silver/Copper
		local SpentCtr = Turbine.UI.Control();
		SpentCtr:SetParent( _G.ToolTipWin );
		SpentCtr:SetZOrder( 2 );
		SpentCtr:SetPosition( EarnedCtr:GetLeft(), MITTPosY );
		SpentCtr:SetSize( MITTListBox:GetWidth(), 19 );
		SpentCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		--SpentCtr:SetBackColor( Color["red"] ); -- Debug purpose

		local lblSpent = Turbine.UI.Label();
		lblSpent:SetParent( SpentCtr );
		lblSpent:SetPosition( 0, 0 );
		lblSpent:SetForeColor( Color["rustedgold"] );
		lblSpent:SetSize( LblStat:GetWidth(), SpentCtr:GetHeight() );
		lblSpent:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		lblSpent:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		lblSpent:SetText( L["MISpent"] );
		--lblStart:SetBackColor( Color["white"] ); -- Debug purpose

		--**v Copper icon & amount v**
		local CopperIcon = Turbine.UI.Control();
		CopperIcon:SetParent( SpentCtr );
		CopperIcon:SetSize( 27, 21 );
		CopperIcon:SetPosition( TotMoneyCtr:GetWidth() - 30, -2 );
		CopperIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		CopperIcon:SetBackground( 0x41007e7d ); -- in-game copper icon
		--CopperIcon:SetBackColor( Color["blue"] ); -- Debug purpose

		DecryptMoney(walletStats[DOY][PN].Spent);

		local CopperLbl = Turbine.UI.Label();
		CopperLbl:SetParent( SpentCtr );
		--CopperLbl:SetForeColor( Color["white"] );
		CopperLbl:SetText( copper );
		CopperLbl:SetSize( 20, SpentCtr:GetHeight() );
		CopperLbl:SetPosition( CopperIcon:GetLeft() - 18, 0 );
		CopperLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--CopperLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Silver icon & amount v**
		local SilverIcon = Turbine.UI.Control();
		SilverIcon:SetParent( SpentCtr );
		SilverIcon:SetSize( 27, 21 );
		SilverIcon:SetPosition( CopperLbl:GetLeft() - 34, -2 );
		SilverIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		SilverIcon:SetBackground( 0x41007e7c ); -- in-game silver icon
		--SilverIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local SilverLbl = Turbine.UI.Label();
		SilverLbl:SetParent( SpentCtr );
		--SilverLbl:SetForeColor( Color["white"] );
		SilverLbl:SetText( silver );
		SilverLbl:SetSize( 20, SpentCtr:GetHeight() );
		SilverLbl:SetPosition( SilverIcon:GetLeft() - 18, 0 );
		SilverLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--SilverLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Gold icon & amount v**
		local GoldIcon = Turbine.UI.Control();
		GoldIcon:SetParent( SpentCtr );
		GoldIcon:SetSize( 27, 21 );
		GoldIcon:SetPosition( SilverLbl:GetLeft() - 34, -2 );
		GoldIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		GoldIcon:SetBackground( 0x41007e7b ); -- in-game gold icon
		--GoldIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local GoldLbl = Turbine.UI.Label();
		GoldLbl:SetParent( SpentCtr );
		--GoldLbl:SetForeColor( Color["white"] );
		GoldLbl:SetText( gold );
		GoldLbl:SetSize( 50, SpentCtr:GetHeight() );
		GoldLbl:SetPosition( GoldIcon:GetLeft() - 48, 0 );
		GoldLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--GoldLbl:SetBackColor( Color["white"] ); -- Debug purpose
		MITTPosY = MITTPosY + 19;


		-- Session Summary (Earned - Spent)
		local SumSSCtr = Turbine.UI.Control();
		SumSSCtr:SetParent( _G.ToolTipWin );
		SumSSCtr:SetZOrder( 2 );
		SumSSCtr:SetPosition( SpentCtr:GetLeft(), MITTPosY );
		SumSSCtr:SetSize( MITTListBox:GetWidth(), 19 );
		SumSSCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		--SumSSCtr:SetBackColor( Color["red"] ); -- Debug purpose

		local lblSum = Turbine.UI.Label();
		lblSum:SetParent( SumSSCtr );
		lblSum:SetPosition( 0, 0 );
		lblSum:SetForeColor( Color["rustedgold"] );
		lblSum:SetSize( LblStat:GetWidth(), SumSSCtr:GetHeight() );
		lblSum:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		lblSum:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		lblSum:SetText( L["MIWTotal"] );
		--lblSum:SetBackColor( Color["white"] ); -- Debug purpose

		--**v Copper icon & amount v**
		local CopperIcon = Turbine.UI.Control();
		CopperIcon:SetParent( SumSSCtr );
		CopperIcon:SetSize( 27, 21 );
		CopperIcon:SetPosition( TotMoneyCtr:GetWidth() - 30, -2 );
		CopperIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		CopperIcon:SetBackground( 0x41007e7d ); -- in-game copper icon
		--CopperIcon:SetBackColor( Color["blue"] ); -- Debug purpose

		DecryptMoney(walletStats[DOY][PN].SumSS);

		local CopperLbl = Turbine.UI.Label();
		CopperLbl:SetParent( SumSSCtr );
		--CopperLbl:SetForeColor( Color["white"] );
		CopperLbl:SetText( copper );
		CopperLbl:SetSize( 20, SumSSCtr:GetHeight() );
		CopperLbl:SetPosition( CopperIcon:GetLeft() - 18, 0 );
		CopperLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		CopperLbl:SetForeColor( Color["white"] );
		if not bSumSSS then CopperLbl:SetForeColor( Color["red"] ); end
		--CopperLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Silver icon & amount v**
		local SilverIcon = Turbine.UI.Control();
		SilverIcon:SetParent( SumSSCtr );
		SilverIcon:SetSize( 27, 21 );
		SilverIcon:SetPosition( CopperLbl:GetLeft() - 34, -2 );
		SilverIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		SilverIcon:SetBackground( 0x41007e7c ); -- in-game silver icon
		--SilverIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local SilverLbl = Turbine.UI.Label();
		SilverLbl:SetParent( SumSSCtr );
		--SilverLbl:SetForeColor( Color["white"] );
		SilverLbl:SetText( silver );
		SilverLbl:SetSize( 20, SumSSCtr:GetHeight() );
		SilverLbl:SetPosition( SilverIcon:GetLeft() - 18, 0 );
		SilverLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		SilverLbl:SetForeColor( Color["white"] );
		if not bSumSSS then SilverLbl:SetForeColor( Color["red"] ); end
		--SilverLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Gold icon & amount v**
		local GoldIcon = Turbine.UI.Control();
		GoldIcon:SetParent( SumSSCtr );
		GoldIcon:SetSize( 27, 21 );
		GoldIcon:SetPosition( SilverLbl:GetLeft() - 34, -2 );
		GoldIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		GoldIcon:SetBackground( 0x41007e7b ); -- in-game gold icon
		--GoldIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local GoldLbl = Turbine.UI.Label();
		GoldLbl:SetParent( SumSSCtr );
		--GoldLbl:SetForeColor( Color["white"] );
		GoldLbl:SetText( gold );
		GoldLbl:SetSize( 50, SumSSCtr:GetHeight() );
		GoldLbl:SetPosition( GoldIcon:GetLeft() - 48, 0 );
		GoldLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		GoldLbl:SetForeColor( Color["white"] );
		if not bSumSSS then GoldLbl:SetForeColor( Color["red"] ); end
		--GoldLbl:SetBackColor( Color["white"] ); -- Debug purpose
	end
	

	if _G.STS then --Show today statistics if true
		MITTPosY = MITTPosY + 25;
		local LblStat = Turbine.UI.Label();
		LblStat:SetParent( _G.ToolTipWin );
		LblStat:SetZOrder( 2 );
		LblStat:SetPosition( MITTListBox:GetLeft(), MITTPosY );
		LblStat:SetForeColor( Color["rustedgold"] );
		LblStat:SetSize( 140, 19 );
		LblStat:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		LblStat:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		LblStat:SetText( L["MIDaily"] .. " " .. L["Stats"] );
		if TBLocale == "fr" then LblStat:SetText( L["Stats"] .. " " .. L["MIDaily"] ); end
		--LblStat:SetBackColor( Color["white"] ); -- Debug purpose
		MITTPosY = MITTPosY + 19;

		local StatsSeparator = Turbine.UI.Control();
		StatsSeparator:SetParent( _G.ToolTipWin );
		StatsSeparator:SetZOrder( 2 );
		StatsSeparator:SetSize( LblStat:GetWidth(), 1 );
		StatsSeparator:SetPosition( LblStat:GetLeft(), MITTPosY );
		StatsSeparator:SetBackColor( Color["trueblue"] );
		MITTPosY = MITTPosY + 2;

		local TotEarnedCtr = Turbine.UI.Control();
		TotEarnedCtr:SetParent( _G.ToolTipWin );
		TotEarnedCtr:SetZOrder( 2 );
		TotEarnedCtr:SetPosition( StatsSeparator:GetLeft(), MITTPosY );
		TotEarnedCtr:SetSize( MITTListBox:GetWidth(), 19 );
		TotEarnedCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		--TotEarnedCtr:SetBackColor( Color["red"] ); -- Debug purpose

		local lblSpent = Turbine.UI.Label();
		lblSpent:SetParent( TotEarnedCtr );
		lblSpent:SetPosition( 0, 0 );
		lblSpent:SetForeColor( Color["rustedgold"] );
		lblSpent:SetSize( LblStat:GetWidth(), TotEarnedCtr:GetHeight() );
		lblSpent:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		lblSpent:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		lblSpent:SetText( L["MIEarned"] );
		--lblStart:SetBackColor( Color["white"] ); -- Debug purpose

		--**v Copper icon & amount v**
		local CopperIcon = Turbine.UI.Control();
		CopperIcon:SetParent( TotEarnedCtr );
		CopperIcon:SetSize( 27, 21 );
		CopperIcon:SetPosition( TotMoneyCtr:GetWidth() - 30, -2 );
		CopperIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		CopperIcon:SetBackground( 0x41007e7d ); -- in-game copper icon
		--CopperIcon:SetBackColor( Color["blue"] ); -- Debug purpose
		
		DecryptMoney(totem);
		
		local CopperLbl = Turbine.UI.Label();
		CopperLbl:SetParent( TotEarnedCtr );
		--CopperLbl:SetForeColor( Color["white"] );
		CopperLbl:SetText( copper );
		CopperLbl:SetSize( 20, TotEarnedCtr:GetHeight() );
		CopperLbl:SetPosition( CopperIcon:GetLeft() - 18, 0 );
		CopperLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--CopperLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Silver icon & amount v**
		local SilverIcon = Turbine.UI.Control();
		SilverIcon:SetParent( TotEarnedCtr );
		SilverIcon:SetSize( 27, 21 );
		SilverIcon:SetPosition( CopperLbl:GetLeft() - 34, -2 );
		SilverIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		SilverIcon:SetBackground( 0x41007e7c ); -- in-game silver icon
		--SilverIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local SilverLbl = Turbine.UI.Label();
		SilverLbl:SetParent( TotEarnedCtr );
		--SilverLbl:SetForeColor( Color["white"] );
		SilverLbl:SetText( silver );
		SilverLbl:SetSize( 20, TotEarnedCtr:GetHeight() );
		SilverLbl:SetPosition( SilverIcon:GetLeft() - 18, 0 );
		SilverLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--SilverLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Gold icon & amount v**
		local GoldIcon = Turbine.UI.Control();
		GoldIcon:SetParent( TotEarnedCtr );
		GoldIcon:SetSize( 27, 21 );
		GoldIcon:SetPosition( SilverLbl:GetLeft() - 34, -2 );
		GoldIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		GoldIcon:SetBackground( 0x41007e7b ); -- in-game gold icon
		--GoldIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local GoldLbl = Turbine.UI.Label();
		GoldLbl:SetParent( TotEarnedCtr );
		--GoldLbl:SetForeColor( Color["white"] );
		GoldLbl:SetText( gold );
		GoldLbl:SetSize( 50, TotEarnedCtr:GetHeight() );
		GoldLbl:SetPosition( GoldIcon:GetLeft() - 48, 0 );
		GoldLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--GoldLbl:SetBackColor( Color["white"] ); -- Debug purpose
		MITTPosY = MITTPosY + 19;
		
		DecryptMoney(totsm);

		local TotSpentCtr = Turbine.UI.Control();
		TotSpentCtr:SetParent( _G.ToolTipWin );
		TotSpentCtr:SetZOrder( 2 );
		TotSpentCtr:SetPosition( TotEarnedCtr:GetLeft(), MITTPosY );
		TotSpentCtr:SetSize( MITTListBox:GetWidth(), 19 );
		TotSpentCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		--TotSpentCtr:SetBackColor( Color["red"] ); -- Debug purpose

		local lblSpent = Turbine.UI.Label();
		lblSpent:SetParent( TotSpentCtr );
		lblSpent:SetPosition( 0, 0 );
		lblSpent:SetForeColor( Color["rustedgold"] );
		lblSpent:SetSize( LblStat:GetWidth(), TotSpentCtr:GetHeight() );
		lblSpent:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
		lblSpent:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		lblSpent:SetText( L["MISpent"] );
		--lblStart:SetBackColor( Color["white"] ); -- Debug purpose

		--**v Copper icon & amount v**
		local CopperIcon = Turbine.UI.Control();
		CopperIcon:SetParent( TotSpentCtr );
		CopperIcon:SetSize( 27, 21 );
		CopperIcon:SetPosition( TotMoneyCtr:GetWidth() - 30, -2 );
		CopperIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		CopperIcon:SetBackground( 0x41007e7d ); -- in-game copper icon
		--CopperIcon:SetBackColor( Color["blue"] ); -- Debug purpose
	
		local CopperLbl = Turbine.UI.Label();
		CopperLbl:SetParent( TotSpentCtr );
		--CopperLbl:SetForeColor( Color["white"] );
		CopperLbl:SetText( copper );
		CopperLbl:SetSize( 20, TotSpentCtr:GetHeight() );
		CopperLbl:SetPosition( CopperIcon:GetLeft() - 18, 0 );
		CopperLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--CopperLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Silver icon & amount v**
		local SilverIcon = Turbine.UI.Control();
		SilverIcon:SetParent( TotSpentCtr );
		SilverIcon:SetSize( 27, 21 );
		SilverIcon:SetPosition( CopperLbl:GetLeft() - 34, -2 );
		SilverIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		SilverIcon:SetBackground( 0x41007e7c ); -- in-game silver icon
		--SilverIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local SilverLbl = Turbine.UI.Label();
		SilverLbl:SetParent( TotSpentCtr );
		--SilverLbl:SetForeColor( Color["white"] );
		SilverLbl:SetText( silver );
		SilverLbl:SetSize( 20, TotSpentCtr:GetHeight() );
		SilverLbl:SetPosition( SilverIcon:GetLeft() - 18, 0 );
		SilverLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--SilverLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Gold icon & amount v**
		local GoldIcon = Turbine.UI.Control();
		GoldIcon:SetParent( TotSpentCtr );
		GoldIcon:SetSize( 27, 21 );
		GoldIcon:SetPosition( SilverLbl:GetLeft() - 34, -2 );
		GoldIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		GoldIcon:SetBackground( 0x41007e7b ); -- in-game gold icon
		--GoldIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local GoldLbl = Turbine.UI.Label();
		GoldLbl:SetParent( TotSpentCtr );
		--GoldLbl:SetForeColor( Color["white"] );
		GoldLbl:SetText( gold );
		GoldLbl:SetSize( 50, TotSpentCtr:GetHeight() );
		GoldLbl:SetPosition( GoldIcon:GetLeft() - 48, 0 );
		GoldLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		--GoldLbl:SetBackColor( Color["white"] ); -- Debug purpose
		MITTPosY = MITTPosY + 19;
		--**^


		-- Today Summary (Earned - Spent)
		local SumTSCtr = Turbine.UI.Control();
		SumTSCtr:SetParent( _G.ToolTipWin );
		SumTSCtr:SetZOrder( 2 );
		SumTSCtr:SetPosition( TotSpentCtr:GetLeft(), MITTPosY );
		SumTSCtr:SetSize( MITTListBox:GetWidth(), 19 );
		SumTSCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		--SumTSCtr:SetBackColor( Color["red"] ); -- Debug purpose

		local lblSum = Turbine.UI.Label();
		lblSum:SetParent( SumTSCtr );
		lblSum:SetPosition( 0, 0 );
		lblSum:SetForeColor( Color["rustedgold"] );
		lblSum:SetSize( LblStat:GetWidth(), SumTSCtr:GetHeight() );
		lblSum:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);

		lblSum:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		lblSum:SetText( L["MIWTotal"] );
		--lblSum:SetBackColor( Color["white"] ); -- Debug purpose

		--**v Copper icon & amount v**
		local CopperIcon = Turbine.UI.Control();
		CopperIcon:SetParent( SumTSCtr );
		CopperIcon:SetSize( 27, 21 );
		CopperIcon:SetPosition( TotMoneyCtr:GetWidth() - 30, -2 );
		CopperIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		CopperIcon:SetBackground( 0x41007e7d ); -- in-game copper icon
		--CopperIcon:SetBackColor( Color["blue"] ); -- Debug purpose

		DecryptMoney(walletStats[DOY][PN].SumTS);

		local CopperLbl = Turbine.UI.Label();
		CopperLbl:SetParent( SumTSCtr );
		--CopperLbl:SetForeColor( Color["white"] );
		CopperLbl:SetText( copper );
		CopperLbl:SetSize( 20, SumTSCtr:GetHeight() );
		CopperLbl:SetPosition( CopperIcon:GetLeft() - 18, 0 );
		CopperLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		CopperLbl:SetForeColor( Color["white"] );
		if not bSumSTS then CopperLbl:SetForeColor( Color["red"] ); end
		--CopperLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Silver icon & amount v**
		local SilverIcon = Turbine.UI.Control();
		SilverIcon:SetParent( SumTSCtr );
		SilverIcon:SetSize( 27, 21 );
		SilverIcon:SetPosition( CopperLbl:GetLeft() - 34, -2 );
		SilverIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		SilverIcon:SetBackground( 0x41007e7c ); -- in-game silver icon
		--SilverIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local SilverLbl = Turbine.UI.Label();
		SilverLbl:SetParent( SumTSCtr );
		--SilverLbl:SetForeColor( Color["white"] );
		SilverLbl:SetText( silver );
		SilverLbl:SetSize( 20, SumTSCtr:GetHeight() );
		SilverLbl:SetPosition( SilverIcon:GetLeft() - 18, 0 );
		SilverLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		SilverLbl:SetForeColor( Color["white"] );
		if not bSumSTS then SilverLbl:SetForeColor( Color["red"] ); end
		--SilverLbl:SetBackColor( Color["white"] ); -- Debug purpose
		--**^
		--**v Gold icon & amount v**
		local GoldIcon = Turbine.UI.Control();
		GoldIcon:SetParent( SumTSCtr );
		GoldIcon:SetSize( 27, 21 );
		GoldIcon:SetPosition( SilverLbl:GetLeft() - 34, -2 );
		GoldIcon:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
		GoldIcon:SetBackground( 0x41007e7b ); -- in-game gold icon
		--GoldIcon:SetBackColor( Color["blue"] ); -- Debug purpose
			
		local GoldLbl = Turbine.UI.Label();
		GoldLbl:SetParent( SumTSCtr );
		--GoldLbl:SetForeColor( Color["white"] );
		GoldLbl:SetText( gold );
		GoldLbl:SetSize( 50, SumTSCtr:GetHeight() );
		GoldLbl:SetPosition( GoldIcon:GetLeft() - 48, 0 );
		GoldLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		GoldLbl:SetForeColor( Color["white"] );
		if not bSumSTS then GoldLbl:SetForeColor( Color["red"] ); end
		--GoldLbl:SetBackColor( Color["white"] ); -- Debug purpose
	end

	_G.ToolTipWin:SetHeight( MITTPosY + 40);

	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
			
	if _G.ToolTipWin:GetWidth() + mouseX + 5 > screenWidth then x = _G.ToolTipWin:GetWidth() - 10;
	else x = -5; end
			
	if TBTop then y = -15;
	else y = _G.ToolTipWin:GetHeight() end

	_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
end

function MITTShowData(k)
	iFound = true;
	--**v Control of Gold/Silver/Copper currencies v**
	local MoneyCtr = Turbine.UI.Control();
	MoneyCtr:SetParent( MITTListBox );
	MoneyCtr:SetSize( MITTListBox:GetWidth(), 19 );
	MoneyCtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	--MoneyCtr:SetBackColor( Color["red"] ); -- Debug purpose
	--**^
	--**v Player name v**
	local lblName = Turbine.UI.Label();
	lblName:SetParent( MoneyCtr );
	--lblName:SetFont ( 12 );
	lblName:SetText( k );
	lblName:SetPosition( 5, 0 );
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
	CopperLbl:SetSize(20, MoneyCtr:GetHeight());
	CopperLbl:SetPosition( CopperIcon:GetLeft() - 18, 0 );
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
	SilverLbl:SetSize(20, MoneyCtr:GetHeight());
	SilverLbl:SetPosition( SilverIcon:GetLeft() - 18, 0 );
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
	GoldLbl:SetSize(50, MoneyCtr:GetHeight());
	GoldLbl:SetPosition( GoldIcon:GetLeft() - 48, 0 );
	GoldLbl:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	--GoldLbl:SetBackColor( Color["white"] ); -- Debug purpose
	--**^

	MITTListBox:AddItem( MoneyCtr );
	MITTPosY = MITTPosY + 19;
end