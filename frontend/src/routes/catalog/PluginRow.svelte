<script lang="ts">
	import type { entities } from '$lib/wailsjs/go/models';

	interface Props {
		index: number;
		plugin: entities.RemotePluginEntity;
		openUrl: (url: string) => void;
		installPlugin: (plugin: entities.RemotePluginEntity) => void;
		updatePlugin: () => void;
	}

	let { index, plugin, openUrl, installPlugin, updatePlugin }: Props = $props();
</script>

<li class="block bg-light-brown cursor-pointer" id="plugin-{index}">
	<div class="flex space-x-4">
		<p
			class="w-1/3 p-2"
			onclick={() => {
				openUrl(plugin.base.infoUrl);
			}}
		>
			{plugin.base.name}
		</p>
		<div class="flex w-2/3">
			<p
				class="w-1/5 p-2"
				onclick={() => {
					openUrl(plugin.base.infoUrl);
				}}
			>
				{plugin.base.latestVersion}
			</p>
			<p
				class="w-1/5 p-2"
				onclick={() => {
					openUrl(plugin.base.infoUrl);
				}}
			>
				{plugin.base.author}
			</p>
			<p
				class="w-1/5 p-2"
				onclick={() => {
					openUrl(plugin.base.infoUrl);
				}}
			>
				{plugin.downloads}
			</p>
			<p
				class="w-1/5 p-2"
				onclick={() => {
					openUrl(plugin.base.infoUrl);
				}}
			>
				{plugin.updatedTimestamp}
			</p>
			{#if plugin.isInstalled && plugin.base.latestVersion !== plugin.base.currentVersion}
				<p class="w-1/5 p-2 text-center text-gold hover:bg-gold-transparent" onclick={updatePlugin}>
					Update
				</p>
			{:else if plugin.isInstalled && plugin.base.latestVersion === plugin.base.currentVersion}
				<p class="w-1/5 p-2 text-center">Installed</p>
			{:else}
				<p
					class="w-1/5 p-2 text-center text-gold hover:bg-gold-transparent"
					onclick={() => installPlugin(plugin)}
				>
					Install
				</p>
			{/if}
		</div>
	</div>
</li>
