-- functionsCtr.lua
-- Written By Habna


function ImportCtr( value )
	if value == "WI" then --Wallet infos
		import (AppCtrD.."Wallet");
		import (AppCtrD.."WalletToolTip");
		UpdateWallet();
		WI["Ctr"]:SetPosition( _G.WILocX, _G.WILocY );
	elseif value == "MI" then --Money Infos
		if _G.MIWhere == 1 then import (AppCtrD.."MoneyInfos");	import (AppCtrD.."MoneyInfosToolTip"); MI["Ctr"]:SetPosition( _G.MILocX, _G.MILocY ); end
		if _G.MIWhere ~= 3 then
			PlayerAtt = Player:GetAttributes();
			AddCallback(PlayerAtt, "MoneyChanged", function(sender, args) UpdateMoney(); end);
			AddCallback(sspack, "CountChanged", UpdateSharedStorageGold); -- Thx Heridian!
			UpdateMoney();
		else
			RemoveCallback(PlayerAtt, "MoneyChanged");
			RemoveCallback(sspack, "CountChanged", UpdateSharedStorageGold); -- Thx Heridian!
		end
	elseif value == "DP" then --Destiny Points
		if _G.DPWhere == 1 then import (AppCtrD.."DestinyPoints"); DP["Ctr"]:SetPosition( _G.DPLocX, _G.DPLocY ); end
		if _G.DPWhere ~= 3 then 
			PlayerAtt = Player:GetAttributes();
			AddCallback(PlayerAtt, "DestinyPointsChanged", function(sender, args) UpdateDestinyPoints(); end);
			UpdateDestinyPoints();
		else
			RemoveCallback(PlayerAtt, "DestinyPointsChanged");
		end
	elseif value == "SP" then --Shards
		if _G.SPWhere == 1 then import (AppCtrD.."Shards"); SP["Ctr"]:SetPosition( _G.SPLocX, _G.SPLocY ); end
		if _G.SPWhere ~= 3 then
			--LoadPlayerWallet();
			--PlayerShard = PlayerCurrency["Shard"];
			--AddCallback(PlayerShard, "QuantityChanged", function(sender, args) UpdateShards(); end);
			UpdateShards();
		--else
			--RemoveCallback(PlayerShard, "QuantityChanged");
		end
	elseif value == "SM" then --Skirmish Marks
		if _G.SMWhere == 1 then	import (AppCtrD.."SkirmishMarks"); SM["Ctr"]:SetPosition( _G.SMLocX, _G.SMLocY ); end
		if _G.SMWhere ~= 3 then
			--LoadPlayerWallet();
			--PlayerMark = PlayerCurrency["Mark"];
			--AddCallback(PlayerMark, "QuantityChanged", function(sender, args) UpdateMarks(); end);
			UpdateMarks();
		--else
			--RemoveCallback(PlayerMark, "QuantityChanged");
		end
	elseif value == "MP" then --Medallions
		if _G.MPWhere == 1 then	import (AppCtrD.."Medallions"); MP["Ctr"]:SetPosition( _G.MPLocX, _G.MPLocY ); end
		if _G.MPWhere ~= 3 then
			--LoadPlayerWallet();
			--PlayerMedallion = PlayerCurrency["Medallion"];
			--AddCallback(PlayerMedallion, "QuantityChanged", function(sender, args) UpdateMedallions(); end);
			UpdateMedallions();
		--else
			--RemoveCallback(PlayerMedallion, "QuantityChanged");
		end		
	elseif value == "SL" then --Seals
		if _G.SLWhere == 1 then	import (AppCtrD.."Seals"); SL["Ctr"]:SetPosition( _G.SLLocX, _G.SLLocY ); end
		if _G.SLWhere ~= 3 then
			--LoadPlayerWallet();
			--PlayerSeals = PlayerCurrency["Seals"];
			--AddCallback(PlayerSeals, "QuantityChanged", function(sender, args) UpdateSeals(); end);
			UpdateSeals();
		--else
			--RemoveCallback(PlayerSeals, "QuantityChanged", CPcb);
		end
	elseif value == "CP" then --Commendations
		if _G.CPWhere == 1 then	import (AppCtrD.."Commendations"); CP["Ctr"]:SetPosition( _G.CPLocX, _G.CPLocY ); end
		if _G.CPWhere ~= 3 then
			--LoadPlayerWallet();
			--PlayerCommendation = PlayerCurrency["Commendation"];
			--AddCallback(PlayerCommendation, "QuantityChanged", function(sender, args) UpdateCommendations(); end);
			UpdateCommendations();
		--else
			--RemoveCallback(PlayerCommendation, "QuantityChanged");
		end		
	elseif value == "BI" then --Backpack Infos
		import (AppCtrD.."BagInfos");
		--import (AppCtrD.."BagInfosToolTip");
		AddCallback(backpack, "ItemAdded", function(sender, args) UpdateBackpackInfos(); end);
		AddCallback(backpack, "ItemRemoved", function(sender, args) ItemRemovedTimer:SetWantsUpdates( true ); end); --Workaround
		--AddCallback(backpack, "ItemRemoved", function(sender, args) UpdateBackpackInfos(); end); --Add when workaround is not needed anymore
		UpdateBackpackInfos();
		BI["Ctr"]:SetPosition( _G.BILocX, _G.BILocY );
	elseif value == "PI" then --Player Pnfos
		import (AppCtrD.."PlayerInfos");
		import (AppCtrD.."PlayerInfosToolTip");
		PlayerAtt = Player:GetAttributes();
		AddCallback(Player, "LevelChanged", function(sender, args) PI["Lvl"]:SetText( Player:GetLevel() ); end);
		AddCallback(Player, "NameChanged", function(sender, args) PI["Name"]:SetText( Player:GetName() ); end);
		XPcb = AddCallback(Turbine.Chat, "Received", function(sender, args)
			if args.ChatType == Turbine.ChatType.Advancement then
				xpMess = args.Message;
				--write("XP message");

				--Steed XP
				--xpMess = "You've earned 14,458 Steed XP for a total of 4,962,257 Steed XP."; --EN debug purpose

				--Normal XP
				--xpMess = "You've earned 40 XP for a total of 5,811 XP."; --EN debug purpose
				--xpMess = "Vous avez gagn\195\169 40 points d'exp\195\169rience, soit un total de 5,310 points d'exp\195\169rience."; --FR debug purpose
				--xpMess = "Euer Gegenstand hat 40 EP erhalten."; --DE debug purpose
				--xpMess = "Ihr habt 40 EP erhalten und verf\195\188gt jetzt insgesamt \195\188ber 5,411 EP."; --DE debug purpose: 1x ","
				--xpMess = "Ihr habt 40 EP erhalten und verf\195\188gt jetzt insgesamt \195\188ber 9,498,712 EP."; --DE debug purpose: 2x ","
				
				if xpMess ~= nil then
					local xpPattern;
					if GLocale == "en" then xpPattern = "total of ([%d%p]*) XP";
					elseif GLocale == "fr" then xpPattern = "de ([%d%p]*) points d'exp\195\169rience";
					elseif GLocale == "de" then xpPattern = "\195\188ber ([%d%p]*) EP"; end
					
					local tmpXP = string.match(xpMess,xpPattern);
					if tmpXP ~= nil then
						ExpPTS = tmpXP;
						--write("XP capture: '"..ExpPTS.."'"); -- debug purpose
						settings.PlayerInfos.XP = ExpPTS;
						SaveSettings( false );
					end
				end
			end
		end);
		UpdatePlayersInfos();
		PI["Ctr"]:SetPosition( _G.PILocX, _G.PILocY );
	elseif value == "DI" then --Durability Infos
		import (AppCtrD.."DurabilityInfos");
		import (AppCtrD.."DurabilityInfosToolTip");
		UpdateDurabilityInfos();
		DI["Ctr"]:SetPosition( _G.DILocX, _G.DILocY );
	elseif value == "EI" then --Equipment Infos
		import (AppCtrD.."EquipInfos");
		import (AppCtrD.."EquipInfosToolTip");
		UpdateEquipsInfos();
		EI["Ctr"]:SetPosition( _G.EILocX, _G.EILocY );
	elseif value == "PL" then --Player Location
		import (AppCtrD.."PlayerLoc");
		--AddCallback(Player, "LocationChanged", UpdatePlayerLoc(); end);
		PLcb = AddCallback(Turbine.Chat, "Received", function(sender, args)
			if args.ChatType == Turbine.ChatType.Standard then
				plMess = args.Message;

				--write("PL message");
				--GLocale = "fr"; --debug purpose
				
				--plMess = "Entered the Bree-town - Trade channel"; -- EN debug purpose
				--plMess = "Canal Pays de Bree - Conseils : connexion."; -- FR debug purpose
				--plMess = "Chat-Kanal 'Breeland - OOC' betreten"; -- DE debug purpose
				
				if plMess ~= nil then
					if GLocale == "en" then plPattern = "Entered the ([%a%p%u%l%s]*) %-";
					elseif GLocale == "fr" then plPattern = "Canal ([%a%p%u%l%s]*) %-";
					elseif GLocale == "de" then plPattern = "Chat%-Kanal '([%a%p%u%l%s]*) %-"; end
					
					local tmpPL = string.match(plMess,plPattern);
					if tmpPL ~= nil then
						--write("'".. tmpPL .. "'"); -- debug purpose
						pLLoc = tmpPL;
						UpdatePlayerLoc( pLLoc );
						settings.PlayerLoc.L = string.format( pLLoc );
						SaveSettings( false );
					end
				end
			end
		end);
		UpdatePlayerLoc( pLLoc );
		PL["Ctr"]:SetPosition( _G.PLLocX, _G.PLLocY );
	elseif value == "TI" then --Track Items
		import (AppCtrD.."TrackItems");
		import (AppCtrD.."TrackItemsToolTip");
		UpdateTrackItems();
		TI["Ctr"]:SetPosition( _G.TILocX, _G.TILocY );
	elseif value == "IF" then --Infamy
		_G.InfamyRanks = { [0]=0, [1]=500, [2]=1250, [3]=2750, [4]=5750, [5]=14750, [6]=33500, [7]=71000, [8]=146000, [9]=258500, [10]=408500, [11]=633500, [12]=1008500, [13]=1608500, [14]=2508500, [15]=3708500 };

		if PlayerAlign == 1 then
			--Free people rank icon 0 to 15
			InfIcon = { [0]=0x4100819b, [1]=0x410080a8, [2]=0x410080a9, [3]=0x410080aa, [4]=0x410080ab, [5]=0x410080ac, [6]=0x410080ad, [7]=0x410080ae, [8]=0x410080af,
						[9]=0x410080a1, [10]=0x410080a2, [11]=0x410080a3, [12]=0x410080a4, [13]=0x410080a5, [14]=0x410080a6, [15]=0x410080a7 };
		else
			--Monster play rank icon 0 to 15
			InfIcon = { [0]=0x4100819c, [1]=0x410080b7, [2]=0x410080b8, [3]=0x410080b9, [4]=0x410080ba, [5]=0x410080bb, [6]=0x410080bc, [7]=0x410080bd, [8]=0x410080be,
						[9]=0x410080b0, [10]=0x410080b1, [11]=0x410080b2, [12]=0x410080b3, [13]=0x410080b4, [14]=0x410080b5, [15]=0x410080b6 };
		end
		import (AppCtrD.."Infamy");
		import (AppCtrD.."InfamyToolTip");
		---InfamyCount = Turbine.
		--AddCallback(InfamyCount, "QuantityChanged", function(sender, args) UpdateInfamy(); end);
		IFcb = AddCallback(Turbine.Chat, "Received", function(sender, args)
			if args.ChatType == Turbine.ChatType.Advancement then
				ifMess = args.Message;
				--write("IF message");

				--ifMess = "You've earned 10 renown points."; --EN debug purpose
				--ifMess = "You've earned 10 infamy points."; --EN debug purpose
				
				--ifMess = "Vous avez gagn\195\169 20 points renomm\195\169e"; --FR debug purpose
				--ifMess = "Vous avez gagn\195\169 20 points d'infamie"; --FR debug purpose

				--ifMess = "Ihr habt 30 Ansehenspunkte."; --DE debug purpose
				--ifMess = "Ihr habt 30 Verrufenheitspunkte erhalten."; --DE debug purpose

				if ifMess ~= nil then
					--if GLocale == "fr" then bS, bE = "gagn\195\169 ", " points"; end

					if PlayerAlign == 1 then
						if GLocale == "en" then ifPattern = "earned ([%d%p]*) renown points";
						elseif GLocale == "fr" then ifPattern = "gagn\195\169 ([%d%p]*) points renomm\195\169e";
						elseif GLocale == "de" then ifPattern = "habt ([%d%p]*) Ansehenspunkte"; end
					else
						if GLocale == "en" then ifPattern = "earned ([%d%p]*) infamy points";
						elseif GLocale == "fr" then ifPattern = "gagn\195\169 ([%d%p]*) points d'infamie";
						elseif GLocale == "de" then ifPattern = "habt ([%d%p]*) Verrufenheitspunkte"; end
					end

					local tmpIF = string.match(ifMess,ifPattern);
					if tmpIF ~= nil then
						InfamyPTS = InfamyPTS + tmpIF;
						
						for i=0, 14 do
							if tonumber(InfamyPTS) >= _G.InfamyRanks[i] and tonumber(InfamyPTS) < _G.InfamyRanks[i+1] then InfamyRank = i; break end
						end

						settings.Infamy.P = string.format("%.0f", InfamyPTS);
						settings.Infamy.K = string.format("%.0f", InfamyRank);

						SaveSettings( false );

						UpdateInfamy();
					end
				end
			end
		end);
		UpdateInfamy();
		IF["Ctr"]:SetPosition( _G.IFLocX, _G.IFLocY );
	elseif value == "BK" then --Bank
		--import (AppCtrD.."Bank");
		--import (AppCtrD.."BankToolTip");
		--UpdateBank();
		--BK["Ctr"]:SetPosition( _G.BKLocX, _G.BKLocY );
	elseif value == "DN" then --Day & Night Time
		durationarray = {572, 1722, 1067, 1678, 1101, 570, 1679, 539, 1141, 1091};
		import (AppCtrD.."DayNight");
		--import (AppCtrD.."DayNightToolTip");
		UpdateDayNight();
		DN["Ctr"]:SetPosition( _G.DNLocX, _G.DNLocY );
	elseif value == "TP" then --Turbine points
		if _G.TPWhere == 1 then	import (AppCtrD.."TurbinePoints"); TP["Ctr"]:SetPosition( _G.TPLocX, _G.TPLocY ); UpdateTurbinePoints(); end
		if _G.TPWhere ~= 3 then
			--PlayerTP = Player:GetTurbinePoints();
			--AddCallback(PlayerTP, "TurbinePointsChanged", function(sender, args) UpdateTurbinePoints(); end);
			TPcb = AddCallback(Turbine.Chat, "Received", function(sender, args)
				if args.ChatType == Turbine.ChatType.Advancement then
					tpMess = args.Message;
					--write("TP message");
				
					--tpMess = "You've earned 10 Turbine Points"; -- EN debug purpose
					--tpMess = "Vous avez gagn\195\169 10 points Turbine"; --FR debug purpose
					--tpMess = "Ihr habt 10 Punkte erhalten"; --DE debug purpose
				
					if tpMess ~= nil then
						local tpPattern;
						if GLocale == "en" then tpPattern = "earned ([%d%p]*) Turbine Points";
						elseif GLocale == "fr" then tpPattern = "gagn\195\169 ([%d%p]*) points Turbine";
						elseif GLocale == "de" then tpPattern = "habt ([%d%p]*) Punkte erhalten"; end
					
						local tmpTP = string.match(tpMess,tpPattern);
						if tmpTP ~= nil then
							TPTS = tmpTP;
							--write("Turbine points capture: '"..TPTS.."'"); -- debug purpose
							_G.TurbinePTS = _G.TurbinePTS + TPTS;
							if _G.TPWhere == 1 then UpdateTurbinePoints(); end
							SavePlayerTurbinePoints();
						end
					end
				end
			end);
		else
			RemoveCallback(Turbine.Chat, "Received", TPcb);
		end
	elseif value == "GT" then --Game Time
		import (AppCtrD.."GameTime");
		--import (AppCtrD.."GameTimeToolTip");
		--PlayerTime = Turbine.Engine.GetDate();
		--AddCallback(PlayerTime, "MinuteChanged", function(sender, args) UpdateGameTime(); end);
		if _G.ShowBT then UpdateGameTime("bt");
		elseif _G.ShowST then UpdateGameTime("st");
		else UpdateGameTime("gt") end
		if _G.GTLocX + GT["Ctr"]:GetWidth() > screenWidth then _G.GTLocX = screenWidth - GT["Ctr"]:GetWidth() end --Replace if out od screen
		GT["Ctr"]:SetPosition( _G.GTLocX, _G.GTLocY );
	elseif value == "VT" then --Vault
		import (AppCtrD.."Vault");
		--import (AppCtrD.."VaultToolTip");
		AddCallback(vaultpack, "CountChanged", function(sender, args) SavePlayerVault(); end);
		UpdateVault();
		VT["Ctr"]:SetPosition( _G.VTLocX, _G.VTLocY );
	elseif value == "SS" then --Shared Storage
		import (AppCtrD.."SharedStorage");
		--import (AppCtrD.."ShredStorageToolTip");
		AddCallback(sspack, "CountChanged", function(sender, args) SavePlayerSharedStorage(); end);
		UpdateSharedStorage();
		SS["Ctr"]:SetPosition( _G.SSLocX, _G.SSLocY );
	elseif value == "RP" then --Reputation Points
		RPR = { [1]=10000, [2]=20000, [3]=25000, [4]=30000, [5]=0 }; --Reputation max points per rank
		RPGR = { [1]=10000, [2]=20000, [3]=25000, [4]=30000, [5]=45000, [6]=60000, [7]=0 }; --Reputation max points per guild rank
		RPGL = { [1]=L["RPGL1"], [2]=L["RPGL2"], [3]=L["RPGL3"], [4]=L["RPGL4"], [5]=L["RPGL5"] }; --Good Level names
		RPBL = { [1]=L["RPBL1"], [2]=L["RPBL2"], [3]=L["RPBL3"], [4]=L["RPBL4"], [5]=L["RPBL5"] }; --Bad Level names
		RPGGL = { [1]=L["RPGG1"], [2]=L["RPGG2"], [3]=L["RPGG3"], [4]=L["RPGG4"], [5]=L["RPGG5"], [6]=L["RPGG6"], [7]=L["RPGG7"] }; --Guild Level names
		import (AppCtrD.."Reputation");
		import (AppCtrD.."ReputationToolTip");
		--ReputationCount = Turbine.
		--AddCallback(ReputationCount, "QuantityChanged", function(sender, args) UpdateReputation(); end);
		RPcb = AddCallback(Turbine.Chat, "Received", function( sender, args )
			--if args.ChatType == Turbine.ChatType.Advancement then
				rpMess = args.Message;
				--write("RP message");

				--Normal ruputation gained
				--rpMess = "Your reputation with Men of Bree has increased by 1,300."; --EN debug purpose
				--rpMess = "Votre r\195\169putation aupr\195\168s de la faction Hommes de Bree a augment\195\169 de 1,500."; -- FR debug purpose
				--rpMess = "Euer Ruf bei Schmiedegilde hat sich um 1,200 verbessert."; --DE debug purpose

				--When accelerator is used
				--rpMess = "Your reputation with Men of Bree has increased by 1,300 (650 from bonus)."; --EN debug purpose
				--rpMess = "Votre r\195\169putation aupr\195\168s de la faction Hommes de Bree a augment\195\169 de 1,500 (750 du bonus)."; -- FR debug purpose
				--rpMess = "Euer Ruf bei der Gruppe \"W\195\164chter der eisernen Garnison\" wurde um 1,400 erh\195\182ht (700 durch Bonus)." --DE debug purpose

				--write(rpMess); --debug purpose
				if rpMess ~= nil then
					--Check string, Reputation Name pattern, Reputation Point pattern
					local cstr, rpnPattern, rppPatern;

					if GLocale == "en" then rpnPattern = "reputation with ([%a%p%u%l%s]*) has increased by"; rppPattern = "has increased by ([%d%p]*)%.";
					elseif GLocale == "fr" then rpnPattern = "de la faction ([%a%p%u%l%s]*) a augment\195\169 de"; rppPattern = "a augment\195\169 de ([%d%p]*)%.";
					elseif GLocale == "de" then rpnPattern = "Euer Ruf bei ([%a%p%u%l%s]*) hat sich um"; rppPattern = "hat sich um ([%d%p]*) verbessert"; end
					
					 --check string if an accelerator was used
					if GLocale == "de" then cstr = string.match(rpMess,"Bonus");
					else cstr = string.match(rpMess,"bonus"); end
					
					--Accelerator was used, end of string is diffrent. Ex. (700 from bonus). instead of just a dot after the amount of points
					if cstr ~= nil then
						if GLocale == "en" then rppPattern = "has increased by ([%d%p]*) %("
						elseif GLocale == "fr" then rppPattern = "a augment\195\169 de ([%d%p]*) %(";
						elseif GLocale == "de" then rpnPattern = "Euer Ruf bei der Gruppe \"([%a%p%u%l%s]*)\" wurde um"; rppPattern = "wurde um ([%d%p]*) erh\195\182ht"; end
					end

					local tmpRPN = string.match(rpMess,rpnPattern); --Reputation Name
					local tmpRPP = string.match(rpMess,rppPattern); --Reputation Points
					if tmpRPN ~= nil then
						rpName = tmpRPN;
						--write("'"..rpName.."'"); --debug purpose
						rpPTS = tmpRPP;
						rpPTS = string.gsub(rpPTS, ",", "");--Replace "," in 1,400 to get 1400
						--write("'"..tmpRPP.."'"); --debug purpose

						for i = 1, maxfaction+maxgfaction do
							if PlayerReputation[PN][tostring(i)][GLocale] == rpName then
								if PlayerReputation[PN][tostring(i)].R == #RPR and PlayerReputation[PN][tostring(i)].S == "good" or --Max lvl in faction
								PlayerReputation[PN][tostring(i)].R == #RPR and PlayerReputation[PN][tostring(i)].S == "bad" or --Max lvl in faction
								PlayerReputation[PN][tostring(i)].R == #RPGR and PlayerReputation[PN][tostring(i)].S == "guild" then --Max lvl in guild faction
									--write("Max rank reach, do nothing");
								else
									-- Check if new points is equal or bigger of the max points
									local tot = PlayerReputation[PN][tostring(i)].P + rpPTS;
									local max = 0;
									if PlayerReputation[PN][tostring(i)].S == "guild" then max = RPGR[tonumber(PlayerReputation[PN][tostring(i)].R)];
									else max = RPR[tonumber(PlayerReputation[PN][tostring(i)].R)];	end
											
									if tot >= max then
										--true, then calculate diff to add to next rank
										tdiff = tot - max;
										-- Change rank & points
										PlayerReputation[PN][tostring(i)].R = tostring(PlayerReputation[PN][tostring(i)].R + 1);
										if PlayerReputation[PN][tostring(i)].R == #RPR and PlayerReputation[PN][tostring(i)].S == "good" then PlayerReputation[PN][tostring(i)].P = "0"; --max rank, set points to 0
										elseif PlayerReputation[PN][tostring(i)].R == #RPGR and PlayerReputation[PN][tostring(i)].S == "guild" then PlayerReputation[PN][tostring(i)].P = "0"; --max giuld rank, set points to 0
										else PlayerReputation[PN][tostring(i)].P = string.format("%.0f", tdiff); end
									else
										--false, only add points
										PlayerReputation[PN][tostring(i)].P = string.format("%.0f", PlayerReputation[PN][tostring(i)].P + rpPTS);
									end
								end
											
								break
							end
						end
						SavePlayerReputation();
					end
				end
			--end
		end);
		UpdateReputation();
		RP["Ctr"]:SetPosition( _G.RPLocX, _G.RPLocY );
	end
