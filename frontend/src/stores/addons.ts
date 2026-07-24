import { defineStore } from 'pinia'
import { ref } from 'vue'
import type { ExtendedAddon, ExtendedRemoteAddon } from '@/types/plugin.ts'
import { GetLocalAddons, GetRemoteAddons } from '@/wailsjs/go/main/App'
import { buildAddonsMap, hasUpdate } from '@/utils/versioning.ts'
import { useSort } from '@/utils.ts'

export const useAddonsStore = defineStore('addons', () => {
    const addons = ref<ExtendedAddon[]>([])
    const remoteAddons = ref<ExtendedRemoteAddon[]>([])

    function setAddons(newAddons: ExtendedAddon[]) {
        addons.value = newAddons
    }

    async function getAddons() {
        if (remoteAddons.value.length > 0) {
            return
        }

        const { sortAddons } = useSort()

        const fetchedLocalAddons = await GetLocalAddons()
        const fetchedLocalAddonsMap = buildAddonsMap(fetchedLocalAddons)

        const fetchedRemoteAddons = await GetRemoteAddons()
        const fetchedRemoteAddonsMap = buildAddonsMap(fetchedRemoteAddons)

        const extendedAddons: ExtendedAddon[] = fetchedLocalAddons.map((addon) => {
            const remote = fetchedRemoteAddonsMap.get(addon.Id)

            return {
                ...addon,
                HasUpdate: remote ? hasUpdate(addon, remote) : false,
                Type: 'local',
            }
        })

        const extendedRemoteAddons: ExtendedRemoteAddon[] = fetchedRemoteAddons.map((remote) => {
            const local = fetchedLocalAddonsMap.get(remote.Id)
            return {
                ...remote,
                IsInstalled: !!local,
                HasUpdate: local ? hasUpdate(local, remote) : false,
                Type: 'remote',
            }
        })

        addons.value = sortAddons(extendedAddons, false)
        remoteAddons.value = sortAddons(extendedRemoteAddons, false)
    }

    return { addons, remoteAddons, setAddons, getAddons }
})
