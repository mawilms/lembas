-- itemsmenu.lua
-- Written By Habna


itemsmenu = Turbine.UI.ContextMenu();
itemsmenu.items = itemsmenu:GetItems();
NumOptClic = 0;


AllItems = Turbine.UI.MenuItem( L["ShowAll"] );
AllItems:SetChecked(true);
AllItems:SetEnabled(false);

AllItems.Click = function( sender, args )
	AllItems:SetChecked(true);
	AllItems:SetEnabled(false);
	SearchInput.FocusLost();
	ResetAllCheck();
	ShowItemsMenu();
end	


ToShowMenu = Turbine.UI.MenuItem( L["Show"] );
ToShowMenuItems = ToShowMenu:GetItems();
	ToShowItems = {};
	aToShow = {"Potion","Healing","Tool","Device","Jewelry","Component","BarterReputation","Quest","Resource","Perks","Misc","Misc 2","Mounts","Special","Dye","Relic","Festival","MinstrelBook","Tome"};
	aToShowText = {L["Potions"],L["Healing"],L["Tools"],L["Devices"],L["Jewelry"],L["Components"],L["BR"],L["QI"],L["Resources"],L["Perks"],L["Misc"],L["Misc2"],L["Mounts"],L["Special"],L["Dye"],L["Relic"],L["Festival"],L["Book"],L["Tome"]};

	for y = 1, #aToShow do
		ToShowItems[y] = Turbine.UI.MenuItem(aToShowText[y]);
		ToShowItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			ItemsSel = not ToShowItems[y]:IsChecked();
			ShowItems(aToShow[y]);
			ToShowItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end
		
	for i = 1, #ToShowItems do ToShowMenuItems:Add( ToShowItems[i] ); end


BuffMenu = Turbine.UI.MenuItem( L["ShowBuff"] );
BuffMenuItems = BuffMenu:GetItems();
	BuffItems = {};
	aBuff = {"Scroll", "Trap", "ShieldSpikes", "Oil"};
	aBuffText = {L["Scroll"], L["Trap"], L["SP"], L["Oil"]};

	BuffItems[1] = Turbine.UI.MenuItem( L["All"] );
	BuffItems[1].Click = function( sender, args )
		AllItems:SetChecked(false);
		AllItems:SetEnabled(true);
		ItemsSel = not BuffItems[1]:IsChecked();
		for x = 1, #aBuff do ShowItems(aBuff[x]); end
		BuffItems[1]:SetChecked(ItemsSel);
		CheckNumClic();
		for y = 1, #aBuff do
			if BuffItems[y+1]:IsChecked() then NumOptClic = NumOptClic - 1; end
			BuffItems[y+1]:SetChecked(false);
		end
		ShowItemsMenu();
	end

	for y = 2, #aBuff+1 do
		BuffItems[y] = Turbine.UI.MenuItem(aBuffText[y-1]);
		BuffItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			if BuffItems[1]:IsChecked() then BuffItems[1].Click( sender, args ); end
			ItemsSel = not BuffItems[y]:IsChecked();
			ShowItems(aBuff[y-1]);
			BuffItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end
		
	for i = 1, #BuffItems do BuffMenuItems:Add( BuffItems[i] ); end


LegendMenu = Turbine.UI.MenuItem( L["ShowLegendary"] );
LegendMenuItems = LegendMenu:GetItems();
	LegendItems = {};
	aLegend = {"LegendaryWeaponExperience", "LegendaryWeaponIncreaseMaxLevel", "LegendaryWeaponReplaceLegacy", "LegendaryWeaponReset", "LegendaryWeaponUpgradeLegacy"};
	aLegendText = {L["WE"], L["WIML"], L["WRL"], L["WR"], L["WUL"]};

	LegendItems[1] = Turbine.UI.MenuItem( L["All"] );
	LegendItems[1].Click = function( sender, args )
		AllItems:SetChecked(false);
		AllItems:SetEnabled(true);
		ItemsSel = not LegendItems[1]:IsChecked();
		for x = 1, #aLegend do ShowItems(aLegend[x]); end
		LegendItems[1]:SetChecked(ItemsSel);
		CheckNumClic();
		if NumOptClic == 0 then AllItems.Click( sender, args ); end
		for y = 1, #aLegend do
			if LegendItems[y+1]:IsChecked() then NumOptClic = NumOptClic - 1; end
			LegendItems[y+1]:SetChecked(false);
		end
		ShowItemsMenu();
	end

	for y = 2, #aLegend+1 do
		LegendItems[y] = Turbine.UI.MenuItem(aLegendText[y-1]);
		LegendItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			if LegendItems[1]:IsChecked() then LegendItems[1].Click( sender, args ); end
			ItemsSel = not LegendItems[y]:IsChecked();
			ShowItems(aLegend[y-1]);
			LegendItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end
		
	for i = 1, #LegendItems do LegendMenuItems:Add( LegendItems[i] ); end


