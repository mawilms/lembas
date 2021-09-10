-- PlayerInfos.lua
-- Written by Habna


_G.PI = {}; -- Player Infos table in _G

--**v Control for player infos v**
PI["Ctr"] = Turbine.UI.Control();
PI["Ctr"]:SetParent( TB["win"] );
PI["Ctr"]:SetMouseVisible( false );
PI["Ctr"]:SetZOrder( 2 );
PI["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
PI["Ctr"]:SetBackColor( Turbine.UI.Color( PIbcAlpha, PIbcRed, PIbcGreen, PIbcBlue ) );
--PI["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Player icon & infos on TitanBar v**
PI["Icon"] = Turbine.UI.Control();
PI["Icon"]:SetParent( PI["Ctr"] );
PI["Icon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
PI["Icon"]:SetSize( 25, 25 );
--PI["Icon"]:SetBackground(  );-- need in-game icon 32x32
--PI["Icon"]:SetBackColor( Color["blue"] ); -- Debug purpose
	
PI["Icon"].MouseMove = function( sender, args )
	PI["Name"].MouseLeave( sender, args )
	TB["win"].MouseMove();
	if dragging then MovePICtr(sender, args); end
end

PI["Icon"].MouseLeave = function( sender, args )
	PI["Name"].MouseLeave( sender, args );
end

PI["Icon"].MouseClick = function( sender, args )
	PI["Name"].MouseClick( sender, args );
end

PI["Icon"].MouseLeave = function( sender, args )
	PI["Name"].MouseLeave( sender, args );
end

PI["Icon"].MouseClick = function( sender, args )
	PI["Name"].MouseClick( sender, args );
end

PI["Icon"].MouseDown = function( sender, args )
	PI["Name"].MouseDown( sender, args );
end

PI["Icon"].MouseUp = function( sender, args )
	PI["Name"].MouseUp( sender, args );
end


PI["Lvl"] = Turbine.UI.Label();
PI["Lvl"]:SetParent( PI["Ctr"] );
PI["Lvl"]:SetFont( _G.TBFont );
PI["Lvl"]:SetPosition( 0, 0 );
--PI["Lvl"]:SetForeColor( Color["white"] );
PI["Lvl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
PI["Lvl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
--PI["Lvl"]:SetBackColor( Color["orange"] ); -- Debug purpose
	
PI["Lvl"].MouseMove = function( sender, args )
	PI["Name"].MouseLeave( sender, args )
	TB["win"].MouseMove();
	if dragging then MovePICtr(sender, args); end
end

PI["Lvl"].MouseLeave = function( sender, args )
	PI["Name"].MouseLeave( sender, args );
end

PI["Lvl"].MouseClick = function( sender, args )
	PI["Name"].MouseClick( sender, args );
end

PI["Lvl"].MouseLeave = function( sender, args )
	PI["Name"].MouseLeave( sender, args );
end

PI["Lvl"].MouseClick = function( sender, args )
	PI["Name"].MouseClick( sender, args );
end

PI["Lvl"].MouseDown = function( sender, args )
	PI["Name"].MouseDown( sender, args );
end

PI["Lvl"].MouseUp = function( sender, args )
	PI["Name"].MouseUp( sender, args );
end

PI["Name"] = Turbine.UI.Label();
PI["Name"]:SetParent( PI["Ctr"] );
PI["Name"]:SetFont( _G.TBFont );
--PI["Name"]:SetForeColor( Color["white"] );
PI["Name"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
PI["Name"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
--PI["Name"]:SetBackColor( Color["white"] ); -- Debug purpose

PI["Name"].MouseMove = function( sender, args )
	--PI["Name"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MovePICtr(sender, args);
	else
		if not PITT then
			PITT = true;
			ShowPIWindow();
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

PI["Name"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	PITT = false;
end

PI["Name"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "PI";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

PI["Name"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		PI["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

PI["Name"].MouseUp = function( sender, args )
	PI["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.PILocX = PI["Ctr"]:GetLeft();
	settings.PlayerInfos.X = string.format("%.0f", _G.PILocX);
	_G.PILocY = PI["Ctr"]:GetTop();
	settings.PlayerInfos.Y = string.format("%.0f", _G.PILocY);
	SaveSettings( false );
end
--**^

function MovePICtr(sender, args)
	PI["Name"].MouseLeave( sender, args );
	local CtrLocX = PI["Ctr"]:GetLeft();
	local CtrWidth = PI["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = PI["Ctr"]:GetTop();
	local CtrHeight = PI["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	PI["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end