-- mix.lua --Debug purpose ONLY in english
-- Written By Habna


function Mix()
	if IsSorting or IsMixing or IsMerging or IsSearching then
		write("Can't mix when sort, mix, merge or search function are active!");
		return
	end
	
	IsMixing = true;
	ButtonsCtr:SetVisible( false );
	write( "HugeBag: mixing items started" );

	Start = Turbine.Engine.GetGameTime();
	MixTimer = Turbine.UI.Control();

	NumSecs = 0;
	MaxSecs = 4; --Number of seconds before fail safe reload HugeBag. (In case sort fail to finish within it's allowed time)

	MixTimer:SetWantsUpdates(true);

	MixTimer.Update = function( sender, args )
		local Time = Turbine.Engine.GetGameTime();
		local elapsed = Time - Start;
		currentdate = Turbine.Engine.GetDate();
		currentsecond = currentdate.Second;

		if NumSecs > MaxSecs then --Stop the mix if it take more then it's allowed secs to complete.
			MixTimer:SetWantsUpdates(false);

			if ShowButton then ButtonsCtr:SetVisible( true ); end
			
			IsMixing = false;
			write( "HugeBag: mixing items finished" );
			write("<rgb=#888888>Mixing finished after ".. string.format( "%.2f", MaxSecs ) .." seconds.")
			Turbine.PluginManager.LoadPlugin( 'HugeBag Reloader' );
		else
			if (oldsecond ~= currentsecond) then --Add 1 to NumSecs every real second
				oldsecond = currentsecond;
				NumSecs = NumSecs + 1;
			end
			if elapsed > 0 then --Seem to not get "Too busy" message with a delay of 0.2 sec
				i = math.random(1, backpackSize);
				j = math.random(1, backpackSize);

				while j == i do	j = math.random(1, backpackSize); end

				item = Backpack:GetItem(j);
				if item ~= nil then Backpack:PerformItemDrop( item, i, false ); end
				Start = Turbine.Engine.GetGameTime();
			end
		end
	end
end