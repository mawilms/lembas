<script lang="ts">
	import '../../app.css';
	import { FetchRemotePlugins, InstallPlugin } from '$lib/wailsjs/go/main/App';
	import { BrowserOpenURL } from '$lib/wailsjs/runtime/runtime';
	import { RemotePlugin } from '$lib/models/remotePlugin';

	class ToggleState {
		toggledItemId;
		isToggled = false;

		constructor(itemId: string) {
			this.toggledItemId = itemId;
		}
	}

	let plugins: RemotePlugin[] = [];
	let toggleState = new ToggleState('');

	FetchRemotePlugins().then(result => {
		let tmpArray: RemotePlugin[] = [];
		for (let i = 0; i < result.length; i++) {
			const element = result[i];
			const time = new Date(element.UpdatedTimestamp * 1000).toLocaleDateString();
			const infoUrl = `https://www.lotrointerface.com/downloads/info${element.Id}-${element.Name}.html`;

			tmpArray.push(new RemotePlugin(element.Id, element.Name, element.Author, element.Version, time, element.Downloads, element.Category, element.Description, element.FileName, infoUrl, element.Url));
		}
		const labelDocument = document.getElementById('plugin-labels')!;
		const pluginListDocument = document.getElementById('plugin-list')!;

		labelDocument.style.paddingRight = pluginListDocument.offsetWidth - pluginListDocument.clientWidth + 'px';

		plugins = tmpArray;
	});

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
				let element = document.getElementById(toggleState.toggledItemId)!;
				element.classList.remove('hidden');
				toggleState.isToggled = true;
			}
		}
	};

	const openUrl = (url: string) => {
		BrowserOpenURL(url);
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
			<li id="plugin-{index}" class="block bg-light-brown">
				<div class="flex space-x-4 cursor-pointer" on:click={() => toggleDetails(index)}>
					<p class="w-1/3 p-2">{plugin.name}</p>
					<div class="flex w-2/3">
						<p class="w-1/5 p-2">{plugin.version}</p>
						<p class="w-1/5 p-2">{plugin.author}</p>
						<p class="w-1/5 p-2">{plugin.totalDownloads}</p>
						<p class="w-1/5 p-2">{plugin.lastUpdated}</p>
						<p class="w-1/5 text-center text-gold hover:bg-gold-transparent p-2">Installed</p>
					</div>
				</div>
				<div id="details-{index}" class="hidden p-4 bg-dark-brown">
					<p>{plugin.description}</p>
					<div class="flex justify-end space-x-8 mt-4">
						<button class="text-primary py-1 px-1 hover:bg-primary-transparent"
										on:click={() => openUrl(plugin.url)}>Open website
						</button>
						<button class="text-primary py-1 px-1 hover:bg-primary-transparent"
										on:click={() => InstallPlugin(plugin.downloadUrl)}>Install/Update
						</button>
						<button class="text-primary py-1 px-1 hover:bg-primary-transparent">Remove</button>

					</div>
				</div>
			</li>
		{/each}
	</ul>

</div>