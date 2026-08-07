<script setup lang="ts">
import { ArrowUpDown } from '@lucide/vue'
import type { Criteria } from '@/types/criteria.ts'

const selectedCriteria = defineModel<string>('selected-criteria', {
    default: () => 'Name',
})
const criteria: Criteria[] = ['Name', 'Category', 'Downloads', 'Recently updated']

function toggle(value: string) {
    selectedCriteria.value = value
}
</script>

<template>
    <UPopover>
        <UTooltip arrow text="Filter by">
            <div class="p-2 hover:bg-light-brown-hover cursor-pointer">
                <ArrowUpDown class="h-5 w-5 hover:bg-light-brown-hover" />
            </div>
        </UTooltip>

        <template #content>
            <div class="flex flex-col gap-4 bg-light-brown-hover p-4 select-none text-sm">
                <UCollapsible class="flex flex-col w-60 space-y-2">
                    <UCheckbox
                        v-for="c in criteria"
                        :key="c"
                        :label="c"
                        :model-value="selectedCriteria === c"
                        @update:model-value="() => toggle(c)"
                        :size="'sm'"
                        :ui="{
                            label: 'font-normal',
                            base: 'bg-gray-300',
                        }"
                    />
                </UCollapsible>
            </div>
        </template>
    </UPopover>
</template>
