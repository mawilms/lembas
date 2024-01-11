import { entities } from '$lib/wailsjs/go/models';

export class LocalPlugin {
	plugin: entities.LocalPluginEntity;
	isHidden: boolean;


	constructor(plugin: entities.LocalPluginEntity) {
		this.plugin = plugin;
		this.isHidden = true;
	}
}