end


function GetEquipmentInfos()
	LoadEquipmentTable();
	local PlayerEquipment = Player:GetEquipment();
	if PlayerEquipment == nil then write("no equipment, returning"); return end --Remove when Player Equipment info are available before plugin is loaded
	
	itemEquip = {};
	itemScore, numItems = 0, 0;
	
	for i = 1, 20 do
		local PlayerEquipItem = PlayerEquipment:GetItem( EquipSlots[i] );
		itemEquip[i] = Turbine.UI.Lotro.ItemControl( PlayerEquipItem );

		-- Item Name, WearState, Quality & Durability
		if PlayerEquipItem ~= nil then
			itemEquip[i].Item = true;
			itemEquip[i].Name = PlayerEquipItem:GetName();

			local Quality = PlayerEquipItem:GetQuality();
			--itemEquip[i].Quality = Quality;
			if Quality == 0 then itemScore = 0; -- undefined
			elseif Quality == 5 then itemScore = 50; -- Common
			elseif Quality == 4 then itemScore = 100; -- Uncommon
			elseif Quality == 3 then itemScore = 150; -- Incomparable
			elseif Quality == 2 then itemScore = 200; -- Rare
			elseif Quality == 1 then itemScore = 250; end -- Legendary

			local Durability = PlayerEquipItem:GetDurability();
			--itemEquip[i].Durability = Durability;
			if Durability == 0 then itemEquip[i].Score = itemScore + 0; -- undefined
			elseif Durability == 7 then itemEquip[i].Score = itemScore + 5; -- Weak / Faible
			elseif Durability == 1 then itemEquip[i].Score = itemScore + 10; -- Substantial
			elseif Durability == 2 then itemEquip[i].Score = itemScore + 20; -- Brittle / Fragile
			elseif Durability == 3 then itemEquip[i].Score = itemScore + 30; -- Normal
			elseif Durability == 4 then itemEquip[i].Score = itemScore + 40; -- Tought / Robuste
			elseif Durability == 5 then itemEquip[i].Score = itemScore + 50; -- Flimsy / Fragile ??
			elseif Durability == 6 then itemEquip[i].Score = itemScore + 60; end -- Indestructible

			local WearState = PlayerEquipItem:GetWearState();
			itemEquip[i].WearState = WearState;
			if WearState ~= 0 then numItems = numItems + 1; end -- Undefined item must not be count (Pocket item are as Undefined Wear State, they are indestructible)
			if WearState == 0 then itemEquip[i].WearStatePts = 0; -- undefined
			elseif WearState == 3 then itemEquip[i].WearStatePts = 0; -- Broken / cassé
			elseif WearState == 1 then itemEquip[i].WearStatePts = 50; -- Damaged / endommagé
			elseif WearState == 4 then itemEquip[i].WearStatePts = 75; -- Worn / usé
			elseif WearState == 2 then itemEquip[i].WearStatePts = 100; end -- Pristine / parfait
						
			itemEquip[i].BImgID = PlayerEquipItem:GetBackgroundImageID();
			itemEquip[i].QImgID = PlayerEquipItem:GetQualityImageID();
			itemEquip[i].UImgID = PlayerEquipItem:GetUnderlayImageID();
			itemEquip[i].SImgID = PlayerEquipItem:GetShadowImageID();
			itemEquip[i].IImgID = PlayerEquipItem:GetIconImageID();
			
			itemEquip[i].wsHandler = AddCallback(PlayerEquipItem, "WearStateChanged", function(sender, args) ChangeWearState(i); end);
			--itemEquip[i].ieHandler = AddCallback(PlayerEquipItem, "ItemEquipped", function(sender, args) UpdateEquipsInfos(i); end); --Add when each item can trigger this event
			--itemEquip[i].iuHandler = AddCallback(PlayerEquipItem, "ItemUnequipped", function(sender, args) UpdateEquipsInfos(i); end); --Add when each item can trigger this event
		else
			itemEquip[i].Item = false;
			itemEquip[i].Name = "zEmpty";
			--itemEquip[i].Quality = 0;
			--itemEquip[i].Durability = 0;
			itemEquip[i].Score = 0;
			itemEquip[i].WearState = 0;
			itemEquip[i].WearStatePts = 0;
		end
	end
