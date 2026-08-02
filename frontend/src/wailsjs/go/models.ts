export namespace internal {
	
	export class Addon {
	    Id: number;
	    Type: string;
	    Name: string;
	    Author: string;
	    Description: string;
	    CurrentVersion: string;
	    LatestVersion: string;
	    Category: string;
	    Downloads: number;
	    UpdatedAt: string;
	    ArchiveName: string;
	    ArchiveSize: string;
	    HasUpdate: boolean;
	    IsInstalled: boolean;
	
	    static createFrom(source: any = {}) {
	        return new Addon(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.Id = source["Id"];
	        this.Type = source["Type"];
	        this.Name = source["Name"];
	        this.Author = source["Author"];
	        this.Description = source["Description"];
	        this.CurrentVersion = source["CurrentVersion"];
	        this.LatestVersion = source["LatestVersion"];
	        this.Category = source["Category"];
	        this.Downloads = source["Downloads"];
	        this.UpdatedAt = source["UpdatedAt"];
	        this.ArchiveName = source["ArchiveName"];
	        this.ArchiveSize = source["ArchiveSize"];
	        this.HasUpdate = source["HasUpdate"];
	        this.IsInstalled = source["IsInstalled"];
	    }
	}
	export class AddonMap {
	    localAddons: Record<number, Addon>;
	    remoteAddons: Record<number, Addon>;
	
	    static createFrom(source: any = {}) {
	        return new AddonMap(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.localAddons = this.convertValues(source["localAddons"], Addon, true);
	        this.remoteAddons = this.convertValues(source["remoteAddons"], Addon, true);
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

