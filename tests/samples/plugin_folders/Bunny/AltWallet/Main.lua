import "Turbine";
import "Turbine.UI";
import "Turbine.UI.Lotro";
import "Turbine.Gameplay";
import "Bunny.AltWallet.Class";
import "Bunny.AltWallet.Type";
import "Bunny.AltWallet.VindarPatch";
import "Bunny.AltWallet.BaseFunc";
import "Bunny.AltWallet.BaseClass";

-- Globális változók
debugMode = false;

shellCommandName = "altwallet";
pluginRoot = "/Bunny/AltWallet/";
pluginName = "AltWallet";
debugPluginName = "AltWallet";
pluginFullIdText = "";

majorNames = {"Mithril Coin","Commendation";"Shard";"Seal";"Medallion";"Mark";"Star of Merit"};
moneyItemName = "Gold, Silver, Copper";

localPlayer=Turbine.Gameplay.LocalPlayer:GetInstance();
charName=localPlayer:GetName();  -- karineve
playerWallet=localPlayer:GetWallet();
if localPlayer:GetAlignment() == Turbine.Gameplay.Alignment.FreePeople then
	isFreep = true
else
	isFreep = false
end;

windowWidth = 450;
windowHeight = 550;
optionWidth = 400;
optionHeight = 300;

windowX = (Turbine.UI.Display:GetWidth()-windowWidth)/2;
windowY = (Turbine.UI.Display:GetHeight()-windowHeight)/2;
treeViewW = windowWidth-30;
accountBoundColor = Turbine.UI.Color(0,0.7,0);
boundColor = Turbine.UI.Color(0.9,0.9,0.9);
filterText = "";

-- Globális osztályváltozók
optionsObj = TOptions();	-- beállítások
accountItemArray = {};  -- account boundos tömb
majorItemArray = {};	-- kiemelt cuccok elsõ fülre
walletObj = TWallet();	-- Wallet adatok és odatartozó függvények osztálya

walletWindow = Turbine.UI.Lotro.Window(); -- Nagyablak
optionsWindow = Turbine.UI.Lotro.Window();
	
	-- main window
switchIcon  = TDesktopIcon();
optionsPanel = Turbine.UI.Control();
searchBox = Turbine.UI.Control();
searchLabel = TLabel("SEARCH:",5,0,60,30);
searchEdit = TEdit(70,5,200,20);
treeView = Turbine.UI.TreeView();
scriptTextScrollBar = Turbine.UI.Lotro.ScrollBar();
refreshButton = TButton("Refresh",(windowWidth-100)/2,windowHeight-40,100,20);
optionsButton = TImageButton(15,40,25,25, pluginRoot .. "resource/options.tga", pluginRoot .. "resource/options_pressed.tga", pluginRoot .. "resource/options_rollover.tga");
expandAllButton = TImageButton(45,47,16,16, pluginRoot .. "resource/expand_all.tga", pluginRoot .. "resource/expand_all_pressed.tga", pluginRoot .. "resource/expand_all_rollover.tga");
collapseAllButton = TImageButton(61,47,16,16, pluginRoot .. "resource/collapse_all.tga", pluginRoot .. "resource/collapse_all_pressed.tga", pluginRoot .. "resource/collapse_all_rollover.tga");

	-- option window
opCbFreep = Turbine.UI.Lotro.CheckBox();
opCbCreep = Turbine.UI.Lotro.CheckBox();
opLabelCharMenu = TLabel("Select a character:",1,1,130,18);
opEditSelectedChar = TEdit(1,1,150,18);
charMenu = Turbine.UI.ContextMenu();
charMenuItems = charMenu:GetItems();
imgCharMenuDrop = TImageButton(1,1, 25, 25, pluginRoot .. "resource/fellowshipmaker_normal.tga", pluginRoot .. "resource/fellowshipmaker_pressed.tga", pluginRoot .. "resource/fellowshipmaker_rollover.tga");
opDeleteCharButton = TButton("Remove the selected character", 1, 1, 300, 18);
optionsSaveButton = TButton("Save the options",1,1,300,18);
opIcoLeftSB = Turbine.UI.Lotro.ScrollBar();
opIcoTopSB = Turbine.UI.Lotro.ScrollBar();
opIcoLeftLabel = TLabel("Desktop icon left distance:",50, 1, 300,18);
opIcoTopLabel = TLabel("Desktop icon top distance:",50, 1, 300,18);

