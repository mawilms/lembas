import { defineStore } from 'pinia'
import { ref } from 'vue'
import { database, remote } from '../../wailsjs/go/models.ts'
import Addon = database.Addon
import RemoteAddon = remote.RemoteAddon
import type { ExtendedAddon } from '@/types/plugin.ts'

export const useLocalAddonsStoreNew = defineStore('localAddons', () => {
    const addons = ref<ExtendedAddon[]>([])

    function setAddons(newAddons: ExtendedAddon[]) {
        addons.value = newAddons
    }

    return { addons, setAddons }
})

export const useLocalAddonsStore = defineStore('localAddons', () => {
    const addons = ref<Addon[]>([])

    function setAddons(newAddons: Addon[]) {
        addons.value = newAddons
    }

    return { addons, setAddons }
})

export const useRemoteAddonsStore = defineStore('remoteAddons', () => {
    const addons = ref<RemoteAddon[]>([])

    function setAddons(newAddons: RemoteAddon[]) {
        addons.value = newAddons
    }

    return { addons, setAddons }
})
