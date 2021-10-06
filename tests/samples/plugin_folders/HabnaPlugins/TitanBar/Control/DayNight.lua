-- DayNight.lua
-- Written by Habna


_G.DN = {}; -- Day & Night table in _G

--**v Control of Day & Night v**
DN["Ctr"] = Turbine.UI.Control();
DN["Ctr"]:SetParent( TB["win"] );
DN["Ctr"]:SetMouseVisible( false );
DN["Ctr"]:SetZOrder( 2 );
DN["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
DN["Ctr"]:SetBackColor( Turbine.UI.Color( DNbcAlpha, DNbcRed, DNbcGreen, DNbcBlue ) );
--DN["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Day & Night & icon on TitanBar v**
DN["Icon"] = Turbine.UI.Control();
DN["Icon"]:SetParent( DN["Ctr"] );
--DN["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
DN["Icon"]:SetSize( 16, 16 ); --need 32x32 icon
--DN["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

DN["Icon"].MouseMove = function( sender, args )
	DN["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveDNCtr(sender, args); end
end

DN["Icon"].MouseLeave = function( sender, args )
	DN["Lbl"].MouseLeave( sender, args );
end

DN["Icon"].MouseClick = function( sender, args )
	DN["Lbl"].MouseClick( sender, args );
end

DN["Icon"].MouseDown = function( sender, args )
	DN["Lbl"].MouseDown( sender, args );
end

DN["Icon"].MouseUp = function( sender, args )
	DN["Lbl"].MouseUp( sender, args );
end


DN["Lbl"] = Turbine.UI.Label();
DN["Lbl"]:SetParent( DN["Ctr"] );
DN["Lbl"]:SetFont( _G.TBFont );
DN["Lbl"]:SetPosition( 0, 0 );
--DN["Lbl"]:SetForeColor( Color["white"] );
DN["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
DN["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--DN["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

DN["Lbl"].MouseMove = function( sender, args )
	DN["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveDNCtr(sender, args);
	else
		ShowToolTipWin( "DN" );
	end
end

DN["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

DN["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			if _G.frmDN then _G.frmDN = false; wDN:Close();
			else
				_G.frmDN = true;
				import (AppCtrD.."DayNightWindow");
				frmDayNightWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "DN";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

DN["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		DN["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

DN["Lbl"].MouseUp = function( sender, args )
	DN["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.DNLocX = DN["Ctr"]:GetLeft();
	settings.DayNight.X = string.format("%.0f", _G.DNLocX);
	_G.DNLocY = DN["Ctr"]:GetTop();
	settings.DayNight.Y = string.format("%.0f", _G.DNLocY);
	SaveSettings( false );
end
--**^

function MoveDNCtr(sender, args)
	local CtrLocX = DN["Ctr"]:GetLeft();
	local CtrWidth = DN["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = DN["Ctr"]:GetTop();
	local CtrHeight = DN["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	DN["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end