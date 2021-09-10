------------------------------------------------------------------------------------------
-- Datas file
-- Written by Homeopatix
-- 7 january 2021
------------------------------------------------------------------------------------------
------------------------------------------------------------------------------------------
-- DATA house
------------------------------------------------------------------------------------------
houseLocations = {
        "0x7000D046",
        "0x7000D047",
        "0x70057C36",
        "0x70046EE4"
        };

houseLocationsMap = {
    house1 = {mapHex = 0x410d9a54, texte = "Bree"},
    house2 = {mapHex = 0x410d9934, texte = "Falathlorn"},
    house3 = {mapHex = 0x410d9a56, texte = "Palais de Thorin"},
    house4 = {mapHex = 0x410d9a57, texte = "La Comté"},
    house5 = {mapHex = 0x411ee217, texte = "Eastfold Hills"},
    house6 = {mapHex = 0x411ee218, texte = "Kingstead Meadows"},
    house7 = {mapHex = 0x411aef52, texte = "Cap de Belfalas"}
    };
------------------------------------------------------------------------------------------
-- DATA racial
------------------------------------------------------------------------------------------
racialLocations = {
        "0x700062F6",-- "Retour à Bree" -- homme
        "0x700062C8", --"Retournez dans la Comté" -- hobbit
        "0x70006346",-- "Retour : Porte de Thorin" -- nain
        "0x7000631F",-- "Retour à Fondcombe" -- elf
        "0x70041A22", --"Retour à la maison" -- beornide
        "0x70048C8C",-- "Voyage vers Caras Galadhon, en Lothlórien" -- elf haut
        "0x70053C0F" -- "Aller au Palais de Thorin" -- nain des haches
        };

racialLocationsMap = {
        racial1 = {mapHex = 0x41008136, texte = "Retour à Bree"},
        racial2 = {mapHex =  0x41008137, texte = "Retournez dans la Comté"},
        racial3 = {mapHex =  0x4100812B, texte = "Retour : Porte de Thorin"},
        racial4 = {mapHex =  0x4100812D, texte = "Retour à Fondcombe"},
        racial5 = {mapHex =  0x4115B98B, texte = "Retour à la maison"},
        racial6 = {mapHex =  0x410E8706, texte = "Voyage vers Caras Galadhon, en Lothlórien"},
        racial7 = {mapHex =  0x4100812B, texte = "Aller au Palais de Thorin"}
        };
------------------------------------------------------------------------------------------
-- DATA teleport travel
------------------------------------------------------------------------------------------
teleportLocations = {
        "0x700256BA",
        "0x70025792",
        "0x70025793",
        "0x70025794",
        "0x70025795",
        "0x70025796",
        "0x7002FF62",
        "0x7002FF61",
        "0x7002FF60",
        "0x7002FF5F",
        "0x7002FF63"
        };
------------------------------------------------------------------------------------------
-- DATA chasseur
------------------------------------------------------------------------------------------
hunterLocations = { 
       "0x7000A2C1",
       "0x70003F42",
       "0x70003F41",
       "0x7000A2C3",
       "0x70003F43",
       "0x7000A2C4",
       "0x7000A2C2",
       "0x70003F44",
       "0x70017C82",
       "0x7000A2C5",
       "0x7000A2C6",
       "0x70017C81",
       "0x70017C7A",
       "0x7001F459",
       "0x700235EF",
       "0x7002A93F",
       "0x7002C62C",
       "0x7002E754",
       "0x7002E756",
       "0x7003198E",
       "0x70036B5D",
       "0x7003DC71",
       "0x7003DC72",
       "0x70041197",
       "0x70043A63",
       "0x70044985",
       "0x700459AF",
       "0x70046CBB",
       "0x70047077",
       "0x70047074",
       "0x70047BFA",
       "0x70047C1D",
       "0x7004AE1E",
       "0x7004D73B",
       "0x7004FACC",
       "0x7004FACB",
       "0x70052F07",
       "0x70052F08",
       "0x700551F4",
       "0x7005762D",
       "0x70058571"
        } ;