--optionsSaveButton = TButton("Save",70,optionHeight-80,100,20);
--optionsCancelButton = TButton("Cancel",220,optionHeight-80,100,20);

-- *************************************************
-- Keresés eventfüggvénye
-- *************************************************
function SetFilter(sender, args)
	-- debug("@SetFilter()");
	filterText = searchEdit:GetText(); 
	RepaintWallet();
end

-- *************************************************
-- Sorbarendezés csak így megy, egy füst alatt szûrés is
-- *************************************************
function SelectMyItems(itemList,oneCharName)
	-- debug("@SelectMyItems() " .. oneCharName);
	
	local myItems = {};	
	local i = 0;
	local enabled = true;
	for f in pairs(itemList) do	
		enabled = true;
		if string.len(filterText)>0 then	-- Ha van filter
			if string.find(string.lower(f),filterText) == nil then enabled = false end;
		end
		if itemList[f]["charQty"][oneCharName] == nil then enabled = false; end;
		if itemList[f]["charQty"][oneCharName] == 0 then enabled = false; end;
		if enabled then table.insert(myItems, f) end;
	end
	table.sort(myItems);
	local iter = function ()   -- iterator function
	  i = i + 1;
	  if myItems[i] == nil then return nil
	  else return myItems[i], itemList[myItems[i]]
	  end
	end
	return iter;
end

-- *************************************************
-- Opciók mentése
-- *************************************************
function OptionsSave()
	debug("@OptionsSave()");
	optionsObj:SaveState();
	walletObj:CheckStorePermission();
	--optionsWindow:Close();
end

-- *************************************************
function OptionsCancel()
	debug("@OptionsCancel()");
	-- optionsWindow:Close();
end


-- *************************************************
-- Options ablak adatoka frissítése
-- *************************************************
function RepaintOptionsWindow()
	debug("@RepaintOptionsWindow()");
	
	opCbCreep:SetChecked(optionsObj.cbCreep);
	opCbFreep:SetChecked(optionsObj.cbFreep);
	opEditSelectedChar:SetText("");
	charMenuItems:Clear();
	charMenuItems:Add(Turbine.UI.MenuItem("- clear -"));
	for k, v in pairs(walletObj.charList) do
		charMenuItems:Add(Turbine.UI.MenuItem(v));
	end
	for i=1, charMenuItems:GetCount() do
		charMenuItems:Get(i).Click = function(sender, args) 
			if sender:GetText() == "- clear -" then
				opEditSelectedChar:SetText("");
			else
				opEditSelectedChar:SetText(sender:GetText());
			end
			charMenu:Close(); 
		end;
	end
	
end

-- Egy karakter adatainak törlését választotta
-- *************************************************
function DeleteCharData(sender, args)
	debug("@DeleteCharData()");
	local found = false;
	local selectedChar = opEditSelectedChar:GetText();
	for index, value in pairs(walletObj.charList) do
		if value == selectedChar then found = true end;
	end
	if found then
		if walletObj:DeleteCharacter(selectedChar) then
			RepaintWallet();
			RepaintOptionsWindow();
		end
	end		
end


-- *************************************************
-- Options ablak alapállapotának beállítása
-- *************************************************
function ResetOptionsWindow()
	debug("@ResetOptionsWindow()");
	
-- eltávolítva a pluginmanager opciós panel miatt

--	local oWindowX = (Turbine.UI.Display:GetWidth()-optionWidth)/2;
--	local oWindowY = (Turbine.UI.Display:GetHeight()-optionHeight)/2;
	
--	optionsWindow:SetSize(optionWidth, optionHeight);
--	optionsWindow:SetPosition(oWindowX,oWindowY);
--	optionsWindow:SetText("Alt Wallet - Options");	
	
