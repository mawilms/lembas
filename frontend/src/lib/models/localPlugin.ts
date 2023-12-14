export class LocalPlugin {
	id: number;
	name: string;
	author: string;
	description: string;
	currentVersion: string;
	latestVersion: string;
	infoUrl: string;
	downloadUrl: string;

	constructor(id: number, name: string, author: string, description: string, currentVersion: string, latestVersion: string, infoUrl: string) {
		if (id !== -1) {
			this.downloadUrl = `http://www.lotrointerface.com/downloads/download${id}`;
		} else {
			this.downloadUrl = '';
		}

		this.id = id;
		this.name = name;
		this.author = author;
		this.description = description;
		this.currentVersion = currentVersion;
		this.latestVersion = latestVersion;
		this.infoUrl = infoUrl;
	}
}