<script setup lang="ts">
import { ArrowDownZA, ArrowUpAZ, ChevronDown, Funnel } from '@lucide/vue'

import AddonList from '@/components/browse/AddonList.vue'

import { useFilteredList, useSort, useTotalAddons } from '@/utils.ts'

import { useRemoteAddonsStore } from '@/stores/addons.ts'
import { computed, ref } from 'vue'

const remoteAddonsStore = useRemoteAddonsStore()

const { sorting, sortAddons } = useSort()
const totalAddons = useTotalAddons(remoteAddonsStore.addons)
const filteredList = useFilteredList(remoteAddonsStore.addons)

const categories = computed(() => {
    return [
        ...new Set(
            remoteAddonsStore.addons.map((a) => {
                return a.Category
            })
        ),
    ]
})

const items = ref(categories)
const value = ref([])
</script>

<template>
    <main class="flex flex-col overflow-hidden">
        <section class="flex justify-between bg-light-brown p-4 text-gray-300">
            <div class="flex text-sm items-center">
                <p>{{ totalAddons }} addons found</p>
            </div>

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

                <UPopover>
                    <div class="p-2 hover:bg-light-brown-hover cursor-pointer">
                        <Funnel class="h-5 w-5 hover:bg-light-brown-hover" />
                    </div>

                    <template #content>
                        <div class="flex flex-col gap-4 bg-light-brown-hover p-4">
                            <div>Filter by</div>
                            <UCollapsible class="flex flex-col w-60">
                                <div class="flex justify-between mb-4">
                                    <span>Categories</span>
                                    <ChevronDown />
                                </div>

                                <template #content>
                                    <UCheckboxGroup
                                        :size="'sm'"
                                        v-model="value"
                                        :items="items"
                                        :ui="{ label: 'font-normal', base: 'bg-gray-300' }"
                                    />
                                </template>
                            </UCollapsible>
                        </div>
                    </template>
                </UPopover>
            </div>
        </section>

        <AddonList class="p-4" :addons="filteredList" />
    </main>
</template>