--	optionsPanel:SetSize(optionsWindow:GetWidth()-20, optionsWindow:GetHeight()-50);
--	optionsPanel:SetPosition(10,25);
--	optionsPanel:SetParent(optionsWindow);
	
	optionsPanel:SetSize(400, 350);
	local cY = 20;
	
	opCbFreep:SetPosition(30,cY);
	opCbFreep:SetSize(optionsPanel:GetWidth()-10, 18);
	opCbFreep:SetText(" Store new Free People data");
	opCbFreep:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	opCbFreep:SetForeColor(Turbine.UI.Color(1,1,1));
	opCbFreep:SetParent(optionsPanel);
	opCbFreep.CheckedChanged = function (sender, args) optionsObj.cbFreep=opCbFreep:IsChecked() end;
	cY = opCbFreep:GetTop() + opCbFreep:GetHeight();
	
	opCbCreep:SetPosition(30,cY+2);
	opCbCreep:SetSize(optionsPanel:GetWidth()-10, 18);
	opCbCreep:SetText(" Store new Monster Player data");
	opCbCreep:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	opCbCreep:SetForeColor(Turbine.UI.Color(1,1,1));
	opCbCreep:SetParent(optionsPanel);
	opCbCreep.CheckedChanged = function (sender, args) optionsObj.cbCreep=opCbCreep:IsChecked() 	end;
	cY = opCbCreep:GetTop() + opCbCreep:GetHeight();
	
	opIcoLeftLabel:SetText("Desktop icon left distance: " .. optionsObj.icoLeft .. "px");	
	opIcoLeftLabel:SetPosition(30, cY+20);
	opIcoLeftLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	opIcoLeftLabel:SetForeColor(Turbine.UI.Color(1,1,1));
	opIcoLeftLabel:SetParent(optionsPanel);
	cY = opIcoLeftLabel:GetTop() + opIcoLeftLabel:GetHeight();
		
	opIcoLeftSB:SetPosition(30, cY);
	opIcoLeftSB:SetParent(optionsPanel);
	opIcoLeftSB:SetSize(300,10);
	opIcoLeftSB:SetMaximum(Turbine.UI.Display:GetWidth()-switchIcon:GetWidth());
	opIcoLeftSB:SetValue(optionsObj.icoLeft);
	opIcoLeftSB.ValueChanged = function(s,a)
		opIcoLeftLabel:SetText("Desktop icon left distance: " .. opIcoLeftSB:GetValue() .. "px");
		optionsObj.icoLeft = opIcoLeftSB:GetValue();
		switchIcon:SetPosition(optionsObj.icoLeft,optionsObj.icoTop);
	end
	cY = opIcoLeftSB:GetTop() + opIcoLeftSB:GetHeight();
	
	opIcoTopLabel:SetText("Desktop icon top distance: " .. optionsObj.icoTop .. "px");	
	opIcoTopLabel:SetPosition(30, cY+10);
	opIcoTopLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	opIcoTopLabel:SetForeColor(Turbine.UI.Color(1,1,1));
	opIcoTopLabel:SetParent(optionsPanel);
	cY = opIcoTopLabel:GetTop() + opIcoTopLabel:GetHeight();
		
	opIcoTopSB:SetPosition(30, cY);
	opIcoTopSB:SetParent(optionsPanel);
	opIcoTopSB:SetSize(300,10);
	opIcoTopSB:SetMaximum(Turbine.UI.Display:GetHeight()-switchIcon:GetHeight());
	opIcoTopSB:SetValue(optionsObj.icoTop);
	opIcoTopSB.ValueChanged = function(s,a)
		opIcoTopLabel:SetText("Desktop icon top distance: " .. opIcoTopSB:GetValue() .. "px");
		optionsObj.icoTop = opIcoTopSB:GetValue();
		switchIcon:SetPosition(optionsObj.icoLeft,optionsObj.icoTop);
	end
	cY = opIcoTopSB:GetTop() + opIcoTopSB:GetHeight();
	
	optionsSaveButton:SetParent(optionsPanel);
	optionsSaveButton:SetPosition(50,cY+10);
	optionsSaveButton.Click = OptionsSave;
	cY = optionsSaveButton:GetTop() + optionsSaveButton:GetHeight();
	
	cY = cY +30;
	opLabelCharMenu:SetPosition(30,cY);
	opLabelCharMenu:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	opLabelCharMenu:SetForeColor(Turbine.UI.Color(1,1,1));
	opLabelCharMenu:SetParent(optionsPanel);
	
	opEditSelectedChar:SetPosition(opLabelCharMenu:GetLeft() + opLabelCharMenu:GetWidth()+2, cY);
	opEditSelectedChar:SetFont(Turbine.UI.Lotro.Font.Verdana14);
	opEditSelectedChar:SetForeColor(Turbine.UI.Color(1,1,1));
	opEditSelectedChar:SetParent(optionsPanel);
	opEditSelectedChar:SetReadOnly();
		
	imgCharMenuDrop:SetPosition(opEditSelectedChar:GetLeft()+opEditSelectedChar:GetWidth()+2, cY-4);
	imgCharMenuDrop:SetParent(optionsPanel);
	imgCharMenuDrop.MouseClick = function() charMenu:ShowMenu() 	end
	cY = opLabelCharMenu:GetTop() + opLabelCharMenu:GetHeight();
	
	opDeleteCharButton:SetPosition(50, cY+10);
	opDeleteCharButton:SetParent(optionsPanel);
	opDeleteCharButton.Click = DeleteCharData;
	cY = opDeleteCharButton:GetTop() + opDeleteCharButton:GetHeight();
	
	-- opIcoTopSB
	
	
