-- EquipInfos.lua
-- Written by Habna


_G.EI = {}; -- Equipment Infos table in _G

--**v Control for equipment infos v**
EI["Ctr"] = Turbine.UI.Control();
EI["Ctr"]:SetParent( TB["win"] );
EI["Ctr"]:SetMouseVisible( false );
EI["Ctr"]:SetZOrder( 2 );
EI["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
EI["Ctr"]:SetBackColor( Turbine.UI.Color( EIbcAlpha, EIbcRed, EIbcGreen, EIbcBlue ) );
--EI["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Player icon & infos on TitanBar v**
EI["Icon"] = Turbine.UI.Control();
EI["Icon"]:SetParent( EI["Ctr"] );
EI["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
EI["Icon"]:SetSize( 32, 32 );
EI["Icon"]:SetBackground( 0x410f2ea5 );-- in-game icon 32x32
--EI["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

EI["Icon"].MouseMove = function( sender, args )
	EI["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveEICtr(sender, args); end
end

EI["Icon"].MouseLeave = function( sender, args )
	EI["Lbl"].MouseLeave( sender, args );
end

EI["Icon"].MouseClick = function( sender, args )
	EI["Lbl"].MouseClick( sender, args );
end

EI["Icon"].MouseDown = function( sender, args )
	EI["Lbl"].MouseDown( sender, args );
end

EI["Icon"].MouseUp = function( sender, args )
	EI["Lbl"].MouseUp( sender, args );
end


EI["Lbl"] = Turbine.UI.Label();
EI["Lbl"]:SetParent( EI["Ctr"] );
EI["Lbl"]:SetFont( _G.TBFont );
EI["Lbl"]:SetPosition( 0, 0 );
--EI["Lbl"]:SetForeColor( Color["white"] );
EI["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
EI["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--EI["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose
	
EI["Lbl"].MouseMove = function( sender, args )
	--EI["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveEICtr(sender, args);
	else
		if not EITT then
			EITT = true;
			ShowEIWindow();
		else
			local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
			
			if _G.ToolTipWin:GetWidth() + mouseX + 5 > screenWidth then x = _G.ToolTipWin:GetWidth() - 10;
			else x = -5; end
			
			if TBTop then y = -15;
			else y = _G.ToolTipWin:GetHeight() end

			_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
		end
	end
end

EI["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	EITT = false;
end

EI["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "EI";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

EI["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		EI["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

EI["Lbl"].MouseUp = function( sender, args )
	EI["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.EILocX = EI["Ctr"]:GetLeft();
	settings.EquipInfos.X = string.format("%.0f", _G.EILocX);
	_G.EILocY = EI["Ctr"]:GetTop();
	settings.EquipInfos.Y = string.format("%.0f", _G.EILocY);
	SaveSettings( false );
end
--**^

function MoveEICtr(sender, args)
	EI["Lbl"].MouseLeave( sender, args );
	local CtrLocX = EI["Ctr"]:GetLeft();
	local CtrWidth = EI["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = EI["Ctr"]:GetTop();
	local CtrHeight = EI["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	EI["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end