end

function CalculateAllItemsDurability()
	TotalDurabilityPts = 0;

	for i = 1, 20 do TotalDurabilityPts = TotalDurabilityPts + itemEquip[i].WearStatePts; end
	
	if numItems == 0 then TotalDurabilityPts = 100;
	else TotalDurabilityPts = TotalDurabilityPts / numItems; end
end

function CalculateAllItemsScore()
	TotalItemsScore = 0;
	for i = 1, 20 do TotalItemsScore = TotalItemsScore + itemEquip[i].Score; end
end

function LoadPlayerItemTrackingList()
	if GLocale == "de" then	ITL = Turbine.PluginData.Load( Turbine.DataScope.Character, "TitanBarPlayerItemTrackingListDE" );
	elseif GLocale == "en" then ITL = Turbine.PluginData.Load( Turbine.DataScope.Character, "TitanBarPlayerItemTrackingListEN" );
	elseif GLocale == "fr" then	ITL = Turbine.PluginData.Load( Turbine.DataScope.Character, "TitanBarPlayerItemTrackingListFR" ); end
	
	if ITL == nil then ITL = {}; end
end

function SavePlayerItemTrackingList(ITL)
	local newt = {};
	for k, v in pairs(ITL) do newt[tostring(k)] = v; end
	ITL = newt;

	if GLocale == "de" then	Turbine.PluginData.Save( Turbine.DataScope.Character, "TitanBarPlayerItemTrackingListDE", ITL );
	elseif GLocale == "en" then Turbine.PluginData.Save( Turbine.DataScope.Character, "TitanBarPlayerItemTrackingListEN", ITL );
	elseif GLocale == "fr" then Turbine.PluginData.Save( Turbine.DataScope.Character, "TitanBarPlayerItemTrackingListFR", ITL ); end
