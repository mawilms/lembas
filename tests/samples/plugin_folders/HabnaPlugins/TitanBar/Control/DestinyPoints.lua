-- DestinyPoints.lua
-- Written by Habna


_G.DP = {}; -- Destiny Points table in _G

--**v Control of Destiny points v**
DP["Ctr"] = Turbine.UI.Control();
DP["Ctr"]:SetParent( TB["win"] );
DP["Ctr"]:SetMouseVisible( false );
DP["Ctr"]:SetZOrder( 2 );
DP["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
DP["Ctr"]:SetBackColor( Turbine.UI.Color( DPbcAlpha, DPbcRed, DPbcGreen, DPbcBlue ) );
--DP["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Destiny points & icon on TitanBar v**
DP["Icon"] = Turbine.UI.Control();
DP["Icon"]:SetParent( DP["Ctr"] );
DP["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
DP["Icon"]:SetSize( 21, 22 );
DP["Icon"]:SetBackground( 0x4100a682 );-- in-game icon 21x22
--DP["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

DP["Icon"].MouseMove = function( sender, args )
	DP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveDPCtr(sender, args); end
end

DP["Icon"].MouseLeave = function( sender, args )
	DP["Lbl"].MouseLeave( sender, args );
end

DP["Icon"].MouseClick = function( sender, args )
	DP["Lbl"].MouseClick( sender, args );
end

DP["Icon"].MouseDown = function( sender, args )
	DP["Lbl"].MouseDown( sender, args );
end

DP["Icon"].MouseUp = function( sender, args )
	DP["Lbl"].MouseUp( sender, args );
end


DP["Lbl"] = Turbine.UI.Label();
DP["Lbl"]:SetParent( DP["Ctr"] );
DP["Lbl"]:SetFont( _G.TBFont );
DP["Lbl"]:SetPosition( 0, 0 );
--DP["Lbl"]:SetForeColor( Color["white"] );
DP["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
DP["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--DP["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

DP["Lbl"].MouseMove = function( sender, args )
	DP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveDPCtr(sender, args);
	else
		ShowToolTipWin( "DP" );
	end
end

DP["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

DP["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "DP";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

DP["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		DP["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

DP["Lbl"].MouseUp = function( sender, args )
	DP["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.DPLocX = DP["Ctr"]:GetLeft();
	settings.DestinyPoints.X = string.format("%.0f", _G.DPLocX);
	_G.DPLocY = DP["Ctr"]:GetTop();
	settings.DestinyPoints.Y = string.format("%.0f", _G.DPLocY);
	SaveSettings( false );
end
--**^

function MoveDPCtr(sender, args)
	local CtrLocX = DP["Ctr"]:GetLeft();
	local CtrWidth = DP["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = DP["Ctr"]:GetTop();
	local CtrHeight = DP["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	DP["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end