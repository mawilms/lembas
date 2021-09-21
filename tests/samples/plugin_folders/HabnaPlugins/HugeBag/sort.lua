-- sort.lua
-- Written By MrJackdaw, tweak by Habna for HugeBag


function Sort()
	if IsSorting or IsMixing or IsMerging or IsSearching then write( L["FSSortE"] ); return end

	IsSorting = true;
	ButtonsCtr:SetVisible( false );
	
	FirstStart = Turbine.Engine.GetGameTime();
	Start = Turbine.Engine.GetGameTime();
	
	FailSafeTimer = Turbine.UI.Control();
	FailSafe( 0, 15 ); --(Starting second number, maximum of seconds before fail safe stop the sorting function)
	FailSafeTimer:SetWantsUpdates( true ); --Enable/Disable Fail safe

	SortTimer = Turbine.UI.Control();
	SortHugeBag( 1 ); --(starting slot).
	SortTimer:SetWantsUpdates( true ); --Enable/Disable sort
end

function SortHugeBag( Slot )	
	CreateVirtualPack();
	
	write( L["FSSortS"] );

	SortTimer.Update = function( sender, args )
		local Time = Turbine.Engine.GetGameTime();
		local elapsed = Time - Start;

		if Slot > backpackSize then -- Stop when last slot is reached
			SortTimer:SetWantsUpdates( false );
			FailSafeTimer:SetWantsUpdates( false );

			if ShowButton then ButtonsCtr:SetVisible( true ); end
	
			IsSorting = false;
			write( L["FSSortF"] );
			local Time = Turbine.Engine.GetGameTime();
			write("<rgb=#888888>" .. L["OWidSort"] .. L["FAMergeFA"] .. string.format( "%.2f", Time - FirstStart ) .. L["FAMergeSec"] )
		else
			if VirtPack[Slot].Dupe == "yes" then
				--write("Duplicate item found at slot " .. Slot);
				xDelay = 0.2; --Seems to not getting the "Too busy" message with a delay of 0.2 sec
			else
				xDelay = 0;
			end

			if elapsed > xDelay then
				--Get the quantity & name of the target item
				targetName = VirtPack[Slot].Name;
				target = VirtPack[Slot].Quantity .. " " .. targetName;
		
				--Search the target item in bag.
				for i = Slot, backpackSize do
					item = Backpack:GetItem( i );

					if item ~= nil then
						itemName = item:GetName();
						itemQuantity = item:GetQuantity();
					else
						itemName = "zEmpty";
						itemQuantity = 0;
					end
					source = itemQuantity .. " " .. itemName;
					--write(source .. " / " .. target);
					if source == target then
						if i == Slot then Slot = Slot + 1 return end
						--write(source .. " found at " .. i .. " / Slot " .. Slot .. ": " .. target);
						-- Check if item in destination slot is not the same item that will go there, cause if true them a merge will
						-- be perform and sort will not end properly, making button not visible and can't perform sort again.
						local ditem = Backpack:GetItem( Slot );
						if ditem ~= nil then
							ditemName = ditem:GetName();
							--write("Destination item name: " .. ditemName .. " / Item name: " .. itemName);
							if ditemName == itemName then
								for NextSlot = Slot + 1, backpackSize do
									--write("Next slot: " .. tostring(NextSlot));
									local nextItem = Backpack:GetItem( NextSlot );
									if nextItem ~= nil then
										nitemName = nextItem:GetName();
										if nitemName ~= ditemName then
											Backpack:PerformItemDrop(ditem, NextSlot, false);
											break
										end
									end
								end
							end
						end

						if item ~= nil then
							--write("Performing item drop to slot " .. i);
							Backpack:PerformItemDrop(item, Slot, false);
							Slot = Slot + 1;
							Start = Turbine.Engine.GetGameTime();
						end
					end
				end
			end
		end
	end
end

function FailSafe( NumSecs, MaxSecs )

	FailSafeTimer.Update = function( sender, args )
		currentdate = Turbine.Engine.GetDate();
		currentsecond = currentdate.Second;

		if NumSecs > MaxSecs then --Stop the sorting if it take more then it's allowed secs to complete.
			write( L["FSSortFS"] .. MaxSecs .. L["FAMergeSec"]);

			FailSafeTimer:SetWantsUpdates( false );
			SortTimer:SetWantsUpdates( false );

			ButtonsCtr:SetVisible( ShowButton );
	
			IsSorting = false;
		else
			if (oldsecond ~= currentsecond) then --Add 1 to NumSecs every real second
				oldsecond = currentsecond;
				NumSecs = NumSecs + 1;
			end
		end
	end
end