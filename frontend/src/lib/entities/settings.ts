export class Settings {
	pluginPath: string;
	dataDirectory: string;
	infoUrl: string;

	constructor(pluginPath: string, dataDirectory: string, infoUrl: string) {
		this.pluginPath = pluginPath;
		this.dataDirectory = dataDirectory;
		this.infoUrl = infoUrl;
	}
}