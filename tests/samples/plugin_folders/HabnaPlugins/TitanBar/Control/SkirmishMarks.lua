-- Skirmish Marks.lua
-- Written by Habna


_G.SM = {}; -- Shards table in _G

--**v Control of Destiny points v**
SM["Ctr"] = Turbine.UI.Control();
SM["Ctr"]:SetParent( TB["win"] );
SM["Ctr"]:SetMouseVisible( false );
SM["Ctr"]:SetZOrder( 2 );
SM["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
SM["Ctr"]:SetBackColor( Turbine.UI.Color( SMbcAlpha, SMbcRed, SMbcGreen, SMbcBlue ) );
--SM["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Destiny points & icon on TitanBar v**
SM["Icon"] = Turbine.UI.Control();
SM["Icon"]:SetParent( SM["Ctr"] );
SM["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
SM["Icon"]:SetSize( 32, 32 );
SM["Icon"]:SetBackground( 0x4111c446 );-- in-game icon 32x32
--SM["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

SM["Icon"].MouseMove = function( sender, args )
	SM["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveSMCtr(sender, args); end
end

SM["Icon"].MouseLeave = function( sender, args )
	SM["Lbl"].MouseLeave( sender, args );
end

SM["Icon"].MouseClick = function( sender, args )
	SM["Lbl"].MouseClick( sender, args );
end

SM["Icon"].MouseDown = function( sender, args )
	SM["Lbl"].MouseDown( sender, args );
end

SM["Icon"].MouseUp = function( sender, args )
	SM["Lbl"].MouseUp( sender, args );
end


SM["Lbl"] = Turbine.UI.Label();
SM["Lbl"]:SetParent( SM["Ctr"] );
SM["Lbl"]:SetFont( _G.TBFont );
SM["Lbl"]:SetPosition( 0, 0 );
--SM["Lbl"]:SetForeColor( Color["white"] );
SM["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
SM["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--SM["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

SM["Lbl"].MouseMove = function( sender, args )
	SM["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveSMCtr(sender, args);
	else
		ShowToolTipWin( "SM" );
	end
end

SM["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

SM["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "SM";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

SM["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		SM["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

SM["Lbl"].MouseUp = function( sender, args )
	SM["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.SMLocX = SM["Ctr"]:GetLeft();
	settings.SkirmishMarks.X = string.format("%.0f", _G.SMLocX);
	_G.SMLocY = SM["Ctr"]:GetTop();
	settings.SkirmishMarks.Y = string.format("%.0f", _G.SMLocY);
	SaveSettings( false );
end
--**^

function MoveSMCtr(sender, args)
	local CtrLocX = SM["Ctr"]:GetLeft();
	local CtrWidth = SM["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = SM["Ctr"]:GetTop();
	local CtrHeight = SM["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	SM["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end