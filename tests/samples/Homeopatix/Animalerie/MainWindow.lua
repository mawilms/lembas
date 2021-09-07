------------------------------------------------------------------------------------------
-- create the main window
------------------------------------------------------------------------------------------
function CreateTheWindow()

	HelloWindow=Turbine.UI.Lotro.GoldWindow(); 
	HelloWindow:SetSize(324,170); 
	HelloWindow:SetText(Strings.PluginName); 
	HelloWindow.Message=Turbine.UI.Label(); 
	HelloWindow.Message:SetParent(HelloWindow); 
	HelloWindow.Message:SetSize(150,10); 
	HelloWindow.Message:SetPosition(HelloWindow:GetWidth()/2 - 75, 32); 
	HelloWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	HelloWindow.Message:SetText(Strings.PluginTextFam); 

	HelloWindow.Message=Turbine.UI.Label(); 
	HelloWindow.Message:SetParent(HelloWindow); 
	HelloWindow.Message:SetSize(150,10); 
	HelloWindow.Message:SetPosition(HelloWindow:GetWidth()/2 - 75, 85); 
	HelloWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	HelloWindow.Message:SetText(Strings.PluginTextFood); 
	HelloWindow:SetWantsKeyEvents(true);

	HelloWindow:SetPosition(settings.positionX, settings.positionY);

	if(settings.isWindowVisible == "true") then
		HelloWindow:SetVisible(true);
	else
		HelloWindow:SetVisible(false);
	end

	--------------------------------------------------------------------------------------------
	--Pet icons
	--------------------------------------------------------------------------------------------
	centerWindow = Turbine.UI.Extensions.SimpleWindow();
	centerWindow:SetSize( 40 , 40 );
	centerWindow:SetParent( HelloWindow );
	centerWindow:SetPosition( 15 ,HelloWindow:GetHeight()/2 - 41);
	centerWindow:SetVisible( true );
	centerWindow:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow2 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow2:SetSize( 40 , 40 );
	centerWindow2:SetParent( HelloWindow );
	centerWindow2:SetPosition( 57 ,HelloWindow:GetHeight()/2 - 41);
	centerWindow2:SetVisible( true );
	centerWindow2:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow3 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow3:SetSize( 40 , 40 );
	centerWindow3:SetParent( HelloWindow );
	centerWindow3:SetPosition( 99,HelloWindow:GetHeight()/2 - 41);
	centerWindow3:SetVisible( true );
	centerWindow3:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow4 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow4:SetSize( 40 , 40 );
	centerWindow4:SetParent( HelloWindow );
	centerWindow4:SetPosition( 141,HelloWindow:GetHeight()/2 - 41);
	centerWindow4:SetVisible( true );
	centerWindow4:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow5 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow5:SetSize( 40 , 40 );
	centerWindow5:SetParent( HelloWindow );
	centerWindow5:SetPosition( 183,HelloWindow:GetHeight()/2 - 41);
	centerWindow5:SetVisible( true );
	centerWindow5:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow6 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow6:SetSize( 40 , 40 );
	centerWindow6:SetParent( HelloWindow );
	centerWindow6:SetPosition( 225,HelloWindow:GetHeight()/2 - 41);
	centerWindow6:SetVisible( true );
	centerWindow6:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow7 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow7:SetSize( 40 , 40 );
	centerWindow7:SetParent( HelloWindow );
	centerWindow7:SetPosition( 267,HelloWindow:GetHeight()/2 - 41);
	centerWindow7:SetVisible( true );
	centerWindow7:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );


	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow2);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow3);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow4);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow5);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow6);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow7);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);


	centerQS1 = Turbine.UI.Lotro.Quickslot();
	centerQS1:SetParent( centerWindow );
	centerQS1:SetPosition( 1, 1 );
	centerQS1:SetSize( 36, 36 );
	centerQS1:SetUseOnRightClick(false);

	centerQS2 = Turbine.UI.Lotro.Quickslot();
	centerQS2:SetParent( centerWindow2 );
	centerQS2:SetPosition( 1, 1 );
	centerQS2:SetSize( 36, 36 );
	centerQS2:SetUseOnRightClick(false);

	centerQS3 = Turbine.UI.Lotro.Quickslot();
	centerQS3:SetParent( centerWindow3 );
	centerQS3:SetPosition( 1, 1 );
	centerQS3:SetSize( 36, 36 );
	centerQS3:SetUseOnRightClick(false);

	centerQS4 = Turbine.UI.Lotro.Quickslot();
	centerQS4:SetParent( centerWindow4 );
	centerQS4:SetPosition( 1, 1 );
	centerQS4:SetSize( 36, 36 );
	centerQS4:SetUseOnRightClick(false);

	centerQS5 = Turbine.UI.Lotro.Quickslot();
	centerQS5:SetParent( centerWindow5 );
	centerQS5:SetPosition( 1, 1 );
	centerQS5:SetSize( 36, 36 );
	centerQS5:SetUseOnRightClick(false);

	centerQS6 = Turbine.UI.Lotro.Quickslot();
	centerQS6:SetParent( centerWindow6 );
	centerQS6:SetPosition( 1, 1 );
	centerQS6:SetSize( 36, 36 );
	centerQS6:SetUseOnRightClick(false);

	centerQS7 = Turbine.UI.Lotro.Quickslot();
	centerQS7:SetParent( centerWindow7 );
	centerQS7:SetPosition( 1, 1 );
	centerQS7:SetSize( 36, 36 );
	centerQS7:SetUseOnRightClick(false);

	--------------------------------------------------------------------------------------------
	--Food for Pet icons
	--------------------------------------------------------------------------------------------

	centerWindow8 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow8:SetSize( 40 , 40 );
	centerWindow8:SetParent( HelloWindow );
	centerWindow8:SetPosition( 15 ,HelloWindow:GetHeight()/2 + 13);
	centerWindow8:SetVisible( true );
	centerWindow8:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow9 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow9:SetSize( 40 , 40 );
	centerWindow9:SetParent( HelloWindow );
	centerWindow9:SetPosition( 57 ,HelloWindow:GetHeight()/2  + 13);
	centerWindow9:SetVisible( true );
	centerWindow9:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow10 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow10:SetSize( 40 , 40 );
	centerWindow10:SetParent( HelloWindow );
	centerWindow10:SetPosition( 99,HelloWindow:GetHeight()/2  + 13);
	centerWindow10:SetVisible( true );
	centerWindow10:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow11 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow11:SetSize( 40 , 40 );
	centerWindow11:SetParent( HelloWindow );
	centerWindow11:SetPosition( 141,HelloWindow:GetHeight()/2  + 13);
	centerWindow11:SetVisible( true );
	centerWindow11:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow12 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow12:SetSize( 40 , 40 );
	centerWindow12:SetParent( HelloWindow );
	centerWindow12:SetPosition( 183,HelloWindow:GetHeight()/2  + 13);
	centerWindow12:SetVisible( true );
	centerWindow12:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow13 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow13:SetSize( 40 , 40 );
	centerWindow13:SetParent( HelloWindow );
	centerWindow13:SetPosition( 225,HelloWindow:GetHeight()/2  + 13);
	centerWindow13:SetVisible( true );
	centerWindow13:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow14 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow14:SetSize( 40 , 40 );
	centerWindow14:SetParent( HelloWindow );
	centerWindow14:SetPosition( 267,HelloWindow:GetHeight()/2  + 13);
	centerWindow14:SetVisible( true );
	centerWindow14:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );


	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow8);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow9);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow10);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow11);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow12);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow13);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow14);
	centerLabel:SetPosition( 0, 0 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);


	centerQS8 = Turbine.UI.Lotro.Quickslot();
	centerQS8:SetParent( centerWindow8 );
	centerQS8:SetPosition( 1, 1 );
	centerQS8:SetSize( 36, 36 );
	centerQS8:SetUseOnRightClick(false);

	centerQS9 = Turbine.UI.Lotro.Quickslot();
	centerQS9:SetParent( centerWindow9 );
	centerQS9:SetPosition( 1, 1 );
	centerQS9:SetSize( 36, 36 );
	centerQS9:SetUseOnRightClick(false);

	centerQS10 = Turbine.UI.Lotro.Quickslot();
	centerQS10:SetParent( centerWindow10 );
	centerQS10:SetPosition( 1, 1 );
	centerQS10:SetSize( 36, 36 );
	centerQS10:SetUseOnRightClick(false);

	centerQS11 = Turbine.UI.Lotro.Quickslot();
	centerQS11:SetParent( centerWindow11 );
	centerQS11:SetPosition( 1, 1 );
	centerQS11:SetSize( 36, 36 );
	centerQS11:SetUseOnRightClick(false);

	centerQS12 = Turbine.UI.Lotro.Quickslot();
	centerQS12:SetParent( centerWindow12 );
	centerQS12:SetPosition( 1, 1 );
	centerQS12:SetSize( 36, 36 );
	centerQS12:SetUseOnRightClick(false);

	centerQS13 = Turbine.UI.Lotro.Quickslot();
	centerQS13:SetParent( centerWindow13 );
	centerQS13:SetPosition( 1, 1 );
	centerQS13:SetSize( 36, 36 );
	centerQS13:SetUseOnRightClick(false);

	centerQS14 = Turbine.UI.Lotro.Quickslot();
	centerQS14:SetParent( centerWindow14 );
	centerQS14:SetPosition( 1, 1 );
	centerQS14:SetSize( 36, 36 );
	centerQS14:SetUseOnRightClick(false);

	------------------------------------------------------------------------------------------
	-- releae pet button
	------------------------------------------------------------------------------------------
	AnimalerieButton = Turbine.UI.Lotro.GoldButton();
	AnimalerieButton:SetParent( HelloWindow );
	AnimalerieButton:SetPosition(HelloWindow:GetWidth()/2 - 75, HelloWindow:GetHeight()/2 + 57);
	AnimalerieButton:SetSize( 150, 20 );
	AnimalerieButton:SetText( Strings.PluginReleaseButton );
	AnimalerieButton:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	AnimalerieButton:SetVisible(true);
	AnimalerieButton:SetMouseVisible(true);

	releaseWindow = Turbine.UI.Extensions.SimpleWindow();
	releaseWindow:SetSize( 150, 20 );
	releaseWindow:SetParent( HelloWindow );
	releaseWindow:SetPosition(HelloWindow:GetWidth()/2 - 75, HelloWindow:GetHeight()/2 + 57);
	releaseWindow:SetOpacity( 0 );
	releaseWindow:SetFadeSpeed( 0.5 );
	releaseWindow:SetVisible( true );
	releaseWindow:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	releaseQSBack = Turbine.UI.Control();
	releaseQSBack:SetParent( releaseWindow );
	releaseQSBack:SetZOrder(-1);
	releaseQSBack:SetSize( 150, 20 );

	releaseQS = Turbine.UI.Lotro.Quickslot();
	releaseQS:SetParent(  releaseQSBack );
	releaseQS:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, Strings.PluginReleaseAlias));
	releaseQS:SetSize( 150, 20 );
	releaseQS:SetPosition( 0, 0 );
	releaseQS:SetAllowDrop(false);

	releaseQS = Turbine.UI.Lotro.Quickslot();
	releaseQS:SetParent(  releaseQSBack );
	releaseQS:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, Strings.PluginReleaseAlias));
	releaseQS:SetSize( 150, 20 );
	releaseQS:SetPosition( 32, 0 );
	releaseQS:SetAllowDrop(false);

	releaseQS = Turbine.UI.Lotro.Quickslot();
	releaseQS:SetParent(  releaseQSBack );
	releaseQS:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, Strings.PluginReleaseAlias));
	releaseQS:SetSize( 150, 20 );
	releaseQS:SetPosition( 64, 0 );
	releaseQS:SetAllowDrop(false);

	releaseQS = Turbine.UI.Lotro.Quickslot();
	releaseQS:SetParent(  releaseQSBack );
	releaseQS:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, Strings.PluginReleaseAlias));
	releaseQS:SetSize( 150, 20 );
	releaseQS:SetPosition( 96, 0 );
	releaseQS:SetAllowDrop(false);

	releaseQS = Turbine.UI.Lotro.Quickslot();
	releaseQS:SetParent(  releaseQSBack );
	releaseQS:SetShortcut(Turbine.UI.Lotro.Shortcut(Turbine.UI.Lotro.ShortcutType.Alias, Strings.PluginReleaseAlias));
	releaseQS:SetSize( 150, 20 );
	releaseQS:SetPosition( 112, 0 );
	releaseQS:SetAllowDrop(false);

end