<script setup lang="ts">
import { ref } from 'vue'
import { internal } from '@/wailsjs/go/models.ts'
import Addon = internal.Addon
import { InstallAddon, UpdateAddon } from '@/wailsjs/go/main/App'

const props = defineProps<{
    addons: Addon[]
}>()

const activeRow = ref<number | null>(null)

const resetRow = () => {
    activeRow.value = null
}
</script>

<template>
    <UScrollArea
        v-slot="{ item, index }"
        :items="props.addons"
        orientation="vertical"
        :virtualize="{
            gap: 16,
        }"
        class="p-4"
    >
        <AddonRow
            class="border cursor-pointer"
            :key="index"
            :addon="item"
            :class="{
                'border-primary': activeRow === index,
                'border-transparent': activeRow !== index,
            }"
            @click="activeRow = index"
        >
            <template v-slot:status>
                <div v-if="item.Type === 'remote'">
                    <button
                        v-if="item.HasUpdate"
                        class="bg-primary hover:bg-gold text-sm py-1 px-2 rounded cursor-pointer"
                    >
                        Update
                    </button>
                    <p v-else-if="item.IsInstalled">Installed</p>
                    <button
                        v-else
                        class="bg-primary hover:bg-gold text-sm py-1 px-2 rounded cursor-pointer"
                        @click="async () => await InstallAddon(item.Id, false)"
                    >
                        Install
                    </button>
                </div>
                <div v-else>
                    <button
                        class="bg-primary hover: text-sm py-1 px-2 rounded cursor-pointer"
                        v-if="item.HasUpdate"
                        @click="async () => await UpdateAddon(item.Id)"
                    >
                        Update
                    </button>
                    <span v-else>Up to date</span>
                </div>
            </template>

            <template v-slot:center>
                <div class="flex min-w-0 flex-1 text-xs text-gray-300">
                    <span v-if="item.Type === 'local'" class="min-w-0 truncate">{{
                        item.ArchiveName
                    }}</span>
                    <span v-else class="min-w-0 flex-1 truncate">{{ item.Description }}</span>
                </div>
            </template>
        </AddonRow>
    </UScrollArea>

    <SelectPopover :addon="props.addons[activeRow!]!" :activeRow="activeRow" @reset-row="resetRow" />
</template>