FishingMenu = Turbine.UI.MenuItem( L["ShowFishing"] );
FishingMenuItems = FishingMenu:GetItems();
	FishingItems = {};
	aFishing = {"Fish", "FishingBait", "FishingPole", "FishingOther"};
	aFishingText = {L["Fish"], L["Bait"], L["Pole"], L["Other"]};

	FishingItems[1] = Turbine.UI.MenuItem( L["All"] );
	FishingItems[1].Click = function( sender, args )
		AllItems:SetChecked(false);
		AllItems:SetEnabled(true);
		ItemsSel = not FishingItems[1]:IsChecked();
		for x = 1, #aFishing do ShowItems(aFishing[x]); end
		FishingItems[1]:SetChecked(ItemsSel);
		CheckNumClic();
		for y = 1, #aFishing do
			if FishingItems[y+1]:IsChecked() then NumOptClic = NumOptClic - 1; end
			FishingItems[y+1]:SetChecked(false);
		end
		ShowItemsMenu();
	end

	for y = 2, #aFishing+1 do
		FishingItems[y] = Turbine.UI.MenuItem(aFishingText[y-1]);
		FishingItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			if FishingItems[1]:IsChecked() then FishingItems[1].Click( sender, args ); end
			ItemsSel = not FishingItems[y]:IsChecked();
			ShowItems(aFishing[y-1]);
			FishingItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end
		
	for i = 1, #FishingItems do FishingMenuItems:Add( FishingItems[i] ); end


FoodMenu = Turbine.UI.MenuItem( L["ShowFoods"] );
FoodMenuItems = FoodMenu:GetItems();
	FoodItems = {};
	aFood = {"Food", "LoremasterFood"};
	aFoodText = {L["Food"], L["Lore-Master"]};

	FoodItems[1] = Turbine.UI.MenuItem( L["All"]);
	FoodItems[1].Click = function( sender, args )
		AllItems:SetChecked(false);
		AllItems:SetEnabled(true);
		ItemsSel = not FoodItems[1]:IsChecked();
		for x = 1, #aFood do ShowItems(aFood[x]); end
		FoodItems[1]:SetChecked(ItemsSel);
		CheckNumClic();
		for y = 1, #aFood do
			if FoodItems[y+1]:IsChecked() then NumOptClic = NumOptClic - 1; end
			FoodItems[y+1]:SetChecked(false);
		end
		ShowItemsMenu();
	end

	for y = 2, #aFood+1 do
		FoodItems[y] = Turbine.UI.MenuItem(aFoodText[y-1]);
		FoodItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			if FoodItems[1]:IsChecked() then FoodItems[1].Click( sender, args ); end
			ItemsSel = not FoodItems[y]:IsChecked();
			ShowItems(aFood[y-1]);
			FoodItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end
		
	for i = 1, #FoodItems do FoodMenuItems:Add( FoodItems[i] ); end


IngredientMenu = Turbine.UI.MenuItem( L["ShowIngredient"] );
IngredientMenuItems = IngredientMenu:GetItems();
	IngredientItems = {};
	aIngredient = {"Ingredient", "OptionalIngredient"};
	aIngredientText = {L["Ingredient"], L["OI"]};

	IngredientItems[1] = Turbine.UI.MenuItem( L["All"] );
	IngredientItems[1].Click = function( sender, args )
		AllItems:SetChecked(false);
		AllItems:SetEnabled(true);
		ItemsSel = not IngredientItems[1]:IsChecked();
		for x = 1, #aIngredient do ShowItems(aIngredient[x]); end
		IngredientItems[1]:SetChecked(ItemsSel);
		CheckNumClic();
		for y = 1, #aIngredient do
			if IngredientItems[y+1]:IsChecked() then NumOptClic = NumOptClic - 1; end
			IngredientItems[y+1]:SetChecked(false);
		end
		ShowItemsMenu();
	end

	for y = 2, #aIngredient+1 do
		IngredientItems[y] = Turbine.UI.MenuItem(aIngredientText[y-1]);
		IngredientItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			if IngredientItems[1]:IsChecked() then IngredientItems[1].Click( sender, args ); end
			ItemsSel = not IngredientItems[y]:IsChecked();
			ShowItems(aIngredient[y-1]);
			IngredientItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end
		
	for i = 1, #IngredientItems do IngredientMenuItems:Add( IngredientItems[i] ); end


