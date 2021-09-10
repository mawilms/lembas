-- DestinyPoints.lua
-- Written by Habna


_G.CP = {}; -- Commendation table in _G

--**v Control of Commendation v**
CP["Ctr"] = Turbine.UI.Control();
CP["Ctr"]:SetParent( TB["win"] );
CP["Ctr"]:SetMouseVisible( false );
CP["Ctr"]:SetZOrder( 2 );
CP["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
CP["Ctr"]:SetBackColor( Turbine.UI.Color( CPbcAlpha, CPbcRed, CPbcGreen, CPbcBlue ) );
--CP["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Commendation & icon on TitanBar v**
CP["Icon"] = Turbine.UI.Control();
CP["Icon"]:SetParent( CP["Ctr"] );
--CP["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
CP["Icon"]:SetSize( 32, 32 );
CP["Icon"]:SetBackground( 0x41123495 );-- in-game icon 32x32
--CP["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

CP["Icon"].MouseMove = function( sender, args )
	CP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveCPCtr(sender, args); end
end

CP["Icon"].MouseLeave = function( sender, args )
	CP["Lbl"].MouseLeave( sender, args );
end

CP["Icon"].MouseClick = function( sender, args )
	CP["Lbl"].MouseClick( sender, args );
end

CP["Icon"].MouseDown = function( sender, args )
	CP["Lbl"].MouseDown( sender, args );
end

CP["Icon"].MouseUp = function( sender, args )
	CP["Lbl"].MouseUp( sender, args );
end


CP["Lbl"] = Turbine.UI.Label();
CP["Lbl"]:SetParent( CP["Ctr"] );
CP["Lbl"]:SetFont( _G.TBFont );
CP["Lbl"]:SetPosition( 0, 0 );
--CP["Lbl"]:SetForeColor( Color["white"] );
CP["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
CP["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--CP["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

CP["Lbl"].MouseMove = function( sender, args )
	CP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveCPCtr(sender, args);
	else
		ShowToolTipWin( "CP" );
	end
end

CP["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

CP["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "CP";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

CP["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		CP["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

CP["Lbl"].MouseUp = function( sender, args )
	CP["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.CPLocX = CP["Ctr"]:GetLeft();
	settings.Commendations.X = string.format("%.0f", _G.CPLocX);
	_G.CPLocY = CP["Ctr"]:GetTop();
	settings.Commendations.Y = string.format("%.0f", _G.CPLocY);
	SaveSettings( false );
end
--**^

function MoveCPCtr(sender, args)
	local CtrLocX = CP["Ctr"]:GetLeft();
	local CtrWidth = CP["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = CP["Ctr"]:GetTop();
	local CtrHeight = CP["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	CP["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end