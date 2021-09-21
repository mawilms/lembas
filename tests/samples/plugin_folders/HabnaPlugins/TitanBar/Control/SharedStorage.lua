-- SharedStorage.lua
-- Written by Habna


_G.SS = {}; -- Infamy table in _G

--**v Vault Control v**
SS["Ctr"] = Turbine.UI.Control();
SS["Ctr"]:SetParent( TB["win"] );
SS["Ctr"]:SetMouseVisible( false );
SS["Ctr"]:SetZOrder( 2 );
SS["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
SS["Ctr"]:SetBackColor( Turbine.UI.Color( SSbcAlpha, SSbcRed, SSbcGreen, SSbcBlue ) );
--SS["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Vault icon on TitanBar v**
SS["Icon"] = Turbine.UI.Control();
SS["Icon"]:SetParent( SS["Ctr"] );
SS["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
SS["Icon"]:SetSize( 32, 32 );
SS["Icon"]:SetBackground( 0x41003830 );-- in-game icon 32x32
--SS["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

SS["Icon"].MouseMove = function( sender, args )
	SS["Icon"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveSSCtr(sender, args);
	else
		ShowToolTipWin( "SS" );
	end
end

SS["Icon"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

SS["Icon"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			if _G.frmSS then _G.frmSS = false; wSS:Close();
			else
				_G.frmSS = true;
				import (AppCtrD.."SharedStorageWindow");
				frmSharedStorage();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "SS";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

SS["Icon"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		SS["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

SS["Icon"].MouseUp = function( sender, args )
	SS["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.SSLocX = SS["Ctr"]:GetLeft();
	settings.SharedStorage.X = string.format("%.0f", _G.SSLocX);
	_G.IfLocY = SS["Ctr"]:GetTop();
	settings.SharedStorage.Y = string.format("%.0f", _G.SSLocY);
	SaveSettings( false );
end
--**^

function MoveSSCtr(sender, args)
	SS["Icon"].MouseLeave( sender, args );
	local CtrLocX = SS["Ctr"]:GetLeft();
	local CtrWidth = SS["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end

	local CtrLocY = SS["Ctr"]:GetTop();
	local CtrHeight = SS["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	SS["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end