end

function LoadPlayerMoney()
	wallet = Turbine.PluginData.Load( Turbine.DataScope.Server, "TitanBarPlayerWallet" );
	
	if wallet == nil then wallet = {}; end

	local PN = Player:GetName();
	local PlayerAtt = Player:GetAttributes();

	if wallet[PN] == nil then wallet[PN] = {}; end
	if wallet[PN].Show == nil then wallet[PN].Show = true; end
	if wallet[PN].ShowToAll == nil then wallet[PN].ShowToAll = true; end
	_G.SCM = wallet[PN].Show;
	_G.SCMA = wallet[PN].ShowToAll;

	--Convert wallet --(Remove after: August 18th 2012)
	local tGold, tSilver, tCopper, bOk;
	for k,v in pairs(wallet) do
		if wallet[k].Gold ~= nil then bOk = true; tGold = tonumber(wallet[k].Gold); wallet[k].Gold = nil; end
		if wallet[k].Silver ~= nil then bOk = true; tSilver = tonumber(wallet[k].Silver); wallet[k].Silver = nil;end
		if wallet[k].Copper ~= nil then bOk = true; tCopper = tonumber(wallet[k].Copper); wallet[k].Copper = nil;
		if tCopper < 10 then tCopper = "0".. tCopper; end end

		if bOk then
			local strdata;
			if tGold == 0 then
				if tSilver == 0 then
					strdata = tCopper;
				else
					strdata = tSilver..tCopper;
				end
			else
				if tSilver == 0 then
					strdata = tGold.."000"..tCopper;
				else
					strdata = tGold..tSilver..tCopper;
				end
			end
			wallet[k].Money = tostring(strdata);
		end
	end
	--
	--Statistics section
	local DDate = Turbine.Engine.GetDate();
	DOY = tostring(DDate.DayOfYear);
	walletStats = Turbine.PluginData.Load( Turbine.DataScope.Server, "TitanBarPlayerWalletStats" );
	if walletStats == nil then walletStats = {};
	else for k,v in pairs(walletStats) do if k ~= DOY then walletStats[k] = nil; end end end --Delete old date entry
	if walletStats[DOY] == nil then walletStats[DOY] = {}; end
	if walletStats[DOY][PN] == nil then walletStats[DOY][PN] = {};
		walletStats[DOY][PN].TotEarned = "0";
		walletStats[DOY][PN].TotSpent = "0";
		walletStats[DOY][PN].SumTS = "0";
	end
	walletStats[DOY][PN].Start = tostring(PlayerAtt:GetMoney());
	walletStats[DOY][PN].Had = tostring(PlayerAtt:GetMoney());
	walletStats[DOY][PN].Earned = "0";
	walletStats[DOY][PN].Spent = "0";
	walletStats[DOY][PN].SumSS = "0";
	--

	Turbine.PluginData.Save( Turbine.DataScope.Server, "TitanBarPlayerWalletStats", walletStats );
