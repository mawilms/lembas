-- InfamyToolTip.lua
-- written by Habna


function ShowIFWindow()
	-- ( offsetX, offsetY, width, height, bubble side )
	x, y, w, h = -5, -15, 0, 100;
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
	
	if w + mouseX > screenWidth then x = w - 10; end
	
	if not TBTop then y = h; end

	_G.ToolTipWin = Turbine.UI.Window();
	_G.ToolTipWin:SetZOrder( 1 );
	--_G.ToolTipWin.xOffset = x;
	--_G.ToolTipWin.yOffset = y;
	_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y );
	_G.ToolTipWin:SetVisible( true );

	RefreshIFToolTip();

	ApplySkin();
end

function RefreshIFToolTip()
	local labelRank = Turbine.UI.Label();
	labelRank:SetParent( _G.ToolTipWin );
	labelRank:SetText( L["IFCR"] );
	labelRank:SetPosition( 15, 12 );
	labelRank:SetSize( labelRank:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	labelRank:SetForeColor( Color["white"] );
	labelRank:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	labelRank:SetVisible( true );
	labelRank:SetZOrder( 2 );
	--labelRank:SetBackColor( Color["red"] ); -- debug purpose

	local lblRank = Turbine.UI.Label();
	lblRank:SetParent( _G.ToolTipWin );
	lblRank:SetText( settings.Infamy.K );
	lblRank:SetPosition( labelRank:GetLeft()+labelRank:GetWidth()+5, labelRank:GetTop() );
	lblRank:SetSize( lblRank:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	lblRank:SetForeColor( Color["green"] );
	lblRank:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	lblRank:SetVisible( true );
	lblRank:SetZOrder( 2 );
	--lblRank:SetBackColor( Color["red"] ); -- debug purpose

	local labelInfamy = Turbine.UI.Label();
	labelInfamy:SetParent( _G.ToolTipWin );
	labelInfamy:SetText( L["IFIF"] );
	labelInfamy:SetPosition( labelRank:GetLeft(), lblRank:GetTop()+lblRank:GetHeight()+5 );
	labelInfamy:SetSize( labelInfamy:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	labelInfamy:SetForeColor( Color["white"] );
	labelInfamy:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	labelInfamy:SetVisible( true );
	labelInfamy:SetZOrder( 2 );
	--labelInfamy:SetBackColor( Color["red"] ); -- debug purpose

	local lblInfamy = Turbine.UI.Label();
	lblInfamy:SetParent( _G.ToolTipWin );
	lblInfamy:SetText( settings.Infamy.P .. "/" .. InfamyRanks[tonumber(settings.Infamy.K)+1]);
	lblInfamy:SetPosition( labelInfamy:GetLeft()+labelInfamy:GetWidth()+5, labelInfamy:GetTop() );
	lblInfamy:SetSize( lblInfamy:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	lblInfamy:SetForeColor( Color["green"] );
	lblInfamy:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	lblInfamy:SetVisible( true );
	lblInfamy:SetZOrder( 2 );
	--lblInfamy:SetBackColor( Color["red"] ); -- debug purpose

	local NextRankCtr = Turbine.UI.Control();
	NextRankCtr:SetParent( _G.ToolTipWin );
	NextRankCtr:SetPosition( labelInfamy:GetLeft(), labelInfamy:GetTop()+labelInfamy:GetHeight()+5 )
	NextRankCtr:SetZOrder( 2 );
	--NextRankCtr:SetBackColor( Color["red"] ); -- debug purpose
	
	local lblNextRank = Turbine.UI.Label();
	lblNextRank:SetParent( NextRankCtr );
	lblNextRank:SetText( InfamyRanks[tonumber(settings.Infamy.K)+1] - settings.Infamy.P);
	lblNextRank:SetPosition( 0, 0 );
	lblNextRank:SetSize( lblNextRank:GetTextLength() * 7.5, 15 ); --Auto size with text lenght
	lblNextRank:SetForeColor( Color["green"] );
	lblNextRank:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	--lblNextRank:SetBackColor( Color["red"] ); -- debug purpose

	local labelTN = Turbine.UI.Label();
	labelTN:SetParent( NextRankCtr );
	labelTN:SetText( L["IFTN"] );
	labelTN:SetPosition( lblNextRank:GetLeft()+lblNextRank:GetWidth()+5, 0 );
	labelTN:SetSize( labelTN:GetTextLength() * 7.2, 15 ); --Auto size with text lenght
	labelTN:SetForeColor( Color["white"] );
	labelTN:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	--labelTN:SetBackColor( Color["red"] ); -- debug purpose

	NextRankCtr:SetSize( lblNextRank:GetWidth()+labelTN:GetWidth()+10, 15 );
	_G.ToolTipWin:SetSize( NextRankCtr:GetWidth()+40, h );

	local percentage_done = string.format("%.1f", tonumber(settings.Infamy.P) / InfamyRanks[tonumber(settings.Infamy.K)+1]*100);
	--percentage_done = string.format("%.1f", percentage_done);
	--percentage_done = 1; --debug purpose

	--**v Infamy progress bar v**		
	local IFPBCTr = Turbine.UI.Control();
	IFPBCTr:SetParent( _G.ToolTipWin );
	IFPBCTr:SetPosition( NextRankCtr:GetLeft(), NextRankCtr:GetTop()+NextRankCtr:GetHeight()+5 )
	IFPBCTr:SetSize( 200, 15 );
	IFPBCTr:SetZOrder( 2 );
	--IFPBCTr:SetBackColor( Color["red"] ); -- debug purpose
		
	local IFPBFill = Turbine.UI.Control();--Filling
	IFPBFill:SetParent( IFPBCTr );
	IFPBFill:SetPosition( 9, 3 );
	IFPBFill:SetSize( (183*percentage_done)/100, 9 );
	IFPBFill:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	IFPBFill:SetBackground( 0x41007df5 );
	-- pink: 0x41007df4
	-- white/grey: 0x41007df7
	-- white: 0x41007e14
	-- blue: 0x41007df5 -gradiant
	-- blue: 0x41000143 -dark
	-- blue: 0x41007e92 -bright
	-- yellow: 0x41007e93
	-- green: 0x41007df3
	-- freeps : 0x41007e25
	--IFPBFill:SetBackColor( Color["red"] ); -- debug purpose
		
	local IFPB = Turbine.UI.Control(); --Frame
	IFPB:SetParent( IFPBCTr );
	IFPB:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	IFPB:SetSize( 200, 15 );
	IFPB:SetBackground( 0x41007e94 );
	-- pourcentage bar: 0x41007e94
	--IFPB:SetBackColor( Color["red"] ); -- debug purpose

	local labelPC = Turbine.UI.Label();
	labelPC:SetParent( IFPBCTr );
	labelPC:SetText( percentage_done .. "%" );
	labelPC:SetPosition( 0, 2 );
	labelPC:SetSize( 200, 15 );
	labelPC:SetForeColor( Color["white"] );
	labelPC:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	--labelTN:SetBackColor( Color["red"] ); -- debug purpose
	--**^
end