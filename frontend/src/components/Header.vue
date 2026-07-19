<script setup lang="ts">
import { Search, Settings } from '@lucide/vue'
import NavLink from '@/components/NavLink.vue'
</script>

<template>
    <header class="bg-light-brown p-4">
        <section class="flex items-center gap-4">
            <img class="w-12 h-12" src="../assets/logo.png" alt="logo" />

            <div class="flex-1 flex items-center gap-2 border border-border rounded-md px-3 py-2">
                <Search />
                <input class="flex-1" placeholder="Search for addons...." />
            </div>

            <div class="flex gap-2">
                <NavLink to="/">Plugins</NavLink>
                <NavLink to="/browse">Browse</NavLink>
            </div>

            <Settings />
        </section>
    </header>
</template>
