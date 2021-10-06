-- background.lua
-- Written by Habna


function frmBackground()
	wBackground = Turbine.UI.Lotro.Window();
	--wBackground = Turbine.UI.Lotro.GoldWindow()
	
	local initHeight = 180;
	local initWidth = 400;
	local initLeft=(Turbine.UI.Display:GetWidth() - initWidth) / 2;
	local initTop=(Turbine.UI.Display:GetHeight() - initHeight) / 2;
	
	wBackground.Opacity = 1;
	wBackground:SetText( L["BWTitle"] );
	wBackground:SetSize( initWidth, initHeight );
	wBackground:SetPosition( initLeft, initTop );
	wBackground:SetVisible( true );
	wBackground:SetWantsKeyEvents( true );
	--wBackground:SetZOrder( 2 );
	wBackground:Activate();

	-- **v Currently set color label v**
	local CurSetColorLbl = Turbine.UI.Label();
	CurSetColorLbl:SetParent( wBackground );
	CurSetColorLbl:SetPosition( 308, 35 );
	CurSetColorLbl:SetSize( 75, 30 );
	CurSetColorLbl:SetText( L["BWCurSetColor"] );
	CurSetColorLbl:SetVisible( true );
	CurSetColorLbl:SetForeColor( Color["rustedgold"] );
	-- **^
	-- **v Currently Selected color box v**
	curSelColorBorder = Turbine.UI.Label();
	curSelColorBorder:SetParent( wBackground );
	curSelColorBorder:SetSize( 73, 73 );
	curSelColorBorder:SetPosition( 305, 60 );
	curSelColorBorder:SetBackColor( Color["white"] );

	curSelColor = Turbine.UI.Label();
	curSelColor:SetParent( curSelColorBorder );
	curSelColor:SetSize( 71, 71 );
	curSelColor:SetPosition( 1, 1 );
	curSelColor:SetBackColor( Turbine.UI.Color( bcAlpha, bcRed, bcGreen, bcBlue ) );
	curSelRed = bcRed;
	curSelGreen = bcGreen;
	curSelBlue = bcBlue;
	-- **^
	-- **v Save button v**
	local buttonSave = Turbine.UI.Lotro.Button();
	buttonSave:SetParent( wBackground );
	buttonSave:SetText( L["BWSave"] );
	buttonSave:SetSize( string.len(buttonSave:GetText()) * 10, 15 ); --Auto size with text lenght
	buttonSave:SetPosition( wBackground:GetWidth() - buttonSave:GetWidth() - 15 , wBackground:GetHeight() - 34 );
	buttonSave:SetVisible( true );
	--buttonSave:SetEnabled( false );

	buttonSave.Click = function( sender, args )
		bcRed = curSelRed;
		bcGreen = curSelGreen;
		bcBlue = curSelBlue;
		ChangeColor();
		HBsettings.BackColor.A = string.format("%.3f", bcAlpha);
		HBsettings.BackColor.R = string.format("%.3f", bcRed);
		HBsettings.BackColor.G = string.format("%.3f", bcGreen);
		HBsettings.BackColor.B = string.format("%.3f", bcBlue);
		SaveSettings( false );
		--buttonSave:SetEnabled( false );
	end
	-- **^
	-- Create alpha label and slider.
	local alphalabel = Turbine.UI.Label();
	alphalabel:SetParent( wBackground );
	alphalabel:SetText( L["BWAlpha"] .. " @ " .. ( bcAlpha * 100 ) .. "%" );
	alphalabel:SetPosition( 40, 40 );
	alphalabel:SetSize( 242, 10 );
	alphalabel:SetBackColor( Color["black"] );
	alphalabel:SetTextAlignment( Turbine.UI.ContentAlignment.TopCenter );
	
	local alphaScrollBar = Turbine.UI.Lotro.ScrollBar();
	alphaScrollBar:SetParent( alphalabel );
	alphaScrollBar:SetPosition( 0, 0 );
	alphaScrollBar:SetSize( 242, 10 );
	alphaScrollBar:SetMinimum( 0 );
	alphaScrollBar:SetMaximum( 100 );
	alphaScrollBar:SetValue( bcAlpha * 100);
	
	alphaScrollBar.ValueChanged = function(sender, args)
		bcAlpha = alphaScrollBar:GetValue() / 100;
		alphalabel:SetText( L["BWAlpha"] .. " " .. ( bcAlpha * 100 ) .. "%" );
		curSelColor:SetBackColor( Turbine.UI.Color( bcAlpha, curSelRed, curSelGreen, curSelBlue ) );
		ChangeColor();
		--buttonSave:SetEnabled( true );
	end
	-- **^
	-- **v Default button v**
	local buttonDefault = Turbine.UI.Lotro.Button();
	buttonDefault:SetParent( wBackground );
	buttonDefault:SetPosition( 23, wBackground:GetHeight() - 34 );
	buttonDefault:SetText( L["BWDef"] );
	buttonDefault:SetSize( string.len(buttonDefault:GetText()) * 10, 15 ); --Auto size with text lenght
	buttonDefault:SetVisible( true );

	buttonDefault.Click = function(sender, args)
		if Widget then
			alphaScrollBar:SetValue( 30 );
			bcAlpha = ( 0.3 );
			curSelRed = ( 0.3 );
			curSelGreen = ( 0.3 );
			curSelBlue = ( 0.3 );
		else
			alphaScrollBar:SetValue( 100 );
			bcAlpha = ( 1 );
			curSelRed = ( 0 );
			curSelGreen = ( 0 );
			curSelBlue = ( 0 );
		end
		curSelColor:SetBackColor( Turbine.UI.Color( bcAlpha, curSelRed, curSelGreen, curSelBlue ) );
		ChangeColor();
		--buttonSave:SetEnabled( true );
	end
	-- **^

	if Widget then
		-- **v Black button v**
		local buttonBlack = Turbine.UI.Lotro.Button();
		buttonBlack:SetParent( wBackground );
		buttonBlack:SetPosition( buttonDefault:GetLeft() + buttonDefault:GetWidth() + 5, wBackground:GetHeight() - 34 );
		buttonBlack:SetText( L["BWBlack"] );
		buttonBlack:SetSize( string.len(buttonBlack:GetText()) * 10, 15 ); --Auto size with text lenght
		buttonBlack:SetVisible( true );

		buttonBlack.Click = function(sender, args)
			alphaScrollBar:SetValue ( 100 );
			bcAlpha = ( 1 );
			curSelRed = ( 0 );
			curSelGreen = ( 0 );
			curSelBlue = ( 0 );
			curSelColor:SetBackColor( Turbine.UI.Color( bcAlpha, curSelRed, curSelGreen, curSelBlue ) );
			wHugeBag.itemListBox:SetBackColor( Turbine.UI.Color( bcAlpha, curSelRed, curSelGreen, curSelBlue ) );
			--buttonSave:SetEnabled( true );
		end
		-- **^
	end

	-- Create Colour Picker window/border.
	ColourPickerBorder = Turbine.UI.Label();
	ColourPickerBorder:SetParent( wBackground );
	ColourPickerBorder:SetPosition( 40, 60 );
	ColourPickerBorder:SetSize( 242, 73 );
	ColourPickerBorder:SetBackColor( Turbine.UI.Color( 1, .2, .2, .2  ) );
	ColourPickerBorder:SetVisible( true );
	
	-- Create Colour Picker.
	ColourPicker = Turbine.UI.Label();
	ColourPicker:SetParent( ColourPickerBorder );
	ColourPicker:SetPosition( 1, 1 );
	ColourPicker:SetSize( 240, 71 ); 
	ColourPicker:SetBackground( resources.Picker.Background );

	ColourPicker.GetColorFromCoord = function( sender, X, Y )
		-- Controls the visibility of the cursor window
		local blockXvalue = (math.floor(ColourPicker:GetWidth()/3));
		local blockYvalue = (math.floor(ColourPicker:GetHeight()/2));

		curColor = Turbine.UI.Color();
		--curColor.A = 1.0;
		local myX=X
		local myY=Y
		local curRed = 0;
		local curGreen = 0;
		local curBlue = 0;

		if (myX >= 0) and (myX < blockXvalue) then

			-- First color block = red to green
			curRed = 100-((100/blockXvalue)*myX);
			curGreen = (100/blockXvalue)*myX;
			curBlue = 0;

		elseif (myX >= blockXvalue) and (myX < (2*blockXvalue)) then

			-- Second color block = green to blue
			curRed = 0;
			curGreen = 100-((100/blockXvalue)*(myX - blockXvalue));
			curBlue = (100/blockXvalue)*(myX - blockXvalue);

		elseif (myX >= (2*blockXvalue)) then

			-- Third color block = blue to red
			curRed = (100/blockXvalue)*(myX - 2*blockXvalue);
			curGreen = 0;
			curBlue = 100-((100/blockXvalue)*(myX - 2*blockXvalue));

		end

		if myY <= blockYvalue then

			-- In the top block, so fade from black to full color
			curRed = curRed * (myY/blockYvalue);
			curGreen = curGreen * (myY/blockYvalue);
			curBlue = curBlue * (myY/blockYvalue);

		else

			-- In the bottom block, so fade from full color to white
			curRed = curRed + ((myY - blockYvalue) * ((100 - curRed)/(blockYvalue)));
			curGreen = curGreen + ((myY - blockYvalue) * ((100 - curGreen)/(blockYvalue)));
			curBlue = curBlue + ((myY - blockYvalue) * ((100 - curBlue)/(blockYvalue)));

		end

		curColor.A = bcAlpha;
		curColor.R = (1/100) * curRed;
		curColor.G = (1/100) * curGreen;
		curColor.B = (1/100) * curBlue;
		return curColor;
	end

	ColourPicker.MouseMove = function( sender, args )
		mColor = ColourPicker:GetColorFromCoord( args.X, args.Y );
		wHugeBag.itemListBox:SetBackColor( mColor );
	end
	
	ColourPicker.MouseClick = function( sender, args )
		curSelRed = curColor.R;
		curSelGreen = curColor.G;
		curSelBlue = curColor.B;
		curSelColor:SetBackColor( mColor );
		--buttonSave:SetEnabled( true );
	end

	wBackground.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			wBackground:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			wBackground:SetVisible( not wBackground:IsVisible() );
		end
	end

	wBackground.Closing = function( sender, args )
		wBackground:SetWantsKeyEvents( false );
		bcRed = curSelRed;
		bcGreen = curSelGreen;
		bcBlue = curSelBlue;
		ChangeColor();
		option_backcolor:SetEnabled( true );
		wBackground = nil;
	end
end