<script setup lang="ts">
import { X } from '@lucide/vue'

import AddonList from '@/components/AddonList.vue'

import { useCategories, useFilteredList, useRemoveCategory, useSort } from '@/utils.ts'

import { useAddonsStore } from '@/stores/addons.ts'
import Filter from '@/components/Filter.vue'
import Sort from '@/components/BrowserSort.vue'
import { storeToRefs } from 'pinia'
import { onMounted, onUnmounted, ref, watch } from 'vue'
import type { Criteria } from '@/types/criteria.ts'
import { EventsOff, EventsOn } from '@/wailsjs/runtime'
import { main } from '@/wailsjs/go/models.ts'
import AddonMap = main.AddonMap

const { remoteAddons } = storeToRefs(useAddonsStore())
const { setAddons, setRemoteAddons } = useAddonsStore()
const categories = useCategories(remoteAddons)
const { selectedCategories, removeCategory } = useRemoveCategory()
const { sortAddonsByCriteria } = useSort()
const selectedCriteria = ref<Criteria>('Name')

const filteredList = useFilteredList(remoteAddons, selectedCategories)
sortAddonsByCriteria(filteredList, selectedCriteria.value)

onMounted(() => {
    EventsOn('install:success', (addonMap: AddonMap) => {
        setRemoteAddons(addonMap.remoteAddons)
        setAddons(addonMap.localAddons)
        const filteredList = useFilteredList(remoteAddons, selectedCategories)
        sortAddonsByCriteria(filteredList, selectedCriteria.value)
    })
})

onUnmounted(() => {
    EventsOff('install:success')
})

watch(selectedCriteria, (criteria) => {
    sortAddonsByCriteria(filteredList, criteria)
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
        <section class="flex justify-between">
            <div class="flex text-sm items-center">
                <p>{{ filteredList.length }} addons found</p>
            </div>

            <div class="flex items-center justify-end">
                <Sort v-model:selected-criteria="selectedCriteria" />

                <Filter
                    v-model:selected-categories="selectedCategories"
                    v-model:categories="categories"
                />
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
