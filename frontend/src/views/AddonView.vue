<script setup lang="ts">
import { ArrowDownToLine, ArrowDownZA, ArrowUpAZ, RefreshCw, X } from '@lucide/vue'
import AddonList from '@/components/AddonList.vue'
import Filter from '@/components/Filter.vue'
import { useCategories, useFilteredList, useRemoveCategory, useSort } from '@/utils.ts'
import { useAddonsStore } from '@/stores/addons.ts'
import { storeToRefs } from 'pinia'
import { computed, onMounted, onUnmounted, ref } from 'vue'
import { EventsOff, EventsOn } from '@/wailsjs/runtime/runtime'
import { main } from '@/wailsjs/go/models.ts'
import AddonMap = main.AddonMap

const { addons } = storeToRefs(useAddonsStore())
const { setAddons, setRemoteAddons } = useAddonsStore()

const categories = useCategories(addons)
const { selectedCategories, removeCategory } = useRemoveCategory()

const { sorting, sortAddons } = useSort()
const filteredList = useFilteredList(addons, selectedCategories)

const { getAddons } = useAddonsStore()

onMounted(() => {
    EventsOn('delete:success', (addonMap: AddonMap) => {
        setAddons(addonMap.localAddons)
        setRemoteAddons(addonMap.remoteAddons)
        resetRow()
    })
})

onUnmounted(() => {
    EventsOff('delete:success')
})

const reloadAddons = async () => {
    // const newAddons = await GetLocalAddons(true)
    // setAddons(newAddons.localAddons)
    // setRemoteAddons(newAddons.remoteAddons)
    await getAddons(true)
}

const amountUpdates = computed(() => {
    return addons.value.filter((addon) => addon.hasUpdate == true).length
})

const activeRow = ref<number | null>(null)

const setActiveRow = (index: number) => {
    activeRow.value = index
}

const resetRow = () => {
    activeRow.value = null
}
</script>

<template>
    <section class="flex flex-col bg-light-brown py-2 px-4 text-gray-300">
        <section class="grid grid-cols-3">
            <div>
                <UChip
                    :text="amountUpdates"
                    :show="amountUpdates > 0"
                    :ui="{
                        base: 'text-sm bg-primary p-2 border-none ring-0',
                    }"
                >
                    <div class="flex gap-1.5 cursor-pointer hover:bg-light-brown-hover p-2 w-fit">
                        <ArrowDownToLine class="h-5 w-5" />
                        <button class="text-sm cursor-pointer">Update all</button>
                    </div>
                </UChip>
            </div>

            <span class="flex items-center justify-center text-sm"
                >{{ filteredList.length }} addons installed</span
            >

            <div class="flex items-center justify-end">
                <UTooltip arrow text="Sort">
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
                </UTooltip>

                <Filter
                    v-model:selected-categories="selectedCategories"
                    v-model:categories="categories"
                />

                <UTooltip arrow text="Synchronize">
                    <div class="p-2 hover:bg-light-brown-hover cursor-pointer">
                        <RefreshCw class="h-5 w-5" @click="reloadAddons" />
                    </div>
                </UTooltip>
            </div>
        </section>

        <section>
            <ul class="flex gap-4 text-xs">
                <li
                    :key="v"
                    v-for="v in selectedCategories"
                    class="flex items-center gap-1 bg-light-brown-hover p-1"
                >
                    <span>{{ v }}</span>
                    <X class="h-3 w-3 cursor-pointer" @click="removeCategory(v)" />
                </li>
            </ul>
        </section>
    </section>

    <AddonList
        :activeRow="activeRow"
        @setActiveRow="setActiveRow"
        @resetRow="resetRow"
        :addons="filteredList"
    />
</template>
