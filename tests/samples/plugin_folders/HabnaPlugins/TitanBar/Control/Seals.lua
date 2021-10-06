-- Seals.lua
-- Written by Habna


_G.SL = {}; -- Seals table in _G

--**v Control of Seals v**
SL["Ctr"] = Turbine.UI.Control();
SL["Ctr"]:SetParent( TB["win"] );
SL["Ctr"]:SetMouseVisible( false );
SL["Ctr"]:SetZOrder( 2 );
SL["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
SL["Ctr"]:SetBackColor( Turbine.UI.Color( SLbcAlpha, SLbcRed, SLbcGreen, SLbcBlue ) );
--SL["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Seals & icon on TitanBar v**
SL["Icon"] = Turbine.UI.Control();
SL["Icon"]:SetParent( SL["Ctr"] );
SL["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
SL["Icon"]:SetSize( 32, 32 );
SL["Icon"]:SetBackground( "HabnaPlugins/TitanBar/Resources/seal.tga" );-- need in-game icon 32x32
--SL["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

SL["Icon"].MouseMove = function( sender, args )
	SL["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveSLCtr(sender, args); end
end

SL["Icon"].MouseLeave = function( sender, args )
	SL["Lbl"].MouseLeave( sender, args );
end

SL["Icon"].MouseClick = function( sender, args )
	SL["Lbl"].MouseClick( sender, args );
end

SL["Icon"].MouseDown = function( sender, args )
	SL["Lbl"].MouseDown( sender, args );
end

SL["Icon"].MouseUp = function( sender, args )
	SL["Lbl"].MouseUp( sender, args );
end


SL["Lbl"] = Turbine.UI.Label();
SL["Lbl"]:SetParent( SL["Ctr"] );
SL["Lbl"]:SetPosition( 0, 0 );
SL["Lbl"]:SetFont( _G.TBFont );
--SL["Lbl"]:SetForeColor( Color["white"] );
SL["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
SL["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--SL["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

SL["Lbl"].MouseMove = function( sender, args )
	SL["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveSLCtr(sender, args);
	else
		ShowToolTipWin( "SL" );
	end
end

SL["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

SL["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "SL";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

SL["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		SL["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

SL["Lbl"].MouseUp = function( sender, args )
	SL["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.SLLocX = SL["Ctr"]:GetLeft();
	settings.Seals.X = string.format("%.0f", _G.SLLocX);
	_G.SLLocY = SL["Ctr"]:GetTop();
	settings.Seals.Y = string.format("%.0f", _G.SLLocY);
	SaveSettings( false );
end
--**^

function MoveSLCtr(sender, args)
	local CtrLocX = SL["Ctr"]:GetLeft();
	local CtrWidth = SL["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = SL["Ctr"]:GetTop();
	local CtrHeight = SL["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	SL["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end