--This class is free software
-- you an use it without credits.
--
-- Ooz
--
-- Example:
--	self.symbolCallback = function()
--		-- ... do something ...
--	end
--  self.symbol = MinimizedIcon("YourPackage/YourPlugin/YourPluginSymbol.tga", 48, 48, self.symbolCallback);
--

import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";

MinimizedIcon = class( Turbine.UI.Window );

function MinimizedIcon:Constructor(image, width, height, callback)
	Turbine.UI.Window.Constructor( self );
	
	self:SetOpacity( 1 );
	self:SetVisible(true);
	self:SetZOrder(10000); -- Always in front
	self:SetMouseVisible(true);
	self:SetWantsUpdates(true);

	self.passiveImage = image;
	self.icon = Turbine.UI.Control();
	self.icon:SetParent(self);
	self.icon:SetBackground(self.passiveImage);
	self.defaultOpacity = 1;

	self.trigger = Turbine.UI.Button();
	self.trigger:SetParent(self);
	self.trigger:SetZOrder(1);
	
	self:SetSize(width, height);
	local sh = Turbine.UI.Display.GetHeight()-self:GetHeight()-1;
	self:SetPosition(1, sh);
	self.drag = false;
	
	self.active = false;
	self.framesPerActiveImage = 20;
	
	self.MouseEnter = function( sender, args )
		self:SetOpacity(1.0);
	end
	self.MouseLeave = function( sender, args )
		self:SetOpacity(self.defaultOpacity);
	end
	self.trigger.MouseClick = function( sender, args )
		if not self.thresholdTrigger then
			if(self.IsShiftKeyDown())then
				if(settings.isLocked == false)then
					settings.isLocked = true;
					Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " : " .. Strings.PluginLocked);
				else
					settings.isLocked = false;
					Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. " : " .. Strings.PluginUnlocked);
				end
				SaveSettings();
			elseif(settings.isWindowVisible == "false") then
				BurglarHelperWindow:SetVisible(true);
				BurglarHelperWindow:SetZOrder(BurglarHelperWindow:GetZOrder()+1);
				settings.isWindowVisible = "true" ;
				SaveSettings();
			else
				BurglarHelperWindow:SetVisible(false);
				settings.isWindowVisible = "false" ;
				SaveSettings();
			end
		end
	end
	self.trigger.MouseDown = function( sender, args )
			self.drag = true;
			self.thresholdTrigger = false;
			self.mx0 = args.X;
			self.my0 = args.Y;
	end
	self.trigger.MouseUp = function( sender, args )
		self.drag = false;
	end
	self.trigger.MouseMove = function( sender, args )
		if(settings.altEnable == true)then
			if self.drag and self.IsAltKeyDown() then
				local dx = args.X - self.mx0;
				local dy = args.Y - self.my0;
				-- Turbine.Shell.WriteLine("dragged "..dx.." "..dy);
				if (self.thresholdTrigger or dx>3 or dx<-3 or dy>3 or dy<-3) then
					self.thresholdTrigger = true;
					local x = self:GetLeft()+dx;
					local y = self:GetTop()+dy;
					if x<0 then x=0 end;
					if y<0 then y=0 end;
					local sh = Turbine.UI.Display.GetHeight()-self:GetHeight()-1;
					local sw = Turbine.UI.Display.GetWidth()-self:GetWidth()-1;
					if x>sw then x=sw end;
					if y>sh then y=sh end;
					self:SetLeft(x);
					self:SetTop(y);
				end
			end
		else
			if self.drag then
				local dx = args.X - self.mx0;
				local dy = args.Y - self.my0;
				-- Turbine.Shell.WriteLine("dragged "..dx.." "..dy);
				if (self.thresholdTrigger or dx>3 or dx<-3 or dy>3 or dy<-3) then
					self.thresholdTrigger = true;
					local x = self:GetLeft()+dx;
					local y = self:GetTop()+dy;
					if x<0 then x=0 end;
					if y<0 then y=0 end;
					local sh = Turbine.UI.Display.GetHeight()-self:GetHeight()-1;
					local sw = Turbine.UI.Display.GetWidth()-self:GetWidth()-1;
					if x>sw then x=sw end;
					if y>sh then y=sh end;
					self:SetLeft(x);
					self:SetTop(y);
				end
			end
		end
	end
	self.Update = function(sender, args)
		if self.active then
			if not Turbine.Gameplay.LocalPlayer.GetInstance():IsInCombat() then
				self.frameCount = self.frameCount +1;
				if self.frameCount>framesPerActiveImage then
					self.frameCount = 0;
					self.currentImageIndex = self.currentImageIndex + 1;
					if self.currentImageIndex>#self.imageTable then
						self.currentImageIndex = 1;
					end
					self.icon:SetBackground(self.imageTable[self.currentImageIndex]);
					if self.activeTickCallback~=nil then
						self.activeTickCallback();
					end
				end
			end
		end
	end

end

function MinimizedIcon:SetDefaultOpacity(opacity)
	self.defaultOpacity = opacity;
	self:SetOpacity(opacity);
	self:SetBlendMode(Turbine.UI.BlendMode.Overlay)
end

function MinimizedIcon:SetActiveAnimation(imageTable)
	self.imageTable = imageTable;
	self.currentImageIndex = 1;
	self.frameCount = 0;
end

function MinimizedIcon:SetActive(value)
	if value then
		self:SetOpacity( .90 );
		if self.imageTable==nil or #self.imageTable==0 then
			self.imageTable	= {self.passiveImage}; -- graceful error handling
		end
		self:SetWantsUpdates(true);
		self.active = true;
	else
		self.active = false;
		self:SetWantsUpdates(false);
		self:SetOpacity( .25 );
		self.icon:SetBackground(self.passiveImage);
	end
end

function MinimizedIcon:SetFramesPerActiveImage(value)
	framesPerActiveImage = value;
end

function MinimizedIcon:SetActiveTickCallback(callback)
	self.activeTickCallback = callback;
end

function MinimizedIcon:SetSize(width, height)
	Turbine.UI.Control.SetSize(self, width, height);
	self.icon:SetSize(width, height);
	self.trigger:SetSize(width, height);
end

function MinimizedIcon:SetHeight(height)
	self:SetSize(self:GetWidth(), height)
end

function MinimizedIcon:SetWidth(width)
	self:SetSize(width, self:GetHeight())
end

function MinimizedIcon:SetText(text)
	self.trigger:SetText(text);
end

function MinimizedIcon:SetFont(font)
	self.trigger:SetFont(font);
end

function MinimizedIcon:SetFontStyle(style)
	self.trigger:SetFontStyle(style);
end

function MinimizedIcon:SetForeColor(color)
	self.trigger:SetForeColor(color);
end

function MinimizedIcon:SetOutlineColor(color)
	self.trigger:SetOutlineColor(color);
end

