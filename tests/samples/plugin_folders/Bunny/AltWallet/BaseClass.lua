import "Bunny.AltWallet.ClassTWallet";
import "Bunny.AltWallet.ClassTOptions";

-- *************************************************
-- Label osztály
-- *************************************************
TLabel = class(Turbine.UI.Label);
function TLabel:Constructor(text, left, top, width, height)
	Turbine.UI.Label.Constructor( self );
	if (width ~= nil) and (height ~= nil) and (left ~= nil) and (top ~= nil) and (text ~= nil) then
		self:SetSize(width, height);		
		self:SetPosition(left, top);
		self:SetText(text);
	end
end

-- *************************************************
-- Label osztály
-- *************************************************
TEdit = class(Turbine.UI.Lotro.TextBox);
function TEdit:Constructor(left, top, width, height)
	Turbine.UI.Lotro.TextBox.Constructor( self );
	if (width ~= nil) and (height ~= nil) and (left ~= nil) and (top ~= nil) then
		self:SetSize(width, height);		
		self:SetPosition(left, top);
	end
end

-- *************************************************
-- Gyári Button osztály
-- *************************************************
TButton = class(Turbine.UI.Lotro.Button);
function TButton:Constructor(text, left, top, width, height)
	Turbine.UI.Lotro.Button.Constructor( self );
	if (width ~= nil) and (height ~= nil) and (left ~= nil) and (top ~= nil) and (text ~= nil) then
		self:SetSize(width, height);		
		self:SetPosition(left, top);
		self:SetText(text);
	end
end

-- *************************************************
-- Image osztály
-- *************************************************
TImage = class(Turbine.UI.Control);
function TImage:Constructor(url, left, top, width, height)		
	Turbine.UI.Control.Constructor( self );
	if (width ~= nil) and (height ~= nil) and (left ~= nil) and (top ~= nil) and (url ~= nil) then
		self:SetSize(width, height);
		self:SetPosition(left, top);
		self:SetBackground(url);
		self:SetBlendMode(Turbine.UI.BlendMode.Overlay);
	end	
end

-- *************************************************
-- Saját grafikus button osztály
-- *************************************************
TImageButton = class(Turbine.UI.Button);
function TImageButton:Constructor(left, top, width, height, normal, pressed, rollover)
	Turbine.UI.Button.Constructor( self );
	if (width ~= nil) and (height ~= nil) and (left ~= nil) and (top ~= nil) then
		self:SetSize(width, height);		
		self:SetPosition(left, top);
	end
	if normal ~= nil then
		self:SetBlendMode(Turbine.UI.BlendMode.Overlay);
		self:SetBackground(normal)
		self.MouseLeave=function() self:SetBackground(normal) end
		if rollover ~= nil then
			self.MouseEnter=function() self:SetBackground(rollover) end		
			self.MouseUp=function() self:SetBackground(rollover) end	
		end
		if pressed ~= nil then
			self.MouseDown=function() self:SetBackground(pressed) end			
		end
	end
end

-- *************************************************
-- Tree Root sora
-- *************************************************
MyTreeNode = class( Turbine.UI.TreeNode );
function MyTreeNode:Constructor(text)
	Turbine.UI.TreeNode.Constructor( self );
	self:SetSize( treeViewW-10, 20 );
	local szin = Turbine.UI.Color(rgb(236), rgb(201), rgb(73) );
	local sor = TLabel(text,0,0,treeViewW-50, 18);
	sor:SetFont(Turbine.UI.Lotro.Font.Verdana18);
	sor:SetForeColor(szin);
	sor:SetParent(self);	
end

-- *************************************************
-- Egy item sora osztály
-- *************************************************
MyItemNode = class( Turbine.UI.TreeNode );
function MyItemNode:Constructor(item , oneCharName )
	local szin = boundColor;
	local qty = 0;
	if item["acc"] ~= nil then
		szin = accountBoundColor;
		qty = item["qty"];
	else
		qty = item["charQty"][oneCharName];		
	end
	if qty == nil then qty = 0 end;
	if qty>0 then
		Turbine.UI.TreeNode.Constructor( self );
		self:SetSize( treeViewW-10, 18 );
		local sor = TLabel(item["name"],0,0,treeViewW-50, 16);
		sor:SetFont(Turbine.UI.Lotro.Font.Verdana14);
		sor:SetForeColor(szin);
		sor:SetParent(self);	

		local sor = TLabel(qty,treeViewW-98, 0, 50, 16);
		sor:SetFont(Turbine.UI.Lotro.Font.Verdana14);
		sor:SetForeColor(boundColor);
		sor:SetTextAlignment( Turbine.UI.ContentAlignment.TopRight );
		sor:SetParent(self);	

		local kep = TImage(item["ico"],treeViewW-45, 0, 16, 16);
		kep:SetParent(self);			
	else
		return false;
	end
end

