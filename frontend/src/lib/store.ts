import { writable } from 'svelte/store';

export const pluginStore = writable<Map<string, string>>(new Map<string, string>());

export function createPluginStore(relationships: Map<string, string>) {
	pluginStore.update(() => relationships);
}