<script lang="ts">
	import '../../app.css';
	import { GetRemotePlugins, InstallPlugin, SearchRemote } from '$lib/wailsjs/go/main/App';
	import { BrowserOpenURL } from '$lib/wailsjs/runtime';
	import type { entities } from '$lib/wailsjs/go/models';
	import PluginRow from './PluginRow.svelte';

	let amountPlugins = 0;

	const getRemotePlugins = async () => {
		const fetchedPlugins = await GetRemotePlugins();

		amountPlugins = fetchedPlugins.length;
		return fetchedPlugins
	};

	let plugins = getRemotePlugins()

	let searchInput = '';
	$: search(searchInput);

	function search(input: string) {
		searchPlugins(input)
	}

	const searchPlugins = async (input: string) => {
		const fetchedPlugins = await SearchRemote(input);

		amountPlugins = fetchedPlugins.length;
		plugins = Promise.resolve(fetchedPlugins)
	};

	const installPlugin = async (plugin: entities.RemotePluginEntity) => {
		if (!plugin.isInstalled) {
			let fetchedPlugins = await InstallPlugin(plugin.base.downloadUrl);
			if (fetchedPlugins === null) {
				fetchedPlugins = [];
			}

			plugins = Promise.resolve(fetchedPlugins)
		}
	};

	getRemotePlugins().then(() => {
		const labelDocument = document.getElementById('plugin-labels')!;
		const pluginListDocument = document.getElementById('plugin-list')!;

		labelDocument.style.paddingRight = pluginListDocument.offsetWidth - pluginListDocument.clientWidth + 'px';
	});

	const openUrl = (url: string) => {
		BrowserOpenURL(url);
	};

	const updatePlugin = () => {
		console.log('Update');
	};
</script>

<div class="h-full text-left space-y-4 overflow-hidden">
	<div class="flex items-center">
		<input bind:value={searchInput} class="p-2 text-gold bg-light-brown focus:outline-none w-1/3"
					 placeholder="Search for plugins..."
					 type="text">
		<p class="ml-16 m-1">{amountPlugins} plugins found</p>
	</div>

	<div id="plugin-labels" class="flex space-x-4">
		<p class="w-1/3 px-2">Plugin</p>
		<div class="flex w-2/3">
			<p class="w-1/5 px-2">Version</p>
			<p class="w-1/5 px-2">Author</p>
			<p class="w-1/5 px-2">Downloads</p>
			<p class="w-1/5 px-2">Latest Release</p>
			<p class="w-1/5 px-2 text-center">Status</p>
		</div>
	</div>

	<ul id="plugin-list" class="space-y-2 h-full overflow-y-scroll">
		{#await plugins}
			<p class="text-center text-gold">Downloading plugin information from lotrocompendium.com</p>
		{:then resolvedData}
			{#each resolvedData as plugin, index}
				<PluginRow {index} {plugin} {openUrl} {installPlugin} {updatePlugin} />
			{/each}
		{:catch error}
			<p>Error while downloading plugin information: {error.message}</p>
		{/await}
	</ul>
</div>