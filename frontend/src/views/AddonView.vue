<script setup lang="ts">
import {
    ArrowDownToLine,
    ArrowDownZA,
    ArrowUpAZ,
    ChevronDown,
    Funnel,
    RefreshCw,
    X,
} from '@lucide/vue'
import AddonList from '@/components/AddonList.vue'
import { useCategories, useFilteredList, useRemoveCategory, useSort } from '@/utils.ts'
import { useAddonsStore } from '@/stores/addons.ts'

const addonsStore = useAddonsStore()

const { selectedCategories, removeCategory } = useRemoveCategory()

const { sorting, sortAddons } = useSort()
const filteredList = useFilteredList(addonsStore.addons, selectedCategories)
const categories = useCategories(addonsStore.addons)

const reloadAddons = async () => {
    // const newAddons = await GetLocalAddons()
    // localAddonsStore.setAddons(newAddons)
}
</script>

<template>
    <section class="flex flex-col bg-light-brown py-2 px-4 text-gray-300">
        <section class="grid grid-cols-3">
            <div>
                <div class="flex gap-1.5 cursor-pointer hover:bg-light-brown-hover p-2 w-fit">
                    <ArrowDownToLine class="h-5 w-5" />
                    <button class="text-sm cursor-pointer">Update all</button>
                </div>
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

                <UPopover>
                    <UTooltip arrow text="Filter by">
                        <div class="p-2 hover:bg-light-brown-hover cursor-pointer">
                            <Funnel class="h-5 w-5 hover:bg-light-brown-hover" />
                        </div>
                    </UTooltip>

                    <template #content>
                        <div class="flex flex-col gap-4 bg-light-brown-hover p-4 select-none">
                            <div>Filter by</div>
                            <UCollapsible class="flex flex-col w-60">
                                <div class="flex justify-between mb-4 cursor-pointer">
                                    <span>Categories</span>
                                    <ChevronDown />
                                </div>

                                <template #content>
                                    <UCheckboxGroup
                                        :size="'sm'"
                                        v-model="selectedCategories"
                                        :items="categories"
                                        :ui="{ label: 'font-normal', base: 'bg-gray-300' }"
                                    />
                                </template>
                            </UCollapsible>
                        </div>
                    </template>
                </UPopover>

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

    <AddonList :addons="filteredList" />
</template>
