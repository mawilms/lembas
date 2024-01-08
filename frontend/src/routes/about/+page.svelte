<script lang="ts">
	import { BrowserOpenURL } from '$lib/wailsjs/runtime';
</script>

<div class="flex flex-col items-center space-y-8 mx-64">
	<h1 class="text-lg text-gold">Welcome to Lembas</h1>
	<p class="text-left">
		Lembas is a completely free project that tries to make the plugin install process in LotRO as
		easy as possible.\n It's open source and shouldn't be used commercialized in any way. The
		project is heavily inspired by <span
			class="text-gold cursor-pointer"
			on:click={() => {
				BrowserOpenURL('https://github.com/ajour/ajour');
			}}>Ajour</span
		>
		which is, in my opinion, the best addon manager for WoW which was ever built.
	</p>
	<button
		class="border-solid border-1 border-primary rounded-xl overflow-hidden p-2 text-primary w-fit"
		on:click={() => {
			BrowserOpenURL('https://github.com/mawilms/lembas');
		}}
		>Website
	</button>
</div>
