ResourcePath = "Homeopatix/Animalerie/Resources/";

Images = {
	MinimizedIcon = ResourcePath .. "Animalerie.tga",
};


function CreateLocalizationInfo()
	Strings = {};
	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
		Strings.PluginName = "Tierhandlung";
		Strings.PluginTextFam = "Ihre Zoohandlung";
		Strings.PluginTextFood = "Ihr Essen";
		Strings.PluginEscEnable = "Escape-Taste aktiviert";
		Strings.PluginEscDesable = "Escape-Taste deaktiviert";
		Strings.PluginAltEnable = "Alt-Taste aktiviert";
		Strings.PluginAltDesable = "Alt-Taste deaktiviert";
		Strings.PluginReleaseButton = "Begleiter freilassen";
		Strings.PluginReleaseAlias = "/begleiter freilassen";
		Strings.PluginDefault = "default die Animalerie";
		Strings.PluginDefaultLuxe = "defaultluxe die Animalerie";
		Strings.PluginClear = "R\195\164umen Sie die Animalerie auf";
		Strings.PluginLocked = "Gesperrte Symbole";
		Strings.PluginUnlocked = "Symbole freigeschaltet";
		Strings.PluginHelp = " *** Tierhandlung Hilfe ***\n\n" ..
		"/show Tierhandlung Poster\n" ..
		"/hide verstecke die Zoohandlung\n" ..
		"/default f\195\188llt sich mit Basistieren\n" ..
		"/defaultluxe f\195\188llt sich mit verbessert Basistieren\n" ..
		"/lock um die Symbole zu sperren oder zu entsperren\n" ..
		"/alt - Aktivieren oder deaktivieren Sie die alt-Taste um das Symbol zu verschieben.\n" ..
		"/clear L\195\182schen Sie alle Verkn\195\188pfungen\n\nSie k\195\182nnen Haustiere in der ersten Zeile\nund Futter in der zweiten Zeile ziehen und ablegen und Sie k\195\182nnen eine Verkn\195\188pfung mit dem Mausrad l\195\182schen";

elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
		Strings.PluginName = "Animalerie";
		Strings.PluginTextFam = "Votre Animalerie";
		Strings.PluginTextFood = "Leur Nourriture";
		Strings.PluginEscEnable = "Touche Escape activ\195\169";
		Strings.PluginEscDesable = "Touche Escape desactiv\195\169";
		Strings.PluginAltEnable = "Touche Alt activ\195\169";
		Strings.PluginAltDesable = "Touche Alt desactiv\195\169";
		Strings.PluginReleaseButton = "Lib\195\169rer Familier";
		Strings.PluginReleaseAlias = "/Fam libérer";
		Strings.PluginDefault = "default l'Animalerie";
		Strings.PluginDefaultLuxe = "defaultluxe l'Animalerie";
		Strings.PluginClear = "Efface l'Animalerie";
		Strings.PluginLocked = "Icones verrouill\195\169es";
		Strings.PluginUnlocked = "Icones d\195\169verouill\195\169es";
		Strings.PluginHelp = " *** Animalerie Aide ***\n\n" ..
		"/show affiche l'animalerie\n" ..
		"/hide cache l'animalerie\n" ..
		"/default remplit avec les familiers de base\n" ..
		"/defaultluxe remplit avec les familiers amelior\195\169s de base\n" ..
		"/lock pour verrouill\195\169 ou d\195\169verrouill\195\169 les icones\n" ..
		"/alt - Active ou d\195\169sactive la touche alt pour le d\195\169placement de l'icon.\n" ..
		"/clear Efface tous les raccourcis\n\nVous pouvez faire glisser et d\195\169poser vos familier sur la premi\195\168re ligne\net de la nourriture sur la deuxi\195\168me et vous pouvez effacer un raccourci avec la molette de la souris";

elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
		Strings.PluginName = "Pet Shop";
		Strings.PluginTextFam = "Your Pet Shop";
		Strings.PluginTextFood = "Their Food";
		Strings.PluginEscEnable = "Escape key Activated";
		Strings.PluginEscDesable = "Escape key Desactivated";
		Strings.PluginAltEnable = "Alt key Activated";
		Strings.PluginAltDesable = "Alt key Desactivated";
		Strings.PluginReleaseButton = "Release Pet";
		Strings.PluginReleaseAlias = "/Pet release";
		Strings.PluginDefault = "default the Animalerie";
		Strings.PluginDefaultLuxe = "defaultluxe the Animalerie";
		Strings.PluginClear = "Clear the Animalerie";
		Strings.PluginLocked = "Icons Locked";
		Strings.PluginUnlocked = "Icons Unlocked";
		Strings.PluginHelp = " *** Pet Shop Help ***\n\n" ..
		"/show Display the Pet Shop\n" ..
		"/hide Hide the Pet Shop\n" ..
		"/default fills with base pets\n" ..
		"/defaultluxe fills with the improved base pets\n" ..
		"/lock to lock or unlock the icons\n" ..
		"/alt - Activate or deactivate the alt key to move the icon.\n" ..
		"/clear delete all shortcuts\n\nYou can drag and drop pets on the first line\nand food on the second line and you can delete a shortcut with the mouse wheel";
	end
end