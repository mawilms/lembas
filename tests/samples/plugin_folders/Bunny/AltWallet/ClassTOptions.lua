
-- *************************************************
-- Opciók kezelése
-- *************************************************
TOptions = class(Turbine.Object);

-- Kontruktor
-- ===================================
function TOptions:Constructor()
	Turbine.Object.Constructor( self );
	self.icoLeft = 100;
	self.icoTop = 5;
	self.mainLeft = windowX;
	self.mainTop = windowY;
	self.cbFreep = true;
	self.cbCreep = false;
end

-- Feltölti adatokkal a struktúrát
-- ===================================
function TOptions:LoadData()
	self:LoadState();
	if switchIcon ~= nil then
		switchIcon:SetPosition(self.icoLeft, self.icoTop);
	end
	if walletWindow ~= nil then
		walletWindow:SetPosition(mainLeft,mainTop);
	end
end

-- PluginData fájl beolvasása
-- ===================================
function TOptions:LoadState()
	debug("@TOptions:LoadState()");
	local euroFormat=(tonumber("1,000")==1);
	if euroFormat then
 		function euroNormalize(value) return tonumber((string.gsub(value,"%.",","))) end
	else
   		function euroNormalize(value) return tonumber((string.gsub(value,",","."))) end
	end
	local obj = Turbine.Object();
	pcall(function() obj = PatchDataLoad( Turbine.DataScope.Character, "BnyAltWalletOptions")	end	);
	if obj ~= nil then
		self.icoLeft= obj.icoLeft;
		self.icoTop = obj.icoTop;
		self.mainLeft = obj.mainLeft;
		self.mainTop = obj.mainTop;
	end
	
	obj = nil;
	obj = Turbine.Object();
	pcall(function() obj = PatchDataLoad( Turbine.DataScope.Server, "BnyAltWalletSOptions")	end	);
	if obj ~= nil then
		self.cbFreep = obj.cbFreep;
		self.cbCreep = obj.cbCreep;
	end
end

-- Adatok PluginData fájlba írása
-- ===================================
function TOptions:SaveState()
	debug("@TOptions:SaveState()");
	local obj = Turbine.Object();
	obj.icoLeft = self.icoLeft;
	obj.icoTop = self.icoTop;
	obj.mainLeft = self.mainLeft;
	obj.mainTop = self.mainTop;
	pcall(function() PatchDataSave( Turbine.DataScope.Character, "BnyAltWalletOptions", obj) end);
	
	obj = nil;
	obj = Turbine.Object();
	obj.cbFreep = self.cbFreep;
	obj.cbCreep = self.cbCreep;
	pcall(function() PatchDataSave( Turbine.DataScope.Server, "BnyAltWalletSOptions", obj) end);
end

