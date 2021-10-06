-- MoneyInfos.lua
-- Written by Habna


_G.MI = {}; -- Money Infos table in _G

--**v Control of Gold/Silver/Copper currencies v**
MI["Ctr"] = Turbine.UI.Control();
MI["Ctr"]:SetParent( TB["win"] );
MI["Ctr"]:SetMouseVisible( false );
MI["Ctr"]:SetZOrder( 2 );
MI["Ctr"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
MI["Ctr"]:SetBackColor( Turbine.UI.Color( MIbcAlpha, MIbcRed, MIbcGreen, MIbcBlue ) );
--MI["Ctr"]:SetBackColor( Color["red"] ); -- Debug purpose
--**^
--**v Control of Gold currencies v**
MI["GCtr"] = Turbine.UI.Control();
MI["GCtr"]:SetParent( MI["Ctr"] );
MI["GCtr"]:SetMouseVisible( false );
--MI["GCtr"]:SetZOrder( 2 );
--MI["GCtr"]:SetBackColor( Color["blue"] ); -- Debug purpose
--**^
--**v Gold & total amount on TitanBar v**
MI["GLblT"] = Turbine.UI.Label();
MI["GLblT"]:SetParent( MI["GCtr"] );
MI["GLblT"]:SetPosition( 0, 0 );
MI["GLblT"]:SetFont( _G.TBFont );
--MI["GLblT"]:SetForeColor( Color["white"] );
MI["GLblT"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["GLblT"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["GLblT"]:SetBackColor( Color["white"] ); -- Debug purpose

MI["GLblT"].MouseMove = function( sender, args )
	MI["CLbl"].MouseMove( sender, args );
end

MI["GLblT"].MouseLeave = function( sender, args )
	MI["CLbl"].MouseLeave( sender, args );
end

MI["GLblT"].MouseClick = function( sender, args )
	MI["CLbl"].MouseClick( sender, args );
end

MI["GLblT"].MouseDown = function( sender, args )
	MI["CLbl"].MouseDown( sender, args );
end

MI["GLblT"].MouseUp = function( sender, args )
	MI["CLbl"].MouseUp( sender, args );
end
--**^
--**v Gold amount & icon on TitanBar v**
MI["GLbl"] = Turbine.UI.Label();
MI["GLbl"]:SetParent( MI["GCtr"] );
MI["GLbl"]:SetPosition( 0, 0 );
MI["GLbl"]:SetFont( _G.TBFont );
--MI["GLbl"]:SetForeColor( Color["white"] );
MI["GLbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["GLbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["GLbl"]:SetBackColor( Color["white"] ); -- Debug purpose

MI["GLbl"].MouseMove = function( sender, args )
	MI["CLbl"].MouseMove( sender, args );
end

MI["GLbl"].MouseLeave = function( sender, args )
	MI["CLbl"].MouseLeave( sender, args );
end

MI["GLbl"].MouseClick = function( sender, args )
	MI["CLbl"].MouseClick( sender, args );
end

MI["GLbl"].MouseDown = function( sender, args )
	MI["CLbl"].MouseDown( sender, args );
end

MI["GLbl"].MouseUp = function( sender, args )
	MI["CLbl"].MouseUp( sender, args );
end


MI["GIcon"] = Turbine.UI.Control();
MI["GIcon"]:SetParent( MI["GCtr"] );
--MI["GIcon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
MI["GIcon"]:SetSize( 27, 21 );
MI["GIcon"]:SetBackground( 0x41007e7b );-- in-game icon 27x21 (3 coins: 0x41004641 / 1 coin: 0x41007e7b) ( all 3 coins 16x16 - 1 of each: 0x41005e9e)
--MI["GIcon"]:SetBackColor( Color["blue"] ); -- Debug purpose

MI["GIcon"].MouseMove = function( sender, args )
	MI["CIcon"].MouseMove( sender, args );
end

MI["GIcon"].MouseLeave = function( sender, args )
	MI["CLbl"].MouseLeave( sender, args );
end

MI["GIcon"].MouseClick = function( sender, args )
	MI["CLbl"].MouseClick( sender, args );
end

MI["GIcon"].MouseDown = function( sender, args )
	MI["CLbl"].MouseDown( sender, args );
end

MI["GIcon"].MouseUp = function( sender, args )
	MI["CLbl"].MouseUp( sender, args );
end
--**^

--**v Control of Silver currencies v**
MI["SCtr"] = Turbine.UI.Control();
MI["SCtr"]:SetParent( MI["Ctr"] );
MI["SCtr"]:SetMouseVisible( false );
--MI["SCtr"]:SetZOrder( 2 );
--MI["SCtr"]:SetBackColor( Color["blue"] ); -- Debug purpose
--**^
--**v Silver & total amount on TitanBar v**
MI["SLblT"] = Turbine.UI.Label();
MI["SLblT"]:SetParent( MI["SCtr"] );
MI["SLblT"]:SetPosition( 0, 0 );
MI["SLblT"]:SetFont( _G.TBFont );
--MI["SLblT"]:SetForeColor( Color["white"] );
MI["SLblT"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["SLblT"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["SLblT"]:SetBackColor( Color["white"] ); -- Debug purpose

MI["SLblT"].MouseMove = function( sender, args )
	MI["CLbl"].MouseMove( sender, args );
end

MI["SLblT"].MouseLeave = function( sender, args )
	MI["CLbl"].MouseLeave( sender, args );
end

MI["SLblT"].MouseClick = function( sender, args )
	MI["CLbl"].MouseClick( sender, args );
end

MI["SLblT"].MouseDown = function( sender, args )
	MI["CLbl"].MouseDown( sender, args );
end

MI["SLblT"].MouseUp = function( sender, args )
	MI["CLbl"].MouseUp( sender, args );

end
--**^
--**v Silver amount & icon on TitanBar v**
MI["SLbl"] = Turbine.UI.Label();
MI["SLbl"]:SetParent( MI["SCtr"] );
MI["SLbl"]:SetPosition( 0, 0 );
MI["SLbl"]:SetFont( _G.TBFont );
--MI["SLbl"]:SetForeColor( Color["white"] );
--MI["SLbl"]:SetSize( 20, 30 );
MI["SLbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["SLbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["SLbl"]:SetBackColor( Color["white"] ); -- Debug purpose

MI["SLbl"].MouseMove = function( sender, args )
	MI["CLbl"].MouseMove( sender, args );
end

MI["SLbl"].MouseLeave = function( sender, args )
	MI["CLbl"].MouseLeave( sender, args );
end

MI["SLbl"].MouseClick = function( sender, args )
	MI["CLbl"].MouseClick( sender, args );
end

MI["SLbl"].MouseDown = function( sender, args )
	MI["CLbl"].MouseDown( sender, args );
end

MI["SLbl"].MouseUp = function( sender, args )
	MI["CLbl"].MouseUp( sender, args );

end


MI["SIcon"] = Turbine.UI.Control();
MI["SIcon"]:SetParent( MI["SCtr"] );
--MI["SIcon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
MI["SIcon"]:SetSize( 27, 21 );
MI["SIcon"]:SetBackground( 0x41007e7c );-- in-game icon 27x21 (3 coins: 0x41007e7e / 1 coin: 0x41007e7c)
--MI["SIcon"]:SetBackColor( Color["blue"] ); -- Debug purpose

MI["SIcon"].MouseMove = function( sender, args )
	MI["CIcon"].MouseMove( sender, args );
end

MI["SIcon"].MouseLeave = function( sender, args )
	MI["CLbl"].MouseLeave( sender, args );
end

MI["SIcon"].MouseClick = function( sender, args )
	MI["CLbl"].MouseClick( sender, args );
end

MI["SIcon"].MouseDown = function( sender, args )
	MI["CLbl"].MouseDown( sender, args );
end

MI["SIcon"].MouseUp = function( sender, args )
	MI["CLbl"].MouseUp( sender, args );
end
--**^

--**v Control of Copper currencies v**
MI["CCtr"] = Turbine.UI.Control();
MI["CCtr"]:SetParent( MI["Ctr"] );
MI["CCtr"]:SetMouseVisible( false );
--MI["CCtr"]:SetZOrder( 2 );
--MI["CCtr"]:SetBackColor( Color["blue"] ); -- Debug purpose
--**^
--**v Copper & total amount on TitanBar v**
MI["CLblT"] = Turbine.UI.Label();
MI["CLblT"]:SetParent( MI["CCtr"] );
MI["CLblT"]:SetPosition( 0, 0 );
MI["CLblT"]:SetFont( _G.TBFont );
--MI["CLblT"]:SetForeColor( Color["white"] );
MI["CLblT"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["CLblT"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["CLblT"]:SetBackColor( Color["white"] ); -- Debug purpose

MI["CLblT"].MouseMove = function( sender, args )
	MI["CLbl"].MouseMove( sender, args );
end

MI["CLblT"].MouseLeave = function( sender, args )
	MI["CLbl"].MouseLeave( sender, args );
end

MI["CLblT"].MouseClick = function( sender, args )
	MI["CLbl"].MouseClick( sender, args );
end

MI["CLblT"].MouseDown = function( sender, args )
	MI["CLbl"].MouseDown( sender, args );
end

MI["CLblT"].MouseUp = function( sender, args )
	MI["CLbl"].MouseUp( sender, args );

end
--**^
--**v Copper amount & icon on TitanBar v**
MI["CIcon"] = Turbine.UI.Control();
MI["CIcon"]:SetParent( MI["CCtr"] );
--MI["CIcon"]:SetBlendMode( Turbine.UI.BlendMode.AlphaBlend );
MI["CIcon"]:SetSize( 27, 21 );
MI["CIcon"]:SetBackground( 0x41007e7d );-- in-game icon 27x21 (3 coins: 0x41007e80 / 1 coin: 0x41007e7d)
--MI["CIcon"]:SetBackColor( Color["blue"] ); -- Debug purpose

MI["CIcon"].MouseMove = function( sender, args )
	MI["CLbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then MoveMICtr(sender, args); end
end

MI["CIcon"].MouseLeave = function( sender, args )
	MI["CLbl"].MouseLeave( sender, args );
end

MI["CIcon"].MouseClick = function( sender, args )
	MI["CLbl"].MouseClick( sender, args );
end

MI["CIcon"].MouseDown = function( sender, args )
	MI["CLbl"].MouseDown( sender, args );
end

MI["CIcon"].MouseUp = function( sender, args )
	MI["CLbl"].MouseUp( sender, args );
end


MI["CLbl"] = Turbine.UI.Label();
MI["CLbl"]:SetParent( MI["CCtr"] );
MI["CLbl"]:SetPosition( 0, 0 );
MI["CLbl"]:SetFont( _G.TBFont );
--MI["CLbl"]:SetForeColor( Color["white"] );
--MI["CLbl"]:SetSize( 20, 30 );
MI["CLbl"]:SetFontStyle( Turbine.UI.FontStyle.Outline );
MI["CLbl"]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
--MI["CLbl"]:SetBackColor( Color["white"] ); -- Debug purpose

MI["CLbl"].MouseMove = function( sender, args )
	--MI["CLbl"].MouseLeave( sender, args );
	TB["win"].MouseMove();
	if dragging then
		MoveMICtr(sender, args);
	else
		if not MITT then
			MITT = true;
			ShowMIWindow();
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

MI["CLbl"].MouseLeave = function( sender, args )
	ResetToolTipWin();
	MITT = false;
end

MI["CLbl"].MouseClick = function( sender, args )
	TB["win"].MouseMove();
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if not WasDrag then
			if _G.frmMI then _G.frmMI = false; wMI:Close();
			else
				_G.frmMI = true;
				import (AppCtrD.."MoneyInfosWindow");
				frmMoneyInfosWindow();
			end
		end
	elseif ( args.Button == Turbine.UI.MouseButton.Right ) then
		_G.sFromCtr = "Money";
		ControlMenu:ShowMenu();
	end
	WasDrag = false;
end

MI["CLbl"].MouseDown = function( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		MI["Ctr"]:SetZOrder( 3 );
		dragStartX = args.X;
		dragStartY = args.Y;
		dragging = true;
	end
end

MI["CLbl"].MouseUp = function( sender, args )
	MI["Ctr"]:SetZOrder( 2 );
	dragging = false;
	_G.MILocX = MI["Ctr"]:GetLeft();
	settings.Money.X = string.format("%.0f", _G.MILocX);
	_G.MILocY = MI["Ctr"]:GetTop();
	settings.Money.Y = string.format("%.0f", _G.MILocY);
	SaveSettings( false );
end
--**^

function MoveMICtr(sender, args)
	MI["CLbl"].MouseLeave( sender, args );
	local CtrLocX = MI["Ctr"]:GetLeft();
	local CtrWidth = MI["Ctr"]:GetWidth();
	CtrLocX = CtrLocX + ( args.X - dragStartX );
	if CtrLocX < 0 then CtrLocX = 0; elseif CtrLocX + CtrWidth > screenWidth then CtrLocX = screenWidth - CtrWidth; end
	
	local CtrLocY = MI["Ctr"]:GetTop();
	local CtrHeight = MI["Ctr"]:GetHeight();
	CtrLocY = CtrLocY + ( args.Y - dragStartY );
	if CtrLocY < 0 then CtrLocY = 0; elseif CtrLocY + CtrHeight > TB["win"]:GetHeight() then CtrLocY = TB["win"]:GetHeight() - CtrHeight; end

	MI["Ctr"]:SetPosition( CtrLocX, CtrLocY );
	WasDrag = true;
end