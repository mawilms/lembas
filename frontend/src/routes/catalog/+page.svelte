<script lang="ts">
	import '../../app.css';
	import { GetRemotePlugins, InstallPlugin, SearchRemote } from '$lib/wailsjs/go/main/App';
	import { BrowserOpenURL } from '$lib/wailsjs/runtime';
	import type { entities } from '$lib/wailsjs/go/models';
	import PluginRow from '$lib/components/catalog/PluginRow.svelte';

	export let data: { plugins: entities.RemotePluginEntity[]; amountPlugins: number };
	let plugins = data.plugins;
	let amountPlugins = data.amountPlugins;

	let searchInput = '';
	$: searchPlugins(searchInput);

	const searchPlugins = async (input: string) => {
		plugins = await SearchRemote(input);
	};

	const installPlugin = async (plugin: entities.RemotePluginEntity) => {
		if (!plugin.isInstalled) {
			const fetchedPlugins = await InstallPlugin(plugin.base.downloadUrl);

			amountPlugins = fetchedPlugins.length;
			plugins = fetchedPlugins;
		}
	};

	const getRemotePlugin = async () => {
		const fetchedPlugins = await GetRemotePlugins();

		const labelDocument = document.getElementById('plugin-labels')!;
		const pluginListDocument = document.getElementById('plugin-list')!;

		labelDocument.style.paddingRight =
			pluginListDocument.offsetWidth - pluginListDocument.clientWidth + 'px';

		amountPlugins = fetchedPlugins.length;
		plugins = fetchedPlugins;
	};

	const openUrl = (url: string) => {
		BrowserOpenURL(url);
	};

	const updatePlugin = () => {
		console.log('Update');
	};

	getRemotePlugin();
</script>

<div class="h-full text-left space-y-4 overflow-hidden">
	<div class="flex items-center">
		<input
			bind:value={searchInput}
			class="p-2 text-gold bg-light-brown focus:outline-none w-1/3"
			placeholder="Search for data.plugins..."
			type="text"
		/>
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
		{#if plugins === null}
			<p class="text-center text-gold">Downloading plugin information from lotrocompendium.com</p>
		{:else}
			{#each plugins as plugin, index}
				<PluginRow {index} {plugin} {openUrl} {installPlugin} {updatePlugin} />
				<!--				<li id="plugin-{index}" class="block bg-light-brown cursor-pointer">-->
				<!--					<div class="flex space-x-4">-->
				<!--						<p class="w-1/3 p-2" on:click={() => {openUrl(plugin.base.infoUrl)}}>{plugin.base.name}</p>-->
				<!--						<div class="flex w-2/3">-->
				<!--							<p class="w-1/5 p-2" on:click={() => {openUrl(plugin.base.infoUrl)}}>{plugin.base.latestVersion}</p>-->
				<!--							<p class="w-1/5 p-2" on:click={() => {openUrl(plugin.base.infoUrl)}}>{plugin.base.author}</p>-->
				<!--							<p class="w-1/5 p-2" on:click={() => {openUrl(plugin.base.infoUrl)}}>{plugin.downloads}</p>-->
				<!--							<p class="w-1/5 p-2" on:click={() => {openUrl(plugin.base.infoUrl)}}>{plugin.updatedTimestamp}</p>-->
				<!--							{#if plugin.isInstalled && plugin.base.latestVersion !== plugin.base.currentVersion}-->
				<!--								<p class="w-1/5 p-2 text-center text-gold hover:bg-gold-transparent"-->
				<!--									 on:click={updatePlugin}>Update</p>-->
				<!--							{:else if plugin.isInstalled && plugin.base.latestVersion === plugin.base.currentVersion}-->
				<!--								<p class="w-1/5 p-2 text-center">Installed</p>-->
				<!--							{:else}-->
				<!--								<p class="w-1/5 p-2 text-center text-gold hover:bg-gold-transparent"-->
				<!--									 on:click={() => installPlugin(plugin)}>Install</p>-->
				<!--							{/if}-->
				<!--						</div>-->
				<!--					</div>-->
				<!--				</li>-->
			{/each}
		{/if}
	</ul>
</div>
