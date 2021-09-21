-- fr.lua
-- Written by Habna


_G.L = {};
L["HBLang"] = "HugeBag: Langue fran\195\167aise charg\195\169e!";
L["HBLoad"] = "HugeBag " .. Version .. " par Habna charg\195\169e!";

--Misc
L["ButDel"] = "Effacer les infos de ce personnage";
--L[""] = "";

--Main form (Widget)
L["HugeBag"] = "HugeBag";
L["HugeBag--"] = "HugeBag - ";
L["Free"] = "Libre: ";
L["Max"] = "  Max: ";
L["Used"] = "  Occup\195\169e: ";
L["Sort"] = "[T]";
L["Merge"] = "[F]";
L["Search"] = "[R]";
L["Bags"] = "[B]";
L["Vault"] = "[V]";
L["SStorage"] = "[SS]";
L["FF"] = "L";
L["UU"] = "O";
L["MM"] = "M";

--Main form (Window)
L["HB--"] = "HB - ";
L["F"] = "L: ";
L["U"] = "  O: ";
L["M"] = "  M: ";

--Options window
L["OWinLP"] = "Chargez les param\195\168tres du profile";
L["OWinSP"] = "Enregistrer les param\195\168tres actuels dans le profile";

--Options widget
L["OWidLoc"] = "D\195\169finir l'emplacement du widget \195\160...";
L["OWidLocL"] = "gauche";
L["OWidLocR"] = "droite";
L["OWidTop"] = "Options section du haut ...";
L["OWidTopT"] = "Afficher l'image";
L["OWidTopI"] = "Afficher les informations";
L["OWidTopN"] = "Ne rien afficher";
L["OWidSide"] = "Options section de coter ...";
L["OWidBot"] = "Options barre du bas ...";
L["OWidAOT"] = "Modifier la capacit\195\169 'toujours au-dessus'";
L["OWidIM"] = "Inverser la fonction fusionner";
L["OWidBC"] = "Changer l'arri\195\168re plan";
L["OWidL"] = "Changer la langue vers ...";
L["OWidLen"] = "l'Anglais";
L["OWidLfr"] = "Fran\195\167ais";
L["OWidLde"] = "l'Allemand";
L["OWidView"] = "Voir votre ";
L["OWidWSort"] = "Trier";
L["OWidWMerge"] = "Fusionner";
L["OWidWSearch"] = "Rechercher";
L["OWidVault"] = "Coffre";
L["OWidStorage"] = "Stockage Partag\195\169";
L["OWidBags"] = "Sacs";
L["OWidNeed"] = "Besoin d'ouvrir votre ";
L["OWidOnce"] = " valide au moins une fois";

-- Background window
L["BWTitle"] = "R\195\169gler couleur";
L["BWAlpha"] = "Alpha";
L["BWCurSetColor"] = "Couleur d\195\169j\195\160 r\195\169gl\195\169";
L["BWSave"] = "Sauvegarder";
L["BWDef"] = "Par d\195\169faut";
L["BWBlack"] = "Noir";

-- Vault window
L["VTh"] = "coffre";
L["VTnd"] = "Aucune donn\195\169e n'as \195\169t\195\169 trouv\195\169 pour ce personnage";
L["VTID"] = " infos coffre supprim\195\169!"
L["VTSe"] = "Rechercher:"
L["VTAll"] = "-- Tous --"

-- Shared Storage window
L["SSh"] = "stockage partag\195\169";
L["SSnd"] = "Besoin d'ouvrir votre stockage partag\195\169 au moins une fois";

-- Backpack window
L["BIh"] = "Sacs";
L["BID"] = " infos sacs supprim\195\169!"

-- Bank window
L["BKh"] = "banque";