--	optionsCancelButton:SetParent(optionsPanel);	
--	optionsCancelButton.Click = OptionsCancel;
	
	RepaintOptionsWindow();
end

-- *************************************************
-- Fõablak alapállapotának beállítása
-- *************************************************
function ResetWindow()
	debug("@ResetWindow()");
	walletWindow:SetSize(windowWidth, windowHeight);
	walletWindow:SetText("      Alt Wallet      ");
    walletWindow:SetVisible(true);
	walletWindow:SetPosition(optionsObj.mainLeft , optionsObj.mainTop);
	walletWindow.PositionChanged = function(sender, args)
		if (optionsObj.mainLeft ~= walletWindow:GetLeft()) or (optionsObj.mainTop ~= walletWindow:GetTop()) then
			optionsObj.mainLeft = walletWindow:GetLeft();
			optionsObj.mainTop = walletWindow:GetTop();
		end
	end
	walletWindow:SetMinimumHeight(180);
	walletWindow:SetMinimumWidth(walletWindow:GetWidth());
	walletWindow:SetMaximumWidth(walletWindow:GetWidth());
	walletWindow:SetResizable(true);
	walletWindow.SizeChanged = function(sender,args)
		treeView:SetSize(  treeViewW, walletWindow:GetHeight()-85-40  );
	    scriptTextScrollBar:SetSize(  10, treeView:GetHeight() );
		refreshButton:SetPosition(  (walletWindow:GetWidth()-100)/2, walletWindow:GetHeight()-40  );
	end
	walletWindow.KeyDown=function(sender, args)
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			walletWindow:Close();
		end
	end
	walletWindow:SetWantsKeyEvents(true);

	searchBox:SetParent( walletWindow );
	searchBox:SetPosition((windowWidth-300)/2, 40 );
	searchBox:SetSize(300, 30);
	
	searchLabel:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	searchLabel:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleRight );
	searchLabel:SetForeColor(Turbine.UI.Color(1, 1, 1));
	searchLabel:SetParent(searchBox);
	
	searchEdit:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	searchEdit:SetParent(searchBox);
	searchEdit:SetMultiline(false);
	searchEdit.TextChanged = SetFilter;
	
    treeView:SetParent( walletWindow );
    treeView:SetPosition( 10, 50+30 );
    treeView:SetSize(  treeViewW, walletWindow:GetHeight()-85-40  );
    treeView:SetBackColor( Turbine.UI.Color(0.95, 0, 0, 0 ) );
    treeView:SetIndentationWidth( 15 );
    
    scriptTextScrollBar:SetOrientation( Turbine.UI.Orientation.Vertical );
    scriptTextScrollBar:SetParent( walletWindow );
    scriptTextScrollBar:SetPosition( treeView:GetWidth()+treeView:GetLeft(), treeView:GetTop() );
    scriptTextScrollBar:SetSize(  10, treeView:GetHeight() );
    treeView:SetVerticalScrollBar( scriptTextScrollBar );
	
	refreshButton:SetPosition(  (walletWindow:GetWidth()-100)/2, walletWindow:GetHeight()-40  );
	
	refreshButton:SetParent( walletWindow );
	refreshButton.Click = eventWalletChange;
	optionsButton:SetParent( walletWindow );
	optionsButton.Click = ShowOptionsWindow;
	expandAllButton:SetParent( walletWindow );
	expandAllButton.Click = function() treeView:ExpandAll() end;
	collapseAllButton:SetParent( walletWindow );
	collapseAllButton.Click = function() treeView:CollapseAll() end;	
	
	walletWindow:Close();
