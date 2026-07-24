<script setup lang="ts">
import { ArrowDownToLine, Clock, Computer, HardDrive } from '@lucide/vue'

import { extractFirstLetter } from '@/utils.ts'
import type { IAddon } from '@/types/plugin.ts'

const props = defineProps<{
    addon: IAddon
}>()
</script>

<template>
    <li
        class="flex gap-4 py-4 items-start bg-light-brown hover:bg-light-brown-hover p-4 select-none"
    >
        <div
            class="w-16 h-16 rounded-lg shrink-0 flex items-center justify-center text-2xl font-bold bg-secondary"
        >
            {{ extractFirstLetter(props.addon.Name) }}
        </div>

        <div class="flex-1 min-w-0">
            <div class="flex justify-between">
                <div class="flex items-center gap-4">
                    <span class="font-semibold">{{ props.addon.Name }}</span>
                    <span class="text-xs">by {{ props.addon.Author }}</span>
                </div>

                <slot name="status"></slot>
            </div>

            <slot name="center"></slot>

            <div class="h-px bg-gray-300 my-2"></div>

            <div class="flex items-center justify-between text-sm text-gray-300">
                <div>
                    <p>{{ props.addon.Category }}</p>
                </div>

                <section class="flex gap-3.5">
                    <UTooltip arrow text="Downloads">
                        <div class="flex items-center gap-1">
                            <ArrowDownToLine class="w-4 h-4" /> {{ props.addon.Downloads }}
                        </div>
                    </UTooltip>

                    <UTooltip arrow text="Last update">
                        <div class="flex items-center gap-1">
                            <Clock class="w-4 h-4" />
                            {{ props.addon.UpdatedAt }}
                        </div>
                    </UTooltip>

                    <UTooltip arrow text="Archive size">
                        <div class="flex items-center gap-1">
                            <HardDrive class="w-4 h-4" /> {{ props.addon.ArchiveSize }}
                        </div>
                    </UTooltip>

                    <UTooltip arrow text="Current version">
                        <div class="flex items-center gap-1">
                            <Computer class="w-4 h-4" /> {{ props.addon.Version }}
                        </div>
                    </UTooltip>
                </section>
            </div>
        </div>
    </li>
</template>