-- *************************************************
-- Pénzem
-- *************************************************
MyCoinNode = class( Turbine.UI.TreeNode );
function MyCoinNode:Constructor(money , summa)		
	Turbine.UI.TreeNode.Constructor( self );
	self:SetSize( treeViewW-10, 18 );	
	
	local noteTextW = 242;
	local cp=math.fmod(money,100);
	money=(money-cp)/100;
	local sp=math.fmod(money,1000);
	local gp=(money-sp)/1000;
	
	local sor = TLabel(moneyItemName,0,0,noteTextW, 16);
	sor:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	if summa then
		sor:SetForeColor(accountBoundColor);
		sor:SetText("All " .. sor:GetText());
	else
		sor:SetForeColor(boundColor);
	end		
	sor:SetParent(self);			
	
	sor = TLabel(gp,noteTextW-20,0,50,16);
	sor:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	sor:SetForeColor(boundColor);
	sor:SetTextAlignment( Turbine.UI.ContentAlignment.TopRight );
	sor:SetParent(self);			
	local kep = TImage(pluginRoot .. "resource/Gold_small.tga",noteTextW+33,0,17,14);
	kep:SetParent(self);			
	
	sor = TLabel(sp,noteTextW+50,0,30,16);
	sor:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	sor:SetForeColor(boundColor);
	sor:SetTextAlignment( Turbine.UI.ContentAlignment.TopRight );
	sor:SetParent(self);			
	kep = TImage(pluginRoot .. "resource/Silver_small.tga",noteTextW+83,0,17,14);
	kep:SetParent(self);			
	
	sor = TLabel(cp,noteTextW+100,0,30,16);
	sor:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	sor:SetForeColor(boundColor);
	sor:SetTextAlignment( Turbine.UI.ContentAlignment.TopRight );
	sor:SetParent(self);			
	local kep = TImage(pluginRoot .. "resource/Copper_small.tga",noteTextW+133,0,17,14);
	kep:SetParent(self);			

end

-- *************************************************
-- Desktop ikon kezelés ki-be kapcsoláshoz
-- Thanks to Garan for idea!
-- *************************************************
TDesktopIcon = class(Turbine.UI.Window);
function TDesktopIcon:Constructor(url, left, top, width, height)		
	Turbine.UI.Window.Constructor( self );	
	
	local left=optionsObj.left;
	local top=optionsObj.top;
--	local top=Turbine.UI.Display.GetHeight()-self:GetHeight()-1;
	self.MoveX=-1;
	self.MoveY=0;
	self.Moving=false;
	self.moving_ico = false;
	
	self:SetSize(32,32);
	self:SetBackground(pluginRoot .. "resource/altwallet.tga");
	self:SetBlendMode(AlphaBlend);
	self:SetOpacity(.5);
	self:SetPosition( left, top );
	self:SetZOrder(self:GetZOrder()+1);
	self:SetVisible(true);
	
	self.MouseEnter = function() self:SetOpacity(1) end
	self.MouseLeave = function() self:SetOpacity(.5) 
		self:SetBackground(pluginRoot .. "resource/altwallet.tga");	
		self.moving_ico = false;
	end
	self.MouseClick = function(sender,args)
		if self.Moving then
			self.Moving=false;
			self.MoveX=-1;
		else
			if walletWindow:IsVisible() then
				debug("Ikon toggle off");
				optionsWindow:Close();
				walletWindow:Close();
			else
				debug("Ikon toggle on");
				eventWalletChange();
				walletWindow:SetVisible();
				walletWindow:Activate();	
			end
		end
	end
	self.MouseDown=function(sender,args)
		if self:IsControlKeyDown() then
			self.MoveX=args.X;
			self.MoveY=args.Y;
		end
		if self:IsControlKeyDown() then
			if 	self.moving_ico == false then
				self:SetBackground(pluginRoot .. "resource/altwallet_moving.tga");
				self.moving_ico = true;
			end
		else
			if 	self.moving_ico == true then
				self:SetBackground(pluginRoot .. "resource/altwallet.tga");	
				self.moving_ico = false;
			end
		end
	end
	self.MouseUp=function(sender,args)
		self.MoveX=-1;
		self.MoveY=0;
		if (optionsObj.icoLeft ~= self:GetLeft()) or (optionsObj.icoTop ~= self:GetTop()) then
			optionsObj.icoLeft = self:GetLeft();
			optionsObj.icoTop = self:GetTop();
			optionsObj:SaveState();
			opIcoLeftSB:SetValue(optionsObj.icoLeft);
			opIcoTopSB:SetValue(optionsObj.icoTop);			
		end
	end
	self.MouseMove=function(sender,args)
		if self.MoveX~=-1 and (args.X~=self.MoveX or args.Y~= self.MoveY) then
			self.Moving=true;
			local newLeft=self:GetLeft()-(self.MoveX-args.X)
			local newTop=self:GetTop()-(self.MoveY-args.Y)
			if newLeft<0 then newLeft=0 end;
			if newLeft>(Turbine.UI.Display.GetWidth()-self:GetWidth()) then newLeft=Turbine.UI.Display.GetWidth()-self:GetWidth() end;
			if newTop<0 then newTop=0 end;
			if newTop>(Turbine.UI.Display.GetHeight()-self:GetHeight()) then newTop=Turbine.UI.Display.GetHeight()-self:GetHeight() end;
			self:SetPosition(newLeft,newTop);

		end
	end
	self.Update=function(sender,args)
		self.SetWantsUpdates(false); -- turn updates off... no need to waste machine cycles on this
	end
end
