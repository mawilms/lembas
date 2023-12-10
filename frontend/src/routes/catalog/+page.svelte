<script lang="ts">
    import "../../app.css";
    import {FetchRemotePlugins} from "$lib/wailsjs/go/main/App";
    import {RemotePlugin} from "$lib/models/remotePlugin";

    let plugins: RemotePlugin[] = []

    FetchRemotePlugins().then(result => {
        let tmpArray: RemotePlugin[] = []
        for (let i = 0; i < result.length; i++) {
            const element = result[i]
            tmpArray.push(new RemotePlugin(element.Id, element.Name, element.Author, element.Version, element.UpdatedTimestamp, element.Downloads, element.Category, element.Description, element.FileName, element.Url))
        }

        plugins = tmpArray
    })

    const toggleDetails = (index: number) => {
        let element = document.getElementById(`details-${index}`)
        if (element.classList.contains("hidden")) {
            element.classList.remove("hidden")
        } else {
            element.classList.add("hidden")
        }
    }
</script>

<div class="text-left my-4 space-y-4">
    <div class="flex mx-2 space-x-4">
        <p>Name</p>
        <p>Version</p>
        <p>Author</p>
        <p>Downloads</p>
        <p>Latest Release</p>
        <p>Status</p>
    </div>

    <div>
        <ul class="overflow-y-auto space-y-2 h-96">
            {#each plugins as plugin, index}
                <li id="plugin-{index}" class="bg-light-brown p-2">
                    <div class="flex space-x-4" on:click={() => toggleDetails(index)}>
                        <p>{plugin.name}</p>
                        <p>{plugin.version}</p>
                        <p>{plugin.author}</p>
                        <p>{plugin.totalDownloads}</p>
                        <p>{plugin.lastUpdated}</p>
                        <p>Installed</p>
                    </div>
                    <div id="details-{index}" class="hidden mt-2 p-4 bg-dark-brown">
                        <p>{plugin.description}</p>
                        <div class="flex justify-between mt-4">
                            <a class="bg-primary" href="{plugin.url}">Open website</a>
                            <div class="flex">
                                <button class="bg-primary">Install/Update</button>
                                <button class="bg-primary">Remove</button>
                            </div>
                        </div>
                    </div>
                </li>
            {/each}
        </ul>
    </div>
</div>