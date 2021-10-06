-- BagInfos.lua
-- Written by Habna


_G.BI = {}; -- Backpack Infos table in _G

--**v Control for backpack infos v**
BI["Ctr"] = Turbine.UI.Control();
BI["Ctr"]:SetParent( TB["win"] );
BI["Ctr"]:SetMouseVisible( false );
BI["Ctr"]:SetZOrder( 2 );
BI["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
BI["Ctr"]:SetBackColor( Turbine.UI.Color( BIbcAlpha, BIbcRed, BIbcGreen, BIbcBlue ) );
--BI["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Backpack infos & icon on TitanBar v**
BI["Icon"] = Turbine.UI.Control();
BI["Icon"]:SetParent( BI["Ctr"] );
BI["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
BI["Icon"]:SetSize( 24, 30 );
--BI["Icon"]:SetBackground( 0x41008113 );-- in-game icon 24x30
--BI["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

BI["Icon"].MouseMove = function( sender, args )
	BI["Lbl"].MouseLeave( sender, args )
	TB["win"].MouseMove();
	if dragging then MoveBICtr(sender, args); end
end

BI["Icon"].MouseLeave = function( sender, args )
	BI["Lbl"].MouseLeave( sender, args );
end

BI["Icon"].MouseClick = function( sender, args )
	BI["Lbl"].MouseClick( sender, args );
end

BI["Icon"].MouseDown = function( sender, args )
	BI["Lbl"].MouseDown( sender, args );
end

BI["Icon"].MouseUp = function( sender, args )
	BI["Lbl"].MouseUp( sender, args );
end


BI["Lbl"] = Turbine.UI.Label();
BI["Lbl"]:SetParent( BI["Ctr"] );
BI["Lbl"]:SetFont( _G.TBFont );
BI["Lbl"]:SetPosition( 0, 0 );
--BI["Lbl"]:SetForeColor( Color["white"] );
BI["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
BI["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--BI["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

BI["Lbl"].MouseMove = function( sender, args )
	BI["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveBICtr(sender, args);
	else
		ShowToolTipWin( "BI" );
	end
end

BI["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

BI["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			if _G.frmBI then _G.frmBI = false; wBI:Close();
			else
				_G.frmBI = true;
				import (AppCtrD.."BagInfosWindow");
				frmBagInfos();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "BI";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

BI["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		BI["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

BI["Lbl"].MouseUp = function( sender, args )
	BI["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.BILocX = BI["Ctr"]:GetLeft();
	settings.BagInfos.X = string.format("%.0f", _G.BILocX);
	_G.BILocY = BI["Ctr"]:GetTop();
	settings.BagInfos.Y = string.format("%.0f", _G.BILocY);
	SaveSettings( false );
end
--**^

function MoveBICtr(sender, args)
	BI["Lbl"].MouseLeave( sender, args );
	local CtrLocX = BI["Ctr"]:GetLeft();
	local CtrWidth = BI["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = BI["Ctr"]:GetTop();
	local CtrHeight = BI["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	BI["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end