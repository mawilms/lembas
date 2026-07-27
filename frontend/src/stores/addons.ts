import { defineStore } from 'pinia'
import { ref } from 'vue'
import { GetAddons } from '@/wailsjs/go/main/App'
import { useSort } from '@/utils.ts'
import { internal } from '@/wailsjs/go/models.ts'
import ParentAddon = internal.ParentAddon

export const useAddonsStore = defineStore('addons', () => {
    const addons = ref<ParentAddon[]>([])
    const remoteAddons = ref<ParentAddon[]>([])

    const getAddons = async () => {
        if (remoteAddons.value.length > 0) {
            return
        }

        const { sortAddons } = useSort()

        const fetchedLocalAddons = Object.values((await GetAddons()).items)

        addons.value = sortAddons(
            fetchedLocalAddons.filter((value) => value.IsInstalled),
            false
        )
        remoteAddons.value = sortAddons(fetchedLocalAddons, false)
    }

    return { addons, remoteAddons, getAddons }
})