hunterLocationsMap = { 
    hunter1 = {mapHex = 0x41008138, texte = "Retour au campement"},
    hunter2 = {mapHex = 0x41008136, texte = "Guide vers Bree"},
    hunter3 = {mapHex = 0x4100812B, texte = "Guide vers le Palais de Thorin"},
    hunter4 = {mapHex = 0x41008137, texte = "Guide vers Grand'Cave"},
    hunter5 = {mapHex = 0x41008132, texte = "Guide vers Esteldin"},
    hunter6 = {mapHex = 0x4101f084, texte = "Guide vers Evendim"},
    hunter7 = {mapHex = 0x41008130, texte = "Guide vers Ost Guruth"},
    hunter8 = {mapHex = 0x4100812D, texte = "Guide vers Fondcombe"},
    hunter9 = {mapHex = 0x410e3f46, texte = "Guide vers Sûri-kylä"},
    hunter10 = {mapHex = 0x41008131, texte = "Guide vers l'ouest d'Angmar"},
    hunter11 = {mapHex = 0x41008131, texte = "Guide vers l'est d'Angmar"},
    hunter12 = {mapHex = 0x410e8686, texte = "Guide vers Echad Dunann"},
    hunter13 = {mapHex = 0x410e871b, texte = "Guide vers la vingt et unième salle"},
    hunter14 = {mapHex = 0x41100DF2, texte = "Guide vers l'Orée noire"},
    hunter15 = {mapHex = 0x411ad8a9, texte = "Guide vers Harndirion"},
    hunter16 = {mapHex = 0x41116EFE, texte = "Guide pour Galtrev"},
    hunter17 = {mapHex = 0x41123F09, texte = "Guide vers Stangarde"},
    hunter18 = {mapHex = 0x410E8706, texte = "Guide vers Caras Galadhon"},
    hunter19 = {mapHex = 0x4100812f, texte = "Guide vers les Monts Brumeux"},
    hunter20 = {mapHex = 0x41132E57, texte = "Guide vers Neigebronne"},
    hunter21 = {mapHex = 0x411379FF, texte = "Guide vers Forloi"},
    hunter22 = {mapHex = 0x4113C321, texte = "Guide vers Aldburg"},
    hunter23 = {mapHex = 0x4113C323, texte = "Guide vers le Gouffre de Helm"},
    hunter24 = {mapHex = 0x41154e05, texte = "Guide vers Dol Amroth"},
    hunter25 = {mapHex = 0x4115ee3c, texte = "Guide pour Arnach"},
    hunter26 = {mapHex = 0x411656ef, texte = "Guide vers Minas Tirith"},
    hunter27 = {mapHex = 0x4113C31F, texte = "Guide pour se rendre au camp militaire"},
    hunter28 = {mapHex = 0x4119389d, texte = "Guide de Minas Tirith après la bataille"},
    hunter29 = {mapHex = 0x411a42e7, texte = "Guide vers Henneth Annûn"},
    hunter30 = {mapHex = 0x411a42e5, texte = "Guide vers Osgiliath après la bataille"},
    hunter31 = {mapHex = 0x411ad8a9, texte = "Guide vers le Camp de l'armée"},
    hunter32 = {mapHex = 0x411ad8a9, texte = "Guide vers Haerondir"},
    hunter33 = {mapHex = 0x411b9591, texte = "Guide vers le fort d'Udûn"},
    hunter34 = {mapHex = 0x411c2de2, texte = "Guide vers Dale"},
    hunter35 = {mapHex = 0x411195ff, texte = "Guide vers Jarnfast"},
    hunter36 = {mapHex = 0x411c8da9, texte = "Guide vers Skarhald"},
    hunter37 = {mapHex = 0x4115B98B, texte = "Guide pour Beorninghus"},
    hunter38 = {mapHex = 0x411da4a0, texte = "Guide de Hultvis"},
    hunter39 = {mapHex = 0x411e9a41, texte = "Guide vers Estolad Lân"},
    hunter40 = {mapHex = 0x411ee769, texte = "Guide de Limlok"},
    hunter41 = {mapHex = 0x411fb86f, texte = "Guide vers Annâk-khurfu"}
    };
------------------------------------------------------------------------------------------
-- DATA warden
------------------------------------------------------------------------------------------
wardenLocations = {
        "0x70014786",
        "0x70014798",
        "0x7001478E",
        "0x70014791",
        "0x700237D4",
        "0x7001819E",
        "0x7001F45C",
        "0x700235EB",
        "0x7002A90A",
        "0x7002C646",
        "0x700303DF",
        "0x700303DD",
        "0x7003198D",
        "0x70036B5B",
        "0x7003DC7A",
        "0x7003DC79",
        "0x70041198",
        "0x70043A66",
        "0x70044982",
        "0x700459AA",
        "0x70046CBF",
        "0x70047075",
        "0x70047076",
        "0x70047BFC",
        "0x70047C23",
        "0x7004AE1F",
        "0x7004D73A",
        "0x7004FACA",
        "0x7004FACD",
        "0x70052F0A",
        "0x70052F06",
        "0x700551F2",
        "0x70057635",
        "0x70058572"
        };