TrophyMenu = Turbine.UI.MenuItem( L["ShowTrophys"] );
TrophyMenuItems = TrophyMenu:GetItems();
	TrophyItems = {};
	aTrophy = {"Trophy","SpecialTrophy"};
	aTrophyText = {L["Trophy"],L["ST"]};

	TrophyItems[1] = Turbine.UI.MenuItem( L["All"] );
	TrophyItems[1].Click = function( sender, args )
		AllItems:SetChecked(false);
		AllItems:SetEnabled(true);
		ItemsSel = not TrophyItems[1]:IsChecked();
		for x = 1, #aTrophy do ShowItems(aTrophy[x]); end
		TrophyItems[1]:SetChecked(ItemsSel);
		CheckNumClic();
		for y = 1, #aTrophy do
			if TrophyItems[y+1]:IsChecked() then NumOptClic = NumOptClic - 1; end
			TrophyItems[y+1]:SetChecked(false);
		end
		ShowItemsMenu();
	end

	for y = 2, #aTrophy+1 do
		TrophyItems[y] = Turbine.UI.MenuItem(aTrophyText[y-1]);
		TrophyItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			if TrophyItems[1]:IsChecked() then TrophyItems[1].Click( sender, args ); end
			ItemsSel = not TrophyItems[y]:IsChecked();
			ShowItems(aTrophy[y-1]);
			TrophyItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end
		
	for i = 1, #TrophyItems do TrophyMenuItems:Add( TrophyItems[i] ); end


RecipeMenu = Turbine.UI.MenuItem( L["ShowRecipes"] );
RecipeMenuItems = RecipeMenu:GetItems();
	RecipeItems = {};
	aRecipe = {"Metalwork","Weaponsmith","Tailor","Jeweller","Cook","Scholar","Woodwork", "Farmer", "Prospecting", "Forestry"};
	aRecipeText = {L["MS"],L["WS"],L["Tailor"],L["Jeweller"],L["Cook"],L["Scholar"],L["WW"],L["Farmer"],L["Prospecter"],L["Forester"]};

	RecipeItems[1] = Turbine.UI.MenuItem( L["All"] );
	RecipeItems[1].Click = function( sender, args )
		AllItems:SetChecked(false);
		AllItems:SetEnabled(true);
		ItemsSel = not RecipeItems[1]:IsChecked();
		for x = 1, #aRecipe do
			ShowItems(L["Apprentice"]..aRecipe[x].."Scroll");
			ShowItems(L["Journeyman"]..aRecipe[x].."Scroll");
			ShowItems(L["Expert"]..aRecipe[x].."Scroll");
			ShowItems(L["Artisan"]..aRecipe[x].."Scroll");
			ShowItems(L["Master"]..aRecipe[x].."Scroll");
			ShowItems(L["Supreme"]..aRecipe[x].."Scroll");
			ShowItems(L["Westfold"]..aRecipe[x].."Scroll");
		end
		RecipeItems[1]:SetChecked(ItemsSel);
		CheckNumClic();
		for y = 1, #aRecipe do
			if RecipeItems[y+1]:IsChecked() then NumOptClic = NumOptClic - 1; end
			RecipeItems[y+1]:SetChecked(false);
		end
		ShowItemsMenu();
	end

	for y = 2, #aRecipe+1 do
		RecipeItems[y] = Turbine.UI.MenuItem(aRecipeText[y-1]);
		RecipeItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			if RecipeItems[1]:IsChecked() then RecipeItems[1].Click( sender, args ); end
			ItemsSel = not RecipeItems[y]:IsChecked();
			ShowItems(L["Apprentice"]..aRecipe[y-1].."Scroll");
			ShowItems(L["Journeyman"]..aRecipe[y-1].."Scroll");
			ShowItems(L["Expert"]..aRecipe[y-1].."Scroll");
			ShowItems(L["Artisan"]..aRecipe[y-1].."Scroll");
			ShowItems(L["Master"]..aRecipe[y-1].."Scroll");
			ShowItems(L["Supreme"]..aRecipe[y-1].."Scroll");
			ShowItems(L["Westfold"]..aRecipe[y-1].."Scroll");
			RecipeItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end
		
	for i = 1, #RecipeItems do RecipeMenuItems:Add( RecipeItems[i] ); end


