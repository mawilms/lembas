<script setup lang="ts">
import { RouterView } from 'vue-router'
import Header from '@/components/Header.vue'
</script>

<template>
    <div class="flex flex-col h-screen bg-dark-brown text-white">
        <Header />

        <RouterView />
    </div>
</template>
