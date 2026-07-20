import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useSearchTextStore = defineStore('searchText', () => {
    const searchText = ref<string>('')

    function changeSearchText(value: string) {
        searchText.value = value
    }

    return { searchText, changeSearchText }
})
