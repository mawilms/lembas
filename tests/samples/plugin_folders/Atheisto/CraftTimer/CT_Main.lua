-- Craft Timer by Atheisto (based on David Down's EventTimer)

import "Turbine";
import "Turbine.Gameplay";
import "Turbine.UI";
import "Turbine.UI.Lotro";


function print(text) 
	Turbine.Shell.WriteLine("<rgb=#00FFFF>CT:</rgb> "..text);
end

local function cnt(list)
	local n = 0;
	for k in pairs(list) do 
		n=n+1; 
	end
	return n;
end

function showTime(hr)
	local hrs = hr % 24;
	local min = hr % 1;
	min = min*60;
	local days = math.floor(hr/24);
	return string.format("%2i\d %02i:%02i",days,hrs,min);
end

Event = Turbine.PluginData.Load(Turbine.DataScope.Server,"CT_Data");
if type(Event) ~= "table" then
	Event = {[0]=false};
	print("Craft Timer data initialized.");
end

-- Save player name for event entries
player = Turbine.Gameplay.LocalPlayer.GetInstance();
pname = player:GetName();

local function GetTime(str)
    local hr = tonumber(str);
    if hr and hr>0 and hr<170 then
        local now = Turbine.Engine.GetLocalTime();
        local time = now + 3600*hr;
        return time;
    end
    print("<rgb=#FF0000>Error, hours must be < 170</rgb>" );
end

CT_Command = Turbine.ShellCommand()

function CT_Command:Execute( command,args )
    if args=="list" or args=="" then
		Turbine.Shell.WriteLine( "Craft Timer events:" );
		ix = {};
		local nr,now,hr = 0, Turbine.Engine.GetLocalTime();
		for time,desc in pairs(Event) do
			if time>0 then
				hr = (time-now)/3600;
				nr = nr+1;
				ix[nr] = time;
			end
		end
		if nr<1 then
            print("No active events");
            return;
        end
		table.sort(ix);
		Turbine.Shell.WriteLine( " # Hours Description" );
		for nr,time in ipairs(ix) do
			hr = (time-now)/3600;
		    Turbine.Shell.WriteLine( string.format("%2i %s %s",nr,showTime(hr),Event[time]) );
        end
    elseif args=="clear" then
		Event = {[-1]=Event[-1], [0]=Event[0]};
        print("All events CLEARED");
    elseif args=="name" then
        Event[0] = not Event[0];
        print("Name append: "..tostring(Event[0]));
    elseif args=="now" then
        local now = Turbine.Engine.GetLocalTime();
        print("now = "..now);
    else
        if args:match("^%d+$") then
            local n = tonumber(args);
            if ix and ix[n] then
                print("Removing "..Event[ix[n]] );
                Event[ix[n]] = nil;
            else 
				print("<rgb=#FF0000>Error, no such event #</rgb> ("..n..")");
			end
            return;
        end
        local line, hours = args:match("^(%d+) (%d+%.?%d?)$");
        if line then
            local n = tonumber(line);
            local time = GetTime(hours);
            if ix and ix[n] and time then
                Event[time] = Event[ix[n]];
                Event[ix[n]] = nil;
                CT_Command:Execute(nil, ""); -- Redisplay list
            else 
				print("<rgb=#FF0000>Error, no such event #</rgb> ("..n..")");
			end
            return;
        end
        local hours,desc = args:match("^(%d+%.?%d?) (.+)$");
        if hours then
            local time = GetTime(hours);
            if not time then 
				return;
			end
			if Event[0] then 
				desc = desc.." ("..pname..")";
			end
            Event[time] = desc;
            CT_Command:Execute( nil,"" ); -- Redisplay list
        else 
			Turbine.Shell.WriteLine( "?? "..self:GetShortHelp() ); 
		end
    end
end

function CT_Command:GetHelp()
	return [[Craft Timer commands:
ct: Display event list
ct clear: Clear all events
ct name: Toggle name appending
ct #: Delete event on line #
ct # <hrs>: Change event time on line #
ct # <desc>: Add event in # hours]]
end

function CT_Command:GetShortHelp()
	return "Craft Timer ('/help ct' for command list)";
end

Turbine.Shell.AddCommand( "ct", CT_Command );

Plugins.CraftTimer.Open = function(sender,args)	
	CT_Command:Execute("ct","");
end

Plugins.CraftTimer.Unload = function(sender,args)
    Turbine.PluginData.Save(Turbine.DataScope.Server,"CT_Data",Event);
    print("Craft Timer data saved.");
end

if Event[-1] then 
	CT_Command:Execute("ct","");
end

-- Options panel
OP = Turbine.UI.Control();
OP:SetBackColor( Turbine.UI.Color(0.0, 0.0, 0.1) );
OP:SetSize( 240, 260 );

local autoBox = Turbine.UI.Lotro.CheckBox();
autoBox:SetText( " Display list on load" );
autoBox:SetSize( 170, 22 );
autoBox:SetPosition( 10, 10 );
autoBox:SetParent( OP );
if Event[-1] then 
	autoBox:SetChecked(true);
end

autoBox.CheckedChanged = function( sender, args )
	Event[-1] = sender:IsChecked();
	print((Event[-1] and "En" or "Dis").."abled Auto-display.");
end

plugin.GetOptionsPanel = function( self ) return OP end

function AddCallback(object, event, callback)
	if (object[event] == nil) then
		object[event] = callback;
	else
		if (type(object[event]) == "table") then
			table.insert(object[event], callback);
		else
			object[event] = {object[event], callback};
		end
	end
end

local items = {};
local itemTabelCnt = 0;
function itemTable(data)
	itemTabelCnt = itemTabelCnt +1;
	items[itemTabelCnt] = data;
end

-- text: You have completed the 'item' recipe!
local shortTime = 18;	-- 18h
local mediumTime = 66;	-- 2d 18h
local longTime = 162;	-- 6d 18h
-- Jeweler
itemTable({name = "Elaborate Red Ring", cd = longTime});
itemTable({name = "Red Ring", cd = mediumTime});
itemTable({name = "Elaborate Dúnedain Star", cd = mediumTime});
itemTable({name = "Royal Circlet", cd = longTime});
itemTable({name = "Beryl Pendant", cd = mediumTime});
itemTable({name = "Dúnedain Star", cd = shortTime});
-- Weapon
itemTable({name = "Flawless Annúminas Sceptre", cd = longTime});
itemTable({name = "Annúminas Sceptre", cd = mediumTime});
itemTable({name = "Númenórean Sceptre", cd = longTime});
itemTable({name = "Engraved Elf-blade", cd = mediumTime});
itemTable({name = "Flawless Ceremonial Dwarf-axe", cd = mediumTime});
itemTable({name = "Ceremonial Dwarf-axe", cd = shortTime});
-- Cook
itemTable({name = "Grand Feast of Ethuilwereth", cd = mediumTime});
itemTable({name = "Grand Feast of Lithe", cd = longTime});
itemTable({name = "Grand Feast of Cormarë", cd = longTime});
itemTable({name = "Feast of Cormarë", cd = mediumTime});
itemTable({name = "Feast of Ethuilwereth", cd = shortTime});
itemTable({name = "Feast of Lithe", cd = mediumTime});
itemTable({name = "Feast of Harvestmath", cd = longTime});
-- Metal
itemTable({name = "Adorned Dragon-helm", cd = longTime});
itemTable({name = "Adorned Royal Crown", cd = mediumTime});
itemTable({name = "Silver Basin", cd = longTime});
itemTable({name = "Dragon-helm", cd = mediumTime});
itemTable({name = "Royal Crown", cd = shortTime});
itemTable({name = "Adorned Gondorian Crown", cd = longTime});
itemTable({name = "Gondorian Crown", cd = mediumTime});
-- Scholar
itemTable({name = "Illuminated Record of the Elf-lords", cd = longTime});
itemTable({name = "Illuminated Record of the Race of Man", cd = mediumTime});
itemTable({name = "Illuminated Scroll of Kings", cd = longTime});
itemTable({name = "Scroll of Kings", cd = mediumTime});
itemTable({name = "Record of the Race of Man", cd = shortTime});
itemTable({name = "Record of the Elf-lords", cd = longTime});
itemTable({name = "Record of Durin", cd = mediumTime});
-- Tailor
itemTable({name = "Embroidered 'Battle of the Hornburg", cd = longTime});
itemTable({name = "Battle of the Hornburg", cd = mediumTime});
itemTable({name = "Embroidered 'Battle of Dagorlad", cd = longTime});
itemTable({name = "Embroidered 'Battle of Five Armies", cd = mediumTime});
itemTable({name = "Battle of Five Armies", cd = shortTime});
itemTable({name = "Battle of Dagorlad", cd = longTime});
itemTable({name = "Siege of Barad-dûr", cd = mediumTime});
-- Wood
itemTable({name = "Engraved Horn of Helm Hammerhand", cd = longTime});
itemTable({name = "Horn of Helm Hammerhand", cd = mediumTime});
itemTable({name = "Engraved Statue of Elendil", cd = longTime});
itemTable({name = "Engraved Red Arrow", cd = mediumTime});
itemTable({name = "Red Arrow", cd = shortTime});
itemTable({name = "Statue of Elendil", cd = longTime});
itemTable({name = "Black-wood Bow", cd = mediumTime});
-- Guild items
local tmp = {[1] = " Pattern", [2] = " Scroll", [3] = " Crest", [4] = " Repast", [5] = " Emblem", [6] = " Carving", [7] = " Symbol"};
itemTable({name = "Small ", cd = shortTime, extra = tmp});
itemTable({name = "Medium ", cd = mediumTime, extra = tmp});
itemTable({name = "Large ", cd = longTime, extra = tmp});
-- Legendaries
itemTable({name = " of the Third Age", cd = shortTime});
itemTable({name = " of the Second Age", cd = mediumTime, extra = tmp});
itemTable({name = " of the First Age", cd = longTime, extra = tmp});


AddCallback(Turbine.Chat,"Received",function(sender, args)
	if (args.ChatType ~= Turbine.ChatType.Standard) then 
		return;
	end
	local tmp = "You have completed the '";
	local pos1 = string.find(args.Message, tmp, 1, true);
	if (pos1 == nil) then
		return
	end
	pos1 = pos1 + string.len(tmp);
	local pos2 = string.find(args.Message, "' recipe!", pos1, true);
	if (pos2 == nil) then
		return
	end
	local itemText = string.sub(args.Message, pos1, pos2-1);
	local item, cd, itemPos = nil;
	local found = false;
	for key,value in pairs(items) do 
		itemPos = itemText:find(value.name, 1, true);
		if (itemPos ~= nil) then
			if (value.extra ~= nil) then
				for k,v in pairs(value.extra) do
					if (itemText:find(v, 1, true) ~= nil and itemPos == 1) then
						found = true;
						break;
					end
				end
			else
				found = true;
			end
			if (found) then
				item = value.name;
				cd = value.cd;
				break;
			end
		end
	end
	if (found) then
		local msg = pname..": '"..itemText.."' ("..cd.."h)";
		-- Remove old one
		for time,desc in pairs(Event) do
			if (desc == msg) then
				Event[time] = nil;
			end
		end
		CT_Command:Execute(nil, cd.." "..msg);
	end
	
end);
