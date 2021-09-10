-- DurabilityInfosToolTip.lua
-- Written by Habna


SlotsBG = {"0x41007eed", "0x41007ef6", "0x41007ef7", "0x41007eef", "0x41007eee", "0x41007ee9", "0x41007ef0", "0x41007ef9", "0x41007ef8",
		"0x41007ef4", "0x41007ef3", "0x41007ef2", "0x41007ef1", "0x41007ef5", "0x41007efa", "0x41007eea", "0x41007eeb", "0x41007eec",
		"0x41007efb", "0x410e8680"};

SlotsText = {L["EWST1"], L["EWST2"], L["EWST3"], L["EWST4"], L["EWST5"], L["EWST6"], L["EWST7"], L["EWST8"], L["EWST9"],
		L["EWST10"], L["EWST11"], L["EWST12"], L["EWST13"], L["EWST14"], L["EWST15"], L["EWST16"], L["EWST17"],	L["EWST18"],
		L["EWST19"], L["EWST20"]};

function ShowDIWindow()
	-- ( offsetX, offsetY, width, height, bubble side )
	--x, y, w, h = -5, -15, 0, 0;
	--mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
	
	--if w + mouseX > screenWidth then x = w - 10; end
	
	_G.ToolTipWin = Turbine.UI.Window();
	_G.ToolTipWin:SetZOrder( 1 );
	--_G.ToolTipWin.xOffset = x;
	--_G.ToolTipWin.yOffset = y;
	_G.ToolTipWin:SetVisible( true );
	
	DIListBox = Turbine.UI.ListBox();
	DIListBox:SetParent( _G.ToolTipWin );
	DIListBox:SetZOrder( 1 );
	DIListBox:SetPosition( 15, 12 );
	DIListBox:SetMaxItemsPerLine( 1 );
	DIListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	--DIListBox:SetBackColor( Color["darkgrey"] ); --debug purpose

	DIRefreshListBox();

	ApplySkin();
end

