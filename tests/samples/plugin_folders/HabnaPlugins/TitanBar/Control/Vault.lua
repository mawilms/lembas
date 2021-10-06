-- Vault.lua
-- Written by Habna


_G.VT = {}; -- Vault table in _G

--**v Vault Control v**
VT["Ctr"] = Turbine.UI.Control();
VT["Ctr"]:SetParent( TB["win"] );
VT["Ctr"]:SetMouseVisible( false );
VT["Ctr"]:SetZOrder( 2 );
VT["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
VT["Ctr"]:SetBackColor( Turbine.UI.Color( VTbcAlpha, VTbcRed, VTbcGreen, VTbcBlue ) );
--VT["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Vault icon on TitanBar v**
VT["Icon"] = Turbine.UI.Control();
VT["Icon"]:SetParent( VT["Ctr"] );
VT["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
VT["Icon"]:SetSize( 16, 16 );
VT["Icon"]:SetBackground( 0x41005e9e );-- in-game icon 16x16 (Need 32x32)
--VT["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

VT["Icon"].MouseMove = function( sender, args )
	VT["Icon"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveVTCtr(sender, args);
	else
		ShowToolTipWin( "VT" );
	end
end

VT["Icon"].MouseLeave = function( sender, args )
	ResetToolTipWin();
end

VT["Icon"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			if _G.frmVT then _G.frmVT = false; wVT:Close();
			else
				_G.frmVT = true;
				import (AppCtrD.."VaultWindow");
				frmVault();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "VT";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

VT["Icon"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		VT["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

VT["Icon"].MouseUp = function( sender, args )
	VT["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.VTLocX = VT["Ctr"]:GetLeft();
	settings.Vault.X = string.format("%.0f", _G.VTLocX);
	_G.VTLocY = VT["Ctr"]:GetTop();
	settings.Vault.Y = string.format("%.0f", _G.VTLocY);
	SaveSettings( false );
end
--**^

function MoveVTCtr(sender, args)
	VT["Icon"].MouseLeave( sender, args );
	local CtrLocX = VT["Ctr"]:GetLeft();
	local CtrWidth = VT["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end

	local CtrLocY = VT["Ctr"]:GetTop();
	local CtrHeight = VT["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	VT["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end