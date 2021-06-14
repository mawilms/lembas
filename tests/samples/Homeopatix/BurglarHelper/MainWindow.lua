------------------------------------------------------------------------------------------
-- create the main window
------------------------------------------------------------------------------------------
function CreateMainWindow()
	BurglarHelperWindow=Turbine.UI.Lotro.GoldWindow(); 
	BurglarHelperWindow:SetSize(200,120); 
	BurglarHelperWindow:SetText(Strings.PluginName); 
	BurglarHelperWindow.Message=Turbine.UI.Label(); 
	BurglarHelperWindow.Message:SetParent(BurglarHelperWindow); 
	BurglarHelperWindow.Message:SetSize(150,15); 
	BurglarHelperWindow.Message:SetPosition(BurglarHelperWindow:GetWidth()/2 - 75, BurglarHelperWindow:GetHeight()/2 + 40); 
	BurglarHelperWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
	BurglarHelperWindow.Message:SetText(Strings.PluginText); 
	BurglarHelperWindow:SetWantsKeyEvents(true);

	BurglarHelperWindow:SetPosition(settings.positionX, settings.positionY);

	------------------------------------------------------------------------------------------
	-- yel helper center window
	------------------------------------------------------------------------------------------
	centerWindow = Turbine.UI.Extensions.SimpleWindow();
	centerWindow:SetSize( 40 , 40 );
	centerWindow:SetParent( BurglarHelperWindow );
	centerWindow:SetPosition( 30 ,BurglarHelperWindow:GetHeight()/2 - 12);
	centerWindow:SetVisible( true );
	centerWindow:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow2 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow2:SetSize( 40 , 40 );
	centerWindow2:SetParent( BurglarHelperWindow );
	centerWindow2:SetPosition( 80 ,BurglarHelperWindow:GetHeight()/2 - 12);
	centerWindow2:SetVisible( true );
	centerWindow2:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerWindow3 = Turbine.UI.Extensions.SimpleWindow();
	centerWindow3:SetSize( 40 , 40 );
	centerWindow3:SetParent( BurglarHelperWindow );
	centerWindow3:SetPosition( 130,BurglarHelperWindow:GetHeight()/2 - 12);
	centerWindow3:SetVisible( true );
	centerWindow3:SetBackColor( Turbine.UI.Color( .6, .5, .7, .5) );

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow);
	centerLabel:SetPosition( 1, 1 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow2);
	centerLabel:SetPosition( 1, 1 );
	centerLabel:SetSize( 40, 40  );
	centerLabel:SetText( "" );
	centerLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	centerLabel:SetZOrder(-1);
	centerLabel:SetMouseVisible(false);

	centerLabel = Turbine.UI.Label();
	centerLabel:SetParent(centerWindow3);
	centerLabel:SetPosition( 1, 1 );
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
end