-- GameTime.lua
-- Written by Habna


_G.GT = {}; -- Game Time table in _G

--**v Control for Game time v**
GT["Ctr"] = Turbine.UI.Control();
GT["Ctr"]:SetParent( TB["win"] );
GT["Ctr"]:SetMouseVisible( false );
GT["Ctr"]:SetZOrder( 2 );
GT["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
GT["Ctr"]:SetBackColor( Turbine.UI.Color( GTbcAlpha, GTbcRed, GTbcGreen, GTbcBlue ) );
--GT["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Game time on TitanBar v**
GT["Lbl"] = Turbine.UI.Label();
GT["Lbl"]:SetParent( GT["Ctr"] );
GT["Lbl"]:SetPosition( 0, 0 );
GT["Lbl"]:SetFont( _G.TBFont );
--GT["Lbl"]:SetForeColor( Color["white"] );
GT["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
GT["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--GT["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

GT["Lbl"].MouseMove = function( sender, args )
	GT["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveGTCtr(sender, args);
	else
		ShowToolTipWin( "GT" );
	end
end

GT["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

GT["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			if _G.frmGT then _G.frmGT = false; wGT:Close();
			else
				_G.frmGT = true;
				import (AppCtrD.."GameTimeWindow");
				frmGameTimeWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "GT";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

GT["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		GT["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

GT["Lbl"].MouseUp = function( sender, args )
	GT["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.GTLocX = GT["Ctr"]:GetLeft();
	settings.GameTime.X = string.format("%.0f", _G.GTLocX);
	_G.GTLocY = GT["Ctr"]:GetTop();
	settings.GameTime.Y = string.format("%.0f", _G.GTLocY);
	SaveSettings( false );
end
--**^

function MoveGTCtr(sender, args)
	local CtrLocX = GT["Ctr"]:GetLeft();
	local CtrWidth = GT["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = GT["Ctr"]:GetTop();
	local CtrHeight = GT["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	GT["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end