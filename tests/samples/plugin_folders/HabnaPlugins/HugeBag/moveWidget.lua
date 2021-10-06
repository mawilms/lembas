-- moveWidget.lua
-- Written By Habna


function MouseDown( sender, args )
	if ( args.Button == Turbine.UI.MouseButton.Left ) then
		if ( args.X < 30 and args.Y < 20 ) then
			CornerClick = "TopLeft";
			dragStartX = args.X;
			dragStartY = args.Y;
			dragging = true;
			if wHugeBag.cursor ~= nil then wHugeBag.cursor:SetVisible( false ); end
		end
	end
end

function MouseHover( sender, args )
	wHugeBag.cursor = up_down_right_clic;
	local mouseX, mouseY = Turbine.UI.Display.GetMousePosition();
	wHugeBag.cursor:SetPosition( mouseX - wHugeBag.cursor.xOffset, mouseY - wHugeBag.cursor.yOffset);
	wHugeBag.cursor:SetVisible( true );
end

function MouseLeave( sender, args )
	if wHugeBag.cursor ~= nil then
		wHugeBag.cursor:SetVisible( false );
		wHugeBag.cursor = nil;
	end
end

function MouseUp( sender, args )
	dragging = false;
	CornerClick = "";
	WinLocX, WinLocY = wHugeBag:GetPosition();
	HBsettings.Location.Y = tostring(WinLocY);
	SaveSettings( false )
end

function MouseMove( sender, args )
	if ( dragging ) then
		local tempY = WinLocY + ( args.Y - dragStartY );

		if CornerClick == "TopLeft" then
			if tempY < 0 or ( tempY + wHugeBag:GetHeight() ) > screenHeight then
				dragging = false;
				wHugeBag.Cursor = nil;
			else
				WinLocY = tempY;
				wHugeBag:SetTop( WinLocY );
			end
		elseif CornerClick == "BottomLeft" then
				
		end
	end
end