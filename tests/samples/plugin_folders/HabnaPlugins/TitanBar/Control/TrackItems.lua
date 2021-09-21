-- TrackItems.lua
-- Written by Habna


_G.TI = {}; -- TrackItems table in _G

--**v TrackItems Control v**
TI["Ctr"] = Turbine.UI.Control();
TI["Ctr"]:SetParent( TB["win"] );
TI["Ctr"]:SetMouseVisible( false );
TI["Ctr"]:SetZOrder( 2 );
TI["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
TI["Ctr"]:SetBackColor( Turbine.UI.Color( TIbcAlpha, TIbcRed, TIbcGreen, TIbcBlue ) );
--TI["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v TrackItems icon on TitanBar v**
TI["Icon"] = Turbine.UI.Control();
TI["Icon"]:SetParent( TI["Ctr"] );
TI["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
TI["Icon"]:SetSize( 32, 32 );
TI["Icon"]:SetBackground( 0x410d42cc );-- in-game icon 32x32 (0x41005bd6 / 0x410d42cc)
--TI["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

TI["Icon"].MouseMove = function( sender, args )
	--TI["Icon"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveTICtr(sender, args);
	else
		if not TITT then
			TITT = true;
			ShowTIWindow();
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

TI["Icon"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	TITT = false;
end

TI["Icon"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			if _G.frmTI then _G.frmTI = false; wTI:Close();
			else
				_G.frmTI = true;
				import (AppCtrD.."TrackItemsWindow");
				frmTrackItemsWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "TI";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

TI["Icon"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		TI["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

TI["Icon"].MouseUp = function( sender, args )
	TI["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.TILocX = TI["Ctr"]:GetLeft();
	settings.TrackItems.X = string.format("%.0f", _G.TILocX);
	_G.TILocY = TI["Ctr"]:GetTop();
	settings.TrackItems.Y = string.format("%.0f", _G.TILocY);
	SaveSettings( false );
end
--**^

function MoveTICtr(sender, args)
	TI["Icon"].MouseLeave( sender, args );
	local CtrLocX = TI["Ctr"]:GetLeft();
	local CtrWidth = TI["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end

	local CtrLocY = TI["Ctr"]:GetTop();
	local CtrHeight = TI["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	TI["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end