end

-- **v Save player wallet infos v**
function SavePlayerMoney( save )
	if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play character

	wallet[PN].Show = _G.SCM;
	wallet[PN].ShowToAll = _G.SCMA;
	wallet[PN].Money = tostring(PlayerAtt:GetMoney());

	-- Calculate Gold/Silver/Copper Total
	--if wallet.Total ~= nil then wallet.Total = nil; end --(Remove this line after: August 18th 2012)
	GoldTot, SilverTot, CopperTot = 0, 0, 0;
	gold, silver, copper = 0, 0, 0;
	
	for k,v in pairs(wallet) do
		DecryptMoney(v.Money);
		if k == PN then
			if v.Show then
				GoldTot = GoldTot + gold;
				SilverTot = SilverTot + silver;
				CopperTot = CopperTot + copper;
			end
		else
			if v.ShowToAll or v.ShowToAll == nil then
				GoldTot = GoldTot + gold;
				SilverTot = SilverTot + silver;
				CopperTot = CopperTot + copper;
			end
		end
	end

	--************************************************************************
	if (string.len(CopperTot)==3) then
		local CopperTotX = CopperTot;
		SilverTot = SilverTot + string.sub(CopperTotX,1,-3);
		CopperTot = string.sub(CopperTot,2,-1);
	end
		
	if (string.len(SilverTot)==4) then
		local SilverTotX = SilverTot;
		GoldTot = GoldTot + string.sub(SilverTotX,1,-4);
		SilverTot = string.sub(SilverTot,2,-1);
	end
	--************************************************************************

	--wallet.Total.Gold = string.format("%.0f", GoldTot)
	--wallet.Total.Silver = string.format("%.0f", SilverTot)
	--wallet.Total.Copper = string.format("%.0f", CopperTot)

	if save then Turbine.PluginData.Save( Turbine.DataScope.Server, "TitanBarPlayerWallet", wallet ); end
