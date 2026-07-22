<script setup lang="ts">
import { ArrowDownToLine, ArrowDownZA, ArrowUpAZ, RefreshCw } from '@lucide/vue'
import AddonList from '@/components/addons/AddonList.vue'
import { useFilteredList, useSort, useTotalAddons } from '@/utils.ts'
import { useLocalAddonsStoreNew } from '@/stores/addons.ts'
// import { GetLocalAddons } from '../../wailsjs/go/main/App'

const localAddonsStore = useLocalAddonsStoreNew()

const { sorting, sortAddons } = useSort()
const totalAddons = useTotalAddons(localAddonsStore.addons)
const filteredList = useFilteredList(localAddonsStore.addons)

const reloadAddons = async () => {
    // const newAddons = await GetLocalAddons()
    // localAddonsStore.setAddons(newAddons)
}
</script>

<template>
    <main>
        <section class="grid grid-cols-3 bg-light-brown p-4">
            <div class="flex">
                <div class="flex gap-1.5 cursor-pointer hover:bg-light-brown-hover p-2">
                    <ArrowDownToLine class="h-5 w-5" />
                    <button class="text-sm cursor-pointer">Alles aktualisieren</button>
                </div>
            </div>

            <span class="flex items-center justify-center text-sm"
                >{{ totalAddons }} addons installed</span
            >

            <div class="flex items-center justify-end">
                <div class="p-2 hover:bg-light-brown-hover cursor-pointer">
                    <ArrowUpAZ
                        v-if="sorting == 1"
                        class="h-5 w-5 hover:bg-light-brown-hover"
                        @click="sortAddons(filteredList, true)"
                    />
                    <ArrowDownZA
                        v-else
                        class="h-5 w-5 hover:bg-light-brown-hover"
                        @click="sortAddons(filteredList, true)"
                    />
                </div>

                <div class="p-2 hover:bg-light-brown-hover cursor-pointer">
                    <RefreshCw class="h-5 w-5" @click="reloadAddons" />
                </div>
            </div>
        </section>

        <AddonList class="p-4" :addons="filteredList" />
    </main>
</template>