--Functions output text
L["FEscH"] = "HugeBag: Je vais me cacher lorsque la touche 'esc' sera press\195\169";
L["FEscS"] = "HugeBag: Je vais rester visible lorsque la touche 'esc' sera press\195\169";
L["FLoadS"] = "HugeBag: Je vais \195\170tre visible au chargement la prochaine fois";
L["FLoadH"] = "HugeBag: Je vais \195\170tre cach\195\169 au chargement la prochaine fois";
L["FWidget"] = "HugeBag: Va charger en mode widget la prochaine fois";
L["FWin"] = "HugeBag: Va charger en mode fen\195\170tre la prochaine fois";
L["FAOTS"] = "HugeBag: Sera toujours au-dessus la prochaine fois";
L["FAOTH"] = "HugeBag: Ne sera pas toujours au-dessus la prochaine fois";
L["FMergeD"] = "HugeBag: Fusionner les articles de ";
L["FMerge1"] = " \195\160 1";
L["FMergeU"] = "HugeBag: Fusionner les articles de 1 \195\160 ";
L["FButVis"] = "HugeBag: Les boutons sont maintenant visibles";
L["FButNVis"] = "HugeBag: Les boutons sont maintenant cach\195\169s"
L["FSortVis"] = "HugeBag: Le bouton 'Trier' est maintenant visibles";
L["FSortNVis"] = "HugeBag: Le bouton 'Trier' est maintenant cach\195\169s"
L["FMergeVis"] = "HugeBag: Le bouton 'Fusionner' est maintenant visibles";
L["FMergeNVis"] = "HugeBag: Le bouton 'Fusionner' est maintenant cach\195\169s"
L["FSearchVis"] = "HugeBag: Le bouton 'Rechercher' est maintenant visibles";
L["FSearchNVis"] = "HugeBag: Le bouton 'Rechercher' est maintenant cach\195\169s";
L["FBagsVis"] = "HugeBag: Le bouton 'Sacs' est maintenant visibles";
L["FBagsNVis"] = "HugeBag: Le bouton 'Sacs' est maintenant cach\195\169s";
L["FVaultVis"] = "HugeBag: Le bouton 'Coffre' est maintenant visibles";
L["FVaultNVis"] = "HugeBag: Le bouton 'Coffre' est maintenant cach\195\169s";
L["FSShVis"] = "HugeBag: Le bouton 'Stockage Partag\195\169' est maintenant visibles";
L["FSSNVis"] = "HugeBag: Le bouton 'Stockage Partag\195\169' est maintenant cach\195\169s";
L["BLT"] = "HugeBag: Affiche le texte long";
L["BST"] = "HugeBag: Affiche le texte court";
L["FCP"] = "HugeBag: Aucun param\195\168tres n'as \195\169t\195\169 trouv\195\169. Le profil a \195\169t\195\169 cr\195\169\195\169 en utilisant les param\195\168tres actuels";
L["FLP"] = "HugeBag: Les param\195\168tres du profil ont \195\169t\195\169 charg\195\169 avec succ\195\168s";
L["FSP"] = "HugeBag: Les param\195\168tres actuel ont \195\169t\195\169 sauvegard\195\169s dans le profil";

--Functions window output text
L["FSlotsS"] = "HugeBag: Affiche maintenant les informations dans le titre";
L["FSlotsH"] = "HugeBag: N'affiche pas les informations dans le titre";
L["FSkinS"] = "HugeBag: Affiche maintenant l'habillage et le titre";
L["FSkinH"] = "HugeBag: N'affiche pas l'habillage ni le titre";
L["FIH"] = "HugeBag: Articles maintenant classer horizontalement";
L["FIV"] = "HugeBag: Articles maintenant classer verticalement";
L["FSL"] = "HugeBag: La fen\195\170tre n'est pas redimensionnable";
L["FSNL"] = "HugeBag: La fen\195\170tre est redimensionnable";
L["FPL"] = "HugeBag: La position de la fen\195\170tre est maintenant verouill\195\169";
L["FPNL"] = "HugeBag: La position de la fen\195\170tre est maintenant d\195\169verrouiller";
L["ISE"] = "HugeBag: La fonction pour modifier la taille des ic\195\180nes est maintenant activ\195\169e";
L["ISD"] = "HugeBag: La fonction pour modifier la taille des ic\195\180nes est maintenant d\195\169sactiv\195\169e";

