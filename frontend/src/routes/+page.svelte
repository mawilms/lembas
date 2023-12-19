<script lang="ts">
	import '../app.css';
	import { DeletePlugin, GetInstalledPlugins, SearchLocal, UpdatePlugins } from '$lib/wailsjs/go/main/App';
	import PluginRow from '$lib/components/plugins/PluginRow.svelte';
	import type { entities } from '$lib/wailsjs/go/models';

	class ToggleState {
		toggledItemId;
		isToggled = false;

		constructor(itemId: string) {
			this.toggledItemId = itemId;
		}
	}

	let allPlugins: entities.LocalPluginEntity[] = [];
	let amountInstalledPlugins = 0;

	let toggleState = new ToggleState('');

	let searchInput = '';
	$: searchPlugins(searchInput);

	const getInstalledPlugins = async () => {
		let installedPlugins = await GetInstalledPlugins();

		const labelDocument = document.getElementById('plugin-labels')!;
		const pluginListDocument = document.getElementById('plugin-list')!;

		labelDocument.style.paddingRight = pluginListDocument.offsetWidth - pluginListDocument.clientWidth + 'px';

		amountInstalledPlugins = installedPlugins.length;
		allPlugins = installedPlugins
	};

	const searchPlugins = async (input: string) => {
		allPlugins = await SearchLocal(input);
	};

	const deletePlugin = async (name: string, author: string) => {
		allPlugins = await DeletePlugin(name, author);
	};

	// const refreshPage = async () => {
	// 	await getInstalledPlugins()
	// };

	const updateAll = () => {
		// let pluginsToUpdate: BasePlugin[] = [];
		//
		// for (let i = 0; i < allPlugins.length; i++) {
		// 	const element = allPlugins[i];
		// 	if (element.currentVersion != element.latestVersion) {
		// 		pluginsToUpdate.push(element);
		// 	}
		// }
		//
		// UpdatePlugins(pluginsToUpdate);
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

	getInstalledPlugins()
</script>

<div class="h-full text-left space-y-4 overflow-hidden">
	<div class="flex items-center">
		<div class="flex w-3/4">
			<div class="flex space-x-2">
				<button class="text-primary p-1 hover:bg-primary-transparent">Refresh
				</button>
				<button class="text-primary p-1 hover:bg-primary-transparent"
								on:click={updateAll}>Update all
				</button>
			</div>
			<p class="ml-16 m-1">{amountInstalledPlugins} plugins installed</p>
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
		{#if allPlugins.length === 0}
			<p class="text-center text-gold">No plugins found</p>
		{:else}
			{#each allPlugins as plugin, index}
				<PluginRow index={index} plugin={plugin} toggleDetails={toggleDetails} deletePlugin={deletePlugin} />
			{/each}
		{/if}

		<!--{#await getInstalledPlugins()}-->
		<!--	<p class="text-center text-gold">Loading plugins from the data store</p>-->
		<!--{:then plugins}-->
		<!--	{#each modifiedPlugins as plugin, index}-->
		<!--		<PluginRow index={index} plugin={plugin} toggleDetails={toggleDetails} deletePlugin={deletePlugin} />-->
		<!--	{/each}-->
		<!--{:catch error}-->
		<!--	<p>Error while downloading plugin information: {error.message}</p>-->
		<!--{/await}-->
	</ul>
</div>