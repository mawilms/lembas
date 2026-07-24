export namespace database {
	
	export class Addon {
	    Id: number;
	    Name: string;
	    Author: string;
	    Version: string;
	    Description: string;
	    IsManaged: boolean;
	    Plugin: string;
	    PluginCompendium: string;
	    RootFolder: string;
	    PluginFolder: string;
	    Downloads: number;
	    UpdatedAt: string;
	    ArchiveName: string;
	    ArchiveSize: string;
	    Category: string;
	
	    static createFrom(source: any = {}) {
	        return new Addon(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.Id = source["Id"];
	        this.Name = source["Name"];
	        this.Author = source["Author"];
	        this.Version = source["Version"];
	        this.Description = source["Description"];
	        this.IsManaged = source["IsManaged"];
	        this.Plugin = source["Plugin"];
	        this.PluginCompendium = source["PluginCompendium"];
	        this.RootFolder = source["RootFolder"];
	        this.PluginFolder = source["PluginFolder"];
	        this.Downloads = source["Downloads"];
	        this.UpdatedAt = source["UpdatedAt"];
	        this.ArchiveName = source["ArchiveName"];
	        this.ArchiveSize = source["ArchiveSize"];
	        this.Category = source["Category"];
	    }
	}

}

export namespace remote {
	
	export class RemoteAddon {
	    Id: number;
	    Name: string;
	    Author: string;
	    Version: string;
	    UpdatedAt: string;
	    Downloads: number;
	    Category: string;
	    Description: string;
	    ArchiveName: string;
	    ArchiveSize: string;
	    FileURL: string;
	
	    static createFrom(source: any = {}) {
	        return new RemoteAddon(source);
	    }
	
	    constructor(source: any = {}) {
	        if ('string' === typeof source) source = JSON.parse(source);
	        this.Id = source["Id"];
	        this.Name = source["Name"];
	        this.Author = source["Author"];
	        this.Version = source["Version"];
	        this.UpdatedAt = source["UpdatedAt"];
	        this.Downloads = source["Downloads"];
	        this.Category = source["Category"];
	        this.Description = source["Description"];
	        this.ArchiveName = source["ArchiveName"];
	        this.ArchiveSize = source["ArchiveSize"];
	        this.FileURL = source["FileURL"];
	    }
	}

}

