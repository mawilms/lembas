------------------------------------------------------------------------------------------
-- Notification file
-- Written by Henna95
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- Sends notifications to chat --
------------------------------------------------------------------------------------------
function notification(message)
	if (message == nil) then message = "nil"; end

	if (type(message) ~= "string") then
		debug(message);
	else
		Turbine.Shell.WriteLine(rgb["start"] .. Strings.PluginName .. rgb["clear"] .. ": " .. message);
	end
end
------------------------------------------------------------------------------------------
-- debugging variable
------------------------------------------------------------------------------------------
local function string(o)
	return '"' .. tostring(o) .. '"';
end

local function recurse(o, indent)
	if indent == nil then indent = "" end
	local indent2 = indent .. '  '
	if type(o) == "table" then
		local s = indent .. 'array {' .. '\n';
		local first = true;
		for k,v in pairs(o) do
			if first == false then s = s .. ', \n' end
			if type(k) ~= 'number' then k = string(k) end
			s = s .. indent2 .. '[' .. k .. '] = ' .. recurse(v, indent2);
			first = false;
		end
		return s .. '\n' .. indent .. '}';
	else
		return string(o)
	end
end

function debug(...)
	local args = {...}
	if #args > 1 then
		debug(args)
	else
		notification(recurse(args[1]))
	end
end