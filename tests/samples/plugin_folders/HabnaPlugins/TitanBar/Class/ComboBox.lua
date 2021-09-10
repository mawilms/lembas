-- ComboBox.lua
-- writen by Kragen, tweak by Habna for TitanBar


import "Turbine.UI";

ComboBox = class(Turbine.UI.Control);

-- colors
ComboBox.HighlightColor = Color["gold"];
ComboBox.SelectionColor = Color["rustedgold"];
ComboBox.ItemColor = Color["nicegold"];
ComboBox.DisabledColor = Color["lightgrey1"];
ComboBox.BlackColor = Color["black"];
ComboBox.BackHighlightColor = Color["lightgrey"];

-- create a var to store the open dropdown in
ComboBox.open = nil;

-- close any open dropdowns
ComboBox.Cleanup = function()
    if (ComboBox.open ~= nil) then
        ComboBox.open:CloseDropDown();
        ComboBox.open = nil;
    end
end

function ComboBox:Constructor()
    Turbine.UI.Control.Constructor(self);
    
    self:SetBackColor(ComboBox.DisabledColor);
    --self:SetZOrder(5);
    
    -- state
    self.dropped = false;
    self.selection = -1;
    
    -- text label
    self.label = Turbine.UI.Label();
    self.label:SetParent(self);
    self.label:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
    self.label:SetForeColor(ComboBox.ItemColor);
    self.label:SetBackColor(ComboBox.BlackColor);
    self.label:SetOutlineColor(ComboBox.HighlightColor);
    self.label:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    self.label:SetMouseVisible(false);
    
    -- arrow
    self.arrow = Turbine.UI.Control();
    self.arrow:SetParent(self);
    self.arrow:SetSize(16, 16);
    self.arrow:SetZOrder(20);
    self.arrow:SetBlendMode(4);
    self.arrow:SetBackground(0x41007e1a);
    self.arrow:SetMouseVisible(false);
    
    -- drop down window
    self.dropDownWindow = Turbine.UI.Window();
	--self.dropDownWindow:SetParent(self);
    self.dropDownWindow:SetBackColor(ComboBox.DisabledColor);
    self.dropDownWindow:SetZOrder(20);
	--self.dropDownWindow:SetMouseVisible(false);
    self.dropDownWindow:SetVisible(false);
    
    -- list scroll bar        
    self.scrollBar = Turbine.UI.Lotro.ScrollBar();
    self.scrollBar:SetOrientation(Turbine.UI.Orientation.Vertical);
    self.scrollBar:SetParent(self.dropDownWindow);
    self.scrollBar:SetBackColor(ComboBox.BlackColor);

    -- list to contain the drop down items
    self.listBox = Turbine.UI.ListBox();
    self.listBox:SetParent(self.dropDownWindow);
    self.listBox:SetOrientation(Turbine.UI.Orientation.Horizontal);
    self.listBox:SetVerticalScrollBar(self.scrollBar);
    self.listBox:SetMaxItemsPerLine(1);
    self.listBox:SetMouseVisible(false);
    self.listBox:SetPosition(2, 2);
    self.listBox:SetBackColor(ComboBox.BlackColor);
end

function ComboBox:MouseEnter(args)
    if (not self:IsEnabled()) then return; end
    
    self.label:SetFontStyle(Turbine.UI.FontStyle.Outline);
    self.label:SetForeColor(ComboBox.ItemColor);
    self.label:SetText(self.label:GetText());

    self.arrow:SetBackground(( self.dropped and 0x41007e19 or 0x41007e1b ));
end

function ComboBox:MouseLeave(args)
    if (not self:IsEnabled()) then return; end
    
    self.label:SetFontStyle(Turbine.UI.FontStyle.None);
    if (self.dropped) then
        self.label:SetForeColor(ComboBox.SelectionColor);
    end
    self.label:SetText(self.label:GetText());

    self.arrow:SetBackground(( self.dropped and 0x41007e18 or 0x41007e1a ));
end

function ComboBox:MouseClick(args)
    if (not self:IsEnabled()) then return; end
    
    if (args.Button == Turbine.UI.MouseButton.Left) then
        if (self.dropped) then self:CloseDropDown();
        else self:ShowDropDown(); end
    end
end
    
function ComboBox:FireEvent()
    if (type(self.ItemChanged) == "function") then
        self:ItemChanged({selection=self:GetSelection()}); --Pass value to args.selection
	end
end

function ComboBox:ItemSelected(index)
    if (self.selection ~= -1) then
        local old = self.listBox:GetItem(self.selection);
        old:SetForeColor(ComboBox.ItemColor);
    end
    
    local item = self.listBox:GetItem(index);
    self.selection = index;
    item:SetForeColor(ComboBox.SelectionColor);
    self.label:SetText(item:GetText());
    
    self:CloseDropDown();
