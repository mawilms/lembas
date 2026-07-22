<script setup lang="ts">
import { ref } from 'vue'
import AddonRow from '@/components/browse/AddonRow.vue'

import type { ExtendedRemoteAddon } from '@/types/plugin.ts'

const props = defineProps<{
    addons: ExtendedRemoteAddon[]
}>()

const activeRow = ref<number | null>(null)
</script>

<template>
    <ul class="flex flex-col flex-1 gap-4 overflow-y-auto">
        <AddonRow
            class="border cursor-pointer"
            v-for="(addon, index) in props.addons"
            :key="addon.Id"
            :addon="addon"
            :class="{
                'border-primary': activeRow === index,
                'border-transparent': activeRow !== index,
            }"
            @click="activeRow = index"
        />
    </ul>
</template>
