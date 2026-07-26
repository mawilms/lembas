<script setup lang="ts">
import { ChevronDown, Funnel } from '@lucide/vue'

const selectedCategories = defineModel<string[]>('selectedCategories', {
    default: () => [],
})
const categories = defineModel<string[]>('categories', {
    default: () => [],
})
</script>

<template>
    <UPopover>
        <UTooltip arrow text="Filter by">
            <div class="p-2 hover:bg-light-brown-hover cursor-pointer">
                <Funnel class="h-5 w-5 hover:bg-light-brown-hover" />
            </div>
        </UTooltip>

        <template #content>
            <div class="flex flex-col gap-4 bg-light-brown-hover p-4 select-none text-sm">
                <div>Filter by</div>
                <div class="h-[0.1px] bg-gray-500"></div>
                <UCollapsible class="flex flex-col w-60">
                    <div class="flex justify-between cursor-pointer">
                        <span>Categories</span>
                        <ChevronDown />
                    </div>

                    <template #content>
                        <UCheckboxGroup
                            class="mt-4 max-h-96 overflow-y-auto"
                            :size="'sm'"
                            v-model="selectedCategories"
                            :items="categories"
                            :ui="{
                                label: 'font-normal',
                                base: 'bg-gray-300',
                                item: 'my-1',
                            }"
                        />
                    </template>
                </UCollapsible>
            </div>
        </template>
    </UPopover>
</template>
