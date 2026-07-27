<script setup lang="ts">
import { ref } from 'vue'
import { internal } from '@/wailsjs/go/models.ts'
import ParentAddon = internal.ParentAddon

const props = defineProps<{
    addons: ParentAddon[]
}>()

const activeRow = ref<number | null>(null)

const resetRow = () => {
    activeRow.value = null
}
</script>

<template>
    <ul class="flex flex-col flex-1 gap-4 overflow-y-auto p-4">
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
        >
            <template v-slot:status>
                <div v-if="addon.Type === 'remote'">
                    <button
                        v-if="addon.HasUpdate"
                        class="bg-primary hover:bg-gold text-sm py-1 px-2 rounded cursor-pointer"
                    >
                        Update
                    </button>
                    <p v-else-if="addon.IsInstalled">Installed</p>
                    <button
                        v-else
                        class="bg-primary hover:bg-gold text-sm py-1 px-2 rounded cursor-pointer"
                    >
                        Install
                    </button>
                </div>
                <div v-else>
                    <button
                        class="bg-primary hover: text-sm py-1 px-2 rounded cursor-pointer"
                        v-if="addon.HasUpdate"
                    >
                        Update
                    </button>
                    <span v-else>Up to date</span>
                </div>
            </template>

            <template v-slot:center>
                <div class="flex min-w-0 flex-1 text-xs text-gray-300">
                    <span v-if="addon.Type === 'local'" class="min-w-0 truncate">{{
                        addon.ArchiveName
                    }}</span>
                    <span v-else class="min-w-0 flex-1 truncate">{{ addon.Description }}</span>
                </div>
            </template>
        </AddonRow>
    </ul>

    <SelectPopover :activeRow="activeRow" @reset-row="resetRow" />
</template>