end

-- *************************************************
-- Megjelenítés
-- *************************************************
function RepaintWallet()
	debug("@RepaintWallet()");
	
	table.sort(majorItemArray, function (arg1,arg2) if arg1["name"]<arg2["name"] then return(true) end end);
	table.sort(accountItemArray, function (arg1,arg2) if arg1["name"]<arg2["name"] then return(true) end end);
	
	-- Create the container window.
	
	local enabled = true;
	
    -- Root	
	rootNodes = treeView:GetNodes();
	rootNodes:Clear();
	
	-- Major 
	local majorNode = MyTreeNode("Major shared coins");
	rootNodes:Add( majorNode );
	local subNodes = majorNode:GetChildNodes();
	local sumMoney = 0;
	for k, v in pairs(walletObj.moneyList) do
		sumMoney = sumMoney + v;
	end;
	local node = MyCoinNode(sumMoney, true);
	subNodes:Add( node );
	for key, value in pairs(majorItemArray) do
		local node = MyItemNode(value, charName);
		subNodes:Add( node );
	end
	majorNode:ExpandAll();
				
	-- account bound
	local accountNode = MyTreeNode("Account Bound");
	rootNodes:Add( accountNode );
	local subNodes = accountNode:GetChildNodes();
	for f=1, #accountItemArray do
		local enabled = true;
		if string.len(filterText)>0 then	-- Ha van filter
			if string.find(string.lower(accountItemArray[f]["name"]),filterText) == nil then enabled = false end;
		end
		if enabled then 
			local node = MyItemNode(accountItemArray[f], charName);
			subNodes:Add( node );
		end
	end
	if string.len(filterText)>0 then -- ha van filter találat kinyitom
		if subNodes:GetCount()==0 then accountNode:SetVisible(false) 
		else accountNode:ExpandAll(); end;
	else	
		accountNode:CollapseAll();
	end
	
	-- Karakterek sorban
	for onCharKey, oneCharName in pairs(walletObj.charList) do
		local tempNode = MyTreeNode("Bound to " .. oneCharName);
		rootNodes:Add( tempNode );	
		local subNodes = tempNode:GetChildNodes();
		-- zsé
		enabled = true;
		if string.len(filterText)>0 then	-- Ha van filter
			if string.find(string.lower(moneyItemName),filterText) == nil then enabled = false end;
		end
		if enabled then 
			if walletObj.moneyList[oneCharName] ~= nil then
				local node = MyCoinNode(walletObj.moneyList[oneCharName]);
				subNodes:Add( node );
			end
		end
		-- item
		for key, value in SelectMyItems(walletObj.itemList,oneCharName) do
			local node = MyItemNode(value, oneCharName);
			subNodes:Add( node );			
		end			
		if (string.len(filterText)>0) then	-- filternél ha üres eltûnik, ha van kinyit
			if (subNodes:GetCount()==0) then tempNode:SetVisible(false)
			else tempNode:ExpandAll() end
		else
			if oneCharName == charName then -- ha nincs filter de ez a kari, kinyit
				tempNode:ExpandAll();
			end
		end			
	end	
	
end

-- *************************************************
-- Wallet frissítõ event kezelése
-- *************************************************
eventWalletChange = function(sender, args)
	debug("@eventWalletChange()");
	walletObj:CheckStorePermission();
	walletObj:RefreshWallet();
	RepaintWallet();
	RepaintOptionsWindow();
