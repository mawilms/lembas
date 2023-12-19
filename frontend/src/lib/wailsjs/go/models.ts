export namespace entities {
	
	export class BasePluginEntity {
	    id: number;
	    name: string;
	    description: string;
	    author: string;
	    currentVersion: string;
	    latestVersion: string;
	    infoUrl: string;
	    downloadUrl: string;
	
	    static createFrom(source: any = {}) {
	        return new BasePluginEntity(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.id = source["id"];
	        this.name = source["name"];
	        this.description = source["description"];
	        this.author = source["author"];
	        this.currentVersion = source["currentVersion"];
	        this.latestVersion = source["latestVersion"];
	        this.infoUrl = source["infoUrl"];
	        this.downloadUrl = source["downloadUrl"];
	    }
	}
	export class LocalPluginEntity {
	    base: BasePluginEntity;
	    descriptors: string[];
	    dependencies: number[];
	
	    static createFrom(source: any = {}) {
	        return new LocalPluginEntity(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.base = this.convertValues(source["base"], BasePluginEntity);
	        this.descriptors = source["descriptors"];
	        this.dependencies = source["dependencies"];
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice) {
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
	export class RemotePluginEntity {
	    base: BasePluginEntity;
	    isInstalled: boolean;
	    updatedTimestamp: number;
	    downloads: number;
	    category: string;
	    file_name: string;
	
	    static createFrom(source: any = {}) {
	        return new RemotePluginEntity(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.base = this.convertValues(source["base"], BasePluginEntity);
	        this.isInstalled = source["isInstalled"];
	        this.updatedTimestamp = source["updatedTimestamp"];
	        this.downloads = source["downloads"];
	        this.category = source["category"];
	        this.file_name = source["file_name"];
	    }
	
		convertValues(a: any, classs: any, asMap: boolean = false): any {
		    if (!a) {
		        return a;
		    }
		    if (a.slice) {
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
	        this.pluginPath = source["pluginPath"];
	        this.dataDirectory = source["dataDirectory"];
	        this.infoUrl = source["infoUrl"];
	    }
	}

}

