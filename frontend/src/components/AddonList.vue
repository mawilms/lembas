<script setup lang="ts">
import { ref } from 'vue'
import { ArrowDownToLine, Trash2, X } from '@lucide/vue'
import type { ExtendedAddon, ExtendedRemoteAddon } from '@/types/plugin.ts'
import { useRoute } from 'vue-router'

const props = defineProps<{
    addons: ExtendedAddon[] | ExtendedRemoteAddon[]
}>()

const route = useRoute()

const activeRow = ref<number | null>(null)

const resetRow = () => {
    activeRow.value = null
}

const forceInstall = () => {}

const uninstall = () => {}
</script>

<template>
    <ul class="flex flex-col flex-1 gap-4 overflow-y-auto p-4">
        <AddonRow
            class="border cursor-pointer"
            v-for="(addon, index) in props.addons"
            :key="addon.Id"
            :addon="addon"
            :class="{
                'border-primary': activeRow === index,
                'border-transparent': activeRow !== index,
            }"
            @click="activeRow = index"
        >
            <template v-slot:status>
                <div v-if="addon.Type === 'remote'">
                    <p v-if="addon.IsInstalled">Installed</p>
                    <button
                        v-else
                        class="bg-primary hover:bg-gold py-1 px-2 rounded cursor-pointer"
                    >
                        Install
                    </button>
                </div>
                <div v-else>
                    <button
                        class="bg-primary hover:bg-gold py-1 px-2 rounded cursor-pointer"
                        v-if="addon.HasUpdate"
                    >
                        Update
                    </button>
                    <span v-else>Up to date</span>
                </div>
            </template>

            <template v-slot:center>
                <div class="flex min-w-0 flex-1 text-xs text-gray-300">
                    <span v-if="addon.Type === 'local'" class="min-w-0 truncate">{{
                        addon.ArchiveName
                    }}</span>
                    <span v-else class="min-w-0 flex-1 truncate">{{ addon.Description }}</span>
                </div>
            </template>
        </AddonRow>
    </ul>

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
            v-if="activeRow !== null"
            class="fixed bottom-6 left-1/2 -translate-x-1/2 z-50 text-sm"
        >
            <UCard :ui="{ body: 'flex items-center gap-2 bg-light-brown shadow-none' }">
                <span class="text-sm text-white">1 ausgewählt</span>

                <button
                    @click="forceInstall"
                    class="flex items-center gap-2 hover:bg-gold py-1 px-2 rounded cursor-pointer"
                >
                    <ArrowDownToLine class="h-4 w-4" />
                    <span>Reinstall</span>
                </button>

                <button
                    @click="uninstall"
                    class="flex items-center gap-2 hover:bg-gold py-1 px-2 rounded cursor-pointer"
                >
                    <Trash2 class="h-4 w-4" />
                    <span>Delete</span>
                </button>

                <button class="hover:bg-gold py-1 px-2 rounded cursor-pointer" @click="resetRow()">
                    <X class="h-4 w-4" />
                </button>
            </UCard>
        </div>
    </Transition>
</template>
