
-- Table the stores the class information objects.
local classInfoTable = { };

-- Table that caches the class type objects.
local classTypesTable = { };

-- Define an IsA method that will be attached to all classes.
local function IsA( self, target )
	return Type.StaticIsA( self.GetType(), target );
end

function _G.static_class( ... )
	local args = { ... };
	local baseClass;
	local mixins = { };
	local baseObjects = 0;

	local i;
	local object;

	-- Validate that there is at most one base class and that the base class is
	-- not marked as final.
	for i, object in pairs( args ) do
		local type = Type.StaticGetType( object );
		
		if ( type:IsClass() ) then
			if ( baseClass ~= nil ) then
				error( "A class can only have a single base class. More than one base class was specified." );
			end
			
			if ( type:IsFinal() ) then
				error( "Unable to inherit from final class." );
			end
			
			baseClass = object;
			baseObjects = baseObjects + 1;
		elseif ( type:IsMixin() ) then
			table.insert( mixins, object );
			baseObjects = baseObjects + 1;
		else
			error( "Invalid base object specified in class declaration." );
		end
	end

	local className = "";
	local environmentTable = getfenv( 0 );

	-- Try to determine the class name.
	if (
		( environmentTable ~= nil ) and
		( environmentTable._ ~= nil ) and
		( type( environmentTable._ ) == "table" ) and
		( environmentTable._.Name ~= nil ) and 
		( type( environmentTable._.Name ) == "string" ) )
	then
		className = getfenv( 0 )._.Name;
	end

	-- Define type information.
	local classTypeInfo = {
		Class = true,
		Static = true,
		Base = baseClass,
		Mixins = mixins,
		FullName = className
	};

	-- Define the metatable for the class table that is used to link
	-- base classes and mixins.
	local classTableMetaTable = { };

	if ( baseObjects == 0 ) then
		-- No base class to associate.
	elseif ( baseObjects == 1 ) then
		-- Only once base class so just associate the index directly to the class
		-- or mixin.
		classTableMetaTable.__index = baseClass or unpack( mixins ); 
	else
		-- Multiple inheritance will require a search.
		classTableMetaTable.__index = function( table, key )
			local i;
			local mixin;
			
			if ( baseClass and baseClass[key] ) then
				return baseClass[key];
			end
			
			for i, mixin in pairs( mixins ) do
				if ( mixin[key] ) then
					return mixin[key];
				end
			end
		end
	end

	-- Define the class definition table.
	local classTable = { };
	setmetatable( classTable, classTableMetaTable );

	classInfoTable[classTable] = classTypeInfo;

	if ( not classTable.GetUniqueID ) then
		local idTable = { };
		local weakKeysTable = { __mode = "k" };
		setmetatable( idTable, weakKeysTable );

		classTable.GetUniqueID = function( self )
			if ( idTable[self] ~= nil ) then
				return idTable[self];
			end

			local metatable = getmetatable( self );
			setmetatable( self, nil );
			local tostringValue = tostring( self );
			setmetatable( self, metatable );
			
			local id = string.sub( tostringValue, 8 );
			idTable[self] = id;
			return id;

		end
	end

	-- Define a ToString method for the class table if one does not already
	-- exist.
	if ( not classTable.ToString ) then
		-- The default ToString method.
		classTable.ToString = function( self )
			local target = self;
			
			-- If self is the class, this is not an instance.
			if ( self == self.GetType():GetClass() ) then
				self = nil;
			end
			
			local id = target:GetUniqueID();
			local className = target.GetType():GetName() or "";
			local value = "<";
			
			if ( string.len( className ) > 0 ) then
				 value =  value .. className .. " ";
			end
			
			if ( self ) then
				value =  value .. "Instance";
			else
				value =  value .. "Class";
			end
			
			value = value .. ": " .. id .. ">";
			
			return value;
		end		
	end

	classTableMetaTable.__tostring = function( self )
		return self:ToString();
	end

	-- Attach the IsA method to the class.
	if ( not classTable.IsA ) then
		classTable.IsA = IsA;
	end

	-- Create the accessor for the type information. This function is always
	-- overriden since it is dependent on local variables.
	classTable.GetType = function()
		local classType = classTypesTable[classTable];

		if ( classType == nil ) then
			classType = Type( classTable, classTypeInfo );
			classTypesTable[classTable] = classType;
		end

		return classType;
	end

	return classTable, classTableMetaTable, classTypeInfo;
end

function _G.class( ... )
	local staticClass, staticClassMetaTable, staticClassInfo = static_class( ... );

	local classInstanceMetaTable = {
		__index = staticClass,
		__tostring = function( self )
			return self:ToString();
		end
	};

	-- No longer static. Giving it a constructor.
	staticClassInfo.Static = nil;

	staticClassMetaTable.__call = function( classTable, ... )
		-- Create the new class instance.
		local instance = { };
		setmetatable( instance, classInstanceMetaTable );
		
		-- Invoke the constructor if it exists.
		if ( ( instance.Constructor ~= nil ) and ( type( instance.Constructor ) == 'function' ) ) then
			instance:Constructor( ... );
		end
		
		return instance;
	end

	return staticClass, staticClassMetaTable, staticClassInfo, classInstanceMetaTable;
end

function _G.abstract_class( ... )
	local staticClass, staticClassMetaTable, staticClassInfo = static_class( ... );
	
	-- No longer static. Giving it a constructor.
	staticClassInfo.Static = nil;
	staticClassInfo.Abstract = true;

	staticClassMetaTable.__call = function( classTable, ... )
		error( "Cannot instantiate an abstract class. " );
	end

	return staticClass, staticClassMetaTable, staticClassInfo;
end

function _G.final_class( ... )
	local classClass, classMetaTable, classInfo, classInstanceMetaTable = class( ... );

	-- Class that cannot be inherited from.
	classInfo.Final = true;

	return classClass, classMetaTable, classInfo, classInstanceMetaTable;
end