WeaponMenu = Turbine.UI.MenuItem( L["ShowWeapon"] );
WeaponMenuItems = WeaponMenu:GetItems();
	WeaponItems = {};
	aWeapon = {"Axe","Club","Crossbow","Bow","Dagger","Halberd","Mace","Staff","Sword","Hammer","Orb","Javelin","Spear"};
	aWeaponText = {L["Axe"],L["Club"],L["Crossbow"],L["Bow"],L["Dagger"],L["Halberd"],L["Mace"],L["Staff"],L["Sword"],L["Hammer"],L["Orb"],L["Javelin"],L["Spear"]};

	WeaponItems[1] = Turbine.UI.MenuItem( L["All"] );
	WeaponItems[1].Click = function( sender, args )
		AllItems:SetChecked(false);
		AllItems:SetEnabled(true);
		ItemsSel = not WeaponItems[1]:IsChecked();
		for x = 1, #aWeapon do ShowItems(aWeapon[x]); end
		WeaponItems[1]:SetChecked(ItemsSel);
		CheckNumClic();
		for y = 1, #aWeapon do
			if WeaponItems[y+1]:IsChecked() then NumOptClic = NumOptClic - 1; end
			WeaponItems[y+1]:SetChecked(false);
		end
		ShowItemsMenu();
	end

	for y = 2, #aWeapon+1 do
		WeaponItems[y] = Turbine.UI.MenuItem(aWeaponText[y-1]);
		WeaponItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			if WeaponItems[1]:IsChecked() then WeaponItems[1].Click( sender, args ); end
			ItemsSel = not WeaponItems[y]:IsChecked();
			ShowItems(aWeapon[y-1]);
			WeaponItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end
		
	for i = 1, #WeaponItems do WeaponMenuItems:Add( WeaponItems[i] ); end


ArmorMenu = Turbine.UI.MenuItem( L["ShowArmor"] );
ArmorMenuItems = ArmorMenu:GetItems();
	ArmorItems = {};
	aArmor = {"Feet","Legs","Hands","Chest","Back","Shoulders","Head","Shield","GuardianBelt"};
	aArmorText = {L["Shoes"],L["Leggings"],L["Gloves"],L["Chest"],L["Cloak"],L["Shoulder"],L["Hat"],L["Shield"],L["GuardianBelt"]};

	ArmorItems[1] = Turbine.UI.MenuItem( L["All"] );
	ArmorItems[1].Click = function( sender, args )
		AllItems:SetChecked(false);
		AllItems:SetEnabled(true);
		ItemsSel = not ArmorItems[1]:IsChecked();
		for x = 1, #aArmor do ShowItems(aArmor[x]); end
		ArmorItems[1]:SetChecked(ItemsSel);
		CheckNumClic();
		for y = 1, #aArmor do
			if ArmorItems[y+1]:IsChecked() then NumOptClic = NumOptClic - 1; end
			ArmorItems[y+1]:SetChecked(false);
		end
		ShowItemsMenu();
	end

	for y = 2, #aArmor+1 do
		ArmorItems[y] = Turbine.UI.MenuItem(aArmorText[y-1]);
		ArmorItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			if ArmorItems[1]:IsChecked() then ArmorItems[1].Click( sender, args ); end
			ItemsSel = not ArmorItems[y]:IsChecked();
			ShowItems(aArmor[y-1]);
			ArmorItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end

	for i = 1, #ArmorItems do ArmorMenuItems:Add( ArmorItems[i] ); end


