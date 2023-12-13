<script lang="ts">
    import "../../app.css";
    import {FetchRemotePlugins, InstallPlugin} from "$lib/wailsjs/go/main/App";
    import {BrowserOpenURL} from "$lib/wailsjs/runtime/runtime"
    import {RemotePlugin} from "$lib/models/remotePlugin";

    let plugins: RemotePlugin[] = []

    FetchRemotePlugins().then(result => {
        let tmpArray: RemotePlugin[] = []
        for (let i = 0; i < result.length; i++) {
            const element = result[i]
            const time = new Date(element.UpdatedTimestamp * 1000).toLocaleDateString()
            const infoUrl = `https://www.lotrointerface.com/downloads/info${element.Id}-${element.Name}.html`

            tmpArray.push(new RemotePlugin(element.Id, element.Name, element.Author, element.Version, time, element.Downloads, element.Category, element.Description, element.FileName, infoUrl, element.Url))
        }

        plugins = tmpArray
    })

    const toggleDetails = (index: number) => {
        let element = document.getElementById(`details-${index}`)!
        if (element.classList.contains("hidden")) {
            element.classList.remove("hidden")
        } else {
            element.classList.add("hidden")
        }
    }

    const openUrl = (url: string) => {
        BrowserOpenURL(url)
    }
</script>

<div class="text-left my-4 space-y-4">
    <div class="flex mx-2 space-x-4">
        <p class="w-1/3">Name</p>
        <div class="flex w-2/3">
        <p class="w-1/5">Version</p>
        <p class="w-1/5">Author</p>
        <p class="w-1/5">Downloads</p>
        <p class="w-1/5">Latest Release</p>
        <p class="w-1/5 text-center">Status</p>
        </div>
    </div>

    <div>
        <ul class="space-y-2 h-96">
            {#each plugins as plugin, index}
                <li id="plugin-{index}" class="bg-light-brown p-2">
                    <div class="flex space-x-4" on:click={() => toggleDetails(index)}>
                        <p class="w-1/3">{plugin.name}</p>
                        <div class="flex w-2/3">
                        <p class="w-1/5">{plugin.version}</p>
                        <p class="w-1/5">{plugin.author}</p>
                        <p class="w-1/5">{plugin.totalDownloads}</p>
                        <p class="w-1/5">{plugin.lastUpdated}</p>
                        <p class="w-1/5 text-center text-gold">Installed</p>
                        </div>
                    </div>
                    <div id="details-{index}" class="hidden mt-2 p-4 bg-dark-brown">
                        <p>{plugin.description}</p>
                        <div class="flex justify-between mt-4">
                            <button class="bg-primary text-dark-brown py-1 px-2 rounded-xl overflow-hidden" on:click={() => openUrl(plugin.url)}>Open website</button>
                            <div class="flex space-x-4">
                                <button class="bg-primary text-dark-brown py-1 px-2 rounded-xl overflow-hidden" on:click={() => InstallPlugin(plugin.downloadUrl)}>Install/Update</button>
                                <button class="bg-primary text-dark-brown py-1 px-2 rounded-xl overflow-hidden">Remove</button>
                            </div>
                        </div>
                    </div>
                </li>
            {/each}
        </ul>
    </div>
</div>