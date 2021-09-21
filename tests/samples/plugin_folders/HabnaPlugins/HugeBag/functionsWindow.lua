-- functions.lua
-- Written By Habna


-- **v Hide HugeBag v**
function ShowHugeBag()
	if frmMain:IsVisible() then
		write( L["FWidShow"] );
	else
		frmMain:SetVisible( true );
	end
end
-- **^
-- **v Hide HugeBag v**
function HideHugeBag()
	if not frmMain:IsVisible() then
		write( L["FWidHide"] );
	else
		frmMain:SetVisible( false );
	end
end
-- **^
-- **v Toggle Items Orientation v**
function ToggleItemsOrientation()
	HorizontalOrientation = not HorizontalOrientation;
	HBsettings.Options.HorizontalOrientation = HorizontalOrientation;
	PerformLayout();
	SaveSettings( false );
	if HorizontalOrientation then
		write( L["FIH"] );
	else
		write( L["FIV"] );
	end
end
-- **^
-- **v Toggle icon resize function v**
function ToggleIconSize()
	ISEnabled = not ISEnabled;
	HBsettings.Size.E = ISEnabled;
	SrollCtr:SetVisible( false );
	lblIconSizeV:SetVisible( false );
	SrollCtr2:SetVisible( ISEnabled );
	
	if ISEnabled then
		write( L["ISE"] );
	else
		write( L["ISD"] );
		IconSize = 35;
		lblIconSizeV:SetText( IconSize );
	end

	SaveSettings( false );
	
	for i = 1, backpackSize do
		itemsCtl[i]:SetSize( IconSize, IconSize );

		itemsBG[i]:SetBackground( resources.Item.Background );
		if ISEnabled then
			itemsBG[i]:SetBlendMode( 0 );
			itemsBG[i]:SetSize( 35, 35 );
			itemsBG[i]:SetStretchMode( 1 );
			itemsBG[i]:SetSize( IconSize, IconSize );
			itemsBG[i]:SetStretchMode( 3 );
		else
			itemsBG[i]:SetStretchMode( 0 );
			itemsBG[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		end

		items[i]:SetStretchMode( 2 );
		items[i]:SetSize( IconSize, IconSize );
		if ISEnabled then items[i]:SetBlendMode( 0 );
		else
			items[i]:SetStretchMode( 0 );
			items[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		end
	end
	
	listWidth = wHugeBag.itemListBox:GetWidth();
	itemsPerRow = math.floor(listWidth / IconSize);
	NumRow = math.ceil(backpackSize / itemsPerRow);
	wHugeBag:SetHeight( (NumRow * IconSize)+55 );
	PerformLayout();
end
-- **^
-- **v Resize icon v**
function ChangeIconSize()
	if IconSize <= 15 then IconSize = 15; end
	if IconSize >= 67 then IconSize = 67; end
	lblIconSizeV:SetText( IconSize-3 );
	HBsettings.Size.I = string.format("%.0f", IconSize);
	SaveSettings( false );
	
	for i = 1, backpackSize do
		itemsCtl[i]:SetSize( IconSize, IconSize );

		itemsBG[i]:SetSize( 35, 35 );
		itemsBG[i]:SetStretchMode( 1 );
		itemsBG[i]:SetSize( IconSize, IconSize );
		itemsBG[i]:SetStretchMode( 3 );

		items[i]:SetStretchMode( 2 );
		items[i]:SetSize( IconSize, IconSize );
	end

	listWidth = wHugeBag.itemListBox:GetWidth();
	itemsPerRow = math.floor(listWidth / IconSize);
	NumRow = math.ceil(backpackSize / itemsPerRow);
	wHugeBag:SetHeight( (NumRow * IconSize)+55 );
	if wHugeBag:GetHeight() < 125 then wHugeBag:SetHeight(125); end
	PerformLayout();
end
-- **^
--[[ Disabled until i found a way to reverse the scrollbar in the same orientation (Top goes to bottom, bottom goes to top)
-- **v Toggle Items ReverseFill v**
function ToggleItemsReverseFill()
	ReverseFill = ( not ReverseFill );
	frmMain.itemListBox:SetReverseFill( ReverseFill );
	frmMain:PerformLayout();
	SaveSettings();
end
-- **^
]]
-- **v Lock HugeBag Position v**
function LockHugeBagSize()
	LockSize = not LockSize;
	HBsettings.Options.LockSize = LockSize;
	SaveSettings( false );
	if LockSize then
		write( L["FSL"] );
	else
		write( L["FSNL"] );
	end
end
-- **^
-- **v Lock HugeBag Position v**
function LockHugeBagPosition()
	LockPosition = not LockPosition;
	LockLabel.Enable = not LockPosition;
	HBsettings.Options.LockPosition = LockPosition;
	SaveSettings( false );
	if LockPosition then
		write( L["FPL"] );
	else
		write( L["FPNL"] );
	end
end
-- **^

function ToggleSkin()
	ShowSkin = not ShowSkin;
	HBsettings.Options.ShowSkin = ShowSkin;
	HBSkin:SetVisible( not ShowSkin );

	if ShowSkin then
		ButtonsCtr:SetPosition( 35, WinHeight - 20 );
		SearchInput:SetPosition( 35,  WinHeight - 23 );
		write( L["FSkinS"] );
	else
		ButtonsCtr:SetPosition( 35, 19 );
		SearchInput:SetPosition( 35,  16 );
		write( L["FSkinH"] );
	end
	
	ButtonAtTop = not ShowSkin;
	HBsettings.Button.AtTop = ButtonAtTop;
	
	SaveSettings( false );
end