ClassMenu = Turbine.UI.MenuItem( L["ShowClass"] );
ClassMenuItems = ClassMenu:GetItems();
	ClassItems = {};
	aClass = {"Loremaster","Runekeeper","Hunter","Champion","Warden","Guardian","Burglar","Captain","Minstrel"};
	aClassText = {L["Lore-Master"],L["Rune-Keeper"],L["Hunter"],L["Champion"],L["Warden"],L["Guardian"],L["Burglar"],L["Captain"],L["Minstrel"]};

	ClassItems[1] = Turbine.UI.MenuItem( L["All"] );
	ClassItems[1].Click = function( sender, args )
		AllItems:SetChecked(false);
		AllItems:SetEnabled(true);
		ItemsSel = not ClassItems[1]:IsChecked();
		for x = 1, #aClass do ShowItems(aClass[x]); end
		ClassItems[1]:SetChecked(ItemsSel);
		CheckNumClic();
		for y = 1, #aClass do
			if ClassItems[y+1]:IsChecked() then NumOptClic = NumOptClic - 1; end
			ClassItems[y+1]:SetChecked(false);
		end
		ShowItemsMenu();
	end

	for y = 2, #aClass+1 do
		ClassItems[y] = Turbine.UI.MenuItem(aClassText[y-1]);
		ClassItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			if ClassItems[1]:IsChecked() then ClassItems[1].Click( sender, args ); end
			ItemsSel = not ClassItems[y]:IsChecked();
			ShowItems(aClass[y-1]);
			ClassItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end
	
	for i = 1, #ClassItems do ClassMenuItems:Add( ClassItems[i] ); end


CosmeticMenu = Turbine.UI.MenuItem( L["ShowCosmetic"] );
CosmeticMenuItems = CosmeticMenu:GetItems();
	CosmeticItems = {};
	aCosmetic = {"CosmeticBack","OutfitHead","OutfitUpperbody","OutfitFeet","OutfitGloves","OutfitShoulder"};
	aCosmeticText = {L["Back"],L["Head"],L["UB"],L["Feet"],L["Gloves"],L["Shoulder"]};

	CosmeticItems[1] = Turbine.UI.MenuItem( L["All"] );
	CosmeticItems[1].Click = function( sender, args )
		AllItems:SetChecked(false);
		AllItems:SetEnabled(true);
		ItemsSel = not CosmeticItems[1]:IsChecked();
		for x = 1, #aCosmetic do ShowItems(aCosmetic[x]); end
		CosmeticItems[1]:SetChecked(ItemsSel);
		CheckNumClic();
		for y = 1, #aCosmetic do
			if CosmeticItems[y+1]:IsChecked() then NumOptClic = NumOptClic - 1; end
			CosmeticItems[y+1]:SetChecked(false);
		end
		ShowItemsMenu();
	end

	for y = 2, #aCosmetic+1 do
		CosmeticItems[y] = Turbine.UI.MenuItem(aCosmeticText[y-1]);
		CosmeticItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			if CosmeticItems[1]:IsChecked() then CosmeticItems[1].Click( sender, args ); end
			ItemsSel = not CosmeticItems[y]:IsChecked();
			ShowItems(aCosmetic[y-1]);
			CosmeticItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end
	
	for i = 1, #CosmeticItems do CosmeticMenuItems:Add( CosmeticItems[i] ); end


DecorationMenu = Turbine.UI.MenuItem( L["ShowDecoration"] );
DecorationMenuItems = DecorationMenu:GetItems();
	DecorationItems = {};
	aDecoration = {"CeilingDecoration", "FloorDecoration", "FurnitureDecoration", "MusicDecoration", "SpecialDecoration", "TrophyDecoration",
					"YardDecoration", "WallDecoration", "SurfacePaintDecoration"};
	aDecorationText = {L["Ceiling"],L["Floor"],L["Furniture"],L["Music"],L["Special"],L["Trophy"],L["Yard"],L["Wall"],L["SurfacePaint"]};

	DecorationItems[1] = Turbine.UI.MenuItem( L["All"] );
	DecorationItems[1].Click = function( sender, args )
		AllItems:SetChecked(false);
		AllItems:SetEnabled(true);
		ItemsSel = not DecorationItems[1]:IsChecked();
		for x = 1, #aDecoration do ShowItems(aDecoration[x]); end
		DecorationItems[1]:SetChecked(ItemsSel);
		CheckNumClic();
		for y = 1, #aDecoration do
			if DecorationItems[y+1]:IsChecked() then NumOptClic = NumOptClic - 1; end
			DecorationItems[y+1]:SetChecked(false);
		end
		ShowItemsMenu();
	end

	for y = 2, #aDecoration+1 do
		DecorationItems[y] = Turbine.UI.MenuItem(aDecorationText[y-1]);
		DecorationItems[y].Click = function( sender, args )
			AllItems:SetChecked(false);
			AllItems:SetEnabled(true);
			if DecorationItems[1]:IsChecked() then DecorationItems[1].Click( sender, args ); end
			ItemsSel = not DecorationItems[y]:IsChecked();
			ShowItems(aDecoration[y-1]);
			DecorationItems[y]:SetChecked(ItemsSel);
			CheckNumClic();
			ShowItemsMenu();
		end
	end
	
	for i = 1, #DecorationItems do DecorationMenuItems:Add( DecorationItems[i] ); end

