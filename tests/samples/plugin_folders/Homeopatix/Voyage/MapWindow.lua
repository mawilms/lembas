------------------------------------------------------------------------------------------
-- MapWindow file
-- Written by Homeopatix
-- 7 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- create the window
------------------------------------------------------------------------------------------
function CreateMapWindow(images, what)
    width = 1044;
    height = 808;

    windowWidth, windowHeight = Turbine.UI.Display:GetSize();

    MapWindow=Turbine.UI.Lotro.GoldWindow(); 
    MapWindow:SetSize(windowWidth, windowHeight); 
    MapWindow:SetPosition(windowWidth / 2 - width / 2, (windowHeight / 2 - height / 2) - 20);
    MapWindow:SetSize(width, height);
    MapWindow:SetBlendMode(Turbine.UI.BlendMode.Undefined);
    MapWindow:SetBackColor(Turbine.UI.Color(0.0, 0, 0, 0));
    MapWindow:SetVisible(false);
    MapWindow:SetWantsKeyEvents(true);

    mapLabel = Turbine.UI.Label();
    mapLabel:SetPosition(10, 30);
    mapLabel:SetSize(1024, 768);

    MapWindowAlert = Turbine.UI.Extensions.SimpleWindow();
    MapWindowAlert:SetParent( MapWindow );
	MapWindowAlert:SetPosition(width / 2 - 250, height / 2 - 50 );
	MapWindowAlert:SetSize( 500, 50 );
	MapWindowAlert:SetZOrder(10000);
	MapWindowAlert:SetVisible(false);
	MapWindowAlert:SetBackground(ResourcePath .. "/Cadre_500_50.tga");

    MapWindow.Message=Turbine.UI.Label(); 
	MapWindow.Message:SetParent(MapWindowAlert); 
	MapWindow.Message:SetSize(496, 46); 
	MapWindow.Message:SetPosition(2, 2 ); 
	MapWindow.Message:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
    MapWindow.Message:SetFont(Turbine.UI.Lotro.Font.Verdana22);
    MapWindow.Message:SetForeColor(Turbine.UI.Color.Red);
    MapWindow.Message:SetText("");
    MapWindow.Message:SetZOrder(10);

