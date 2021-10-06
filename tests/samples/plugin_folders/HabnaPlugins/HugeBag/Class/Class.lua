-- Class.lua
-- Written by Rod of Turbine, originally part of the LotRO Lua Examples.
-- Compatible with Lua 5.1 (not 5.0).

_G.class = function( base )
	if ( base ~= nil ) then
		local baseType = type( base );

		if ( baseType ~= 'table' ) then
			error( "Base class is not a table. Base class was a " .. baseType );
		end
	end

	-- The class definition table. Contains all of the actual class
	-- methods, constructor, and an IsA function automatically
	-- provided.
	local c  = { };

	c.base = base;
	c.IsA = function( self, klass )
		local m = getmetatable( self );
		
		while m do 
			if m == klass then
				return true;
			end
			
			m = m.base;
		end
		
		return false;
	end

	-- The class definition metatable. This is used to hook up
	-- base classes and then to register a call handler that is
	-- used to construct new instances of the class.
	local mt = { };
	mt.__index = base;

	mt.__call = function( class_tbl, ... )
		if ( class_tbl.Abstract ) then
			error "Abstract class cannot be constructed.";
		end

		-- Create the new class instance.
		local instance = { };
		setmetatable( instance, { __index = c } );
		
		-- Invoke the constructor if it exists.
		if ( ( instance.Constructor ~= nil ) and ( type( instance.Constructor ) == 'function' ) ) then
			instance:Constructor( ... );
		end
		
		return instance;
	end

	setmetatable( c, mt );
	return c;
end
