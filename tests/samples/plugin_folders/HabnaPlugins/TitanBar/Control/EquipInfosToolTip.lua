-- EquipInfosWindow.lua
-- Written by Habna


SlotsBG = {"0x41007eed", "0x41007ef6", "0x41007ef7", "0x41007eef", "0x41007eee", "0x41007ee9", "0x41007ef0", "0x41007ef9", "0x41007ef8",
		"0x41007ef4", "0x41007ef3", "0x41007ef2", "0x41007ef1", "0x41007ef5", "0x41007efa", "0x41007eea", "0x41007eeb", "0x41007eec",
		"0x41007efb", "0x410e8680"};

SlotsText = {L["EWST1"], L["EWST2"], L["EWST3"], L["EWST4"], L["EWST5"], L["EWST6"], L["EWST7"], L["EWST8"], L["EWST9"],
		L["EWST10"], L["EWST11"], L["EWST12"], L["EWST13"], L["EWST14"], L["EWST15"], L["EWST16"], L["EWST17"],	L["EWST18"],
		L["EWST19"], L["EWST20"]};

function ShowEIWindow()
	-- ( offsetX, offsetY, width, height, bubble side )
	local x, y, w, h, bblTo = -5, -15, 592, 495, "left";
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
	
	if w + mouseX > screenWidth then bblTo = "right"; x = w - 10; end
	if not TBTop then y = h; end
	
	_G.ToolTipWin = Turbine.UI.Window();
	_G.ToolTipWin:SetSize( w, h );
	_G.ToolTipWin:SetZOrder( 1 );
	--_G.ToolTipWin.xOffset = x;
	--_G.ToolTipWin.yOffset = y;
	_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
	_G.ToolTipWin:SetVisible( true );

	--**v Control of all equipment infos v**
	local AEICtr = Turbine.UI.Control();
	AEICtr:SetParent( _G.ToolTipWin );
	AEICtr:SetZOrder( 1 );
	AEICtr:SetSize( w, h );
	AEICtr:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
	--AEICtr:SetBackColor( Color["red"] ); -- Debug purpose
	--**^

	lblBackPack = Turbine.UI.Label();
	lblBackPack:SetParent( AEICtr );
	lblBackPack:SetText( L["EWLbl"] );
	lblBackPack:SetPosition( 15, 15);
	lblBackPack:SetSize( 350, 15 );
	lblBackPack:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
	lblBackPack:SetForeColor( Color["green"] );

	lblBackPackD = Turbine.UI.Label();
	lblBackPackD:SetParent( AEICtr );
	lblBackPackD:SetText( L["EWLblD"] );
	lblBackPackD:SetSize( 80, 15 );
	lblBackPackD:SetPosition( AEICtr:GetWidth() - lblBackPackD:GetWidth() - 20 , 15);
	lblBackPackD:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	lblBackPackD:SetForeColor( Color["green"] );

	ListBoxBorder = Turbine.UI.Control();
	ListBoxBorder:SetParent( AEICtr );
	ListBoxBorder:SetPosition( lblBackPack:GetLeft(), lblBackPack:GetTop() + lblBackPack:GetHeight() + 2 );
	ListBoxBorder:SetSize( 562, 444 );
	ListBoxBorder:SetBackColor( Color["grey"] );
	ListBoxBorder:SetVisible( true );

	EIListBox = Turbine.UI.ListBox();
	EIListBox:SetParent( AEICtr );
	EIListBox:SetPosition( ListBoxBorder:GetLeft() + 2, ListBoxBorder:GetTop() + 2 );
	EIListBox:SetSize( ListBoxBorder:GetWidth() - 4, ListBoxBorder:GetHeight() - 4 );
	EIListBox:SetMaxItemsPerLine( 6 );
	EIListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	EIListBox:SetBackColor( Color["black"] );

	EIRefreshListBox();

	ApplySkin();
end

function EIRefreshListBox()
	local EIitemCtl = {};
	local EIitemLbl = {};
	local EIitemLblScore = {};
	local EIitemBG, EIitemU, EIitemS, EIitem = {}, {}, {}, {};
	EIListBox:ClearItems();
	
	for i = 1, 20 do
		-- Item background
		EIitemCtl[i] = Turbine.UI.Control();
		EIitemCtl[i]:SetSize( 44, 44 );
		EIitemCtl[i]:SetBackground( tonumber(SlotsBG[i]) );
		EIitemCtl[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		-- Item Background/Underlay/Shadow/Item
		EIitemBG[i] = Turbine.UI.Control();
		EIitemBG[i]:SetParent( EIitemCtl[i] );
		EIitemBG[i]:SetSize( 32, 32 );
		EIitemBG[i]:SetPosition( 6, 6 );
		EIitemBG[i]:SetBackground(itemEquip[i].BImgID);
		EIitemBG[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		
		EIitemU[i] = Turbine.UI.Control();
		EIitemU[i]:SetParent( EIitemCtl[i] );
		EIitemU[i]:SetSize( 32, 32 );
		EIitemU[i]:SetPosition( 6, 6 );
		EIitemU[i]:SetBackground(itemEquip[i].UImgID);
		EIitemU[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		EIitemS[i] = Turbine.UI.Control();
		EIitemS[i]:SetParent( EIitemCtl[i] );
		EIitemS[i]:SetSize( 32, 32 );
		EIitemS[i]:SetPosition( 6, 6 );
		EIitemS[i]:SetBackground(itemEquip[i].SImgID);
		EIitemS[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

		EIitem[i] = Turbine.UI.Control();
		EIitem[i]:SetParent( EIitemCtl[i] );
		EIitem[i]:SetSize( 32, 32 );
		EIitem[i]:SetPosition( 6, 6 );
		EIitem[i]:SetBackground(itemEquip[i].IImgID);
		EIitem[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		
		-- Item name
		EIitemLbl[i] = Turbine.UI.Label();
		EIitemLbl[i]:SetSize( 205, EIitemCtl[i]:GetHeight() );
		EIitemLbl[i]:SetFont(Turbine.UI.Lotro.Font.TrajanPro12 );
		EIitemLbl[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		--EIitemLbl[i]:SetForeColor( Color["white"] );
		
		if itemEquip[i].Item == false then 
			EIitemLbl[i]:SetForeColor( Color["red"] );
			EIitemLbl[i]:SetText( SlotsText[i] .. ":\n" .. L["EWItemNP"] );
		else
			EIitemLbl[i]:SetText( SlotsText[i] .. ":\n" .. itemEquip[i].Name );
		end

		-- Item Score
		EIitemLblScore[i] = Turbine.UI.Label();
		EIitemLblScore[i]:SetText( itemEquip[i].Score );
		EIitemLblScore[i]:SetSize( 30, EIitemCtl[i]:GetHeight() );
		EIitemLblScore[i]:SetFont( Turbine.UI.Lotro.Font.TrajanPro12 );
		EIitemLblScore[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
		
		-- Show item
		EIListBox:AddItem( EIitemCtl[i] );
		EIListBox:AddItem( EIitemLbl[i] );
		EIListBox:AddItem( EIitemLblScore[i] );
	end
end