<script>
    import {Plugin} from "../lib/plugin";
    import ProgressBar from "../components/Progressbar.svelte";
    import "../app.css";

    const plugins = [
        new Plugin("RaidGuy", "1.90", "1.90"),
        new Plugin("Potions", "1.00", "1.02"),
    ]


    const refreshPage = () => {
        console.log("Refresh")
    }

    const updateAll = () => {
        console.log("Update all")
    }
</script>


<div class="my-4">
    <div class="flex">
        <div class="flex w-3/4">
            <div class="flex space-x-2">
                <button class="text-primary active:bg-primary-transparent hover:bg-primary-transparent py-1 px-4"
                        on:click={refreshPage}>Refresh
                </button>
                <button class="text-primary active:bg-primary-transparent hover:bg-primary-transparent py-1 px-4"
                        on:click={updateAll}>Update all
                </button>
            </div>
            <p class="ml-24 py-2 px-4">2 plugins installed</p>
        </div>
        <input class="grow py-2 px-4 text-black" type="text" placeholder="Search for a plugin...">
    </div>
</div>

<div class="flex text-left mx-2">
    <p class="w-1/3">Plugin</p>
    <p class="w-1/3">Current Version</p>
    <p class="w-1/4">Latest Version</p>
    <p class="w-1/4">Update</p>
</div>

<div class="text-left mt-2">
    <ul class="overflow-y-auto space-y-2 h-96">
        {#each plugins as plugin}
            <li class="flex bg-light-brown p-2">
                <p class="w-1/3">{plugin.name}</p>
                <p class="w-1/3">{plugin.currentVersion}</p>
                <p class="w-1/4">{plugin.latestVersion}</p>
                <p class="w-1/4">
                    {#if plugin.currentVersion < plugin.latestVersion}
                        <button>Update</button>
                    {/if}
                </p>
            </li>
        {/each}
    </ul>
</div>

<ProgressBar/>
