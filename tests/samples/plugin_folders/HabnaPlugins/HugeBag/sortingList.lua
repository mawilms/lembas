-- sortingList.lua version 161 (10-29-2012 12:10 PM) - ( http://www.lotrointerface.com/downloads/info457-SortPack.html )
-- Written By MrJackdaw


ItemCategory={}	

--Trying to fill the holes in Item Category
--Revise this when Turbine fix the ItemCategory enumeration.
ItemCategory[89]= "BarterReputation"

ItemCategory[111]= "GuardianBelt"

ItemCategory[163]= "MinstrelBook"

ItemCategory[173]= "Special"

ItemCategory[177]= "Skirmish"
ItemCategory[178]= "Barter"
ItemCategory[179]= "ShieldSpikes"
ItemCategory[180]= "OutfitFeet"
ItemCategory[181]= "OutfitShoulder"
ItemCategory[182]= "OutfitUpperbody"
ItemCategory[183]= "OutfitHead"
ItemCategory[184]= "OutfitGloves"
ItemCategory[185]= "OutfitTrousers" -- Thanks Galureth
ItemCategory[186]= "SkillScrolls"
ItemCategory[187]= "ChampionHorns"
ItemCategory[188]= "CraftOptionalIngredient"
ItemCategory[189]= "Perks"
ItemCategory[190]= "TomeOf" --Is it just tome of will?
ItemCategory[191]= "TravelAndMaps"

ItemCategory[194]= "RelicScroll"
ItemCategory[195]= "WestfoldMetalworkScroll"
ItemCategory[196]= "WestfoldJewellerScroll"
ItemCategory[197]= "WestfoldWoodworkScroll"
ItemCategory[198]= "WestfoldWeaponsmithScroll"
ItemCategory[199]= "WestfoldTailorScroll"

ItemCategory[201]= "WestfoldForesterScroll"

ItemCategory[203]= "WestfoldCookScroll"
ItemCategory[204]= "WestfoldScholarScroll"
ItemCategory[205]= "FestivalConsumable" --Thanks eloyolo

ItemCategory[207]= "Misc 2" --Thanks ralphtro
ItemCategory[208]="EastemnetMetalworkScroll"
ItemCategory[209]="EastemnetJewellerScroll"		--A guess!
ItemCategory[210]="EastemnetWoodworkScroll"		--A guess!
ItemCategory[211]="EastemnetWeaponsmithScroll"
ItemCategory[212]="EastemnetTailorScroll"
--ItemCategory[213]="Eastemnet
ItemCategory[214]="EastemnetForesterScroll"
--ItemCategory[215]="Eastemnet
ItemCategory[216]="EastemnetCookScroll"
ItemCategory[217]="EastemnetScholarScroll"

ItemCategory[218]="Legendary Bridle"

--This next line *could* overwrite the data above, if Turbine ever fix the categories.
for i,v in pairs(Turbine.Gameplay.ItemCategory) do ItemCategory[v]=i end

if list==nil then
	list={}
	--Turbine.Shell.WriteLine("<rgb=#00FF00>SortPack loaded. /Sort to sort the backpack, /SortOption to change the order</rgb>")
	
	CraftScroll={
	"ApprenticeCookScroll",
	"ApprenticeFarmerScroll",
	"ApprenticeForestryScroll",
	"ApprenticeJewellerScroll",
	"ApprenticeMetalworkScroll",
	"ApprenticeProspectingScroll",
	"ApprenticeScholarScroll",
	"ApprenticeTailorScroll",
	"ApprenticeWeaponsmithScroll",
	"ApprenticeWoodworkScroll",
	"ArtisanCookScroll",
	"ArtisanFarmerScroll",
	"ArtisanForestryScroll",
	"ArtisanJewellerScroll",
	"ArtisanMetalworkScroll",
	"ArtisanProspectingScroll",
	"ArtisanScholarScroll",
	"ArtisanTailorScroll",
	"ArtisanWeaponsmithScroll",
	"ArtisanWoodworkScroll",
	"ExpertCookScroll",
	"ExpertFarmerScroll",
	"ExpertForestryScroll",
	"ExpertJewellerScroll",
	"ExpertMetalworkScroll",
	"ExpertProspectingScroll",
	"ExpertScholarScroll",
	"ExpertTailorScroll",
	"ExpertWeaponsmithScroll",
	"ExpertWoodworkScroll",
	"JourneymanCookScroll",
	"JourneymanFarmerScroll",
	"JourneymanForestryScroll",
	"JourneymanJewellerScroll",
	"JourneymanMetalworkScroll",
	"JourneymanProspectingScroll",
	"JourneymanScholarScroll",
	"JourneymanTailorScroll",
	"JourneymanWeaponsmithScroll",
	"JourneymanWoodworkScroll",
	"MasterCookScroll",
	"MasterFarmerScroll",
	"MasterForestryScroll",
	"MasterJewellerScroll",
	"MasterMetalworkScroll",
	"MasterProspectingScroll",
	"MasterScholarScroll",
	"MasterTailorScroll",
	"MasterWeaponsmithScroll",
	"MasterWoodworkScroll",
	"SupremeCookScroll",
	"SupremeFarmerScroll",
	"SupremeForestryScroll",
	"SupremeJewellerScroll",
	"SupremeMetalworkScroll",
	"SupremeProspectingScroll",
	"SupremeScholarScroll",
	"SupremeTailorScroll",
	"SupremeWeaponsmithScroll",
	"SupremeWoodworkScroll"}
	CraftScroll.Name="CraftScroll"
	
	Tool={
	"Tool"}
	Tool.Name="Tool"

	Weapons={
	"Axe",
	"Bow",
	"Club",
	"Crossbow",
	"Dagger",
	"Book",
	"Halberd",
	"Hammer",
	"Instrument",
	"Javelin",
	"Mace",
	"Minstrel",
	"Spear",
	"Shield",
	"Staff",
	"Sword",
	"Thrown",
	"Weapon"}
	Weapons.Name="Weapons"
	
	Armor={
	"Armor",
	"GuardianBelt",
	"Back",
	"Chest",
	"Clothing",
	"CosmeticBack",
	"CosmeticHeld",
	"Feet",
	"Hands",
	"Head",
	"Jewelry",
	"Legs",
	"MinstrelBook",
	"Shoulders",
	"OutfitFeet",									--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	"OutfitUpperbody",							--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	"OutfitHead",									--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	"OutfitShoulder",								--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	"OutfitGloves"									--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	}
	Armor.Name="Armor"
	
	Dye={
	"Dye"}
	Dye.Name="Dye"
	
	Fishing={
	"Fish",
	"FishingBait",
	"FishingOther",
	"FishingPole"}
	Fishing.Name="Fishing"
	
	Class={
	"Runekeeper",
	"Burglar",
	"Captain",
	"Guardian",
	"Champion",
	 "ChampionHorns",							--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	"Loremaster",
	"Hunter",
	"Warden"}
	Class.Name="Class"
	
	Food={
	"Food",
	"LoremasterFood"}
	Food.Name="Food"
	
	Decoration={
	"CeilingDecoration",
	"Decoration",
	"FloorDecoration",
	"FurnitureDecoration",
	"MusicDecoration",
	"SpecialDecoration",
	"Trophy",
	"TrophyDecoration",
	"YardDecoration",
	"WallDecoration",
	"SurfacePaintDecoration"}
	Decoration.Name="Decoration"
	
	Legend={
	"LegendaryWeaponExperience",
	"LegendaryWeaponIncreaseMaxLevel",
	"LegendaryWeaponReplaceLegacy",
	"LegendaryWeaponReset",
	"LegendaryWeaponUpgradeLegacy"}
	Legend.Name="Legend"
	
	Potion={
	"Potion"}
	Potion.Name="Potion"
	
	Device={
	"Device"}
	Device.Name="Device"
	
	Craft={
	"Component",
	"Crafting",
	"Ingredient",
	"CraftOptionalIngredient"				--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	}
	Craft.Name="Craft"
	
	BuffItem={
	"Scroll",
	"Trap",
	"ShieldSpikes",								--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	"Oil"}
	BuffItem.Name="BuffItem"
	
	Misc={

	"CraftingTrophy",
	"Deconstructable",
	"Effect",
	"Healing",
	"Implement",

	"Key",
	"KinshipCharter",

	"Mounts",
	"NonInventory",

	"Orb",
	"Pennant",
	"Quest",
	"Relic",
	"Resource",

	"SpecialTrophy",


	"Treasure",
	"Undefined",

	"BarterReputation",						--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	 "Special",										--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	"BarterSkirmish",							--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	 "Barter",											--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	"SkillScrolls",									--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	 
	 "Perks",											--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	 "TravelAndMaps",							--CUSTOM! Remove when Turbine fix the ItemCategory Enumeration
	 "Misc"
	}
	Misc.Name="Misc"

	Instrument={
	"Instrument"}
	Instrument.Name="Instrument"

	mergetable(list,{Tool,Device,Potion,BuffItem,Food,Legend,Weapons,Instrument,Armor,Class,Craft,Dye,Fishing,Decoration,CraftScroll,Misc})
end

--Now, change the way the table works.
--This changes the text list to a numbered list. so, for example, value["Tool"] would equal 150 or whatever.
function listtonum()
	value={}
	for i,v in pairs(list) do 
		value[v]=i					--This converts say, list[1]="Geoff" to value[Geoff]=1 Nice huh?
	end
end

listtonum()

--Repair function if any new item categories have been added
for i,v in pairs(ItemCategory) do
	if value[ItemCategory[i]]==nil then
		table.insert(list,ItemCategory[i])
		listtonum()
	end
end