end
-- **^

function LoadPlayerWallet()
	PlayerWallet = Player:GetWallet();
	PlayerWalletSize = PlayerWallet:GetSize();
	--write(tostring(PlayerWalletSize));
	if PlayerWalletSize == 0 then return end --Remove when Wallet info are available before plugin is loaded
	
	for i = 1, PlayerWalletSize do
		local CurItem = PlayerWallet:GetItem(i);
		local CurName = PlayerWallet:GetItem(i):GetName();

		PlayerCurrency[CurName] = CurItem;
		if PlayerCurrencyHandler[CurName] == nil then PlayerCurrencyHandler[CurName] = AddCallback(PlayerCurrency[CurName], "QuantityChanged", function(sender, args) UpdateCurrency(CurName); end); end
	end
end

function LoadPlayerVault()
	PlayerVault = Turbine.PluginData.Load( Turbine.DataScope.Server, "TitanBarVault" );
	if PlayerVault == nil then PlayerVault = {}; end
	if PlayerVault[PN] == nil then PlayerVault[PN] = {}; end
end

function SavePlayerVault()
	if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play character
	
	vaultpackSize = vaultpack:GetCapacity();
	vaultpackCount = vaultpack:GetCount();

	PlayerVault[PN] = {};

	for ii = 1, vaultpackCount do
		PlayerVault[PN][tostring(ii)] = vaultpack:GetItem( ii );
		local iteminfo = PlayerVault[PN][tostring(ii)]:GetItemInfo();
		
		PlayerVault[PN][tostring(ii)].Q = tostring(iteminfo:GetQualityImageID());
		PlayerVault[PN][tostring(ii)].B = tostring(iteminfo:GetBackgroundImageID());
		PlayerVault[PN][tostring(ii)].U = tostring(iteminfo:GetUnderlayImageID());
		PlayerVault[PN][tostring(ii)].S = tostring(iteminfo:GetShadowImageID());
		PlayerVault[PN][tostring(ii)].I = tostring(iteminfo:GetIconImageID());
		PlayerVault[PN][tostring(ii)].T = tostring(iteminfo:GetName());
		local tq = tostring(PlayerVault[PN][tostring(ii)]:GetQuantity());
		if tq == "1" then tq = ""; end
		PlayerVault[PN][tostring(ii)].N = tq;
		PlayerVault[PN][tostring(ii)].Z = tostring(vaultpackSize);
	end

	Turbine.PluginData.Save( Turbine.DataScope.Server, "TitanBarVault", PlayerVault );
end

function LoadPlayerSharedStorage()
	PlayerSharedStorage = Turbine.PluginData.Load( Turbine.DataScope.Server, "TitanBarSharedStorage" );
	if PlayerSharedStorage == nil then PlayerSharedStorage = {}; end
end

