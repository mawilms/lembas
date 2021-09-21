-- Medallions.lua
-- Written by Habna


_G.MP = {}; -- Shards table in _G

--**v Control of Destiny points v**
MP["Ctr"] = Turbine.UI.Control();
MP["Ctr"]:SetParent( TB["win"] );
MP["Ctr"]:SetMouseVisible( false );
MP["Ctr"]:SetZOrder( 2 );
MP["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
MP["Ctr"]:SetBackColor( Turbine.UI.Color( MPbcAlpha, MPbcRed, MPbcGreen, MPbcBlue ) );
--MP["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Destiny points & icon on TitanBar v**
MP["Icon"] = Turbine.UI.Control();
MP["Icon"]:SetParent( MP["Ctr"] );
MP["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
MP["Icon"]:SetSize( 32, 32 );
MP["Icon"]:SetBackground( 0x4111c43d );-- in-game icon 32x32
--MP["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

MP["Icon"].MouseMove = function( sender, args )
	MP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveMPCtr(sender, args); end
end

MP["Icon"].MouseLeave = function( sender, args )
	MP["Lbl"].MouseLeave( sender, args );
end

MP["Icon"].MouseClick = function( sender, args )
	MP["Lbl"].MouseClick( sender, args );
end

MP["Icon"].MouseDown = function( sender, args )
	MP["Lbl"].MouseDown( sender, args );
end

MP["Icon"].MouseUp = function( sender, args )
	MP["Lbl"].MouseUp( sender, args );
end


MP["Lbl"] = Turbine.UI.Label();
MP["Lbl"]:SetParent( MP["Ctr"] );
MP["Lbl"]:SetPosition( 0, 0 );
MP["Lbl"]:SetFont( _G.TBFont );
--MP["Lbl"]:SetForeColor( Color["white"] );
MP["Lbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MP["Lbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--MP["Lbl"]:SetBackColor( Color["white"] ); -- Debug purpose

MP["Lbl"].MouseMove = function( sender, args )
	MP["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveMPCtr(sender, args);
	else
		ShowToolTipWin( "MP" );
	end
end

MP["Lbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

MP["Lbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "MP";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

MP["Lbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		MP["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

MP["Lbl"].MouseUp = function( sender, args )
	MP["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.MPLocX = MP["Ctr"]:GetLeft();
	settings.Medallions.X = string.format("%.0f", _G.MPLocX);
	_G.MPLocY = MP["Ctr"]:GetTop();
	settings.Medallions.Y = string.format("%.0f", _G.MPLocY);
	SaveSettings( false );
end
--**^

function MoveMPCtr(sender, args)
	local CtrLocX = MP["Ctr"]:GetLeft();
	local CtrWidth = MP["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = MP["Ctr"]:GetTop();
	local CtrHeight = MP["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	MP["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end

-- 0x4111c43d (Medaillons) 32x32
-- 0x4110182c (Medaillons of moria) 32x32
-- 0x41101829 (Medaillons of Lothlrien) 32x32
-- 0x41101826 (Medaillon of Dol Guldur) 32x32