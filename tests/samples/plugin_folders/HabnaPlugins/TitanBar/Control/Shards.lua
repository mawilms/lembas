-- Shards.lua
-- Written by Habna


_G.SP = {}; -- Shard table in _G

--**v Control of Shard v**
SP["Ctr"] = Turbine.UI.Control();
SP["Ctr"]:SetParent( TB["win"] );
SP["Ctr"]:SetMouseVisible( false );
SP["Ctr"]:SetZOrder( 2 );
SP["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
SP["Ctr"]:SetBackColor( Turbine.UI.Color( SPbcAlpha, SPbcRed, SPbcGreen, SPbcBlue ) );
--SP["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Shard & icon on TitanBar v**
SP["Icon"] = Turbine.UI.Control();
SP["Icon"]:SetParent( SP["Ctr"] );
SP["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
SP["Icon"]:SetSize( 32, 32 );
SP["Icon"]:SetBackground( 0x41110d5b );-- in-game icon 32x32
--SP["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

SP["Icon"].MouseMove = function( sender, args )
	SP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveSPCtr(sender, args); end
end

SP["Icon"].MouseLeave = function( sender, args )
	SP["Lbl"].MouseLeave( sender, args );
end

SP["Icon"].MouseClick = function( sender, args )
	SP["Lbl"].MouseClick( sender, args );
end

SP["Icon"].MouseDown = function( sender, args )
	SP["Lbl"].MouseDown( sender, args );
end

SP["Icon"].MouseUp = function( sender, args )
	SP["Lbl"].MouseUp( sender, args );
end


SP["Lbl"] = Turbine.UI.Label();
SP["Lbl"]:SetParent( SP["Ctr"] );
SP["Lbl"]:SetPosition( 0, 0 );
SP["Lbl"]:SetFont( _G.TBFont );
--SP["Lbl"]:SetForeColor( Color["white"] );
SP["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
SP["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--SP["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

SP["Lbl"].MouseMove = function( sender, args )
	SP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveSPCtr(sender, args);
	else
		ShowToolTipWin( "SP" );
	end
end

SP["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

SP["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "SP";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

SP["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		SP["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

SP["Lbl"].MouseUp = function( sender, args )
	SP["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.SPLocX = SP["Ctr"]:GetLeft();
	settings.Shards.X = string.format("%.0f", _G.SPLocX);
	_G.SPLocY = SP["Ctr"]:GetTop();
	settings.Shards.Y = string.format("%.0f", _G.SPLocY);
	SaveSettings( false );
end
--**^

function MoveSPCtr(sender, args)
	local CtrLocX = SP["Ctr"]:GetLeft();
	local CtrWidth = SP["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end

	local CtrLocY = SP["Ctr"]:GetTop();
	local CtrHeight = SP["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	SP["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end