--Functions widget output text
L["FWidShow"] = "HugeBag: Impossible, je suis d\195\169j\195\160 visible";
L["FWidTBTitle"] = "HugeBag: Affiche maintenant l'image dans le titre";
L["FWidTBInfo"] = "HugeBag: Affiche maintenant les informations dans le titre";
L["FWidTBNot"] = "HugeBag: Affiche maintenant rien dans le titre";
L["FWidSBImg"] = "HugeBag: Affiche maintenant l'image dans le coter";
L["FWidSBInfo"] = "HugeBag: Affiche maintenant les informations dans le coter";
L["FWidSBNot"] = "HugeBag: Affiche maintenant rien dans le coter";
L["FWidActive"] = "Impossible d'afficher/cacher les boutons lorsque 'trier', 'fusionner' ou 'rechercher' sont active!";
L["FWidHide"] = "HugeBag: Impossible, je suis d\195\169j\195\160 cach\195\169";

--Settings widget output text
L["SWidRA"] = "HugeBag: Tous mes param\195\168tres ont \195\169t\195\169 remis par d\195\169faut";

--Settings window output text
L["SWinRLS"] = "HugeBag: Ma position et taille ont \195\169t\195\169 remis par d\195\169faut";

--Widget & Window shell commands
L["SCWTitle"] = "Commandes shell HugeBag";
L["SC0"] = "Cette commande n'est pas support\195\169";
L["SC1"] = "Afficher HugeBag";
L["SC2"] = "Cacher HugeBag";
L["SC3"] = "D\195\169charger HugeBag";
L["SC4"] = "Recharger HugeBag";
L["SC5"] = "R\195\169initialiser tous les r\195\169glages par d\195\169faut";
L["SC6"] = "Afficher/cacher HugeBag lorsque la touche 'esc' sera press\195\169";
L["SC7"] = "Afficher/cacher HugeBag lors du chargement";
L["SC8"] = "Alterner entre le mode widget et fen\195\170tre";
L["SC9"] = "Capacit\195\169 d'\195\170tre toujours au-dessus ou pas";
L["SC10"] = "Afficher/cacher les boutons";
L["SC11"] = "Trier les articles (Courtoisie de MrJackdaw)";
L["SC12"] = "Fusionner les articles empilables dans une pile";
L["SC13"] = "Fonction fusionner par d\195\169faut: 1 \195\160 45/75";
L["SC14"] = "Afficher les commandes shell";
L["SC15"] = "Afficher les options";
L["SC16"] = "Afficher/cacher le bouton 'Trier'";
L["SC17"] = "Afficher/cacher le bouton 'Fusionner'";
L["SC18"] = "Afficher/cacher le bouton 'Rechercher'";
L["SC19"] = "Afficher/cacher la fen\195\170tre 'Sacs'";
L["SC20"] = "Afficher/cacher la fen\195\170tre 'Coffre'";
L["SC21"] = "Afficher/cacher la fen\195\170tre 'Stockage partag\195\169'";
L["SC22"] = L["OWinLP"];
L["SC23"] = L["OWinSP"];
L["SC24"] = "Afficher/cacher la bouton 'Sacs'";
L["SC25"] = "Afficher/cacher la bouton 'Coffre'";
L["SC26"] = "Afficher/cacher la bouton 'Stockage partag\195\169'";
L["SC27"] = "Afficher le texte court/long";

