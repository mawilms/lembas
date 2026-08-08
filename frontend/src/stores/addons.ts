import { defineStore } from 'pinia'
import { ref } from 'vue'
import { GetAddons } from '@/wailsjs/go/main/App'
import { useSort } from '@/utils.ts'
import { internal } from '@/wailsjs/go/models.ts'
import Addon = internal.Addon

export const useAddonsStore = defineStore('addons', () => {
    const addons = ref<Addon[]>([])
    const remoteAddons = ref<Addon[]>([])

    const { sortAddons } = useSort()

    const getAddons = async () => {
        if (remoteAddons.value.length > 0) {
            return
        }

        const fetchedAddons = await GetAddons()

        addons.value = sortAddons(Object.values(fetchedAddons.localAddons), false)
        remoteAddons.value = sortAddons(Object.values(fetchedAddons.remoteAddons), false)
    }

    const setAddons = (newAddons: Record<number, Addon>) => {
        addons.value = sortAddons(Object.values(newAddons), false)
    }

    const setRemoteAddons = (newAddons: Record<number, Addon>) => {
        remoteAddons.value = sortAddons(Object.values(newAddons), false)
    }

    return { addons, remoteAddons, setAddons, setRemoteAddons, getAddons }
})
