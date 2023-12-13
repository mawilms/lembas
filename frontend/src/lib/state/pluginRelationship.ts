import { writable } from 'svelte/store';

export const pluginRelationship = writable<Map<string, string>>(new Map<string, string>());

export function createRelationship(relationships: Map<string, string>) {
	pluginRelationship.update(() => relationships);
}