<script lang="ts">
	import '../app.css';
	import { LocalPlugin } from '$lib/models/localPlugin';
	import { GetInstalledPlugins } from '$lib/wailsjs/go/main/App';
	import { BrowserOpenURL } from '$lib/wailsjs/runtime';
	//import { createRelationship } from '$lib/state/pluginRelationship';

	class ToggleState {
		toggledItemId;
		isToggled = false;

		constructor(itemId: string) {
			this.toggledItemId = itemId;
		}
	}

	let plugins: LocalPlugin[] = [];
	let toggleState = new ToggleState('');

	GetInstalledPlugins().then(result => {
		let tmpPlugins: LocalPlugin[] = [];
		let relationship = new Map<string,string>();

		for (let i = 0; i < result.length; i++) {
			const element = result[i];
			tmpPlugins.push(new LocalPlugin(element.Id, element.Name, element.Author, element.Description, element.CurrentVersion, element.LatestVersion, element.InfoUrl));
			relationship.set(`${element.Name}-${element.Author}`, element.CurrentVersion)
		}

		plugins = tmpPlugins;

		const labelDocument = document.getElementById('plugin-labels')!;
		const pluginListDocument = document.getElementById('plugin-list')!;

		labelDocument.style.paddingRight = pluginListDocument.offsetWidth - pluginListDocument.clientWidth + 'px';
	});

	const refreshPage = () => {
		console.log('Refresh');
	};

	const updateAll = () => {
		console.log('Update all');
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

	const openUrl = (url: string) => {
		BrowserOpenURL(url);
	};
</script>

<div class="h-full text-left space-y-4 overflow-hidden">
	<div class="flex items-center">
		<div class="flex w-3/4">
			<div class="flex space-x-2">
				<button class="text-primary p-1 hover:bg-primary-transparent"
								on:click={refreshPage}>Refresh
				</button>
				<button class="text-primary p-1 hover:bg-primary-transparent"
								on:click={updateAll}>Update all
				</button>
			</div>
			<p class="ml-16 m-1">2 plugins installed</p>
		</div>
		<input class="grow p-2 text-gold bg-light-brown focus:outline-none" type="text"
					 placeholder="Search for a plugin...">
	</div>

	<div id="plugin-labels" class="flex text-left mx-2">
		<p class="w-1/2 px-2">Plugin</p>
		<div class="flex w-1/2">
			<p class="w-1/3 px-2">Current Version</p>
			<p class="w-1/3 px-2">Latest Version</p>
			<p class="w-1/3 px-2 text-center">Update</p>
		</div>
	</div>


	<ul id="plugin-list" class="space-y-2 h-full overflow-y-scroll">
		{#each plugins as plugin, index}
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
					<p>{plugin.description}</p>
					<div class="flex justify-end space-x-8 mt-4 mr-4">
						<button class="text-primary p-1 hover:bg-primary-transparent"
										on:click={() => openUrl(plugin.infoUrl)}>Open website
						</button>
						<button class="text-primary p-1 hover:bg-primary-transparent">Remove</button>
					</div>
				</div>
			</li>
		{/each}
	</ul>
</div>