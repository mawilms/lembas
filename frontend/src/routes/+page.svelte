<script lang="ts">
	import '../app.css';
	import { BasePlugin } from '$lib/entities/plugin';
	import { DeletePlugin, GetInstalledPlugins, SearchLocal, UpdatePlugins } from '$lib/wailsjs/go/main/App';
	import { BrowserOpenURL } from '$lib/wailsjs/runtime';

	class ToggleState {
		toggledItemId;
		isToggled = false;

		constructor(itemId: string) {
			this.toggledItemId = itemId;
		}
	}

	let toggleState = new ToggleState('');
	let installedPlugins: BasePlugin[] = [];
	let amountInstalledPlugins = 0;

	let modifiedPlugins: BasePlugin[];
	$: modifiedPlugins = [];
	$: {
		getInstalledPlugins().then((v => {
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

	const getInstalledPlugins = async () => {
		let installedPlugins = await GetInstalledPlugins();
		if (installedPlugins === null) {
			installedPlugins = []
		}

		let tmpPlugins: BasePlugin[] = [];

		for (let i = 0; i < installedPlugins.length; i++) {
			const element = installedPlugins[i];

			tmpPlugins.push(new BasePlugin(element.Base.Id, element.Base.Name, element.Base.Author, element.Base.Description, element.Base.CurrentVersion, element.Base.LatestVersion, element.Base.InfoUrl, element.Base.DownloadUrl));
		}
		amountInstalledPlugins = tmpPlugins.length;

		return tmpPlugins;
	};

	const searchPlugins = async (input: string) => {
		let installedPlugins = await SearchLocal(input);
		if (installedPlugins === null) {
			installedPlugins = [];
		}

		let tmpPlugins: BasePlugin[] = [];

		for (let i = 0; i < installedPlugins.length; i++) {
			const element = installedPlugins[i];

			tmpPlugins.push(new BasePlugin(element.Base.Id, element.Base.Name, element.Base.Author, element.Base.Description, element.Base.CurrentVersion, element.Base.LatestVersion, element.Base.InfoUrl, element.Base.DownloadUrl));
		}
		amountInstalledPlugins = tmpPlugins.length;

		return tmpPlugins;
	};

	getInstalledPlugins().then((plugins) => {
		installedPlugins = plugins;

		const labelDocument = document.getElementById('plugin-labels')!;
		const pluginListDocument = document.getElementById('plugin-list')!;

		labelDocument.style.paddingRight = pluginListDocument.offsetWidth - pluginListDocument.clientWidth + 'px';
	});

	// const refreshPage = async () => {
	// 	await getInstalledPlugins()
	// };

	const updateAll = () => {
		let pluginsToUpdate: BasePlugin[] = [];

		for (let i = 0; i < installedPlugins.length; i++) {
			const element = installedPlugins[i];
			if (element.currentVersion != element.latestVersion) {
				pluginsToUpdate.push(element);
			}
		}

		UpdatePlugins(pluginsToUpdate)
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
		{#await getInstalledPlugins()}
			<p class="text-center text-gold">Loading plugins from the data store</p>
		{:then plugins}
			{#each modifiedPlugins as plugin, index}
				<li id="plugin-{index}" class="block bg-light-brown">
					<div class="flex space-x-4 cursor-pointer" on:click={() => toggleDetails(index)}>
						<p class="w-1/2 p-2">{plugin.name}</p>
						<div class="flex w-1/2">
							<p class="w-1/3 p-2">{plugin.currentVersion}</p>
							<p class="w-1/3 p-2">{plugin.latestVersion}</p>
							<p class="w-1/3 p-2 text-center text-gold hover:bg-gold-transparent">
								{#if plugin.currentVersion !== plugin.latestVersion}
									<button>Update</button>
								{/if}
							</p>
						</div>
					</div>

					<div id="details-{index}" class="hidden p-4 bg-dark-brown">
						{#if (plugin.description === "")}
							<p>No description</p>
							{:else }
							<p>{plugin.description}</p>
						{/if}

						<div class="flex justify-end space-x-8 mt-4 mr-4">
							<button class="text-primary p-1 hover:bg-primary-transparent"
											on:click={() => BrowserOpenURL(plugin.infoUrl)}>Open website
							</button>
							<button class="text-primary p-1 hover:bg-primary-transparent" on:click={() => {DeletePlugin(plugin.name, plugin.author)}}>Delete</button>
						</div>
					</div>
				</li>
			{/each}
		{:catch error}
			<p>Error while downloading plugin information: {error.message}</p>
		{/await}
	</ul>


	<!--	<ul id="plugin-list" class="space-y-2 h-full overflow-y-scroll">-->
	<!--		{#each plugins as plugin, index}-->
	<!--			<li id="plugin-{index}" class="block bg-light-brown">-->
	<!--				<div class="flex space-x-4 cursor-pointer" on:click={() => toggleDetails(index)}>-->
	<!--					<p class="w-1/2 p-2">{plugin.name}</p>-->
	<!--					<div class="flex w-1/2">-->
	<!--						<p class="w-1/3 p-2">{plugin.currentVersion}</p>-->
	<!--						<p class="w-1/3 p-2">{plugin.latestVersion}</p>-->
	<!--						<p class="w-1/3 p-2 text-center text-gold hover:bg-gold-transparent">-->
	<!--							{#if plugin.currentVersion !== plugin.latestVersion}-->
	<!--								<button>Update</button>-->
	<!--							{/if}-->
	<!--						</p>-->
	<!--					</div>-->
	<!--				</div>-->

	<!--				<div id="details-{index}" class="hidden p-4 bg-dark-brown">-->
	<!--					<p>{plugin.description}</p>-->
	<!--					<div class="flex justify-end space-x-8 mt-4 mr-4">-->
	<!--						<button class="text-primary p-1 hover:bg-primary-transparent"-->
	<!--										on:click={() => openUrl(plugin.infoUrl)}>Open website-->
	<!--						</button>-->
	<!--						<button class="text-primary p-1 hover:bg-primary-transparent">Remove</button>-->
	<!--					</div>-->
	<!--				</div>-->
	<!--			</li>-->
	<!--		{/each}-->
	<!--	</ul>-->
</div>