local option_line = Turbine.UI.MenuItem("-----------------------------------", false);


itemsmenu.items:Add(AllItems);
itemsmenu.items:Add(option_line);
itemsmenu.items:Add(ToShowMenu);
itemsmenu.items:Add(LegendMenu);
itemsmenu.items:Add(WeaponMenu);
itemsmenu.items:Add(ArmorMenu);
itemsmenu.items:Add(ClassMenu);
itemsmenu.items:Add(RecipeMenu);
itemsmenu.items:Add(IngredientMenu);
itemsmenu.items:Add(BuffMenu);
itemsmenu.items:Add(FoodMenu);
itemsmenu.items:Add(FishingMenu);
itemsmenu.items:Add(TrophyMenu);
itemsmenu.items:Add(CosmeticMenu);
itemsmenu.items:Add(DecorationMenu);


function ResetAllCheck()
	NumOptClic = 0;
	for y = 1, #aToShow do ToShowItems[y]:SetChecked(false); end
	for y = 1, #aLegend do LegendItems[y]:SetChecked(false); end
	for y = 1, #aWeapon+1 do WeaponItems[y]:SetChecked(false); end
	for y = 1, #aArmor+1 do ArmorItems[y]:SetChecked(false); end
	for y = 1, #aClass+1 do ClassItems[y]:SetChecked(false); end
	for y = 1, #aRecipe+1 do RecipeItems[y]:SetChecked(false); end
	for y = 1, #aIngredient+1 do IngredientItems[y]:SetChecked(false); end
	for y = 1, #aBuff+1 do BuffItems[y]:SetChecked(false); end
	for y = 1, #aFood+1 do FoodItems[y]:SetChecked(false); end
	for y = 1, #aFishing+1 do FishingItems[y]:SetChecked(false); end
	for y = 1, #aTrophy+1 do TrophyItems[y]:SetChecked(false); end
	for y = 1, #aCosmetic+1 do CosmeticItems[y]:SetChecked(false); end
	for y = 1, #aDecoration+1 do DecorationItems[y]:SetChecked(false); end
end

function ShowItemsMenu()
	if WidgetLoc == L["OWidLocL"] then
		itemsmenu:ShowMenuAt(wHugeBag:GetLeft() + wHugeBag:GetWidth() + 5, wHugeBag:GetTop());
	elseif WidgetLoc == L["OWidLocR"] then
		itemsmenu:ShowMenuAt(wHugeBag:GetLeft() - 200, wHugeBag:GetTop());
	else
		if wHugeBag:GetLeft() >= 204 then
			itemsmenu:ShowMenuAt(wHugeBag:GetLeft() - 200, wHugeBag:GetTop());
			if HBLocale == "fr" then itemsmenu:ShowMenuAt(wHugeBag:GetLeft() - 282, wHugeBag:GetTop()); end
			if HBLocale == "de" then itemsmenu:ShowMenuAt(wHugeBag:GetLeft() - 238, wHugeBag:GetTop()); end
		else
			itemsmenu:ShowMenuAt(wHugeBag:GetLeft() + wHugeBag:GetWidth() + 5, wHugeBag:GetTop());
		end
	end
end

function CheckNumClic()
	if ItemsSel then NumOptClic = NumOptClic + 1;
	else NumOptClic = NumOptClic - 1; end
	if NumOptClic == 0 then AllItems.Click( sender, args ); end
end