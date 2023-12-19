<script lang="ts">
	import '../../app.css';
	import { GetRemotePlugins, InstallPlugin, SearchRemote } from '$lib/wailsjs/go/main/App';
	import { BrowserOpenURL } from '$lib/wailsjs/runtime';
	import { BasePlugin, RemotePlugin } from '$lib/entities/plugin';

	let amountPlugins = 0;
	let modifiedPlugins: RemotePlugin[];
	$: modifiedPlugins = [];
	$: {
		getRemotePlugin().then((v => {
			modifiedPlugins = v;
		}));
	}

	let searchInput = '';
	$: search(searchInput);

	function search(input: string) {
		searchPlugins(input).then((v => {
			modifiedPlugins = v;
		}));
	}

	const searchPlugins = async (input: string) => {
		const fetchedPlugins = await SearchRemote(input);

		let tmpArray: RemotePlugin[] = [];

		for (let i = 0; i < fetchedPlugins.length; i++) {
			const element = fetchedPlugins[i];
			const time = new Date(element.UpdatedTimestamp * 1000).toLocaleDateString();

			const basePlugin = new BasePlugin(element.Base.Id, element.Base.Name, element.Base.Author, element.Base.Description, element.Base.CurrentVersion, element.Base.LatestVersion, element.Base.InfoUrl, element.Base.DownloadUrl);
			tmpArray.push(new RemotePlugin(basePlugin, element.Downloads, element.Category, element.FileName, element.IsInstalled, time));
		}

		amountPlugins = tmpArray.length;

		return tmpArray;
	};

	const installPlugin = async (plugin: RemotePlugin) => {
		if (!plugin.isInstalled) {
			let fetchedPlugins = await InstallPlugin(plugin.base.downloadUrl);
			if (fetchedPlugins === null) {
				fetchedPlugins = [];
			}

			let tmpArray: RemotePlugin[] = [];

			for (let i = 0; i < fetchedPlugins.length; i++) {
				const element = fetchedPlugins[i];
				const time = new Date(element.UpdatedTimestamp * 1000).toLocaleDateString();

				const basePlugin = new BasePlugin(element.Base.Id, element.Base.Name, element.Base.Author, element.Base.Description, element.Base.CurrentVersion, element.Base.LatestVersion, element.Base.InfoUrl, element.Base.DownloadUrl);
				tmpArray.push(new RemotePlugin(basePlugin, element.Downloads, element.Category, element.FileName, element.IsInstalled, time));
			}
			modifiedPlugins = tmpArray;
		}
	};

	const getRemotePlugin = async () => {
		const fetchedPlugins = await GetRemotePlugins();

		let tmpArray: RemotePlugin[] = [];

		for (let i = 0; i < fetchedPlugins.length; i++) {
			const element = fetchedPlugins[i];
			const time = new Date(element.UpdatedTimestamp * 1000).toLocaleDateString();

			const basePlugin = new BasePlugin(element.Base.Id, element.Base.Name, element.Base.Author, element.Base.Description, element.Base.CurrentVersion, element.Base.LatestVersion, element.Base.InfoUrl, element.Base.DownloadUrl);
			tmpArray.push(new RemotePlugin(basePlugin, element.Downloads, element.Category, element.FileName, element.IsInstalled, time));
		}

		amountPlugins = tmpArray.length;

		return tmpArray;
	};
	getRemotePlugin().then(() => {
		const labelDocument = document.getElementById('plugin-labels')!;
		const pluginListDocument = document.getElementById('plugin-list')!;

		labelDocument.style.paddingRight = pluginListDocument.offsetWidth - pluginListDocument.clientWidth + 'px';
	});

	const openUrl = (url: string) => {
		BrowserOpenURL(url);
	};

	const UpdatePlugin = () => {
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
		{#await getRemotePlugin()}
			<p class="text-center text-gold">Downloading plugin information from lotrocompendium.com</p>
		{:then plugins}
			{#each modifiedPlugins as plugin, index}
				<li id="plugin-{index}" class="block bg-light-brown cursor-pointer">
					<div class="flex space-x-4">
						<p class="w-1/3 p-2" on:click={() => {openUrl(plugin.base.infoUrl)}}>{plugin.base.name}</p>
						<div class="flex w-2/3">
							<p class="w-1/5 p-2" on:click={() => {openUrl(plugin.base.infoUrl)}}>{plugin.base.latestVersion}</p>
							<p class="w-1/5 p-2" on:click={() => {openUrl(plugin.base.infoUrl)}}>{plugin.base.author}</p>
							<p class="w-1/5 p-2" on:click={() => {openUrl(plugin.base.infoUrl)}}>{plugin.totalDownloads}</p>
							<p class="w-1/5 p-2" on:click={() => {openUrl(plugin.base.infoUrl)}}>{plugin.lastUpdated}</p>
							{#if plugin.isInstalled && plugin.base.latestVersion !== plugin.base.currentVersion}
								<p class="w-1/5 p-2 text-center text-gold hover:bg-gold-transparent"
									 on:click={UpdatePlugin}>Update</p>
							{:else if plugin.isInstalled && plugin.base.latestVersion === plugin.base.currentVersion}
								<p class="w-1/5 p-2 text-center">Installed</p>
							{:else}
								<p class="w-1/5 p-2 text-center text-gold hover:bg-gold-transparent"
									 on:click={() => installPlugin(plugin)}>Install</p>
							{/if}
						</div>
					</div>
				</li>
			{/each}
		{:catch error}
			<p>Error while downloading plugin information: {error.message}</p>
		{/await}
	</ul>

</div>