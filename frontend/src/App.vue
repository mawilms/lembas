<script setup lang="ts">
import { RouterView } from 'vue-router'
import Header from '@/components/Header.vue'
import { onMounted, ref } from 'vue'
import { GetLocalAddons, GetRemoteAddons } from '../wailsjs/go/main/App'
import { useLocalAddonsStore, useRemoteAddonsStore } from '@/stores/addons.ts'
import { useSort } from '@/utils.ts'
import { buildAddonsMap, hasUpdate } from '@/utils/versioning.ts'
import type { ExtendedAddon, ExtendedRemoteAddon } from '@/types/plugin.ts'

const { sortAddons } = useSort()
const localAddonStoreNew = useLocalAddonsStore()
const remoteAddonsStore = useRemoteAddonsStore()

const isLoading = ref(true)
const error = ref<string | null>(null)

onMounted(async () => {
    try {
        const localAddons = await GetLocalAddons()
        const remoteAddons = await GetRemoteAddons()

        const extendedAddons: ExtendedAddon[] = localAddons.map((addon) => {
            const remote = buildAddonsMap(remoteAddons).get(addon.Id)
            return {
                ...addon,
                HasUpdate: remote ? hasUpdate(addon, remote) : false,
                Type: 'local',
            }
        })

        const extendedRemoteAddons: ExtendedRemoteAddon[] = remoteAddons.map((remote) => {
            const local = buildAddonsMap(localAddons).get(remote.Id)
            return {
                ...remote,
                IsInstalled: !!local,
                Type: 'remote',
            }
        })

        remoteAddonsStore.setAddons(sortAddons(extendedRemoteAddons, false))
        localAddonStoreNew.setAddons(sortAddons(extendedAddons, false))
    } catch (e) {
        console.log(e)
        error.value = 'Error while loading addons'
    } finally {
        isLoading.value = false
    }
})
</script>

<template>
    <UApp>
        <div class="flex flex-col h-screen bg-dark-brown text-white">
            <Header />

            <div v-if="isLoading">Loading addons...</div>
            <div v-else-if="error">{{ error }}</div>
            <main v-else class="flex flex-col overflow-hidden select-none">
                <RouterView />
            </main>
        </div>
    </UApp>
</template>
