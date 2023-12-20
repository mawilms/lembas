import type { entities } from '$lib/wailsjs/go/models';

export function load(): { plugins: entities.RemotePluginEntity[], amountPlugins: number } {
	return {
		plugins: [],
		amountPlugins: 0
	};
}