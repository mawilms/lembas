<script setup lang="ts">
import { Computer } from '@lucide/vue'

const props = defineProps({
    addon: {
        type: Object,
        required: true,
    },
})

const extractFirstLetter = () => {
    return props.addon.base.name.substring(0, 1)
}
</script>

<template>
    <li class="flex gap-4 py-4 items-start bg-light-brown hover:bg-light-brown-hover p-4">
        <!--        TODO: Icon wenn in .plugin Datei existent ansonsten Fallback -> Erster Buchstabe des Addons-->
        <div
            class="w-16 h-16 rounded-lg shrink-0 flex items-center justify-center text-2xl font-bold"
        >
            {{ extractFirstLetter() }}
        </div>

        <div class="flex-1">
            <div class="flex justify-between">
                <div class="flex items-center gap-4">
                    <span class="font-semibold">{{ props.addon.base.name }}</span>
                    <span class="text-xs">by {{ props.addon.base.author }}</span>
                </div>

                <div>
                    <button
                        class="bg-primary hover:bg-gold py-1 px-2 rounded cursor-pointer"
                        v-if="props.addon.base.currentVersion !== props.addon.base.latestVersion"
                    >
                        Update
                    </button>
                    <span v-else>Up to date</span>
                </div>
            </div>

            <div class="flex text-xs text-gray-300">
                <span>hello_world.zip</span>
            </div>

            <div class="flex items-center justify-end gap-3.5 text-sm">
                <!--                <div class="flex items-center gap-1">-->
                <!--                    <Clock class="w-4 h-4" /> {{ props.addon.updatedAgo }}-->
                <!--                </div>-->
                <!--                <div class="flex items-center gap-1">-->
                <!--                    <HardDrive class="w-4 h-4" /> {{ props.addon.size }}-->
                <!--                </div>-->
                <div class="flex items-center gap-1">
                    <Computer class="w-4 h-4" /> {{ props.addon.base.currentVersion }}
                </div>
            </div>
        </div>
    </li>
</template>