end

function ComboBox:AddItem(text, value)
    local width, height = self.listBox:GetSize();

    local listItem = Turbine.UI.Label();
    listItem:SetSize(width, 20);
    listItem:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter);
    listItem:SetForeColor(ComboBox.ItemColor);
	listItem:SetBackColorBlendMode(5);
    listItem:SetFont(Turbine.UI.Lotro.Font.TrajanPro14);
    listItem:SetOutlineColor(ComboBox.HighlightColor);
	listItem:SetText(text);
    
    listItem.MouseEnter = function(sender, args)
        sender:SetFontStyle(Turbine.UI.FontStyle.Outline);
        sender:SetForeColor(ComboBox.ItemColor);
		sender:SetBackColor(ComboBox.BackHighlightColor); -- enable if want to highlight the background
        sender:SetText(sender:GetText());
    end

    listItem.MouseLeave = function(sender, args)
		sender:SetFontStyle(Turbine.UI.FontStyle.None);
        if (self.listBox:IndexOfItem(sender) == self.selection) then
            sender:SetForeColor(ComboBox.SelectionColor);
        end
		sender:SetBackColor(ComboBox.BlackColor); -- enable if want to highlight the background
        sender:SetText(sender:GetText());
    end

    listItem.MouseClick = function(sender, args)
        if (args.Button == Turbine.UI.MouseButton.Left) then
            self:ItemSelected(self.listBox:GetSelectedIndex());
            self:FireEvent();
        end
    end

    listItem.value = value;
    self.listBox:AddItem(listItem);
end

function ComboBox:SetSelection(value)
    for i = 1, self.listBox:GetItemCount() do
        local item = self.listBox:GetItem(i);
        if (item.value == value) then
            self:ItemSelected(i);
            --self:FireEvent();
            break;
        end
    end
end

function ComboBox:GetSelection()
    if (self.selection == -1) then
        return nil;
    else
        local item = self.listBox:GetItem(self.selection);
        return item.value;
    end
end

function ComboBox:SetSize(width, height)
    Turbine.UI.Control.SetSize(self, width, height);
    self:Layout();
end

function ComboBox:SetEnabled(enabled)
    Turbine.UI.Control.SetEnabled(self, enabled);
    if (enabled) then
        self.label:SetForeColor(ComboBox.ItemColor);
        self.arrow:SetBackground(0x41007e1a);
    else
        self:CloseDropDown();
        self.label:SetForeColor(ComboBox.DisabledColor);
        --self.arrow:SetBackground();--same as 0x41007e1a but disable (greyed)
    end
end

function ComboBox:Layout()
    local width, height = self:GetSize();
    self.label:SetSize(width - 4, height - 4);
    self.label:SetPosition(2, 2);
    self.arrow:SetPosition(width - 2 - 16, 2 + ((height - 4 - 16) / 2));
end

function ComboBox:ShowDropDown()
    -- close the existing drop down if one is open
    ComboBox.Cleanup();
    
    local itemCount = self.listBox:GetItemCount();
    if ((itemCount > 0) and not (self.dropped)) then
        self.dropped = true;
        self.label:SetForeColor(ComboBox.SelectionColor);
        self.arrow:SetBackground(0x41007e19);
        local width, height = self:GetSize();
        --width = width + 10;
        
        -- max size
        local maxItems = itemCount;
        local scrollSize = 0;
        if (maxItems > 5) then
            maxItems = 5;
            scrollSize = 12;
        end

        -- list item sizes
        local listHeight = 0;
        for i = 1, self.listBox:GetItemCount() do
            local item = self.listBox:GetItem(i);
            item:SetWidth(width - 4 - scrollSize);
            if (i <= maxItems) then
                listHeight = listHeight + item:GetHeight();
            end
        end
        
        -- window size
        self.listBox:SetSize(width - 4 - scrollSize, listHeight);
        self.dropDownWindow:SetSize(width, listHeight + 4);
        
        -- scrollbar
        self.scrollBar:SetSize(scrollSize, listHeight);
        self.scrollBar:SetPosition(width - 14, 2);

        -- position
        --local x, y = self:GetParent():PointToScreen(self:GetPosition());
        --self.dropDownWindow:SetPosition(x, y + height + 2);
		--self.dropDownWindow:SetPosition(self.label:GetLeft()-2, self.label:GetTop()-2 + height + 2);
        self.dropDownWindow:SetVisible(true);
        
        -- store the open drop down
        ComboBox.open = self;
    end
end

function ComboBox:CloseDropDown()
    if (self.dropped) then
        self.dropped = false;
        self.dropDownWindow:SetVisible(false);
        self.label:SetForeColor(ComboBox.ItemColor);
        self.arrow:SetBackground(0x41007e1b);
    end
end