wardenLocationsMap = { 
    warden1 = {mapHex = 0x41008130, texte = "Rassemblement à Ost Guruth"},
    warden2 = {mapHex = 0x41008132, texte = "Rassemblement à Esteldin"},
    warden3 = {mapHex = 0x4101f084, texte = "Rassemblement dans la région d'Evendim"},
    warden4 = {mapHex = 0x4100812D, texte = "Rassemblement à Fondcombe"},
    warden5 = {mapHex = 0x410e3f46, texte = "Rassemblement à Sûri-kylä"},
    warden6 = {mapHex = 0x410e871b, texte = "Rassemblement à la vingt et unième salle"},
    warden7 = {mapHex = 0x41100DF2, texte = "Rassemblement à l'Orée noire"},
    warden8 = {mapHex = 0x411ad8a9, texte = "Rassemblement à Harndirion"},
    warden9 = {mapHex = 0x41116EFE, texte = "Rassemblement à Galtrev"},
    warden10 = {mapHex = 0x41123F09, texte = "Rassemblement à Stangarde"},
    warden11 = {mapHex = 0x410E8706, texte = "Rassemblement à Caras Galadhon"},
    warden12 = {mapHex = 0x4100812f, texte = "Rassemblement dans les Monts Brumeux"},
    warden13 = {mapHex = 0x41132E57, texte = "Rassemblement à Neigebronne"},
    warden14 = {mapHex = 0x411379FF, texte = "Rassemblement à Forloi"},
    warden15 = {mapHex = 0x4113C321, texte = "Rassemblement à Aldburg"},
    warden16 = {mapHex = 0x4113C323, texte = "Rassemblement au Gouffre de Helm"},
    warden17 = {mapHex = 0x41154e05, texte = "Rassemblement à Dol Amroth"},
    warden18 = {mapHex = 0x4115ee3c, texte = "Rassemblement à Arnach"},
    warden19 = {mapHex = 0x411656ef, texte = "Rassemblement à Minas Tirith"},
    warden20 = {mapHex = 0x4113C31F, texte = "Rassemblement au camp militaire"},
    warden21 = {mapHex = 0x4119389d, texte = "Rassemblement à Minas Tirith après la bataille"},
    warden22 = {mapHex = 0x411a42e7, texte = "Rassemblement à Henneth Annûn"},
    warden23 = {mapHex = 0x411a42e5, texte = "Rassemblement à Osgiliath après la bataille"},
    warden24 = {mapHex = 0x411ad8a9, texte = "Rassemblement au Camp de l'armée"},
    warden25 = {mapHex = 0x411ad8a9, texte = "Rassemblement à Haerondir"},
    warden26 = {mapHex = 0x411b9591, texte = "Rassemblement dans le fort d'Udûn"},
    warden27 = {mapHex = 0x411c2de2, texte = "Retour à Dale"},
    warden28 = {mapHex = 0x411195ff, texte = "Retour à Jarnfast"},
    warden29 = {mapHex = 0x411c8da9, texte = "Retour à Skarhald"},
    warden30 = {mapHex = 0x4115B98B, texte = "Rassemblement à Beorninghus"},
    warden31 = {mapHex = 0x411da4a0, texte = "Rassemblement à Hultvis"},
    warden32 = {mapHex = 0x411e9a41, texte = "Rassemblement à Estolad Lân"},
    warden33 = {mapHex = 0x411ee769, texte = "Rassemblement à Limlok"},
    warden34 = {mapHex = 0x411fb86f, texte = "Rassemblement à Annâk-khurfu"}
    };
------------------------------------------------------------------------------------------
-- reputation travel
------------------------------------------------------------------------------------------
reputLocations = {
        "0x7001BF91",
        "0x7001BF90",
        "0x700364B1",
        "0x70023262",
        "0x70023263",
        "0x70020441",
        "0x7001F374",
        "0x70021FA2",
        "0x7002C647",
        "0x7002C65D",
        "0x70031A46",
        "0x70036B5E",
        "0x7003DC81",
        "0x7004128F",
        "0x7003DC82",
        "0x700411AC",
        "0x70043A6A",
        "0x7004497E",
        "0x700459A9",
        "0x70046CC0",
        "0x70047080",
        "0x7004707D",
        "0x70047BF4",
        "0x70047C1B",
        "0x7004AE1D",
        "0x7004B8C2",
        "0x7004B8C3",
        "0x7004B8C4",
        "0x7004B8C5",
        "0x7004D738",
        "0x7004FAC3",
        "0x7004FAC5",
        "0x70052F12",
        "0x70052F04",
        "0x700551F8",
        "0x70057629",
        "0x7005856F"
        };