L["SCa1"] = "afficher";
L["SCb1"] = "shb / ";
L["SCa2"] = "cacher";
L["SCb2"] = "hhb / ";
L["SCa3"] = "d\195\169";
L["SCb3"] = "  u / ";
L["SCa4"] = "recharger";
L["SCb4"] = "  r / ";
L["SCa5"] = "r\195\169initialiser";
L["SCb5"] = " ra / ";
L["SCa6"] = "wesc";
L["SCb6"] = "  w / ";
L["SCa7"] = "visible";
L["SCb7"] = "  v / ";
L["SCa8"] = "mode";
L["SCb8"] = "hbm / ";
L["SCa9"] = "au-dessus";
L["SCb9"] = "aot / ";
L["SCa10"] = "boutons";
L["SCb10"] = " bv / ";
L["SCa11"] = "trier";
L["SCb11"] = " si / ";
L["SCa12"] = "fusionner";
L["SCb12"] = " mi / ";
L["SCa13"] = "inverser";
L["SCb13"] = " im / ";
L["SCa14"] = "aide";
L["SCb14"] = " sc / ";
L["SCa15"] = "options";
L["SCb15"] = "opt / ";
L["SCa16"] = "affichertrier";
L["SCb16"] = "sbv / ";
L["SCa17"] = "afficherfusionner";
L["SCb17"] = "mbv / ";
L["SCa18"] = "afficherrechercher";
L["SCb18"] = "ebv / ";
L["SCa19"] = "sacs";
L["SCb19"] = "bp / ";
L["SCa20"] = "coffre";
L["SCb20"] = "vt / ";
L["SCa21"] = "stockage partag\195\169";
L["SCb21"] = "ss / ";
L["SCa22"] = "charger profil";
L["SCb22"] = "lp / ";
L["SCa23"] = "sauvegarder profil";
L["SCb23"] = "sp / ";
L["SCa24"] = "affichersacs";
L["SCb24"] = "bbv / ";
L["SCa25"] = "affichercoffre";
L["SCb25"] = "vbv / ";
L["SCa26"] = "affichersp";
L["SCb26"] = "hbv / ";
L["SCa27"] = "Changerbb";
L["SCb27"] = "sbb / ";

--Widget shell commands



--Window shell commands
L["WinSC1"] = "R\195\169initialiser la position et la dimension par d\195\169faut";
L["WinSC2"] = "Afficher/cacher l'habillage et le titre";
L["WinSC3"] = "Changer l'oriention des articles";
L["WinSC4"] = "Verrouiller/D\195\169v\195\169rouiller la taille";
L["WinSC5"] = "Verrouiller/D\195\169v\195\169rouiller la position";
L["WinSC6"] = "Activer/D\195\169sactiver la fonction pour modifier la taille des ic\195\180nes";

L["WinSCa1"] = "r\195\169initialiserpt";
L["WinSCb1"] = "rls / ";
L["WinSCa2"] = "habillage";
L["WinSCb2"] = " sk / ";
L["WinSCa3"] = "orientation";
L["WinSCb3"] = " io / ";
L["WinSCa4"] = "verrouiller taille";
L["WinSCb4"] = " ls / ";
L["WinSCa5"] = "verrouiller position";
L["WinSCb5"] = " lp / ";
L["WinSCa6"] = "ic\195\180nes";
L["WinSCb6"] = " is / ";

--Merge
L["FAMergeS"] = "HugeBag: La fusion est commenc\195\169";
L["FAMergeF"] = "HugeBag: La fusion est termin\195\169";
L["FAMergeE"] = "Impossible de fusionner lorsque 'trier', 'fusionner' ou 'rechercher' sont active!";
L["FAMergeFA"] = " termin\195\169 apr\195\168s ";
L["FAMergeSec"] = " secondes";

--Sort
L["FSSortS"] = "HugeBag: Le triage est commenc\195\169";
L["FSSortF"] = "HugeBag: Le triage est termin\195\169";
L["FSSortE"] = "Impossible de trier lorsque 'trier', 'fusionner' ou 'rechercher' sont active!";
L["FSSortFS"] = "HugeBag: Par mesure de s\195\169curit\195\169 le triage \195\160 \195\169t\195\169 annul\195\169 parce que le triage ne c'est pas termin\195\169 en moins de ";

