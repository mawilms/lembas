--[[

This class is used to provide type information about an object in lua.
The GetType static method can be used on an object to return a Type instance
that can then be used to retrieve information about the type of the object.

The type class can be used to create an instance of the type with a
default value using the CreateInstance method. For classes the CreateInstance
method can accept arguments that will be passed to the class constructor.

]]--

local ClassMetaTable;
local ClassInfoTable;
local TypeInstanceMetaTable;
Type, ClassMetaTable, ClassInfoTable, TypeInstanceMetaTable = final_class();

function Type:Constructor( type, typeInfo )
	self.type = ( type or "nil" );
	self.typeInfo = typeInfo;
end

function Type:IsSimple()
	-- Simple types don't have extended type information.
	return ( self.typeInfo == nil );
end

function Type:IsNil()
	return ( self:IsSimple() and self.type == "nil" );
end

function Type:IsNumber()
	return ( self:IsSimple() and self.type == "number" );
end

function Type:IsBoolean()
	return ( self:IsSimple() and self.type == "boolean" );
end

function Type:IsString()
	return ( self:IsSimple() and self.type == "string" );
end

function Type:IsFunction()
	return ( self:IsSimple() and self.type == "function" );
end

function Type:IsTable()
	return ( self:IsSimple() and self.type == "table" );
end

function Type:IsThread()
	return ( self:IsSimple() and self.type == "thread" );
end

function Type:IsUserData()
	return ( self:IsSimple() and self.type == "userdata" );
end

function Type:IsClass()
	return (
		( self.typeInfo ~= nil ) and
		( self.typeInfo.Class == true )
	);
end

function Type:IsMixin()
	return (
		( self.typeInfo ~= nil ) and
		( self.typeInfo.Mixin == true )
	);
end

function Type:IsReferenceType()
	return self:IsFunction() or self:IsTable() or self:IsThread() or self:IsClass() or self:IsMixin();
end

function Type:IsStatic()
	return (
		( self.typeInfo ~= nil ) and
		( self.typeInfo.Static == true )
	);
end

function Type:IsAbstract()
	return (
		( self.typeInfo ~= nil ) and
		( self.typeInfo.Abstract == true )
	);
end

function Type:IsFinal()
	return (
		( self.typeInfo ~= nil ) and
		( self.typeInfo.Final == true )
	);
end

function Type:IsInstantiatableClass()
	return (
		self:IsClass() and
		( self.type.Constructor ~= nil ) and
		( not self:IsAbstractClass() ) and
		( type( self.type.Constructor ) == "function" )
	);
end

function Type:GetFullName()
	if ( self:IsSimple() ) then
		return self.type;
	end

	return self.typeInfo.FullName;
end

function Type:GetName()
	local fullName = self:GetFullName();

	return string.gmatch( fullName, ".+%.(.+)" )();
end

function Type:GetPackageName()
	if ( self:IsSimple() ) then
		return nil;
	end

	local fullName = self:GetFullName();

	return string.gmatch( fullName, "(.+)%..+" )();
end

function Type:GetPackage()
	if ( self:IsSimple() ) then
		return _G;
	end

	local packageName = self:GetPackageName();
	local currentPackage = _G;
	local package;

	for package in string.gmatch( packageName, "([^.]+)" ) do
		currentPackage = currentPackage[package];
	end

	return currentPackage;
end

function Type:GetClass()
	if ( self:IsClass() ) then
		return self.type;
	end
	
	return nil;
end

function Type:GetBaseClass()
	if ( self:IsClass() ) then
		return self.typeInfo.Base;
	end

	return nil;
end

function Type:GetMixins()
	if ( self.typeInfo ~= nil ) then
		return self.typeInfo.Mixins;
	end

	return nil;
end

function Type:CreateInstance( ... )
	if ( self:IsSimple() ) then
		if ( self:IsNil() ) then
			return nil;
		end

		if ( self:IsNumber() ) then
			return 0;
		end

		if ( self:IsBoolean() ) then
			return false;
		end

		if ( self:IsTable() ) then
			return { };
		end

		if ( self:IsString() ) then
			return "";
		end

		if ( self:IsFunction() ) then
			return function() end;
		end
	end

	if ( self:IsStaticClass() ) then
		error( "Cannot instantiate a static class." );
	end

	if ( self:IsAbstractClass() ) then
		error( "Cannot instantiate am abstract class." );
	end

	if ( self:IsClass() ) then
		return self.type( ... );
	end
end

local nativeTypeCache = { };

function Type.StaticGetType( object )
	if ( type( object ) == "table" ) then
		if ( ( object.GetType ~= nil ) and ( type( object.GetType ) == "function" ) ) then
			return object.GetType();
		end
		
		-- Support for built in types.
		local classTable = object;
		
		if ( classTable.__implementation ~= nil ) then
			classTable = getmetatable( classTable ).__index;
		end
		
		if ( ( classTable.Constructor ~= nil ) and ( type( classTable.Constructor ) == "function" ) ) then
			if ( nativeTypeCache[classTable] ~= nil ) then
				return nativeTypeCache[classTable];
			end
			
			local baseClass = Type.StaticGetType( getmetatable( classTable ).__index );
			local classType = Type( classTable, { Class = true, Base = baseClass } );
			nativeTypeCache[classTable] = classType;
			return classType;
		end
	end

	return Type( type( object ) )
end

function Type.StaticIsA( inputType, target )
	-- Get the type of the instance object.
	local current = inputType;
	local targetType = Type.StaticGetType( target );

	if ( targetType == nil ) then
		return false;
	end

	if ( targetType:IsClass() ) then
		-- Search the class inheritance tree first.
		while ( current ~= nil ) do
			if ( current == targetType ) then
				return true;
			end
			
			local baseClass = current:GetBaseClass();
			
			if ( baseClass == nil ) then
				break;
			end
			
			current = current:GetBaseClass().GetType();
		end
	elseif ( targetType:IsMixin() ) then
		-- Recursive dive through all mixins to see if this is one.
		local baseMixins = current:GetMixins();

		if ( baseMixins ~= nil and type( baseMixins ) == "table" ) then
			local k, v;
			for k, v in pairs( baseMixins ) do
				if ( ( v == target ) or ( v:IsA( target ) ) ) then
					return true;
				end
			end
		end
	else
		error( "Invalid target type. Target must be a class or mixin." );
	end

	return false;
end

function TypeInstanceMetaTable.__eq( first, second )
	if ( first:IsSimple() and second:IsSimple() ) then
		return first.type == second.type;
	end

	return rawequal( first, second );
end
