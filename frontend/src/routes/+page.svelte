<script lang="ts">
	import '../app.css';
	import { DeletePlugin, GetInstalledPlugins, SearchLocal, UpdatePlugins } from '$lib/wailsjs/go/main/App';
	import PluginRow from '$lib/components/plugins/PluginRow.svelte';
	import type { entities } from '$lib/wailsjs/go/models';

	export let data: { plugins: entities.LocalPluginEntity[], amountPlugins: number };
	let plugins = data.plugins;
	let amountPlugins = data.amountPlugins;

	class ToggleState {
		toggledItemId;
		isToggled = false;

		constructor(itemId: string) {
			this.toggledItemId = itemId;
		}
	}

	let toggleState = new ToggleState('');

	let searchInput = '';
	$: searchPlugins(searchInput);

	const getInstalledPlugins = async () => {
		const installedPlugins = await GetInstalledPlugins();

		const labelDocument = document.getElementById('plugin-labels')!;
		const pluginListDocument = document.getElementById('plugin-list')!;

		labelDocument.style.paddingRight = pluginListDocument.offsetWidth - pluginListDocument.clientWidth + 'px';

		amountPlugins = installedPlugins.length;
		plugins = installedPlugins;
	};

	const searchPlugins = async (input: string) => {
		plugins = await SearchLocal(input);
	};

	const deletePlugin = async (name: string, author: string) => {
		plugins = await DeletePlugin(name, author);
	};

	const refreshPage = async () => {
		await getInstalledPlugins();
	};

	const updateAll = () => {
		let pluginsToUpdate: entities.LocalPluginEntity[] = [];

		for (let i = 0; i < plugins.length; i++) {
			const element = plugins[i];
			if (element.base.currentVersion != element.base.latestVersion) {
				pluginsToUpdate.push(element);
			}
		}

		UpdatePlugins(pluginsToUpdate);
	};

	const toggleDetails = (index: number) => {
		if (toggleState.isToggled) {
			let element = document.getElementById(toggleState.toggledItemId)!;

			element.classList.add('hidden');
			toggleState.isToggled = false;

			if (`details-${index}` !== toggleState.toggledItemId) {
				toggleState = new ToggleState(`details-${index}`);
				element = document.getElementById(toggleState.toggledItemId)!;
				element.classList.remove('hidden');
				toggleState.isToggled = true;
			}

		} else {
			if (`details-${index}` !== toggleState.toggledItemId || `details-${index}` === toggleState.toggledItemId && !toggleState.isToggled) {
				toggleState = new ToggleState(`details-${index}`);
				const element = document.getElementById(toggleState.toggledItemId)!;
				element.classList.remove('hidden');
				toggleState.isToggled = true;
			}
		}
	};

	getInstalledPlugins();
</script>

<div class="h-full text-left space-y-4 overflow-hidden">
	<div class="flex items-center">
		<div class="flex w-3/4">
			<div class="flex space-x-2">
				<button class="text-primary p-1 hover:bg-primary-transparent" on:click={refreshPage}>Refresh
				</button>
				<button class="text-primary p-1 hover:bg-primary-transparent"
								on:click={updateAll}>Update all
				</button>
			</div>
			<p class="ml-16 m-1">{amountPlugins} plugins installed</p>
		</div>
		<input class="grow p-2 text-gold bg-light-brown focus:outline-none" type="text"
					 bind:value={searchInput} placeholder="Search for a plugin...">
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
		<!--{#await getInstalledPlugins()}-->
		<!--	<p class="text-center text-gold">Loading plugins from the data store</p>-->
		<!--{:then plugins}-->
		<!--	{#each plugins as plugin, index}-->
		<!--		<PluginRow index={index} plugin={plugin} toggleDetails={toggleDetails} deletePlugin={deletePlugin} />-->
		<!--	{/each}-->
		<!--{:catch error}-->
		<!--	<p>Error while downloading plugin information: {error.message}</p>-->
		<!--{/await}-->
		{#if plugins === null}
			<p class="text-center text-gold">No plugins found</p>
		{:else}
			{#each plugins as plugin, index}
				<PluginRow index={index} plugin={plugin} toggleDetails={toggleDetails} deletePlugin={deletePlugin} />
			{/each}
		{/if}
	</ul>
</div>