end

-- *************************************************
-- Opciók ablak megjelenítése
-- *************************************************
function ShowOptionsWindow()
	debug("@ShowOptionsWindow()");
	--optionsWindow:SetVisible(true);
	--optionsWindow:Activate();
	RepaintOptionsWindow();
	Turbine.PluginManager.ShowOptions(Plugins[pluginName]);
end

-- *************************************************
-- Plugin Betöltés
-- *************************************************
Plugins[pluginName].Load = function(self,sender,args)
	debug("@@Plugin load");
	pluginFullIdText = self:GetName() .. " v" .. self:GetVersion() .. " (c) 2015 " .. self:GetAuthor();
	Turbine.Shell.WriteLine("Plugin " .. pluginFullIdText);
	if debugMode then Turbine.Shell.WriteLine("Debug mode ON") end
	optionsObj:LoadData();	-- Opciók betöltése fájlból
	walletObj:LoadData();	-- fájlból és saját adatokból feltöltés
	ResetWindow();			-- képelemek alapérték beállítása
	ResetOptionsWindow();	-- Opciók ablak létrehozása
	RepaintWallet();		-- item tree frissítés	
	AddCallback(playerWallet, "ItemAdded", eventWalletChange);	-- Új item
	AddCallback(playerWallet, "ItemRemoved", eventWalletChange); -- Item törlés	
	
--	if localPlayer:GetAlignment() == Turbine.Gameplay.Alignment.MonsterPlayer then
--	end

	-- Commandline parancs definiálása
	
	if Turbine.Shell.IsCommand(shellCommandName) then
		debug("A ".. shellCommandName .. " parancs már regisztált!");
	else
		myCommandLine = Turbine.ShellCommand();
		-- Parancsok feldolgozása
		function myCommandLine:Execute( name, shellCommand )
			shellCommand = string.lower(shellCommand);
			if (shellCommand == "setup") or (shellCommand == "options") then
				walletWindow:SetVisible();
				ShowOptionsWindow();
			elseif (shellCommand == "show") or (shellCommand == "on") then
				walletWindow:SetVisible();
				walletWindow:Activate();
			elseif (shellCommand == "hide") or (shellCommand == "off") then
				walletWindow:Close();
			elseif shellCommand == "refresh" then
				eventWalletChange();
			else 
				myCommandLine:GetHelp();
			end
		end
		-- Rövid help
		function myCommandLine:GetShortHelp()
			echo("Command: <rgb=#FFFFFF>/"..shellCommandName.."</rgb> [show|on] [hide|off] [setup|options] [refresh] [help]");
		end
		-- Részletes help
		function myCommandLine:GetHelp()
			echo(string.rep("=",string.len(pluginFullIdText)));
			echo(pluginFullIdText);
			echo(string.rep("=",string.len(pluginFullIdText)));
			echo("USAGE: /"..shellCommandName.." [command]\n");
			echo("COMMANDS:");
			echo("help - show this help (also if no command)");
			echo("show|on - show the Altwallet");
			echo("hide|off - hide the Altwallet");
			echo("setup|options - show the options window");
			echo("refresh - refresh your wallet");
			echo("");
		end
		
		Turbine.Shell.AddCommand( shellCommandName, myCommandLine );
		Plugins[pluginName].GetOptionsPanel = function(self) return optionsPanel end;
		echo(myCommandLine:GetShortHelp());
	end
end;

-- *************************************************
-- Plugin megszüntetése
-- *************************************************
Plugins[pluginName].Unload = function(self,sender,args)
	debug("@@Plugin unload");
	RemoveCallback(playerWallet, "ItemAdded", eventWalletChange);
	RemoveCallback(playerWallet, "ItemRemoved", eventWalletChange);
	if Turbine.Shell.IsCommand(shellCommandName) then
		Turbine.Shell.RemoveCommand(shellCommandName);
	end	
	walletObj:RefreshWallet();
	walletObj:SaveState();
	optionsObj:SaveState();
	debug(pluginFullIdText .. " has removed!");	
end;

