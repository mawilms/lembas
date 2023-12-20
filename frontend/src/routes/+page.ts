import type { entities } from '$lib/wailsjs/go/models';

export function load(): { plugins: entities.LocalPluginEntity[], amountPlugins: number } {
	return {
		plugins: [],
		amountPlugins: 0
	};
}