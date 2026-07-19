<script setup lang="ts">
defineProps({
    to: { type: [String, Object], required: true },
})
</script>

<template>
    <router-link :to="to" custom v-slot="{ isActive, navigate, href }">
        <a :href="href" @click="navigate" class="relative inline-block cursor-pointer">
            <slot />
            <span
                v-if="isActive"
                class="absolute left-0 -bottom-1 h-0.5 w-full origin-center color-primary animate-underline bg-primary"
            />
        </a>
    </router-link>
</template>
