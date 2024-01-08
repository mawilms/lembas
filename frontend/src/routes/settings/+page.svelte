<script lang="ts">
	import { GetSettings, SaveSettings } from '$lib/wailsjs/go/main/App';
	import { Settings } from '$lib/entities/settings';

	let settings = new Settings('', '', '');

	const getSettings = () => {
		GetSettings().then((result) => {
			settings = new Settings(result.pluginPath, result.dataDirectory, result.infoUrl);
		});
	};

	$: onChange(settings);

	function onChange(settings: Settings) {
		SaveSettings({
			pluginPath: settings.pluginPath,
			dataDirectory: settings.dataDirectory,
			infoUrl: settings.infoUrl
		});
	}

	getSettings();
</script>

<div class="text-left my-4 space-y-4">
	<div class="flex flex-col space-y-2">
		<label for="plugin-path">LotRO directory</label>
		<input
			bind:value={settings.pluginPath}
			class="w-1/2 p-2 text-gold bg-light-brown focus:outline-none"
			id="plugin-path"
			type="text"
		/>
	</div>
	<!--	<div class="flex flex-col space-y-2">-->
	<!--		<label for="data-directory">Lembas directory</label>-->
	<!--		<input class="w-1/2 p-2 text-gold bg-light-brown focus:outline-none" type="text" id="data-directory" disabled-->
	<!--					 bind:value={settings.dataDirectory} />-->
	<!--	</div>-->
	<div class="flex flex-col space-y-2">
		<label for="info-url">Plugin Feed Url</label>
		<input
			bind:value={settings.infoUrl}
			class="w-1/2 p-2 text-gold bg-light-brown focus:outline-none"
			id="info-url"
			type="text"
		/>
	</div>
</div>
