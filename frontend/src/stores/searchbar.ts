import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useSearchbarStore = defineStore('searchbar', () => {
    const text = ref<string>('')

    function changeSearchText(value: string) {
        text.value = value
    }

    function reset() {
        text.value = ''
    }

    return { text, changeSearchText, reset }
})
