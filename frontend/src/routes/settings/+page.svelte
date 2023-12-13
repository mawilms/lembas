<script lang="ts">
	import { SaveSettings } from '$lib/wailsjs/go/main/App';

	// TODO Load settings functionality

	let pluginDirectory = 'Hiiiiilfe';
</script>

<div class="text-left my-4">
	<div class="flex flex-col space-y-2">
		<input class="w-1/2 p-2 text-gold bg-light-brown focus:outline-none" type="text" id="lotroPath" bind:value={pluginDirectory}
					 on:change={() => {SaveSettings(pluginDirectory)}} />
	</div>
</div>