<script lang="ts">
	import "../app.css";
	import {Plugin} from "$lib/plugin";
	// import {LocalPlugin} from "$lib/models/localPlugin";
	import {GetInstalledPlugins} from "$lib/wailsjs/go/main/App"

	const plugins = [
		new Plugin('RaidGuy', '1.90', '1.90'),
		new Plugin('Potions', '1.00', '1.02')
	];

	// const labelDocument = document.getElementById('plugin-labels')!;
	// const pluginListDocument = document.getElementById('plugin-list')!;
	//
	// labelDocument.style.paddingRight = pluginListDocument.offsetWidth - pluginListDocument.clientWidth + 'px';

	GetInstalledPlugins().then(result => {
		// let tmpPlugins: LocalPlugin[] = []
		console.log(result)
	})

	const refreshPage = () => {
		console.log('Refresh');
	};

	const updateAll = () => {
		console.log('Update all');
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
		{#each plugins as plugin}
			<li class="flex bg-light-brown">
				<p class="w-1/2 p-2">{plugin.name}</p>
				<div class="flex w-1/2">
					<p class="w-1/3 p-2">{plugin.currentVersion}</p>
					<p class="w-1/3 p-2">{plugin.latestVersion}</p>
					<p class="w-1/3 p-2 text-center text-gold hover:bg-gold-transparent">
						{#if plugin.currentVersion < plugin.latestVersion}
							<button>Update</button>
						{/if}
					</p>
				</div>
			</li>
		{/each}
	</ul>
</div>