<script lang="ts">
	import '../app.css';
	import { setContext } from 'svelte';

	let pluginRelationship = new Map<string, string>();

	setContext("relationship", pluginRelationship)
</script>

<main class="h-full">
	<nav class="flex justify-between items-center bg-light-brown py-4 px-8">
		<div class="flex space-x-8 items-center">
			<h1>Lembas</h1>
			<ul class="flex border-solid border-1 border-primary rounded-xl overflow-hidden">
				<li>
					<a class="block text-primary active:bg-primary-transparent hover:bg-primary-transparent py-2 px-2"
						 href="/">My Plugins</a></li>
				<li>
					<a class="block text-primary active:bg-primary-transparent hover:bg-primary-transparent py-2 px-2"
						 href="/catalog">Catalog</a></li>
			</ul>
		</div>
		<div>
			<ul class="flex border-solid border-1 border-primary rounded-xl overflow-hidden">
				<li><a class="block text-primary active:bg-primary-transparent hover:bg-primary-transparent py-2 px-2" href="#">About</a>
				</li>
				<li><a class="block text-primary active:bg-primary-transparent hover:bg-primary-transparent py-2 px-2"
							 href="/settings">Settings</a></li>
			</ul>
		</div>
	</nav>

	<div class="absolute mt-20 top-0 right-0 left-0 bottom-0 p-4">
		<slot />
	</div>

</main>
<!--absolute left-0 top-0 right-0 bottom-0 mt-20 p-4 overflow-hidden-->