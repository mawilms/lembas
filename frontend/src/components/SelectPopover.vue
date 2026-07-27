<script setup lang="ts">
import { ArrowDownToLine, Trash2, X } from '@lucide/vue'
import { useRoute } from 'vue-router'
import { DeleteAddon, InstallAddon } from '@/wailsjs/go/main/App'
import { internal } from '@/wailsjs/go/models.ts'
import ParentAddon = internal.ParentAddon

const props = defineProps<{
    activeRow: number | null
    addon: ParentAddon
}>()
const emit = defineEmits(['reset-row'])

const route = useRoute()
</script>

<template>
    <Transition
        v-if="route.fullPath === '/'"
        enter-active-class="transition duration-200 ease-out"
        enter-from-class="opacity-0 translate-y-4"
        enter-to-class="opacity-100 translate-y-0"
        leave-active-class="transition duration-150 ease-in"
        leave-from-class="opacity-100 translate-y-0"
        leave-to-class="opacity-0 translate-y-4"
    >
        <div
            v-if="props.activeRow !== null"
            class="fixed bottom-6 left-1/2 -translate-x-1/2 z-50 text-sm"
        >
            <UCard
                class="ring-0"
                :ui="{ body: 'flex items-center gap-1 bg-light-brown shadow-none p-2 sm:p-2' }"
            >
                <span class="text-sm text-white">1 ausgewählt</span>

                <button
                    @click="async () => await InstallAddon(addon.Id, false)"
                    class="flex items-center gap-1 hover:bg-gold py-1 px-2 rounded cursor-pointer"
                >
                    <ArrowDownToLine class="h-4 w-4" />
                    <span>Reinstall</span>
                </button>

                <button
                    @click="async () => await DeleteAddon(addon.Id)"
                    class="flex items-center gap-1 hover:bg-gold py-1 px-2 rounded cursor-pointer"
                >
                    <Trash2 class="h-4 w-4" />
                    <span>Delete</span>
                </button>

                <button
                    class="hover:bg-gold py-1 px-2 rounded cursor-pointer"
                    @click="emit('reset-row')"
                >
                    <X class="h-4 w-4" />
                </button>
            </UCard>
        </div>
    </Transition>
</template>
