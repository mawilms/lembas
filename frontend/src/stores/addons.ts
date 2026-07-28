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

    const setAddons = (newAddons: Addon[]) => {
        addons.value = sortAddons(newAddons, false)
    }

    return { addons, setAddons, remoteAddons, getAddons }
})
