<script lang="ts">
	import '../app.css';
	interface Props {
		children?: import('svelte').Snippet;
	}

	let { children }: Props = $props();

	let pluginsTabActive = $state(false);
	let plugins_tab_active_class = $derived(pluginsTabActive ? 'bg-primary-transparent' : '');

	let catalogTabActive = $state(false);
	let catalog_tab_active_class = $derived(catalogTabActive ? 'bg-primary-transparent' : '');

	let aboutTabActive = $state(false);
	let about_tab_active_class = $derived(aboutTabActive ? 'bg-primary-transparent' : '');

	let settingsTabActive = $state(false);
	let settings_tab_active_class = $derived(settingsTabActive ? 'bg-primary-transparent' : '');

	const togglePluginsTab = () => {
		if (catalogTabActive) {
			catalogTabActive = false;
		}
		if (settingsTabActive) {
			settingsTabActive = false;
		}
		if (aboutTabActive) {
			aboutTabActive = false;
		}

		if (!pluginsTabActive) {
			pluginsTabActive = !pluginsTabActive;
		}
	};

	const toggleCatalogTab = () => {
		if (pluginsTabActive) {
			pluginsTabActive = !pluginsTabActive;
		}
		if (settingsTabActive) {
			settingsTabActive = !settingsTabActive;
		}
		if (aboutTabActive) {
			aboutTabActive = !aboutTabActive;
		}

		if (!catalogTabActive) {
			catalogTabActive = !catalogTabActive;
		}
	};

	const toggleAboutTab = () => {
		if (pluginsTabActive) {
			pluginsTabActive = !pluginsTabActive;
		}
		if (catalogTabActive) {
			catalogTabActive = !catalogTabActive;
		}
		if (settingsTabActive) {
			settingsTabActive = !settingsTabActive;
		}

		if (!aboutTabActive) {
			aboutTabActive = !aboutTabActive;
		}
	};

	const toggleSettingsTab = () => {
		if (pluginsTabActive) {
			pluginsTabActive = !pluginsTabActive;
		}
		if (catalogTabActive) {
			catalogTabActive = !catalogTabActive;
		}
		if (aboutTabActive) {
			aboutTabActive = !aboutTabActive;
		}

		if (!settingsTabActive) {
			settingsTabActive = !settingsTabActive;
		}
	};
</script>

<main class="h-full">
	<nav class="flex justify-between items-center bg-light-brown py-4 px-8 h-20">
		<div class="flex space-x-8 items-center">
			<div>
				<img class="h-12 w-12" src="./logo.png" alt="Lembas Logo">
			</div>
			<ul class="flex border-solid border-1 border-primary rounded-xl overflow-hidden">
				<li>
					<a
						class:pluginsTabActive
						class="block text-primary hover:bg-primary-transparent p-2 {plugins_tab_active_class}"
						href="/"
						onclick={togglePluginsTab}>My Plugins</a
					>
				</li>
				<li>
					<a
						class:catalogTabActive
						class="block text-primary hover:bg-primary-transparent p-2 {catalog_tab_active_class}"
						href="/catalog"
						onclick={toggleCatalogTab}>Catalog</a
					>
				</li>
			</ul>
		</div>
		<div>
			<ul class="flex border-solid border-1 border-primary rounded-xl overflow-hidden">
				<li>
					<a
						class:aboutTabActive
						class="block text-primary hover:bg-primary-transparent p-2 {about_tab_active_class}"
						href="/about"
						onclick={toggleAboutTab}>About</a
					>
				</li>
				<li>
					<a
						class:settingsTabActive
						class="block text-primary hover:bg-primary-transparent p-2 {settings_tab_active_class}"
						href="/settings"
						onclick={toggleSettingsTab}>Settings</a
					>
				</li>
			</ul>
		</div>
	</nav>

	<div class="absolute mt-20 top-0 right-0 left-0 bottom-0 p-4">
		{@render children?.()}
	</div>
</main>
