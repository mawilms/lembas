<script lang="ts">
	import { BrowserOpenURL } from '$lib/wailsjs/runtime/runtime.js';
	import type { entities } from '$lib/wailsjs/go/models';

	type deletePlugin = (name: string, author: string) => void;
	type toggleDetails = (index: number) => void;

	export let index: number;
	export let plugin: entities.LocalPluginEntity;
	export let toggleDetails: toggleDetails;
	export let deletePlugin: deletePlugin;
</script>

<li id="plugin-{index}" class="block bg-light-brown">
	<div class="flex space-x-4 cursor-pointer" on:click={() => toggleDetails(index)}>
		<p class="w-1/2 p-2">{plugin.base.name}</p>
		<div class="flex w-1/2">
			<p class="w-1/3 p-2">{plugin.base.currentVersion}</p>
			<p class="w-1/3 p-2">{plugin.base.latestVersion}</p>
			{#if plugin.base.currentVersion !== plugin.base.latestVersion}
				<p class="w-1/3 p-2 text-center text-gold hover:bg-gold-transparent">
					<button>Update</button>
				</p>
			{:else }
				<p class="w-1/3 p-2 text-center text-gold">
					<button></button>
				</p>
			{/if}
		</div>
	</div>

	<div id="details-{index}" class="hidden p-4 bg-dark-brown">
		{#if (plugin.base.description === "")}
			<p>No description</p>
		{:else }
			<p>{plugin.base.description}</p>
		{/if}

		<div class="flex justify-end space-x-8 mt-4 mr-4">
			<button class="text-primary p-1 hover:bg-primary-transparent"
							on:click={() => BrowserOpenURL(plugin.base.infoUrl)}>Open website
			</button>
			<button class="text-primary p-1 hover:bg-primary-transparent"
							on:click={() => {deletePlugin(plugin.base.name, plugin.base.author)}}>Delete
			</button>
		</div>
	</div>
</li>