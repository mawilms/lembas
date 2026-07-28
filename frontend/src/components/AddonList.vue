<script setup lang="ts">
import { ref } from 'vue'
import { internal } from '@/wailsjs/go/models.ts'
import { InstallAddon } from '@/wailsjs/go/main/App'
import { useAddonsStore } from '@/stores/addons.ts'
import { useRoute } from 'vue-router'
import Addon = internal.Addon

const props = defineProps<{
    addons: Addon[]
}>()

const route = useRoute()
const { setAddons } = useAddonsStore()

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
                <button
                    v-if="item.HasUpdate"
                    class="bg-primary hover:bg-gold text-sm py-1 px-2 rounded cursor-pointer"
                >
                    Update
                </button>
                <p v-else-if="item.IsInstalled"></p>
                <button
                    v-else
                    class="bg-primary hover:bg-gold text-sm py-1 px-2 rounded cursor-pointer"
                    @click="
                        async () =>
                            InstallAddon(item.Id, false).then((newAddons) => {
                                setAddons(Object.values(newAddons.localAddons))
                            })
                    "
                >
                    Install
                </button>
            </template>

            <template v-slot:center>
                <div class="flex min-w-0 flex-1 text-xs text-gray-300">
                    <span v-if="item.Type === 'local'" class="min-w-0 truncate">{{
                        item.ArchiveName
                    }}</span>
                    <span v-else class="min-w-0 flex-1 truncate">{{ item.Description }}</span>
                </div>
            </template>

            <template v-slot:version>
                <span v-if="route.fullPath === '/'">{{ item.CurrentVersion }}</span>
                <span v-else>{{ item.LatestVersion }}</span>
            </template>
        </AddonRow>
    </UScrollArea>

    <SelectPopover
        :addon="props.addons[activeRow!]!"
        :activeRow="activeRow"
        @reset-row="resetRow"
    />
</template>
