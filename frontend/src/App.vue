<script setup lang="ts">
import { RouterView } from 'vue-router'
import Header from '@/components/Header.vue'
import { computed, onMounted, ref } from 'vue'
import { GetLocalAddons, GetRemoteAddons } from '../wailsjs/go/main/App'
import { useLocalAddonsStoreNew, useRemoteAddonsStore } from '@/stores/addons.ts'
import { useSort } from '@/utils.ts'
import { database, remote } from '../wailsjs/go/models.ts'
import RemoteAddon = remote.RemoteAddon
import Addon = database.Addon

const { sortAddons } = useSort()
const localAddonStoreNew = useLocalAddonsStoreNew()
const remoteAddonsStore = useRemoteAddonsStore()

const isLoading = ref(true)
const error = ref<string | null>(null)

onMounted(async () => {
    try {
        const localAddons = await GetLocalAddons()
        const remoteAddons = await GetRemoteAddons()
        remoteAddonsStore.setAddons(sortAddons(remoteAddons, false))

        const extendedAddons = localAddons.map((addon) => {
            const remote = remoteAddonsMap.value.get(addon.Id)
            return {
                ...addon,
                HasUpdate: remote ? hasUpdate(addon, remote) : false,
            }
        })
        localAddonStoreNew.setAddons(sortAddons(extendedAddons, false))
    } catch (e) {
        console.log(e)
        error.value = 'Error while loading addons'
    } finally {
        isLoading.value = false
    }
})

function normalizeVersion(version: string): number[] {
    return version
        .trim()
        .replace(/^v/i, '') // "v1.4" -> "1.4"
        .split('.')
        .map((part) => {
            const num = parseInt(part, 10)
            return Number.isNaN(num) ? 0 : num
        })
}

function compareVersions(a: string, b: string): number {
    const partsA = normalizeVersion(a)
    const partsB = normalizeVersion(b)
    const length = Math.max(partsA.length, partsB.length)

    for (let i = 0; i < length; i++) {
        const numA = partsA[i] ?? 0
        const numB = partsB[i] ?? 0

        if (numA > numB) return 1
        if (numA < numB) return -1
    }

    return 0
}

function hasUpdate(local: Addon, remote: RemoteAddon): boolean {
    return compareVersions(remote.Version, local.Version) > 0
}

const remoteAddonsMap = computed(() => {
    const map = new Map<number, RemoteAddon>()
    for (const r of remoteAddonsStore.addons) {
        map.set(r.Id, r)
    }
    return map
})
</script>

<template>
    <div class="flex flex-col h-screen bg-dark-brown text-white">
        <Header />

        <div v-if="isLoading">Loading addons...</div>
        <div v-else-if="error">{{ error }}</div>
        <div v-else>
            <RouterView />
        </div>
    </div>
</template>
