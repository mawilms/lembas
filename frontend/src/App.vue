<script setup lang="ts">
import { RouterView } from 'vue-router'
import Header from '@/components/Header.vue'
import { onMounted, ref } from 'vue'
import { useAddonsStore } from '@/stores/addons.ts'

const { getAddons } = useAddonsStore()

const isLoading = ref(true)
const error = ref<string | null>(null)

onMounted(async () => {
    try {
        await getAddons(false)
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
