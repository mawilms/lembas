<script lang="ts">
	import '../../app.css';
	import { FetchRemotePlugins, InstallPlugin } from '$lib/wailsjs/go/main/App';
	import { RemotePlugin } from '$lib/models/remotePlugin';
	import { BrowserOpenURL } from '$lib/wailsjs/runtime';

	let plugins: RemotePlugin[] = [];

	FetchRemotePlugins().then(result => {
		const relationship: Map<string, string> = new Map<string, string>();
		let tmpArray: RemotePlugin[] = [];

		for (let i = 0; i < result.length; i++) {
			const element = result[i];
			const time = new Date(element.UpdatedTimestamp * 1000).toLocaleDateString();
			const infoUrl = `https://www.lotrointerface.com/downloads/info${element.Id}-${element.Name}.html`;

			let isInstalled = false;
			let installedVersion = '';
			if (relationship.has(`${element.Name}-${element.Author}`)) {
				isInstalled = true;
				installedVersion = relationship.get(`${element.Name}-${element.Author}`)!;
			}

			tmpArray.push(new RemotePlugin(element.Id, element.Name, element.Author, element.Version, time, element.Downloads, element.Category, element.Description, element.FileName, infoUrl, element.Url, isInstalled, installedVersion));
		}
		const labelDocument = document.getElementById('plugin-labels')!;
		const pluginListDocument = document.getElementById('plugin-list')!;

		labelDocument.style.paddingRight = pluginListDocument.offsetWidth - pluginListDocument.clientWidth + 'px';

		plugins = tmpArray;
	});

	const openUrl = (url: string) => {
		BrowserOpenURL(url);
	};

	const UpdatePlugin = () => {
		console.log('Update');
	};
</script>

<div class="h-full text-left space-y-4 overflow-hidden">
	<input class="p-2 text-gold bg-light-brown focus:outline-none w-1/3" type="text" placeholder="Search for plugins...">

	<div id="plugin-labels" class="flex space-x-4">
		<p class="w-1/3 px-2">Name</p>
		<div class="flex w-2/3">
			<p class="w-1/5 px-2">Version</p>
			<p class="w-1/5 px-2">Author</p>
			<p class="w-1/5 px-2">Downloads</p>
			<p class="w-1/5 px-2">Latest Release</p>
			<p class="w-1/5 px-2 text-center">Status</p>
		</div>
	</div>

	<ul id="plugin-list" class="space-y-2 h-full overflow-y-scroll">
		{#each plugins as plugin, index}
			<li id="plugin-{index}" class="block bg-light-brown cursor-pointer">
				<div class="flex space-x-4">
					<p class="w-1/3 p-2" on:click={() => {openUrl(plugin.infoUrl)}}>{plugin.name}</p>
					<div class="flex w-2/3">
						<p class="w-1/5 p-2" on:click={() => {openUrl(plugin.infoUrl)}}>{plugin.version}</p>
						<p class="w-1/5 p-2" on:click={() => {openUrl(plugin.infoUrl)}}>{plugin.author}</p>
						<p class="w-1/5 p-2" on:click={() => {openUrl(plugin.infoUrl)}}>{plugin.totalDownloads}</p>
						<p class="w-1/5 p-2" on:click={() => {openUrl(plugin.infoUrl)}}>{plugin.lastUpdated}</p>
						{#if plugin.isInstalled && plugin.version !== plugin.installedVersion}
							<p class="w-1/5 p-2 text-center text-gold hover:bg-gold-transparent"
								 on:click={UpdatePlugin}>Update</p>
						{:else if plugin.isInstalled && plugin.version === plugin.installedVersion}
							<p class="w-1/5 p-2 text-center">Installed</p>
						{:else}
							<p class="w-1/5 p-2 text-center text-gold hover:bg-gold-transparent"
								 on:click={() => InstallPlugin(plugin.downloadUrl)}>Install</p>
						{/if}
					</div>
				</div>
			</li>
		{/each}
	</ul>

</div>