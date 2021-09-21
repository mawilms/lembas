-- frmMain.lua
-- Written by Habna


function frmMain()
	self = Turbine.UI.Window();
	self.WasDrag = false;
	self:SetSize( 24, 24 );
	local screenWidth, screenHeight = Turbine.UI.Display.GetSize()
	local winWidth, winHeight = self:GetSize();

	settings = {};
	settings = Turbine.PluginData.Load( Turbine.DataScope.Character, "HugeBagUtilitySettings" );
	
	if settings == nil then
		self:SetPosition( screenWidth - winWidth - 90, screenHeight - winHeight - 40 );
		SaveSettings();
	end
	
	--Replace if out of screenwidth/screenheight
	if settings.Location.X + winWidth > screenWidth then ResetLoc(); end
	if settings.Location.Y + winHeight > screenHeight then ResetLoc(); end

	self:SetPosition( settings.Location.X, settings.Location.Y );
	self:SetVisible( true );

	reloadButton = Turbine.UI.Button();
	reloadButton:SetParent( self );
	reloadButton:SetPosition( 0, 0 );
	reloadButton:SetSize( self:GetWidth(), self:GetHeight() );
	reloadButton:SetBackground( "HabnaPlugins/HugeBag/Utility/Resources/reload.tga" );

	reloadButton.Click = function( sender, args )
		if not self.WasDrag then ReloadHugeBag(); end
		self.WasDrag = false;
	end

	reloadButton.MouseDown = function( sender, args )
		self.dragStartX, self.dragStartY = args.X, args.Y;
		self.dragging = true;
	end
	
	reloadButton.MouseUp = function( sender, args )
		local screenWidth, screenHeight = Turbine.UI.Display.GetSize();
		if self:GetLeft() < 0 then self:SetLeft( 0 ); end
		if self:GetLeft() + self:GetWidth() > screenWidth then self:SetLeft( screenWidth - self:GetWidth() ); end
		if self:GetTop() < 0 then self:SetTop( 0 ); end
		if self:GetTop() + self:GetHeight() > screenHeight then self:SetTop( screenHeight - self:GetHeight() ); end
		self.dragging = false;
		SaveSettings();
	end
	
	reloadButton.MouseMove = function( sender, args )
		local left, top = self:GetPosition();
  		
		if self.dragging then
			self:SetPosition( left + ( args.X - self.dragStartX ), top + ( args.Y - self.dragStartY ) );
			self.WasDrag = true;
		end
	end
end

function SaveSettings()
	settings = {};
	
	settings.Location = {};
	settings.Location.X, settings.Location.Y = self:GetPosition();

	Turbine.PluginData.Save( Turbine.DataScope.Character, "HugeBagUtilitySettings", settings );
end

function ReloadHugeBag()
	Turbine.PluginManager.RefreshAvailablePlugins()
	local loaded_plugins = Turbine.PluginManager.GetLoadedPlugins()
	local foundHugeBag, foundWrapper = false, false;

	for k,v in pairs(loaded_plugins) do
		if v.Name == "HugeBag" then foundHugeBag = true;
		elseif v.Name == "HugeBag Unloader" then foundWrapper = true;
		end
	end

	if foundWrapper then Turbine.PluginManager.UnloadScriptState( "HugeBag Unloader" ); end
	if foundHugeBag then Turbine.PluginManager.UnloadScriptState( "HugeBag" ); end
	Turbine.PluginManager.LoadPlugin( 'HugeBag' );

	write( "HugeBag Utility: HugeBag was reloaded" );
end

function ResetLoc()
	local screenWidth, screenHeight = Turbine.UI.Display.GetSize()
	local winWidth, winHeight = self:GetSize();
	self:SetPosition( screenWidth - winWidth - 90, screenHeight - winHeight - 40 );
	SaveSettings();
end