--------------------- help for position
 --[[
    local position = 10;
    for i=1, 1044 do
        MapWindowLines=Turbine.UI.Label(); 
	    MapWindowLines:SetParent(MapWindow); 
	    MapWindowLines:SetSize(2, 808); 
	    MapWindowLines:SetPosition(position*i, 30 ); 
	    MapWindowLines:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
        if(i%10 == 0)then
            MapWindowLines:SetBackColor(Turbine.UI.Color.Red);
        else
            MapWindowLines:SetBackColor(Turbine.UI.Color.Black);
        end
        MapWindowLines:SetText(position*i);
        MapWindowLines:SetZOrder(100000);
        MapWindowLines:SetOpacity(0.2);

        if(i%10 == 0)then
            MapWindowLines=Turbine.UI.Label(); 
	        MapWindowLines:SetParent(MapWindow); 
	        MapWindowLines:SetSize(30, 30); 
	        MapWindowLines:SetPosition(position*i - 15, 30); 
	        MapWindowLines:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
            MapWindowLines:SetForeColor(Turbine.UI.Color.Black);
            MapWindowLines:SetText(position*i);
            MapWindowLines:SetZOrder(1000001);
            MapWindowLines:SetBackColor(Turbine.UI.Color.White);
        end

    end

    local positiony = 10;
    for i=1, 808 do
        MapWindowLines=Turbine.UI.Label(); 
	    MapWindowLines:SetParent(MapWindow); 
	    MapWindowLines:SetSize(1000, 2); 
	    MapWindowLines:SetPosition(10, positiony*i ); 
	    MapWindowLines:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
        if(i%10 == 0)then
            MapWindowLines:SetBackColor(Turbine.UI.Color.Red);
        else
            MapWindowLines:SetBackColor(Turbine.UI.Color.Black);
        end
        MapWindowLines:SetText(position*i);
        MapWindowLines:SetZOrder(100000);
        MapWindowLines:SetOpacity(0.2);

        if(i%10 == 0)then
            MapWindowLines=Turbine.UI.Label(); 
	        MapWindowLines:SetParent(MapWindow); 
	        MapWindowLines:SetSize(30, 30); 
	        MapWindowLines:SetPosition(10, positiony*i - 15 ); 
	        MapWindowLines:SetTextAlignment(Turbine.UI.ContentAlignment.MiddleCenter); 
            MapWindowLines:SetForeColor(Turbine.UI.Color.Black);
            MapWindowLines:SetText(positiony*i);
            MapWindowLines:SetZOrder(1000001);
            MapWindowLines:SetBackColor(Turbine.UI.Color.White);
        end
    end
      
]]--
-----------------------------------------

    if(what == "racial")then
        mapLabel:SetBackground(racialLocationsMap[what .. images]["mapHex"]);
        MapWindow:SetText(racialLocationsMap[what .. images]["texte"]);
        DisplayIcon(what, images);
    end
    if(what == "reput")then
        mapLabel:SetBackground(reputLocationsMap[what .. images]["mapHex"]);
        MapWindow:SetText(reputLocationsMap[what .. images]["texte"]);
        DisplayIcon(what, images);
    end

    if(what == "house")then
        if(images == 1)then
            index = settings["personalHouseMap"]["value"];
        end
        if(images == 2)then
            index = settings["confrerieHouseMap"]["value"];
        end
        if(images == 3)then
            index = settings["confrerieFriendHouseMap"]["value"];
        end
        if(images == 4)then
            index = settings["premiumHouseMap"]["value"];
        end
        if(index == 0)then
            	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
                    mapLabel:SetBackground(0x41008139);
                    MapWindow.Message:SetText(Strings.PluginHouseAlert); 
                    MapWindow.Message:SetBackColor(Turbine.UI.Color( 1, .5, .7, .5));
                    MapWindowAlert:SetVisible(true);
                elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
                    mapLabel:SetBackground(0x41008139);
                    MapWindow.Message:SetText(Strings.PluginHouseAlert); 
                    MapWindow.Message:SetBackColor(Turbine.UI.Color( 1, .5, .7, .5));
                    MapWindowAlert:SetVisible(true);
                elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
                    mapLabel:SetBackground(0x41008139);
                    MapWindow.Message:SetText(Strings.PluginHouseAlert); 
                    MapWindow.Message:SetBackColor(Turbine.UI.Color( 1, .5, .7, .5));
                    MapWindowAlert:SetVisible(true);
                end
         
            MapWindow:SetText(Strings.PluginMap2);
        else
            mapLabel:SetBackground(houseLocationsMap[what .. index]["mapHex"]);
            MapWindow:SetText(houseLocationsMap[what .. index]["texte"]);
        end
    end

    if(what == "warden")then
        mapLabel:SetBackground(wardenLocationsMap[what .. images]["mapHex"]);
        MapWindow:SetText(wardenLocationsMap[what .. images]["texte"]);
        DisplayIcon(what, images);
    end

    if(what == "hunter")then
        mapLabel:SetBackground(hunterLocationsMap[what .. images]["mapHex"]);
        MapWindow:SetText(hunterLocationsMap[what .. images]["texte"]);
        DisplayIcon(what, images);
    end

    if(what == "creep")then
        mapLabel:SetBackground(creepLocationsMap[what .. images]["mapHex"]);
        MapWindow:SetText(creepLocationsMap[what .. images]["texte"]);
    end

    if(what == "tele")then
        if(images == 0)then
            	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
                    mapLabel:SetBackground(0x41008139);
                    MapWindow.Message:SetText(Strings.PluginTeleportAlert); 
                    MapWindow.Message:SetBackColor(Turbine.UI.Color( 1, .5, .7, .5));
                    MapWindowAlert:SetVisible(true);
                elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
                    mapLabel:SetBackground(0x41008139);
                    MapWindow.Message:SetText(Strings.PluginTeleportAlert); 
                    MapWindow.Message:SetBackColor(Turbine.UI.Color( 1, .5, .7, .5));
                    MapWindowAlert:SetVisible(true);
                elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
                    mapLabel:SetBackground(0x41008139);
                    MapWindow.Message:SetText(Strings.PluginTeleportAlert); 
                    MapWindow.Message:SetBackColor(Turbine.UI.Color( 1, .5, .7, .5));
                    MapWindowAlert:SetVisible(true);
                end
         
            MapWindow:SetText(Strings.PluginMap2);
        else
            mapLabel:SetBackground(teleportLocationsMap[what .. images]["mapHex"]);
            --MapWindow:SetText(teleportLocationsMap[what .. images]["texte"]);
            MapWindow:SetText(Strings.Teleport[images]);
            DisplayIcon(what, images);
        end
    end


    mapLabel:SetParent(MapWindow);
    mapLabel:SetVisible(true);

    buttonValider = Turbine.UI.Lotro.GoldButton();
	buttonValider:SetParent( MapWindow );
	buttonValider:SetPosition(400, 776);
	buttonValider:SetSize( 300, 20 );
	buttonValider:SetFont(Turbine.UI.Lotro.Font.Verdana16);
	buttonValider:SetText( Strings.PluginMap1 );
	buttonValider:SetTextAlignment( Turbine.UI.ContentAlignment.MiddleCenter );
	buttonValider:SetVisible(true);
	buttonValider:SetMouseVisible(true);
    buttonValider:SetZOrder(10);

    buttonValider.MouseClick = function(sender, args)
        CloseMapWindow();
    end

    MapWindow.KeyDown=function(sender, args)
		if ( args.Action == Turbine.UI.Lotro.Action.Escape ) then
			MapWindow:SetVisible(false);
		end
	end

