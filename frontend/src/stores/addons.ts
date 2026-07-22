import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { ExtendedAddon, ExtendedRemoteAddon } from '@/types/plugin.ts'

export const useLocalAddonsStore = defineStore('localAddons', () => {
    const addons = ref<ExtendedAddon[]>([])

    function setAddons(newAddons: ExtendedAddon[]) {
        addons.value = newAddons
    }

    return { addons, setAddons }
})

export const useRemoteAddonsStore = defineStore('remoteAddons', () => {
    const addons = ref<ExtendedRemoteAddon[]>([])

    function setAddons(newAddons: ExtendedRemoteAddon[]) {
        addons.value = newAddons
    }

    return { addons, setAddons }
})
