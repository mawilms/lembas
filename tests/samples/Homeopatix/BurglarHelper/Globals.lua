ResourcePath = "Homeopatix/BurglarHelper/Resources/";

Images = {
	MinimizedIcon = ResourcePath .. "BurglarHelper.tga",
};

function CreateLocalizationInfo()
	Strings = {};

	if Turbine.Engine.GetLanguage() == Turbine.Language.German then
		Strings.PluginName = "BurglarHelper";
		Strings.PluginText = "BurglarHelper";
		Strings.PluginAltEnable = "Alt-Taste aktiviert";
		Strings.PluginAltDesable = "Alt-Taste deaktiviert";
		Strings.PluginBurglarHelper1 = "HeimliChkeit";
		Strings.PluginBurglarHelper2 = "Stehlen";
		Strings.PluginBurglarHelper3 = "Streich";
		Strings.PluginEscEnable = "Escape-Taste aktiviert";
		Strings.PluginEscDesable = "Escape-Taste deaktiviert";
		Strings.PluginLocked = "Gesperrte Symbole";
		Strings.PluginUnlocked = "Symbole freigeschaltet";
		------------------------------------------------------------------------------------------
		-- help --
		------------------------------------------------------------------------------------------
		Strings.PluginHelp1 = "\n\nListe der Befehle:\n";
		Strings.PluginHelp2 = "/Bu help - Schaufenster help.\n";
		Strings.PluginHelp3 = "/Bu show - Schaufenster.\n";
		Strings.PluginHelp4 = "/Bu hide - verstecke das Fenster.\n";
		Strings.PluginHelp5 = "/Bu esc - Active ou d\195\169sactive la touche Escape.\n";
		Strings.PluginHelp6 = "/Bu default - Verkn\195\188pfungen zur\195\188cksetzen.\n";
		Strings.PluginHelp7 = "/Bu lock um die Symbole zu sperren oder zu entsperren.\n";
		Strings.PluginHelp8 = "/Bu alt - Aktivieren oder deaktivieren Sie die alt-Taste um das Symbol zu verschieben.\n";

elseif Turbine.Engine.GetLanguage() == Turbine.Language.French then
		Strings.PluginName = "BurglarHelper";
		Strings.PluginText = "BurglarHelper";
		Strings.PluginAltEnable = "Touche Alt activ\195\169";
		Strings.PluginAltDesable = "Touche Alt desactiv\195\169";
		Strings.PluginBurglarHelper1 = "Dissimulation";
		Strings.PluginBurglarHelper2 = "Vol \195\160 la tire";
		Strings.PluginBurglarHelper3 = "Farce";
		Strings.PluginEscEnable = "Touche Escape activ\195\169";
		Strings.PluginEscDesable = "Touche Escape desactiv\195\169";
		Strings.PluginLocked = "Icones verrouill\195\169es";
		Strings.PluginUnlocked = "Icones d\195\169verouill\195\169es";
		------------------------------------------------------------------------------------------
		-- help --
		------------------------------------------------------------------------------------------
		Strings.PluginHelp1 = "\n\nListe des commandes:\n";
		Strings.PluginHelp2 = "/Bu help - affiche la fen\195\168tre. d'aide\n";
		Strings.PluginHelp3 = "/Bu show - affiche la fen\195\168tre.\n";
		Strings.PluginHelp4 = "/Bu hide - cache la fen\195\168tre.\n";
		Strings.PluginHelp5 = "/Bu esc - Active ou d\195\169sactive la touche Escape.\n";
		Strings.PluginHelp6 = "/Bu default - Reinitialize tous les raccourcis\n";
		Strings.PluginHelp7 = "/Bu lock pour verrouill\195\169 ou d\195\169verrouill\195\169 les icones.\n";
		Strings.PluginHelp8 = "/Bu alt - Active ou d\195\169sactive la touche alt pour le d\195\169placement de l'icon.\n";
elseif Turbine.Engine.GetLanguage() == Turbine.Language.English then
		Strings.PluginName = "BurglarHelper";
		Strings.PluginText = "BurglarHelper";
		Strings.PluginAltEnable = "Alt key Activated";
		Strings.PluginAltDesable = "Alt key Desactivated";
		Strings.PluginBurglarHelper1 = "Sneak";
		Strings.PluginBurglarHelper2 = "Burgle";
		Strings.PluginBurglarHelper3 = "Pratical Joke";
		Strings.PluginEscEnable = "Escape key Activated";
		Strings.PluginEscDesable = "Escape key Desactivated";
		Strings.PluginLocked = "Icons Locked";
		Strings.PluginUnlocked = "Icons Unlocked";
		------------------------------------------------------------------------------------------
		-- help --
		------------------------------------------------------------------------------------------
		Strings.PluginHelp1 = "\n\ncommands List:\n";
		Strings.PluginHelp2 = "/Bu help - Show the help window.\n";
		Strings.PluginHelp3 = "/Bu show - Show the window.\n";
		Strings.PluginHelp4 = "/Bu hide - Hide the window.\n";
		Strings.PluginHelp5 = "/Bu esc - Active ou d\195\169sactive la touche Escape.\n";
		Strings.PluginHelp6 = "/Bu default - Reset shortcuts.\n";
		Strings.PluginHelp7 = "/Bu lock to lock or unlock the icons.\n";
		Strings.PluginHelp8 = "/Bu alt - Activate or deactivate the alt key to move the icon.\n";
	end
end