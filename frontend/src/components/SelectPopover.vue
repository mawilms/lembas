<script setup lang="ts">
import { ArrowDownToLine, Trash2, X } from '@lucide/vue'
import { useRoute } from 'vue-router'

const props = defineProps<{
    activeRow: number | null
}>()
const emit = defineEmits(['reset-row'])

const route = useRoute()

const forceInstall = () => {}

const uninstall = () => {}

const popupContent = [
    {
        label: 'Reinstall',
        icon: ArrowDownToLine,
        callback: forceInstall,
    },
    {
        label: 'Delete',
        icon: Trash2,
        callback: uninstall,
    },
]
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
                    :key="e.label"
                    v-for="e in popupContent"
                    @click="e.callback"
                    class="flex items-center gap-1 hover:bg-gold py-1 px-2 rounded cursor-pointer"
                >
                    <component :is="e.icon" class="h-4 w-4" />
                    <span>{{ e.label }}</span>
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

<style scoped></style>