function SavePlayerSharedStorage()
	if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play character

	sspackSize = sspack:GetCapacity();
	sspackCount = sspack:GetCount();

	PlayerSharedStorage = {};

	for ii = 1, sspackCount do
		PlayerSharedStorage[tostring(ii)] = sspack:GetItem( ii );
		local iteminfo = PlayerSharedStorage[tostring(ii)]:GetItemInfo();
			
		PlayerSharedStorage[tostring(ii)].Q = tostring(iteminfo:GetQualityImageID());
		PlayerSharedStorage[tostring(ii)].B = tostring(iteminfo:GetBackgroundImageID());
		PlayerSharedStorage[tostring(ii)].U = tostring(iteminfo:GetUnderlayImageID());
		PlayerSharedStorage[tostring(ii)].S = tostring(iteminfo:GetShadowImageID());
		PlayerSharedStorage[tostring(ii)].I = tostring(iteminfo:GetIconImageID());
		PlayerSharedStorage[tostring(ii)].T = tostring(iteminfo:GetName());
		local tq = tostring(PlayerSharedStorage[tostring(ii)]:GetQuantity());
		if tq == "1" then tq = ""; end
		PlayerSharedStorage[tostring(ii)].N = tq;
		PlayerSharedStorage[tostring(ii)].Z = tostring(sspackSize);
	end

	Turbine.PluginData.Save( Turbine.DataScope.Server, "TitanBarSharedStorage", PlayerSharedStorage );
end

-- vvv Added by Heridan vvv
function UpdateSharedStorageGold( sender, args )
	local storagesize = sspack:GetCount()
	local sharedmoney = 0
	local i
	for i = 1, storagesize do
		local item = sspack:GetItem(i)
		if item ~= nil then
			local name = item:GetName()
			local count = item:GetQuantity()
			if name == L["MGB"] then -- Gold Bag
				sharedmoney = sharedmoney + (count * 1000000)
			elseif name == L["MSB"] then -- Silver Bag
				sharedmoney = sharedmoney + (count * 100000)
			elseif name == L["MCB"] then -- Copper Bag
				sharedmoney = sharedmoney + (count * 10000)
			end
		end
	end
	wallet[L["MStorage"]] =  {
		["Show"] = true,
		["ShowToAll"] = true,
	    ["Money"] = tostring(sharedmoney)	
	}
	UpdateMoney()
end
-- ^^^ Added by Heridan ^^^

function LoadPlayerBags()
	PlayerBags = Turbine.PluginData.Load( Turbine.DataScope.Server, "TitanBarBags" );
	if PlayerBags == nil then PlayerBags = {}; end
	if PlayerBags[PN] == nil then PlayerBags[PN] = {}; end
end

function SavePlayerBags()
	if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play character

	backpackSize = backpack:GetSize();

	PlayerBags[PN] = {};
	ii=1;
	for i = 1, backpackSize do
		
		local items = backpack:GetItem( i );
		
		if items ~= nil then
			PlayerBags[PN][tostring(ii)] = items;
			local iteminfo = PlayerBags[PN][tostring(ii)]:GetItemInfo();

			--local sc = Turbine.UI.Lotro.Shortcut( items );
			--PlayerBags[PN][tostring(ii)].C = sc:GetData();
			
			PlayerBags[PN][tostring(ii)].Q = tostring(iteminfo:GetQualityImageID());
			PlayerBags[PN][tostring(ii)].B = tostring(iteminfo:GetBackgroundImageID());
			PlayerBags[PN][tostring(ii)].U = tostring(iteminfo:GetUnderlayImageID());
			PlayerBags[PN][tostring(ii)].S = tostring(iteminfo:GetShadowImageID());
			PlayerBags[PN][tostring(ii)].I = tostring(iteminfo:GetIconImageID());
			PlayerBags[PN][tostring(ii)].T = tostring(iteminfo:GetName());
			local tq = tostring(PlayerBags[PN][tostring(ii)]:GetQuantity());
			if tq == "1" then tq = ""; end
			PlayerBags[PN][tostring(ii)].N = tq;
			PlayerBags[PN][tostring(ii)].Z = tostring(backpackSize);

			ii = ii +1;
		end
	end

	Turbine.PluginData.Save( Turbine.DataScope.Server, "TitanBarBags", PlayerBags );
	--Turbine.PluginData.Save( Turbine.DataScope.Server, "TitanBarSharedStorage", PlayerBags[PN] ); --Debug purpose since i dont have a shared storage
end

function LoadPlayerBank()
	--PlayerBank = Turbine.PluginData.Load( Turbine.DataScope.Server, "TitanBarBank" );
	--if PlayerBank == nil then PlayerBank = {}; end
	--if PlayerBank[PN] == nil then PlayerBank[PN] = {}; end
	--ShowTableContent(bankpack[PN]);
end

function SavePlayerBank()
	--if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play character

	--Turbine.PluginData.Save( Turbine.DataScope.Server, "TitanBarBank", PlayerBank );
end

function LoadPlayerMount()
	--PlayerMount = Turbine.PluginData.Load( Turbine.DataScope.Server, "TitanBarMount" );
	--if PlayerMount == nil then PlayerMount = {}; end
	--if PlayerMount[PN] == nil then PlayerMount[PN] = {}; end
	--ShowTableContent(PlayerMount[PN]);
end

function SavePlayerMount()
	--if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play character

	--Turbine.PluginData.Save( Turbine.DataScope.Server, "TitanBarMount", PlayerBank );
end

function LoadPlayerPet()
	--PlayerPet = Turbine.PluginData.Load( Turbine.DataScope.Server, "TitanBarPet" );
	--if PlayerPet == nil then PlayerPet = {}; end
	--if PlayerPet[PN] == nil then PlayerPet[PN] = {}; end
	--ShowTableContent(PlayerPet[PN]);
end

function SavePlayerPet()
	--if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play character

	--Turbine.PluginData.Save( Turbine.DataScope.Server, "TitanBarPet", PlayerBank );
end

