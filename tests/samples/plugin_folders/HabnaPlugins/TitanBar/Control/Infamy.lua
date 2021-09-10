-- Infamy.lua
-- Written by Habna


_G.IF = {}; -- Infamy table in _G

--**v Control of Infamy v**
IF["Ctr"] = Turbine.UI.Control();
IF["Ctr"]:SetParent( TB["win"] );
IF["Ctr"]:SetMouseVisible( false );
IF["Ctr"]:SetZOrder( 2 );
IF["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
IF["Ctr"]:SetBackColor( Turbine.UI.Color( IFbcAlpha, IFbcRed, IFbcGreen, IFbcBlue ) );
--IF["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Infamy & icon on TitanBar v**
IF["Icon"] = Turbine.UI.Control();
IF["Icon"]:SetParent( IF["Ctr"] );
IF["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
IF["Icon"]:SetSize( 32, 32 );
--IF["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose

IF["Icon"].MouseMove = function( sender, args )
	--IF["Lbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveIFCtr(sender, args);
	else
		if not IFTT then
			IFTT = true;
			ShowIFWindow();
		else
			local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
			
			if _G.ToolTipWin:GetWidth() + mouseX + 5 > screenWidth then x = _G.ToolTipWin:GetWidth() - 10;
			else x = -5; end
			
			if TBTop then y = -15;
			else y = _G.ToolTipWin:GetHeight() end

			_G.ToolTipWin:SetPosition( mouseX - x, mouseY - y);
		end
	end
end

IF["Icon"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	IFTT = false;
end

IF["Icon"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			if _G.frmIF then _G.frmIF = false; wIF:Close();
			else
				_G.frmIF = true;
				import (AppCtrD.."InfamyWindow");
				frmInfamyWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "IF";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

IF["Icon"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		IF["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

IF["Icon"].MouseUp = function( sender, args )
	IF["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.IFLocX = IF["Ctr"]:GetLeft();
	settings.Infamy.X = string.format("%.0f", _G.IFLocX);
	_G.IFLocY = IF["Ctr"]:GetTop();
	settings.Infamy.Y = string.format("%.0f", _G.IFLocY);
	SaveSettings( false );
end
--**^

function MoveIFCtr(sender, args)
	IF["Icon"].MouseLeave( sender, args );
	local CtrLocX = IF["Ctr"]:GetLeft();
	local CtrWidth = IF["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end

	local CtrLocY = IF["Ctr"]:GetTop();
	local CtrHeight = IF["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	IF["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end