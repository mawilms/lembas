<script setup lang="ts">
import { ArrowDownZA, ArrowUpAZ, Funnel } from '@lucide/vue'
import { remote } from '../../wailsjs/go/models.ts'

import { GetNewRemotePlugins } from '../../wailsjs/go/main/App'
import AddonList from '@/components/browse/AddonList.vue'
import { computed, onMounted, ref } from 'vue'
import { useSearchTextStore } from '@/stores/counter.ts'
import RemoteAddon = remote.RemoteAddon

const searchTextStore = useSearchTextStore()

const addons = ref<RemoteAddon[]>([])
const isLoading = ref(true)
const error = ref<string | null>(null)

const sorting = ref<number>(1)

onMounted(async () => {
    try {
        const fetchedAddons = await GetNewRemotePlugins()
        addons.value = sortAddons(fetchedAddons, false)
    } catch (e) {
        console.log(e)
        error.value = 'Error while loading addons'
    } finally {
        isLoading.value = false
    }
})

const totalAddons = computed(() => {
    return addons.value.length
})

const filteredList = computed(() => {
    const text = searchTextStore.searchText.trim().toLowerCase()
    if (!text) return addons.value

    return addons.value.filter((item) => item.Name.toLowerCase().includes(text))
})

const sortAddons = (addons: RemoteAddon[], reverse: boolean) => {
    if (reverse) sorting.value = sorting.value * -1

    return addons.sort((a, b) => sorting.value * a.Name.localeCompare(b.Name))
}
</script>

<template>
    <main class="flex flex-col overflow-hidden">
        <section class="flex justify-between bg-light-brown p-4">
            <div class="flex">
                <p>{{ totalAddons }} addons found</p>
            </div>

            <div class="flex items-center justify-end gap-4">
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

                <Funnel class="h-5 w-5 hover:bg-light-brown-hover" />
            </div>
        </section>

        <div v-if="isLoading">Loading addons...</div>
        <div v-else-if="error">{{ error }}</div>

        <AddonList class="p-4" :addons="filteredList" />
    </main>
</template>
