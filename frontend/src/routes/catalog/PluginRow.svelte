<script lang="ts">
	import type { entities } from '$lib/wailsjs/go/models';

	export let index: number;
	export let plugin: entities.RemotePluginEntity;
	export let openUrl: (url: string) => void;
	export let installPlugin: (plugin: entities.RemotePluginEntity) => void;
	export let updatePlugin: () => void;
</script>

<li class="block bg-light-brown cursor-pointer" id="plugin-{index}">
	<div class="flex space-x-4">
		<p
			class="w-1/3 p-2"
			on:click={() => {
				openUrl(plugin.base.infoUrl);
			}}
		>
			{plugin.base.name}
		</p>
		<div class="flex w-2/3">
			<p
				class="w-1/5 p-2"
				on:click={() => {
					openUrl(plugin.base.infoUrl);
				}}
			>
				{plugin.base.latestVersion}
			</p>
			<p
				class="w-1/5 p-2"
				on:click={() => {
					openUrl(plugin.base.infoUrl);
				}}
			>
				{plugin.base.author}
			</p>
			<p
				class="w-1/5 p-2"
				on:click={() => {
					openUrl(plugin.base.infoUrl);
				}}
			>
				{plugin.downloads}
			</p>
			<p
				class="w-1/5 p-2"
				on:click={() => {
					openUrl(plugin.base.infoUrl);
				}}
			>
				{plugin.updatedTimestamp}
			</p>
			{#if plugin.isInstalled && plugin.base.latestVersion !== plugin.base.currentVersion}
				<p
					class="w-1/5 p-2 text-center text-gold hover:bg-gold-transparent"
					on:click={updatePlugin}
				>
					Update
				</p>
			{:else if plugin.isInstalled && plugin.base.latestVersion === plugin.base.currentVersion}
				<p class="w-1/5 p-2 text-center">Installed</p>
			{:else}
				<p
					class="w-1/5 p-2 text-center text-gold hover:bg-gold-transparent"
					on:click={() => installPlugin(plugin)}
				>
					Install
				</p>
			{/if}
		</div>
	</div>
</li>
