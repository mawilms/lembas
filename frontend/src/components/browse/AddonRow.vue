<script setup lang="ts">
import { ArrowDownToLine, Clock, Computer, HardDrive } from '@lucide/vue'

import { extractFirstLetter } from '@/utils.ts'
import type { ExtendedRemoteAddon } from '@/types/plugin.ts'

const props = defineProps<{
    addon: ExtendedRemoteAddon
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

                <p v-if="props.addon.IsInstalled">Installed</p>
                <button v-else class="bg-primary hover:bg-gold py-1 px-2 rounded cursor-pointer">
                    Install
                </button>
            </div>

            <div class="flex text-xs text-gray-300">
                <span>{{ props.addon.File }}</span>
            </div>

            <div class="h-px bg-gray-300 my-2"></div>

            <div class="flex items-center justify-between text-sm text-gray-300">
                <div>
                    <p>{{ props.addon.Category }}</p>
                </div>

                <section class="flex gap-3.5">
                    <div class="flex items-center gap-1">
                        <ArrowDownToLine class="w-4 h-4" /> {{ props.addon.Downloads }}
                    </div>
                    <div class="flex items-center gap-1">
                        <Clock class="w-4 h-4" />
                        {{ props.addon.Updated }}
                    </div>
                    <div class="flex items-center gap-1">
                        <HardDrive class="w-4 h-4" /> {{ props.addon.Size }}
                    </div>
                    <div class="flex items-center gap-1">
                        <Computer class="w-4 h-4" /> {{ props.addon.Version }}
                    </div>
                </section>
            </div>
        </div>
    </li>
</template>
