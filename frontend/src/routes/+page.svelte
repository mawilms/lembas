<script lang="ts">
	import '../app.css';
	import { DeletePlugin, GetInstalledPlugins, SearchLocal, UpdatePlugins } from '$lib/wailsjs/go/main/App';
	import type { entities } from '$lib/wailsjs/go/models';
	import { ToggleState } from './interactions';
	import PluginRow from './PluginRow.svelte';

	let amountPlugins = 0;

	const getInstalledPlugins = async () => {
		const installedPlugins = await GetInstalledPlugins();

		amountPlugins = installedPlugins.length;
		return installedPlugins;
	};

	getInstalledPlugins().then(() => {
		const labelDocument = document.getElementById('plugin-labels')!;
		const pluginListDocument = document.getElementById('plugin-list')!;

		labelDocument.style.paddingRight = pluginListDocument.offsetWidth - pluginListDocument.clientWidth + 'px';
	});

	let plugins = getInstalledPlugins();
	let toggleState = new ToggleState('');

	let searchInput = '';
	$: searchPlugins(searchInput);

	const searchPlugins = async (input: string) => {
		plugins = SearchLocal(input);
	};

	const deletePlugin = async (name: string, author: string) => {
		plugins = DeletePlugin(name, author);
	};

	const refreshPage = async () => {
		plugins = getInstalledPlugins();
	};

	const updateAll = async () => {
		const localPlugins = await plugins;
		let pluginsToUpdate: entities.LocalPluginEntity[] = [];

		for (let i = 0; i < localPlugins.length; i++) {
			const element = localPlugins[i];
			if (element.base.currentVersion != element.base.latestVersion) {
				pluginsToUpdate.push(element);
			}
		}

		// TODO: Return updated plugin view
		await UpdatePlugins(pluginsToUpdate);
	};

	const toggle = (index: number) => {
		toggleState.toggle(index);
	};
</script>

<div class="h-full text-left space-y-4 overflow-hidden">
	<div class="flex items-center">
		<div class="flex w-3/4">
			<div class="flex space-x-2">
				<button class="text-primary p-1 hover:bg-primary-transparent" on:click={refreshPage}
				>Refresh
				</button>
				<button class="text-primary p-1 hover:bg-primary-transparent" on:click={updateAll}
				>Update all
				</button>
			</div>
			<p class="ml-16 m-1">{amountPlugins} plugins installed</p>
		</div>
		<input
			class="grow p-2 text-gold bg-light-brown focus:outline-none"
			type="text"
			bind:value={searchInput}
			placeholder="Search for a plugin..."
		/>
	</div>

	<div id="plugin-labels" class="flex text-left mx-2">
		<p class="w-1/2 px-2">Plugin</p>
		<div class="flex w-1/2">
			<p class="w-1/3 px-2">Local Version</p>
			<p class="w-1/3 px-2">Latest Version</p>
			<p class="w-1/3 px-2 text-center">Update</p>
		</div>
	</div>

	<ul id="plugin-list" class="space-y-2 h-full overflow-y-scroll">
		{#await plugins}
			<p class="text-center text-gold">Loading plugins from the data store</p>
		{:then resolvedData}
			{#each resolvedData as plugin, index}
				<PluginRow index={index} plugin={plugin} toggle={toggle} deletePlugin={deletePlugin} />
			{/each}
		{:catch error}
			<p>Error while downloading plugin information: {error.message}</p>
		{/await}
	</ul>
</div>