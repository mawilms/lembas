import { defineStore } from 'pinia'
import { ref } from 'vue'
import { GetLocalAddons, GetRemoteAddons } from '@/wailsjs/go/main/App'
import { hasUpdate } from '@/utils/versioning.ts'
import { useSort } from '@/utils.ts'
import { internal, main } from '@/wailsjs/go/models.ts'
import ParentAddon = internal.ParentAddon
import ParentAddonMap = main.ParentAddonMap

export const useAddonsStore = defineStore('addons', () => {
    const addons = ref<ParentAddon[]>([])
    const remoteAddons = ref<ParentAddon[]>([])

    const getAddons = async () => {
        if (remoteAddons.value.length > 0) {
            return
        }

        const { sortAddons } = useSort()

        const fetchedLocalAddons: ParentAddonMap = await GetLocalAddons()
        const fetchedRemoteAddons: ParentAddonMap = await GetRemoteAddons()

        const extendedAddons: ParentAddon[] = Object.values(fetchedLocalAddons.items).map(
            (local) => {
                const remote = fetchedRemoteAddons.items[`${local.Name}_${local.Author}`]

                return {
                    ...local,
                    HasUpdate: remote ? hasUpdate(local, remote) : false,
                }
            }
        )

        const extendedRemoteAddons: ParentAddon[] = Object.values(fetchedRemoteAddons.items).map(
            (remote) => {
                const local = fetchedLocalAddons.items[`${remote.Name}_${remote.Author}`]
                return {
                    ...remote,
                    IsInstalled: !!local,
                    HasUpdate: local ? hasUpdate(local, remote) : false,
                }
            }
        )

        addons.value = sortAddons(extendedAddons, false)
        remoteAddons.value = sortAddons(extendedRemoteAddons, false)
    }

    return { addons, remoteAddons, getAddons }
})
