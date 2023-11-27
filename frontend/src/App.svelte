<script lang="ts">
    import {Greet} from '../wailsjs/go/main/App.js'
    import Plugins from "./pages/Plugins.svelte";

    let resultText: string = "Please enter your name below 👇"
    let name: string

    function greet(): void {
        Greet(name).then(result => resultText = result)
    }
</script>

<main class="h-screen overflow-hidden">
    <nav class="flex justify-between bg-light-brown py-4 px-8">
        <div class="flex space-x-8 items-center">
            <h1>Lembas</h1>
            <ul class="flex border-solid border-2 border-primary rounded-xl overflow-hidden">
                <li><a class="block text-primary active:bg-primary-transparent hover:bg-primary-transparent py-2 px-4"
                       href="#">My Plugins</a></li>
                <li><a class="block text-primary active:bg-primary-transparent hover:bg-primary-transparent py-2 px-4"
                       href="#">Catalog</a></li>
            </ul>
        </div>
        <div>
            <ul class="flex space-x-4 border-solid border-2 border-primary rounded-xl overflow-hidden">
                <li><a class="block text-primary  py-2 px-4" href="#">About</a></li>
                <li><a class="block text-primary  py-2 px-4" href="#">Settings</a></li>
            </ul>
        </div>
    </nav>

    <div class="px-8">
        <Plugins/>
    </div>
</main>