reputLocationsMap = { 
        reput1 = {mapHex = 0x4100812B, texte = "Retour : Porte de Thorin"},
        reput2 = {mapHex =  0x41008136, texte = "Retour à Bree"},
        reput3 = {mapHex =  0x41008134, texte = "Retour au Marché de Lalia"},
        reput4 = {mapHex =  0x41008137, texte = "Retour à Grand'Cave"},
        reput5 = {mapHex =  0x4100812D, texte = "Retour à Fondcombe"},
        reput6 = {mapHex =  0x41008130, texte = "Retournez à Ost Guruth"},
        reput7 = {mapHex =  0x41100DF2, texte = "Retour dans la Forêt Noire"},
        reput8 = {mapHex =  0x411041a4, texte = "Retour en Enedwaith"},
        reput9 = {mapHex =  0x41116EFE, texte = "Retour à Galtrev"},
        reput10 = {mapHex =  0x41123F09, texte = "Retour à Stangarde"},
        reput11 = {mapHex =  0x41132E57, texte = "Retourner à Neigebronne"},
        reput12 = {mapHex =  0x411379FF, texte = "Retour à Forloi"},
        reput13 = {mapHex =  0x4113C321, texte = "Retour à Aldburg"}, -- to check
        reput14 = {mapHex =  0x4114BEAA, texte = "Retour à Derunant"},
        reput15 = {mapHex =  0x4113C323, texte = "Retour au Gouffre de Helm"},
        reput16 = {mapHex =  0x41154e05, texte = "Retour à Dol Amroth"},
        reput17 = {mapHex =  0x4115ee3c, texte = "Retournez à Arnach"},
        reput18 = {mapHex =  0x411656ef, texte = "Retour à Minas Tirith"},
        reput19 = {mapHex =  0x4113C31F, texte = "Retour au camp militaire"},
        reput20 = {mapHex =  0x4119389d, texte = "Retour à Minas Tirith après la bataille"},
        reput21 = {mapHex =  0x411a42e7, texte = "Retour à Henneth Annûn"},
        reput22 = {mapHex =  0x411a42e5, texte = "Retour à Osgiliath après la bataille"},
        reput23 = {mapHex =  0x411ad8a9, texte = "Retour au Camp de l'armée"},
        reput24 = {mapHex =  0x411ad8a9, texte = "Retour à Haerondir"},
        reput25 = {mapHex =  0x411b84d4, texte = "Retour au fort d'Udûn"},
        reput26 = {mapHex =  0x410e8707, texte = "Voyager jusqu'à la Cour de Lothlórien"},
        reput27 = {mapHex =  0x41005d2f, texte = "Voyager jusqu'au Palais du roi"},
        reput28 = {mapHex =  0x4100812b, texte = "Voyager jusqu'au Palais sous la Montagne"},
        reput29 = {mapHex =  0x411a4436, texte = "Voyager jusqu'à Bâr Thorenion"},
        reput30 = {mapHex =  0x411c2de2, texte = "Revenir à Dale"},
        reput31 = {mapHex =  0x411195ff, texte = "Revenir à Jarnfast"}, -- to find a solution the map is too big -- 2400,1800
        reput32 = {mapHex =  0x411c8da9, texte = "Revenir à Skarhald"},
        reput33 = {mapHex =  0x4115B98B, texte = "Retournez auprès de Beorninghus"},
        reput34 = {mapHex =  0x411da4a0, texte = "Retournez auprès de Hultvis"},
        reput35 = {mapHex =  0x411e9a41, texte = "Retour à Estolad Lân"},
        reput36 = {mapHex =  0x411ee769, texte = "Retour à Limlok"},
        reput37 = {mapHex =  0x411fb86f, texte = "Retournez à Annâk-khurfu"}
        };
------------------------------------------------------------------------------------------
-- creep location for munster play
------------------------------------------------------------------------------------------
creepLocations = {
        "0x70028BBC",
        "0x70028BC1",
        "0x70028BB3",
        "0x70028BB6",
        "0x70028BB7",
        "0x70028BBE",
        "0x70028BBF",
        "0x70028BAF",
        "0x70028BB1",
        "0x70028BB2",
        "0x70028BB4",
        "0x70028BB9",
        "0x70028BC0",
        "0x70028BC2",
        "0x70028BB5",
        "0x70028BB0",
        "0x70028BBD"
        };