end
------------------------------------------------------------------------------------------
-- boutton valider
------------------------------------------------------------------------------------------
function CloseMapWindow()
    MapWindow:SetVisible(false);
    settings["isMapWindowVisible"]["value"] = false;
end
-- debut des icones d'escarmouche = 0x4110163B

function DisplayIcon(what, images)
    ---------------- testage icones
    MapWindowIcon = Turbine.UI.Extensions.SimpleWindow();
    MapWindowIcon:SetParent( MapWindow );  

    local posx = 0;
    local posy = 0;

    if(what == "tele")then
        posx = teleportLocationsMap[what .. images]["coordx"];
        posy = teleportLocationsMap[what .. images]["coordy"];
    elseif(what == "racial")then
        posx = racialLocationsMap[what .. images]["coordx"];
        posy = racialLocationsMap[what .. images]["coordy"];
    elseif(what == "reput")then 
        posx = reputLocationsMap[what .. images]["coordx"];
        posy = reputLocationsMap[what .. images]["coordy"];
    elseif(what == "warden")then 
        posx = wardenLocationsMap[what .. images]["coordx"];
        posy = wardenLocationsMap[what .. images]["coordy"];
    elseif(what == "hunter")then 
        posx = hunterLocationsMap[what .. images]["coordx"];
        posy = hunterLocationsMap[what .. images]["coordy"];
    end

    MapWindowIcon:SetPosition(tonumber(posx), tonumber(posy) );
    MapWindowIcon:SetSize( 32, 32 );  
    MapWindowIcon:SetZOrder(10000);
	MapWindowIcon:SetBackground(0x411BB317);

    MapWindowLabel=Turbine.UI.Label(); 
	MapWindowLabel:SetParent(MapWindow); 
	MapWindowLabel:SetSize(30, 30);  
    MapWindowLabel:SetPosition(tonumber(posx), tonumber(posy) );
    MapWindowLabel:SetText("");
    MapWindowLabel:SetZOrder(100001); --
    -- reput -- 0x41164AEA
    if(what == "tele")then
        MapWindowLabel:SetBackground( 0x41005E55);
    elseif(what == "reput")then
        MapWindowLabel:SetBackground( 0x41164AEA);
        MapWindowLabel:SetPosition(tonumber(posx)+8, tonumber(posy)+4 );
    else
        MapWindowLabel:SetBackground( 0x410D4635);
    end
    MapWindowLabel:SetBlendMode(Turbine.UI.BlendMode.Overlay);

    if(tonumber(posx) >= 1 and tonumber(posy) >= 1)then
        MapWindowIcon:SetVisible(true);
        MapWindowLabel:SetVisible(true);
    else
        MapWindowIcon:SetVisible(false);
        MapWindowLabel:SetVisible(false);
    end
    ---------------------------
end