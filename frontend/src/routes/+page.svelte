<script lang="ts">
	import '../app.css';
	import { DeletePlugin, GetInstalledPlugins, SearchLocal, UpdatePlugins } from '$lib/wailsjs/go/main/App';
	import type { entities } from '$lib/wailsjs/go/models';
	import { ToggleState } from './interactions';
	import PluginRow from './PluginRow.svelte';

	// TODO: Add state for plugins loading and no plugins found
	enum Status {
		Loading = 1,
		Loaded
	}

	let amountPlugins = 0;
	let error = '';
	let status = Status.Loading;

	$:  plugins = [];
	$: if (plugins != null) {
		const labelDocument = document.getElementById('plugin-labels');
		const pluginListDocument = document.getElementById('plugin-list');
		if (labelDocument !== null && pluginListDocument !== null) {
			labelDocument.style.paddingRight = pluginListDocument.offsetWidth - pluginListDocument.clientWidth + 'px';
		}

		amountPlugins = plugins.length;
	}

	GetInstalledPlugins()
		.then((result) => {
			status = Status.Loaded;
			plugins = result;
		});

	async function getInstalledPlugins() {
		const installedPlugins = await GetInstalledPlugins();

		amountPlugins = installedPlugins.length;
		plugins = installedPlugins;
	}

	let toggleState = new ToggleState('');

	let searchInput = '';
	$: searchPlugins(searchInput);

	const searchPlugins = async (input: string) => {
		plugins = await SearchLocal(input);
	};

	const deletePlugin = async (name: string, author: string) => {
		plugins = await DeletePlugin(name, author);
	};

	const refreshPage = async () => {
		await getInstalledPlugins();
	};

	const updateAll = async () => {
		let pluginsToUpdate: entities.LocalPluginEntity[] = [];

		for (let i = 0; i < plugins.length; i++) {
			const element = plugins[i];
			if (element.base.currentVersion != element.base.latestVersion) {
				pluginsToUpdate.push(element);
			}
		}

		// TODO: Return updated plugin view
		await UpdatePlugins(pluginsToUpdate);
	};

	const toggle = (index: number) => {
		const element = document.getElementById(`details-${index}`)!;
		toggleState.toggle(index, element);
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
		{#if plugins === null}
			{#if status === Status.Loading}
				<p class="text-center text-gold">Loading plugins from the data store</p>
			{:else}
				<p class="text-center text-gold">No plugins found</p>
			{/if}
		{:else if plugins.length === 0}
			{#if status === Status.Loading}
				<p class="text-center text-gold">Loading plugins from the data store</p>
			{:else}
				<p class="text-center text-gold">No plugins found</p>
			{/if}
		{:else if plugins.length !== 0}
			{#each plugins as plugin, index}
				<PluginRow index={index} plugin={plugin} toggle={toggle} deletePlugin={deletePlugin} />
			{/each}
		{:else}
			<p class="text-center text-gold">Error while loading data from the data store: {error}</p>
		{/if}
	</ul>
</div>