function LoadPlayerReputation()
	RepFR = { "La confr\195\168rie de la cervoise", "Les Eldgangs", "Conseil du Nord", "Hommes de Bree", "Palais de Thorin", "Les Gardiens d'Annuminas", "Lossoth du Forochel",
				"Les Eglain", "R\195\180deurs d'Esteld\195\173n", "Elfes de Foncombe", "La Soci\195\169t\195\169 des Mathoms", "La Ligue des Tavernes", "Gardes de la Garnison de fer",
				"Minuers de la Garnison de fer", "Les Algraig, Hommes d'Enedwaith", "La Compagnie grise", "Galadhrim", "Malledhrim", "Les Cavaliers de Stangarde", "Les H\195\169ros de la Gorge de Limeclair",
				"Hommes du Pays de Dun", "Les Cavaliers de Th\195\169odred", "Guilde des bijoutiers", "Guilde des cuisiniers", "Guilde des \195\169rudits", "Guilde des tailleurs", "Guilde des menuisiers",
				"Guilde des fabricants d'armes", "Guilde des ferroniers", "Hommes de la vall\195\169e de l'Entalluve", "Hommes des Norcrofts", "Hommes des Sutcrofts", "Hommes du Plateau", "Peuple des Landes farouches", "Survivants des Landes farouches", "Les Eorlingas", "Les Helmingas" }

	RepEN = { "The Ale Association", "The Eldgang", "Council of the North", "Men of Bree", "Thorin's Hall", "The Wardens of Ann\195\186minas", "Lossoth of Forochel", "The Eglain",
				"Rangers of Esteld\195\173n", "Elves of Rivendell", "The Mathom Society", "The Inn League", "Iron Garrison Guards", "Iron Garrison Miners", "Algraig, Men of Enedwaith",
				"The Grey Company", "Galadhrim", "Malledhrim", "The Riders of Stangard", "Heroes of Limlight Gorge", "Men of Dunland", "Th\195\169odred's Riders",
				"Jeweller's Guild", "Cook's Guild", "Scholar's Guild", "Tailor's Guild", "Woodworker's Guild", "Weaponsmith's Guild", "Metalsmith's Guild", "Men of the Entwash Vale",
				"Men of the Norcrofts", "Men of the Sutcrofts", "Men of the Wold", "People of Wildermore", "Survivors of Wildermore", "The Eorlingas", "The Helmingas" }

	RepDE = { "Die Bier-Genossenschaft", "Die Eldgang", "Rat des Nordens", "Menschen von Bree", "Thorins Halle", "Die H\195\188ter von Ann\195\186minas", "Lossoth von Forochel", "Die Eglain",
				"Waldl\195\164ufer von Esteld\195\173n", "Elben von Bruchtal", "Die Mathom-Gesellschaft", "Die Gasthausliga", "W\195\164chter der eisernen Garnison", "Minenbauer der Eisernen Garnison",
				"Algraig, Menschen von Enedwaith", "Die Graue Schar", "Galadhrim", "Malledhrim", "Die Reiter von Stangard", "Helden der Limklar-Schlucht", "Menschen aus Dunland", "Th\195\169odreds Reiter",
				"Goldschmiedegilde", "Kochgilde", "Gelehrtengilde", "Schneidergilde", "Drechslergilde", "Waffenschmiedegilde", "Schmiedegilde", "Menschen des Entwasser-Tals",
				"Menschen der Norhofen", "Menschen der Suthofen", "Menschen der Steppe", "Bewohner der Wildermark", "\195\156berlebende von Wildermark", "Die Eorlingas", "Die Helmingas" }

	PlayerReputation = Turbine.PluginData.Load( Turbine.DataScope.Server, "TitanBarReputation" );
	if PlayerReputation == nil then PlayerReputation = {}; end
	if PlayerReputation[PN] == nil then PlayerReputation[PN] = {}; end
	for i = 1, #FactionOrder do
		if PlayerReputation[PN][tostring(FactionOrder[i])] == nil then PlayerReputation[PN][tostring(FactionOrder[i])] = {}; end
		PlayerReputation[PN][tostring(FactionOrder[i])].en = RepEN[FactionOrder[i]]; --English Faction name
		PlayerReputation[PN][tostring(FactionOrder[i])].fr = RepFR[FactionOrder[i]]; --French Faction name
		PlayerReputation[PN][tostring(FactionOrder[i])].de = RepDE[FactionOrder[i]]; --Deutsch Faction name
		if PlayerReputation[PN][tostring(FactionOrder[i])].P == nil then PlayerReputation[PN][tostring(FactionOrder[i])].P = "0"; end --Points
		if PlayerReputation[PN][tostring(FactionOrder[i])].V == nil then PlayerReputation[PN][tostring(FactionOrder[i])].V = false; end --Show faction in tooltip
		if PlayerReputation[PN][tostring(FactionOrder[i])].R == nil then PlayerReputation[PN][tostring(FactionOrder[i])].R = "1"; end --1st rank max points
		if i > maxfaction then if PlayerReputation[PN][tostring(FactionOrder[i])].S == nil then PlayerReputation[PN][tostring(FactionOrder[i])].S = "guild"; end --good/bad/guild
		else if PlayerReputation[PN][tostring(FactionOrder[i])].S == nil then PlayerReputation[PN][tostring(FactionOrder[i])].S = "good"; end end --good/bad/guild
		--if PlayerReputation[PN][tostring(FactionOrder[i])].N ~= nil then PlayerReputation[PN][tostring(FactionOrder[i])].N = nil; end
	end

	SavePlayerReputation();
end

function SavePlayerReputation()
	if string.sub( PN, 1, 1 ) == "~" then return end; --Ignore session play character

	Turbine.PluginData.Save( Turbine.DataScope.Server, "TitanBarReputation", PlayerReputation );
end

function LoadPlayerTurbinePoints()
	PlayerTurbinePoints = Turbine.PluginData.Load( Turbine.DataScope.Account, "TitanBarTurbinePoints" );
	if PlayerTurbinePoints == nil then PlayerTurbinePoints = {}; end
	if PlayerTurbinePoints.PTS == nil then PlayerTurbinePoints.PTS = "0"; end
	_G.TurbinePTS = PlayerTurbinePoints.PTS;
end

function SavePlayerTurbinePoints()
	PlayerTurbinePoints.PTS = string.format("%.0f", _G.TurbinePTS);
	Turbine.PluginData.Save( Turbine.DataScope.Account, "TitanBarTurbinePoints", PlayerTurbinePoints );
end

function UpdateCurrency(str)
	if str == pwShard and ShowShards then UpdateShards(); end
	if str == pwMark and ShowSkirmishMarks then UpdateMarks(); end
	if str == pwMedallion and ShowMedallions then UpdateMedallions(); end
	if str == pwSeal and ShowSeals then UpdateSeals(); end
	if str == pwCommendation and ShowCommendations then UpdateCommendations(); end
end

function GetCurrency(str)
	CurQuantity = 0;
	
	for k,v in pairs(PlayerCurrency) do
		if k == str then
			CurQuantity = PlayerCurrency[str]:GetQuantity();
			break
		end
	end
	
	return CurQuantity
end