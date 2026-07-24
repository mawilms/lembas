<script setup lang="ts">
import { Search } from '@lucide/vue'
import NavLink from '@/components/NavLink.vue'
import { useSearchbarStore } from '@/stores/searchbar.ts'

const searchbarStore = useSearchbarStore()
</script>

<template>
    <header class="bg-light-brown p-4">
        <section class="flex items-center gap-4">
            <img class="w-12 h-12" src="../assets/logo.png" alt="logo" />

            <div class="flex-1 flex items-center gap-2 rounded-md bg-light-brown-hover px-3 py-2">
                <Search class="h-5 w-5 text-gray-300" />
                <input
                    class="flex-1 focus:outline-none"
                    placeholder="Search for addons...."
                    :value="searchbarStore.text"
                    @input="
                        (event) => {
                            const el = (event.target as HTMLInputElement).value
                            searchbarStore.changeSearchText(el)
                        }
                    "
                />
            </div>

            <div class="flex gap-2">
                <NavLink to="/">Plugins</NavLink>
                <NavLink to="/browse">Browse</NavLink>
            </div>
        </section>
    </header>
</template>
