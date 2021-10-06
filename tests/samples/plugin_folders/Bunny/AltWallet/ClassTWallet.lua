-- *************************************************
--	Wallet objektum
-- *************************************************
TWallet = class(Turbine.Object);
-- Kontruktor
-- ===================================
function TWallet:Constructor()
	Turbine.Object.Constructor( self );
	self.charList = {};
	self.itemList = {};
	self.moneyList = {};
	self.storeEnable = true;
end

-- Engedélyezett a feltöltés?
-- ===================================
function TWallet:CheckStorePermission()
	if (isFreep and optionsObj.cbFreep) or ((isFreep==false) and optionsObj.cbCreep) then
		self.storeEnable = true;
		if string.sub(charName,1,1) == "~" then	-- session play
			self.storeEnable = false;
			debug("Session play detected.");
		end
	else
		self.storeEnable = false;		
	end
	
	if self.storeEnable then debug("Store enabled") else debug("Store disabled") end;
end

-- Feltölti adatokkal a struktúrát
-- ===================================
function TWallet:LoadData()
	self:CheckStorePermission();
	self:LoadState();
	self:RefreshWallet();
	self:SaveState();
end

-- Karakter a karitömbbe
-- ===================================
function TWallet:AddChar()
	if not self.storeEnable then return false end
	local found = false;
	for index, value in pairs(self.charList) do
		if value == charName then found = true end;
	end
	if found == false then
		self.charList[#self.charList+1] = charName 
		table.sort(self.charList,function (arg1,arg2) if tostring(arg1)<tostring(arg2) then return(true) end end);
	end;
end

-- Item az itemtömbbe
-- ===================================
function TWallet:AddItem(itemArray)
	if not self.storeEnable then return false end	
	local itemName = itemArray["name"];
	if self.itemList[itemName] == nil then
		self.itemList[itemName] = {};
		self.itemList[itemName]["name"] = itemArray["name"];
		self.itemList[itemName]["desc"] = itemArray["desc"];
		self.itemList[itemName]["ico"] = itemArray["ico"];
		self.itemList[itemName]["big"] = itemArray["big"];
		self.itemList[itemName]["charQty"] = {};
	end
	self.itemList[itemName]["charQty"][charName] = itemArray["qty"];	
end

-- Zsé a zsétömbbe
-- ===================================
function TWallet:AddMoney()
	if not self.storeEnable then return false end
	self.moneyList[charName] = localPlayer:GetAttributes():GetMoney();
end

-- Saját adatok feltöltése az itemtömbbe
-- ===================================
function TWallet:RefreshWallet()
	debug("@TWallet:RefreshWallet()");
	self:AddChar();
	self:AddMoney();
	majorItemArray = nil;
	majorItemArray = {};
	accountItemArray = nil;
	accountItemArray = {};
	-- Saját mennyiségek üresre
	for index, value in pairs(self.itemList) do
		if value["charQty"][charName] ~= nil then
			self.itemList[index]["charQty"][charName] = nil;
		end
	end
		
	walletSize = playerWallet:GetSize();	
	for f=1, walletSize do
		walletItem = playerWallet:GetItem(f);
		itemId = walletItem:GetName();
		itemArray = {};
		itemArray["desc"] = walletItem:GetDescription();
		itemArray["ico"] = walletItem:GetSmallImage();
		itemArray["big"] = walletItem:GetImage();
		itemArray["qty"] = walletItem:GetQuantity();		
		itemArray["acc"] = walletItem:IsAccountItem();
		itemArray["name"] = itemId;
		
		local found = false;
		for k=1, #majorNames do
			if majorNames[k] == itemId then found = true end;
		end
		if found then
			majorItemArray[#majorItemArray+1] = itemArray;	
		elseif walletItem:IsAccountItem() then
			accountItemArray[#accountItemArray+1] = itemArray;	
		else
			self:AddItem(itemArray);
		end		
	end
	-- Üres item törlése
	local i=0;
	for index, value in pairs(self.itemList) do
		i = 0;
		for k,v in pairs(value["charQty"]) do i=i+1 end
		if i==0 then
			self.itemList[index] = nil;
			debug("item:"..index.." full clear.");
		end		
	end
end

-- PluginData fájl beolvasása
-- ===================================
function TWallet:LoadState()
	debug("@TWallet:LoadState()");
	local euroFormat=(tonumber("1,000")==1);
	if euroFormat then
 		function euroNormalize(value)
   			return tonumber((string.gsub(value,"%.",",")));
		end
	else
   		function euroNormalize(value)
   			return tonumber((string.gsub(value,",",".")));
  		end
	end
	local obj = Turbine.Object();
	pcall(function() obj = PatchDataLoad( Turbine.DataScope.Server, "BnyAltWallet")	end	);
	if obj ~= nil then
		if obj.charList ~= nil then
			self.charList = obj.charList;			
		end
		if obj.itemList ~= nil then
			self.itemList = obj.itemList;
		end
		if obj.moneyList ~= nil then
			self.moneyList = obj.moneyList;
		end
	end
end

-- Adatok PluginData fájlba írása
-- ===================================
function TWallet:SaveState()
	debug("@TWallet:SaveState()");
	if not self.storeEnable then return false end
	local obj = Turbine.Object();
	obj.charList = self.charList;
	obj.itemList = self.itemList;
	obj.moneyList = self.moneyList;	
	table.sort(obj.charList,function (arg1,arg2) if tostring(arg1)<tostring(arg2) then return(true) end end);
	pcall(function() PatchDataSave( Turbine.DataScope.Server, "BnyAltWallet", obj) end);
end

-- Egy karakter adatainak törlése
-- ===================================
function TWallet:DeleteCharacter(selectedChar)
	debug("@TWallet:DeleteCharacter() "..selectedChar);
	
	local found = false;
	local i = 0;

	-- charlist
	for index, value in pairs(self.charList) do
		if value == selectedChar then 
			debug("charlist found"); 
			self.charList[index] = nil;
			found = true;
		end;
	end
	if not found then return false end;
		
	-- moneylist
	for index, value in pairs(self.moneyList) do
		if index == selectedChar then 
			debug("moneylist found"); 
			self.moneyList[index] = nil 
		end;
	end
	
	for index, value in pairs(self.itemList) do
		if value["charQty"][selectedChar] ~= nil then
			debug("[" .. self.itemList[index]["charQty"][selectedChar] .. "] "..index.." removed.")
			self.itemList[index]["charQty"][selectedChar] = nil;
		end
		i = 0;
		for k,v in pairs(value["charQty"]) do i=i+1 end
		if i==0 then
			self.itemList[index] = nil;
			debug(index.." full clear.");
		end		
	end
	
	self:SaveState();
	if selectedChar == charName then self.storeEnable = false end
	return true;
end
