<script setup lang="ts">
import { Clock, Computer, HardDrive } from '@lucide/vue'
import { extractFirstLetter } from '@/utils.ts'
import type { ExtendedAddon } from '@/types/plugin.ts'

const props = defineProps<{
    addon: ExtendedAddon
}>()
</script>

<template>
    <li class="flex gap-4 py-4 items-start bg-light-brown hover:bg-light-brown-hover p-4">
        <div
            class="w-16 h-16 rounded-lg shrink-0 flex items-center justify-center text-2xl font-bold bg-secondary"
        >
            {{ extractFirstLetter(props.addon.Name) }}
        </div>

        <div class="flex-1">
            <div class="flex justify-between">
                <div class="flex items-center gap-4">
                    <span class="font-semibold">{{ props.addon.Name }}</span>
                    <span class="text-xs">by {{ props.addon.Author }}</span>
                </div>

                <div>
                    <button
                        class="bg-primary hover:bg-gold py-1 px-2 rounded cursor-pointer"
                        v-if="props.addon.HasUpdate"
                    >
                        Update
                    </button>
                    <span v-else>Up to date</span>
                </div>
            </div>

            <div class="flex text-xs text-gray-300">
                <span>{{ props.addon.ArchiveName }}</span>
            </div>

            <div class="flex items-center justify-end gap-3.5 text-sm">
                <div class="flex items-center gap-1">
                    <Clock class="w-4 h-4" /> {{ props.addon.UpdatedAt }}
                </div>
                <div class="flex items-center gap-1">
                    <HardDrive class="w-4 h-4" />
                    {{ props.addon.ArchiveSize }}
                </div>
                <div class="flex items-center gap-1">
                    <Computer class="w-4 h-4" /> {{ props.addon.Version }}
                </div>
            </div>
        </div>
    </li>
</template>
