-- debugwin2.lua
-- Written by Habna


function frmDebug()
	self = Turbine.UI.Lotro.Window();
	--self = Turbine.UI.Lotro.GoldWindow();
	
	self:SetSize( 500, 445 );
	local screenWidth, screenHeight = Turbine.UI.Display.GetSize();
	local winWidth, winHeight = self:GetSize();
	local left, top = ( screenWidth / 2 ) - ( winWidth / 2 ) , ( screenHeight / 2 ) - ( winHeight / 2 );
    self:SetPosition( left, top );
	self:SetText( "Debug window" );
	self:SetVisible( true );
	self:SetWantsKeyEvents( true );
	--self:SetZOrder( 2 );
	self:Activate();

	self.MouseClick = function( sender, args )
		if ( args.Button == Turbine.UI.MouseButton.Right ) then CreateVirtualPack(); RefreshListBox(); end
	end

	self.KeyDown = function( sender, args )
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			self:Close();
		elseif ( args.Action == 268435635 ) or ( args.Action == 268435579 ) then -- Hide if F12 key is press or reposition UI
			self:SetVisible( not self:IsVisible() );
		end
	end

	self.Closing = function( sender, args )
		self:SetWantsKeyEvents( false );
	end

	lblVirtPack = Turbine.UI.Label();
	lblVirtPack:SetParent( self );
	lblVirtPack:SetText( "Items in bag sorted by is weight. Name (Quantity)(Slot)(Quality)(Durability)(WearState)(CategoryNo)(Type)(Stack Size)(Weight)" );
	lblVirtPack:SetPosition( 25, 35);
	lblVirtPack:SetSize( self:GetWidth() - 50, 35 );
	lblVirtPack:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	lblVirtPack:SetForeColor( green );

	rListBoxBorder = Turbine.UI.Control();
	rListBoxBorder:SetParent( self );
	rListBoxBorder:SetPosition( lblVirtPack:GetLeft() - 2, lblVirtPack:GetHeight() + 40 );
	rListBoxBorder:SetSize( lblVirtPack:GetWidth() + 4, 354 );
	rListBoxBorder:SetBackColor( grey );
	rListBoxBorder:SetVisible( true );

	rListBox = Turbine.UI.ListBox();
	rListBox:SetParent( self );
	rListBox:SetPosition( rListBoxBorder:GetLeft() + 2, rListBoxBorder:GetTop() + 2 );
	rListBox:SetSize( rListBoxBorder:GetWidth() - 4, rListBoxBorder:GetHeight() - 4 );
	rListBox:SetMaxItemsPerLine( 3 );
	rListBox:SetOrientation( Turbine.UI.Orientation.Horizontal );
	rListBox:SetBackColor( black );

	rScrollBar = Turbine.UI.Lotro.ScrollBar();
	rScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
	rScrollBar:SetParent( self );
	rScrollBar:SetPosition( self:GetWidth() - 21, rListBoxBorder:GetTop() );
	rScrollBar:SetHeight( rListBoxBorder:GetHeight() );
	rScrollBar:SetWidth( 10 );
	rListBox:SetVerticalScrollBar( rScrollBar );

	RefreshListBox();
end

function RefreshListBox()
	CreateVirtualPack();
	itemsCtl = {};
	itemsLbl = {};
	lblrow = {};
	rListBox:ClearItems();

	for i = 1, #VirtPack do
		-- Slot number
		lblrow[i] = Turbine.UI.Label();
		lblrow[i]:SetSize( 20, 35 );
		lblrow[i]:SetPosition( 5, 15 );
		lblrow[i]:SetText( i );
		lblrow[i]:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
		lblrow[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		lblrow[i]:SetForeColor( white );
		rListBox:AddItem( lblrow[i] );
		
		-- Item background
		itemsCtl[i] = Turbine.UI.Control();
		itemsCtl[i]:SetSize( 35, 35 );
		itemsCtl[i]:SetBackground( "HabnaPlugins/HugeBag/Resources/slotBackground.tga" );
		itemsCtl[i]:SetBlendMode( Turbine.UI.BlendMode.Overlay );
		
		-- Item
		local item = VirtPack[i].Item;
		item:SetParent( itemsCtl[i] );
		rListBox:AddItem( itemsCtl[i] );

		-- Item name, slot & weight
		itemsLbl[i] = Turbine.UI.Label();
		itemsLbl[i]:SetSize( rListBox:GetWidth() - 35, 35 );
		itemsLbl[i]:SetFont( Turbine.UI.Lotro.Font.TrajanPro16 );
		itemsLbl[i]:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleLeft );
		itemsLbl[i]:SetForeColor( white );
		
		itemsLbl[i]:SetText( VirtPack[i].Name .. "\n (" .. VirtPack[i].Quantity .. ")(" .. VirtPack[i].AtSlot .. ")(" .. VirtPack[i].Quality .. ")(" .. VirtPack[i].Durability .. ")(" .. VirtPack[i].WearState .. ")(" .. VirtPack[i].CategoryNo .. ")(" .. VirtPack[i].Type .. ")(" .. VirtPack[i].StackSize .. ")(" .. VirtPack[i].Weight .. ")" );
		rListBox:AddItem( itemsLbl[i] );
	end
end