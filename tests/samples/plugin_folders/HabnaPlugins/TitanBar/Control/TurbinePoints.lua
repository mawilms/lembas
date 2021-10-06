-- TurbinePoints.lua
-- Written by Habna


_G.TP = {}; -- Destiny Points table in _G

--**v Control of Destiny points v**
TP["Ctr"] = Turbine.UI.Control();
TP["Ctr"]:SetParent( TB["win"] );
TP["Ctr"]:SetMouseVisible( false );
TP["Ctr"]:SetZOrder( 2 );
TP["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
TP["Ctr"]:SetBackColor( Turbine.UI.Color( TPbcAlpha, TPbcRed, TPbcGreen, TPbcBlue ) );
--TP["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Destiny points & icon on TitanBar v**
TP["Icon"] = Turbine.UI.Control();
TP["Icon"]:SetParent( TP["Ctr"] );
TP["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
TP["Icon"]:SetSize( 30, 32 );
TP["Icon"]:SetBackground( "HabnaPlugins/TitanBar/Resources/tp.tga" ); --nedd 32x32 in-game icon
--TP["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

TP["Icon"].MouseMove = function( sender, args )
	TP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveTPCtr(sender, args); end
end

TP["Icon"].MouseLeave = function( sender, args )
	TP["Lbl"].MouseLeave( sender, args );
end

TP["Icon"].MouseClick = function( sender, args )
	TP["Lbl"].MouseClick( sender, args );
end

TP["Icon"].MouseDown = function( sender, args )
	TP["Lbl"].MouseDown( sender, args );
end

TP["Icon"].MouseUp = function( sender, args )
	TP["Lbl"].MouseUp( sender, args );
end


TP["Lbl"] = Turbine.UI.Label();
TP["Lbl"]:SetParent( TP["Ctr"] );
TP["Lbl"]:SetFont( _G.TBFont );
TP["Lbl"]:SetPosition( 0, 0 );
--TP["Lbl"]:SetForeColor( Color["white"] );
TP["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
TP["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--TP["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

TP["Lbl"].MouseMove = function( sender, args )
	TP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveTPCtr(sender, args);
	else
		ShowToolTipWin( "TP" );
	end
end

TP["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

TP["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			if _G.frmTP then _G.frmTP = false; wTP:Close();
			else
				_G.frmTP = true;
				import (AppCtrD.."TurbinePointsWindow");
				frmTurbinePointsWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "TP";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

TP["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		TP["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

TP["Lbl"].MouseUp = function( sender, args )
	TP["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.TPLocX = TP["Ctr"]:GetLeft();
	settings.TurbinePoints.X = string.format("%.0f", _G.TPLocX);
	_G.TPLocY = TP["Ctr"]:GetTop();
	settings.TurbinePoints.Y = string.format("%.0f", _G.TPLocY);
	SaveSettings( false );
end
--**^

function MoveTPCtr(sender, args)
	local CtrLocX = TP["Ctr"]:GetLeft();
	local CtrWidth = TP["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = TP["Ctr"]:GetTop();
	local CtrHeight = TP["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	TP["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end