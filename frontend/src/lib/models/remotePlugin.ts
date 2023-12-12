export class RemotePlugin {
	id: number;
	name: string;
	author: string;
	version: string;
	lastUpdated: string;
	totalDownloads: number;
	category: string;
	description: string;
	filename: string;
	infoUrl: string;
	downloadUrl: string;

	constructor(id: number, name: string, author: string, version: string, lastUpdated: string, totalDownloads: number, category: string, description: string, filename: string, infoUrl: string, downloadUrl: string) {
		this.id = id;
		this.name = name;
		this.author = author;
		this.version = version;
		this.lastUpdated = lastUpdated;
		this.totalDownloads = totalDownloads;
		this.category = category;
		this.description = description;
		this.filename = filename;
		this.infoUrl = infoUrl;
		this.downloadUrl = downloadUrl;
	}
}
