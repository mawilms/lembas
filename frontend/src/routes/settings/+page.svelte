<script lang="ts">
	import { SaveSettings } from '$lib/wailsjs/go/main/App';

	let pluginDirectory = '';
</script>

<div class="text-left my-4">
	<form autocomplete="off" method="POST" class="flex flex-col space-y-8"
				on:submit|preventDefault={() => {SaveSettings(pluginDirectory)}}>
		<div class="flex flex-col space-y-2">
			<label for="lotroPath">Plugin directory</label>
			<input class="w-1/2 py-1 px-2 text-black" type="text" name="" id="lotroPath" bind:value={pluginDirectory} />
		</div>
		<div>
			<button class="bg-primary text-dark-brown py-1 px-8 rounded-xl overflow-hidden">Save</button>
		</div>
	</form>
</div>