function DIRefreshListBox()
	local DIitemCtl = {};
	local Lblnint = {};
	local DIitemLbl = {};
	local DIitemLblScore = {};
	local DIitemBG, DIitemU, DIitemS, DIitem = {}, {}, {}, {};
	DIListBox:ClearItems();
	DITTPosY = 36;

	mis, mts, nint = 0, 0, false;

	if not DIIcon and not DIText then nint=true; end

	iFound = 0;

	for i = 1, #itemEquip do
		for k,v in pairs(itemEquip[i]) do
			if itemEquip[i].WearStatePts ~= 100 and itemEquip[i].WearState ~= 0 then
				iFound = iFound + 1; -- Count damaged item
				break
			end
		end
	end

	if iFound == 0 or nint then
		cw=250;
		local lblName = Turbine.UI.Label();
		lblName:SetParent( _G.ToolTipWin );
		--lblName:SetFont ( 12 );
		lblName:SetText( L["DWLblND"] );
		if iFound ~= 0 then
			if nint then
				if iFound == 1 then	lblName:SetText( "1 ".. L["DWLbl"].. "\n" .. L["DWnint"] );
				else lblName:SetText( iFound .. L["DWLbls"].. "\n" .. L["DWnint"] ); end
			cw=215;
			end
		end
		lblName:SetPosition( 0, 0 );
		lblName:SetSize( 210, 35 );
		lblName:SetForeColor( Color["green"] );
		lblName:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
		--lblName:SetBackColor( Color["red"] ); -- debug purpose

		DIListBox:SetWidth( 250 );
		DIListBox:AddItem( lblName );
		
		DITTPosY = DITTPosY + 36;
	else
		for i = 1, 20 do
			if itemEquip[i].WearStatePts ~= 100 and itemEquip[i].WearState ~= 0 then
				cw=32;
				iFound = iFound + 1;

				TheColor = Color["TurbineYellow"];
				if itemEquip[i].WearStatePts == "50" then TheColor = Color["orange"];
				elseif itemEquip[i].WearStatePts == "0" then TheColor = Color["red"]; end

				-- Item control
				DIitemCtl[i] = Turbine.UI.Control();
				DIitemCtl[i]:SetParent( DIListBox );
				--DIitemCtl[i]:SetSize( cw-mis-mts, 36 );
				DIitemCtl[i]:SetHeight( 36 );
				--DIitemCtl[i]:SetBackColor( Color["red"] ); -- debug purpose


				if DIIcon then
					-- Item Background/Underlay/Shadow/Item
					DIitemBG[i] = Turbine.UI.Control();
					DIitemBG[i]:SetParent( DIitemCtl[i] );
					DIitemBG[i]:SetSize( 32, 32 );
					DIitemBG[i]:SetPosition( 0, 2 );
					DIitemBG[i]:SetBackground(itemEquip[i].BImgID);
					DIitemBG[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		
					DIitemU[i] = Turbine.UI.Control();
					DIitemU[i]:SetParent( DIitemCtl[i] );
					DIitemU[i]:SetSize( 32, 32 );
					DIitemU[i]:SetPosition( 0, 2 );
					DIitemU[i]:SetBackground(itemEquip[i].UImgID);
					DIitemU[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

					DIitemS[i] = Turbine.UI.Control();
					DIitemS[i]:SetParent( DIitemCtl[i] );
					DIitemS[i]:SetSize( 32, 32 );
					DIitemS[i]:SetPosition( 0, 2 );
					DIitemS[i]:SetBackground(itemEquip[i].SImgID);
					DIitemS[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

					DIitem[i] = Turbine.UI.Control();
					DIitem[i]:SetParent( DIitemCtl[i] );
					DIitem[i]:SetSize( 32, 32 );
					DIitem[i]:SetPosition( 0, 2 );
					DIitem[i]:SetBackground(itemEquip[i].IImgID);
					DIitem[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );

					-- Item Durability (over the icon)
					DIitemLblScore[i] = Turbine.UI.Label();
					DIitemLblScore[i]:SetParent( DIitemCtl[i] );
					DIitemLblScore[i]:SetPosition( 0, 26 );
					DIitemLblScore[i]:SetSize( 30, 15 );
					DIitemLblScore[i]:SetText( itemEquip[i].WearStatePts .. "%" );
					DIitemLblScore[i]:SetForeColor( TheColor );
					DIitemLblScore[i]:SetFont( Turbine.UI.Lotro.Font.Verdana10 );
					DIitemLblScore[i]:SetFontStyle( Turbine.UI.FontStyle.Outline );
					DIitemLblScore[i]:SetOutlineColor( Color["black"] );
					DIitemLblScore[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
					--DIitemLblScore[i]:SetBackColorBlendMode( Turbine.UI.BlendMode.Overlay );
				else
					mis=37;
				end

				if DIText then
					cw=cw+208;
					-- Item name
					DIitemLbl[i] = Turbine.UI.Label();
					DIitemLbl[i]:SetParent( DIitemCtl[i] );
					DIitemLbl[i]:SetPosition( 37-mis, 2 );
					DIitemLbl[i]:SetSize( 208, DIitemCtl[i]:GetHeight() );
					DIitemLbl[i]:SetFont(Turbine.UI.Lotro.Font.TrajanPro12 );
					DIitemLbl[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
					--DIitemLbl[i]:SetForeColor( Color["white"] );
					--DIitemLbl[i]:SetBackColor( Color["blue"] ); -- debug purpose
		
					if itemEquip[i].Item == false then 
						DIitemLbl[i]:SetForeColor( Color["red"] );
						DIitemLbl[i]:SetText( SlotsText[i] .. ":\n" .. L["EWItemNP"] );
					else
						DIitemLbl[i]:SetText( SlotsText[i] .. ":\n" .. itemEquip[i].Name );
					end
					DIitemLbl[i]:SetForeColor( TheColor );

					if not DIIcon then
						-- Item Durability
						DIitemLblScore[i] = Turbine.UI.Label();
						DIitemLblScore[i]:SetParent( DIitemCtl[i] );
						DIitemLblScore[i]:SetPosition( 250-mis, 0 );
						DIitemLblScore[i]:SetText( itemEquip[i].WearStatePts .. "%" );
						DIitemLblScore[i]:SetForeColor( TheColor );
						DIitemLblScore[i]:SetSize( 30, DIitemCtl[i]:GetHeight() );
						DIitemLblScore[i]:SetFont( Turbine.UI.Lotro.Font.TrajanPro12 );
						DIitemLblScore[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
						--DIitemLblScore[i]:SetBackColor( Color["grey"] ); -- debug purpose
					end
				end

				DIitemCtl[i]:SetWidth( cw );
				DIListBox:SetSize( cw, DITTPosY );

				DIListBox:AddItem( DIitemCtl[i] );
			
				DITTPosY = DITTPosY + 36;
			end
		end
	end

	if iFound == 0 then _G.ToolTipWin:SetSize( cw, DITTPosY-10 );
	else _G.ToolTipWin:SetSize( cw+30, DITTPosY-10 ); end

	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
			
	if _G.ToolTipWin:GetWidth() + mouseX + 5 > screenWidth then x = _G.ToolTipWin:GetWidth() - 10;
	else x = -5; end
			
	if TBTop then y = -15;
	else y = _G.ToolTipWin:GetHeight() end

	_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
end