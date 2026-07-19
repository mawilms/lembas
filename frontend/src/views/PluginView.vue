<script setup lang="ts">
import AddonList from '@/components/plugins/AddonList.vue'
import { ArrowDownToLine, ArrowUpAZ, RefreshCw } from '@lucide/vue'
import { entities } from '../../wailsjs/go/models.ts'

// import { GetInstalledPlugins } from '../../wailsjs/go/main/App'

const addons: entities.LocalPluginEntity[] = []
</script>

<template>
    <main>
        <section class="grid grid-cols-3 bg-light-brown p-4">
            <div class="flex">
                <div class="flex gap-1.5 cursor-pointer hover:bg-light-brown-hover p-2">
                    <ArrowDownToLine class="h-5 w-5" />
                    <button class="text-sm cursor-pointer">Alles aktualisieren</button>
                </div>
                <div class="flex gap-1.5 cursor-pointer hover:bg-light-brown-hover p-2">
                    <RefreshCw class="h-5 w-5" />
                    <button class="text-sm cursor-pointer">Synchronisieren</button>
                </div>
            </div>

            <span class="flex items-center justify-center text-sm">2 addons installed</span>

            <div class="flex items-center justify-end">
                <ArrowUpAZ class="h-5 w-5" />
            </div>
        </section>

        <AddonList class="p-4" :addons="addons" />
    </main>
</template>
