<script setup lang="ts">
import { ArrowDownToLine, Clock, Computer, HardDrive } from '@lucide/vue'

import { extractFirstLetter } from '@/utils.ts'
import { BrowserOpenURL } from '@/wailsjs/runtime'
import { internal } from '@/wailsjs/go/models.ts'
import Addon = internal.Addon

const props = defineProps<{
    addon: Addon
}>()

const openPluginPage = (id: number) => {
    BrowserOpenURL(`https://www.lotrointerface.com/downloads/info${id}`)
}
</script>

<template>
    <li
        class="flex gap-4 py-4 items-start bg-light-brown hover:bg-light-brown-hover p-4 select-none"
    >
        <div
            class="flex justify-center items-center self-stretch w-22 rounded-lg text-3xl font-bold bg-secondary"
        >
            {{ extractFirstLetter(props.addon.Name) }}
        </div>

        <div class="flex-1 min-w-0">
            <section class="grid grid-cols-10 grid-rows-2">
                <section class="col-span-9 row-span-2 gap-y-2">
                    <div class="flex gap-4 items-center mb-1">
                        <a
                            class="font-bold hover:underline"
                            @click="openPluginPage(props.addon.Id)"
                            >{{ props.addon.Name }}</a
                        >
                        <span class="text-xs text-gray-300">by {{ props.addon.Author }}</span>
                    </div>
                    <slot name="center"></slot>
                </section>

                <section class="row-span-2 text-end">
                    <slot name="status"></slot>
                </section>
            </section>

            <div class="h-[0.1px] bg-gray-500 my-4"></div>

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
