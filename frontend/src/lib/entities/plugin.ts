export class BasePlugin {
	id: number;
	name: string;
	author: string;
	description: string;
	currentVersion: string;
	latestVersion: string;
	infoUrl: string;
	downloadUrl: string;

	constructor(id: number, name: string, author: string, description: string, currentVersion: string, latestVersion: string, infoUrl: string, downloadUrl: string) {
		this.id = id;
		this.name = name;
		this.author = author;
		this.description = description;
		this.currentVersion = currentVersion;
		this.latestVersion = latestVersion;
		this.infoUrl = infoUrl;
		this.downloadUrl = downloadUrl;
	}
}

export class Plugin {
	base: BasePlugin;

	constructor(base: BasePlugin) {
		this.base = base;
	}
}

export class RemotePlugin {
	base: BasePlugin;
	totalDownloads: number;
	category: string;
	filename: string;
	isInstalled: boolean;
	lastUpdated: string;

	constructor(base: BasePlugin, totalDownloads: number, category: string, filename: string, isInstalled: boolean, lastUpdated: string) {
		this.base = base;
		this.totalDownloads = totalDownloads;
		this.category = category;
		this.filename = filename;
		this.isInstalled = isInstalled;
		this.lastUpdated = lastUpdated;
	}
}