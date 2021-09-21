-- Chat �zenet
function echo(message)
	Turbine.Shell.WriteLine(message);
end
-- Kerek�t�s
function round(what, precision)
   return math.floor(what*math.pow(10,precision)+0.5) / math.pow(10,precision)
end

-- 0-255 sz�mb�l 0-1 k�z�ttit csin�l
function rgb(num)
	return round(num/255,2);
end

-- Bevezet� karival felt�lt
function fill(text, pattern, length)
	if string.len(text)<length then
		text = string.rep(pattern, length-string.len(text)) .. text;
	end
	return text;
end

-- dev �zenet�r�s chatre, script.log-ba debugMode=true eset�n d�tummal, logban n�vvel
function debug(message)
	if debugMode then
		local getdate = Turbine.Engine.GetDate();
		message = fill(getdate.Hour,"0",2) ..":".. fill(getdate.Minute,"0",2) ..":".. fill(getdate.Second,"0",2) .." ".. message;
		Turbine.Shell.WriteLine(message);
		Turbine.Engine.ScriptLog(debugPluginName .."|".. message);
	end
end

--
-- haszn�lat: seen = {}; DumpTable( table, "  ", seen );
function DumpTable( t, indentation, seen )
	if ( t == nil ) then
		Turbine.Shell.WriteLine( indentation .. "(nil)" );
		return;
	end
	seen[t] = true;
	local s= {};
	local n = 0;
	for k in pairs(t) do
		n = n + 1;
		s[n] = k;
	end
	table.sort(s, function(a,b) return tostring(a) < tostring(b) end);
	for k,v in pairs(s) do
		Turbine.Shell.WriteLine( indentation .. tostring( v ) .. ": " .. tostring( t[v] ) );
		if type( t[v] ) == "table" and not seen[t[v]] then
			DumpTable( t[v], indentation .. "  ", seen );
		end
	end
end

