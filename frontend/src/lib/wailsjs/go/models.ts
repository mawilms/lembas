export namespace settings {

	export class Settings {
		pluginPath: string;
		dataDirectory: string;
		infoUrl: string;

		static createFrom(source: any = {}) {
			return new Settings(source);
		}

		constructor(source: any = {}) {
			if ('string' === typeof source) source = JSON.parse(source);
			this.pluginPath = source['pluginPath'];
			this.dataDirectory = source['dataDirectory'];
			this.infoUrl = source['infoUrl'];
		}
	}

}

