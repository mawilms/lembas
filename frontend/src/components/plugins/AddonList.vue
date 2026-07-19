<script setup lang="ts">
import AddonRow from './AddonRow.vue'
import { ref } from 'vue'
import type { entities } from '../../../wailsjs/go/models.ts'

const props = defineProps({
    addons: {
        type: Array<entities.LocalPluginEntity>,
        required: true,
    },
})

const activeRow = ref<number | null>(null)
</script>

<template>
    <ul class="flex flex-col gap-4">
        <AddonRow
            class="border cursor-pointer"
            v-for="(addon, index) in props.addons"
            :key="addon.base.id"
            :addon="addon"
            :class="{
                'border-primary': activeRow === index,
                'border-transparent': activeRow !== index,
            }"
            @click="activeRow = index"
        />
    </ul>
</template>
