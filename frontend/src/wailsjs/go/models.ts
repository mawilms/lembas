export namespace internal {
	
	export class Addon {
	    id: number;
	    type: string;
	    name: string;
	    author: string;
	    description: string;
	    localVersion: string;
	    remoteVersion: string;
	    category: string;
	    downloads: number;
	    updatedAt: string;
	    archiveName: string;
	    archiveSize: string;
	    hasUpdate: boolean;
	    isInstalled: boolean;
	
	    static createFrom(source: any = {}) {
	        return new Addon(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.type = source["type"];
	        this.name = source["name"];
	        this.author = source["author"];
	        this.description = source["description"];
	        this.localVersion = source["localVersion"];
	        this.remoteVersion = source["remoteVersion"];
	        this.category = source["category"];
	        this.downloads = source["downloads"];
	        this.updatedAt = source["updatedAt"];
	        this.archiveName = source["archiveName"];
	        this.archiveSize = source["archiveSize"];
	        this.hasUpdate = source["hasUpdate"];
	        this.isInstalled = source["isInstalled"];
	    }
	}

}

export namespace main {
	
	export class AddonMap {
	    localAddons: Record<number, internal.Addon>;
	    remoteAddons: Record<number, internal.Addon>;
	
	    static createFrom(source: any = {}) {
	        return new AddonMap(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.localAddons = this.convertValues(source["localAddons"], internal.Addon, true);
	        this.remoteAddons = this.convertValues(source["remoteAddons"], internal.Addon, true);
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice && a.map) {
		        return (a as any[]).map(elem => this.convertValues(elem, classs));
		    } else if ("object" === typeof a) {
		        if (asMap) {
		            for (const key of Object.keys(a)) {
		                a[key] = new classs(a[key]);
		            }
		            return a;
		        }
		        return new classs(a);
		    }
		    return a;
		}
	}

}

