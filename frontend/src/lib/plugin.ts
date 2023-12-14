export class Plugin {
	name: string;
	currentVersion: string;
	latestVersion: string;

	constructor(name: string, currentVersion: string, latestVersion: string) {
		this.name = name;
		this.currentVersion = currentVersion;
		this.latestVersion = latestVersion;
	}
}