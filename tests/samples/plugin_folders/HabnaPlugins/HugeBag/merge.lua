-- merge.lua
-- Written By Habna

-- This method is slower then method 2 but the message "You are too busy to do that right now" will not appear

function Merge()
	if IsSorting or IsMixing or IsMerging or IsSearching then
		write( L["FAMergeE"] );
		return
	end
	
	iFirst, iLast, iStep = 1, backpackSize, 1;
	if InverseMerge then iFirst, iLast, iStep = backpackSize, 1, -1; end
	DestSlot = iFirst;
	--Lasti = 0;
	
	IsMerging = true;
	ButtonsCtr:SetVisible( false );
	write( L["FAMergeS"] );
	
	FirstStart = Turbine.Engine.GetGameTime();
	Timer = Turbine.UI.Control();

	Timer.Update = function( sender, args )
		--Get the destination item
		TargetItem = Backpack:GetItem(DestSlot);
		
		if TargetItem ~= nil then
			if not InverseMerge then ToDestSlot = DestSlot + 1; else ToDestSlot = DestSlot - 1; end

			for SourceSlot = ToDestSlot, iLast, iStep do
				SourceItem = Backpack:GetItem(SourceSlot);
				
				if SourceItem ~= nil then
					--Get the name of the destination item
					local TargetName = TargetItem:GetName();
					
					--Get the name of the source item
					local SourceName = SourceItem:GetName();
			
					if SourceName == TargetName then
						--Get the item Quantity & Max stack of the destination item
						local TargetItemQuantity = TargetItem:GetQuantity();
						local TargetItemMaxStackSize = TargetItem:GetMaxStackSize();
						local TargetDif = TargetItemMaxStackSize - TargetItemQuantity;

						--Get the item Quantity & Max stack size of the source item
						local SourceItemQuantity = SourceItem:GetQuantity();
						local SourceItemMaxStackSize = SourceItem:GetMaxStackSize();

						--write(tostring("Target: " .. TargetItemQuantity .. " " .. TargetName .. " at " .. DestSlot));
						--write(tostring("Source: " .. SourceItemQuantity .. " " .. SourceName .. " at " .. SourceSlot));

						if SourceItemMaxStackSize ~= 1 and SourceItemQuantity <= TargetDif then
							--write(tostring("Lasti: " .. Lasti .. " " .. "SourceSlot: " .. SourceSlot));
							--if Lasti ~= SourceSlot then
								--write("Merging: " .. SourceItemQuantity .. " " .. SourceName .. " at " .. SourceSlot);
								--write("with: " .. TargetItemQuantity .. " " .. TargetName .. " at " .. DestSlot);

								Backpack:PerformItemDrop( SourceItem, DestSlot, false );
								--Lasti = SourceSlot; --Last item move (slot number)
							--end
						end
					end
				end
			end
		end
		
		if not InverseMerge then DestSlot = DestSlot + 1; else DestSlot = DestSlot - 1; end

		if DestSlot < 1 or DestSlot > backpackSize then
			Timer:SetWantsUpdates( false );

			if ShowButton then ButtonsCtr:SetVisible( true ); end
			
			IsMerging = false;
			write( L["FAMergeF"] );
			--Turbine.PluginManager.LoadPlugin( 'HugeBag Reloader' );
			local Time = Turbine.Engine.GetGameTime();
			write("<rgb=#888888>" .. L["OWidMerge"] .. L["FAMergeFA"] .. string.format( "%.2f", Time - FirstStart ) .. L["FAMergeSec"]);
		end
	end

	Timer:SetWantsUpdates( true );
end