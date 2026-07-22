<script setup lang="ts">
import { ArrowDownZA, ArrowUpAZ } from '@lucide/vue'

import AddonList from '@/components/browse/AddonList.vue'

import { useFilteredList, useSort, useTotalAddons } from '@/utils.ts'

import { useRemoteAddonsStore } from '@/stores/addons.ts'

const remoteAddonsStore = useRemoteAddonsStore()

const { sorting, sortAddons } = useSort()
const totalAddons = useTotalAddons(remoteAddonsStore.addons)
const filteredList = useFilteredList(remoteAddonsStore.addons)
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
            </div>
        </section>

        <AddonList class="p-4" :addons="filteredList" />
    </main>
</template>
