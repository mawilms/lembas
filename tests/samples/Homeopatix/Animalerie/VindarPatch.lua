--[[ Vindar, 11/2010
     A patch for the Turbine.PluginData bug for European clients. It's dirty but it seems to works :)
]]--


-- return a copy of the object obj in a safe format
function convSafe(obj)
    local lookup = {}
    local function _copy(obj)
		function _convSafe(obj)
			if type(obj)=="number" then return(tostring(obj)) end
			if type(obj)~="string" then return(obj) end
			local res = ""
			for i,v in ipairs({obj:byte(1,-1)}) do
				if (v < 32) or (v > 125) then res = res .. "#" .. tonumber(v) .. "#"
				else
					res = res .. string.char(v)
					if v == 35 then res = res .. "#" end
				end
			end
			if res:byte(1,1) == 35 then return("#" .. res) end
			if (tonumber(res)~= nil) then return("#" .. res) end
			return res
		end
        if type(obj) ~= "table" then return _convSafe(obj) elseif lookup[obj] then return lookup[obj] end
        local newt = {}
        lookup[obj] = newt
        for i, v in pairs(obj) do newt[_copy(i)] = _copy(v) end
        return setmetatable(newt, getmetatable(obj))
    end
    return _copy(obj)
end


-- the inverse operation
function convBack(obj)
    local lookup = {}
    local function _copy(obj)
		local function _convBack(obj)
			if type(obj) ~= "string" then return obj end
			if obj == "" then return "" end
			local num = tonumber(obj)
			if num ~= nil then return num end
			local res = ""
			if obj:byte(1,1) == 35 then obj = string.sub(obj,2,-1) end
			while string.len(obj)~=0 do
				if 		obj:byte(1,1) ~= 35 then res = res .. string.char(obj:byte(1,1)); obj = string.sub(obj,2,-1)
				elseif obj:byte(2,2) == 35 then  res = res .. "#"; obj = string.sub(obj,3,-1)
				else
					obj = string.sub(obj,2,-1)
					local k = 1;
					while (obj:byte(k,k) ~= nil) and (obj:byte(k,k) ~= 35) do k = k + 1 end
					if obj:byte(k,k) == nil then error("convBack : parse error 1 !") end
					local v = tonumber(string.sub(obj,1,k-1))
					if v == nil then error("convBack : parse error 2 !") end
					res = res .. string.char(v)
					obj = string.sub(obj,k+1,-1)
				end
			end
			return res;
		end
        if type(obj) ~= "table" then return _convBack(obj) elseif lookup[obj] then return lookup[obj] end
        local newt = {}
        lookup[obj] = newt
        for i, v in pairs(obj) do newt[_copy(i)] = _copy(v) end
        return setmetatable(newt, getmetatable(obj))
    end
    return _copy(obj)
end

-- Replacement for Turbine.PluginData.Load
function PatchDataLoad(a,b,c)
	local success,results;
	success,results=pcall(Turbine.PluginData.Load,a,b,c);
	if success then
		success,results=pcall(convBack,results);
		if success then
			return results;
		else
			Turbine.Shell.WriteLine("Error:"..tostring(results))
			Turbine.Shell.WriteLine("While processing convBack(Turbine.PluginData.Load("..tostring(a)..", "..tostring(b)..", "..tostring(c).."))")
			return nil;
		end
	else
		Turbine.Shell.WriteLine("Error:"..tostring(results))
		Turbine.Shell.WriteLine("While processing Turbine.PluginData.Load("..tostring(a)..", "..tostring(b)..", "..tostring(c)..")")
		return nil;
	end
end

-- Replacement for Turbine.PluginData.Save
function PatchDataSave(a,b,c,d)
	return Turbine.PluginData.Save(a,b,convSafe(c),d)
end

-- end of file
