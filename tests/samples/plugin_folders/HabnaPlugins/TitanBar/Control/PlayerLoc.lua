-- PlayerLoc.lua
-- Written by Habna


_G.PL = {}; -- Player Location table in _G

--**v Control for Player location v**
PL["Ctr"] = Turbine.UI.Control();
PL["Ctr"]:SetParent( TB["win"] );
PL["Ctr"]:SetMouseVisible( false );
PL["Ctr"]:SetZOrder( 2 );
PL["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
PL["Ctr"]:SetBackColor( Turbine.UI.Color( PLbcAlpha, PLbcRed, PLbcGreen, PLbcBlue ) );
--PL["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Player Icon & location on TitanBar v**
PL["Lbl"] = Turbine.UI.Label();
PL["Lbl"]:SetParent( PL["Ctr"] );
PL["Lbl"]:SetPosition( 0, 0 );
PL["Lbl"]:SetFont( _G.TBFont );
--PL["Lbl"]:SetForeColor( Color["white"] );
PL["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
PL["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
--PL["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

PL["Lbl"].MouseMove = function( sender, args )
	PL["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MovePLCtr(sender, args);
	else
		ShowToolTipWin( "PL" );
	end
end

PL["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

PL["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "PL";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

PL["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		PL["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

PL["Lbl"].MouseUp = function( sender, args )
	PL["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.PLLocX = PL["Ctr"]:GetLeft();
	settings.PlayerLoc.X = string.format("%.0f", _G.PLLocX);
	_G.PLLocY = PL["Ctr"]:GetTop();
	settings.PlayerLoc.Y = string.format("%.0f", _G.PLLocY);
	SaveSettings( false );
end
--**^

function MovePLCtr(sender, args)
	local CtrLocX = PL["Ctr"]:GetLeft();
	local CtrWidth = PL["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = PL["Ctr"]:GetTop();
	local CtrHeight = PL["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	PL["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end