--Items menu
L["All"] = "Tous";
L["ShowAll"] = "Afficher tous les articles";
L["Show"] = "Afficher ...";
L["Potions"] = "Potions";
L["Healing"] = "Gu\195\169rison";
L["Tools"] = "Outils";
L["Devices"] = "Dispositifs";
L["Jewelry"] = "Bijoux";
L["Components"] = "Composants";
L["BR"] = "Troc & R\195\169putation";
L["QI"] = "objets de qu\195\170te";
L["Resources"] = "Ressources";
L["Perks"] = "Perks";
L["Misc"] = "Divers";
L["Misc2"] = "Divers 2";
L["Mounts"] = "Montures";
L["Special"] = "Sp\195\169cial";
L["Dye"] = "Dye";
L["Relic"] = "Relique";
L["Festival"] = "Festival";
L["Book"] = "Livre du M\195\169nestrel";
L["Tome"] = "Tome";
L["ShowBuff"] = "Afficher buff ...";
L["Scroll"] = "Parchemin";
L["Trap"] = "Pi\195\168ge";
L["SP"] = "Pointes de bouclier";
L["Oil"] = "Huile";
L["ShowLegendary"] = "Afficher l\195\169gendaire ...";
L["WE"] = "Exp\195\169rience arme";
L["WIML"] = "Augmentation arme niveau max";
L["WRL"] = "Remplacer h\195\169ritage d'armes";
L["WR"] = "R\195\169initialiser arme";
L["WUL"] = "Augmentation h\195\169ritage d'armes";
L["ShowFishing"] = "Afficher la p\195\170che ...";
L["Fish"] = "Poisson";
L["Bait"] = "App\195\162t";
L["Pole"] = "Canne \195\160 p\195\170che";
L["Other"] = "Autre";
L["ShowFoods"] = "Afficher nourritures ...";
L["Food"] = "Nourriture";
L["ShowIngredient"] = "Afficher ingr\195\169dient ...";
L["Ingredient"] = "Ingr\195\169dient";
L["OI"] = "Ingr\195\169dient facultatif";
L["ShowTrophys"] = "Afficher troph\195\169es ...";
L["Trophy"] = "troph\195\169e";
L["ST"] = "troph\195\169e sp\195\169cial";
L["ShowRecipes"] = "Afficher recettes ...";
L["MS"] = "Ferronnier";
L["WS"] = "Fabricant d'armes";
L["Tailor"] = "Tailleur";
L["Jeweller"] = "Bijoutier";
L["Cook"] = "Cuisinier";
L["Scholar"] = "Savant";
L["WW"] = "Menuisier";
L["Farmer"] = "Agriculteur";
L["Prospecter"] = "Prospecteur";
L["Forester"] = "Foresteir";
L["Apprentice"] = "Apprenti";
L["Journeyman"] = "Compagnon";
L["Expert"] = "Expert";
L["Artisan"] = "Artisan";
L["Master"] = "Ma\195\174tre";
L["Supreme"] = "Supr\195\170me";
L["Westfold"] = "Westfold";
L["ShowWeapon"] = "Afficher armes ...";
L["Axe"] = "Axe";
L["Club"] = "Club";
L["Crossbow"] = "Arbal\195\168te";
L["Bow"] = "Arc";
L["Dagger"] = "Poignard";
L["Halberd"] = "Hallebarde";
L["Mace"] = "Mace";
L["Staff"] = "Staff";
L["Sword"] = "\195\137p\195\169e";
L["Hammer"] = "Marteau";
L["Orb"] = "Orbe";
L["Javelin"] = "Javelot";
L["Spear"] = "Lance";
L["ShowArmor"] = "Afficher armures ...";
L["Shoes"] = "Soulier";
L["Leggings"] = "Jambi\195\168re";
L["Gloves"] = "Gant";
L["Chest"] = "Poitrine";
L["Cloak"] = "Cape";
L["Hat"] = "Chapeau";
L["Shield"] = "Bouclier";
L["GuardianBelt"] = "Ceinture de Guardien";
L["ShowClass"] = "Affichier articles de classe ...";
L["ShowCosmetic"] = "Afficher articles de cosm\195\169tiques ...";
L["Back"] = "Dos";
L["Head"] = "T\195\170te";
L["UB"] = "Haut du corps";
L["Feet"] = "Pied";
L["Shoulder"] = "\195\137paule";
L["ShowDecoration"] = "Afficher d\195\169coration ...";
L["Ceiling"] = "Plafond";
L["Floor"] = "Plancher";
L["Furniture"] = "Meuble";
L["Music"] = "Musique";
L["Yard"] = "Cour";
L["Wall"] = "Mur";
L["SurfacePaint"] = "Peinture de surface";

-- Free People Class
L["Guardian"] = "Gardien";
L["Captain"] = "Capitaine";
L["Minstrel"] = "M\195\169nestrel";
L["Burglar"] = "Cambrioleur";
L["Hunter"] = "Chasseur";
L["Champion"] = "Champion";
L["Lore-Master"] = "Maitre \195\169l\195\169mentaires";
L["Rune-Keeper"] = "Gardien des Runes";
L["Warden"] = "Warden";