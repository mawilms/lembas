export class RemotePlugin {
    id: number;
    name: string;
    author: string;
    version: string;
    lastUpdated: number;
    totalDownloads: number;
    category: string;
    description: string;
    filename: string;
    url: string;

    constructor(id: number, name: string, author: string, version: string, lastUpdated: number, totalDownloads: number, category: string, description: string, filename: string, url: string) {
        this.id = id;
        this.name = name;
        this.author = author;
        this.version = version;
        this.lastUpdated = lastUpdated;
        this.totalDownloads = totalDownloads;
        this.category = category;
        this.description = description;
        this.filename = filename;
        this.url = url;
    }
}
