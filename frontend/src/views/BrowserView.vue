<script setup lang="ts">
import { ArrowDownZA, ArrowUpAZ, X } from '@lucide/vue'

import AddonList from '@/components/AddonList.vue'

import { useCategories, useFilteredList, useRemoveCategory, useSort } from '@/utils.ts'

import { useAddonsStore } from '@/stores/addons.ts'
import Filter from '@/components/Filter.vue'
import { storeToRefs } from 'pinia'
import { ref } from 'vue'

const { remoteAddons } = storeToRefs(useAddonsStore())
const categories = useCategories(remoteAddons)
const { selectedCategories, removeCategory } = useRemoveCategory()

const { sorting, sortAddons } = useSort()
const filteredList = useFilteredList(remoteAddons, selectedCategories)

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
                <UTooltip arrow text="Sort">
                    <div class="p-2 hover:bg-light-brown-hover cursor-pointer"
                         @click="sortAddons(filteredList, true)">
                        <ArrowUpAZ
                            v-if="sorting == 1"
                            class="h-5 w-5 hover:bg-light-brown-hover"

                        />
                        <ArrowDownZA
                            v-else
                            class="h-5 w-5 hover:bg-light-brown-hover"
                        />
                    </div>
                </UTooltip>

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
