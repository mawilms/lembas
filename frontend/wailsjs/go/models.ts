export namespace remote {
	
	export class RemoteAddon {
	    Id: number;
	    Name: string;
	    Author: string;
	    Version: string;
	    Updated: string;
	    Downloads: number;
	    Category: string;
	    Description: string;
	    File: string;
	    Size: string;
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
	        this.Updated = source["Updated"];
	        this.Downloads = source["Downloads"];
	        this.Category = source["Category"];
	        this.Description = source["Description"];
	        this.File = source["File"];
	        this.Size = source["Size"];
	        this.FileURL = source["FileURL"];
	    }
	}

}

