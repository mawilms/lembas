import { computed, type ComputedRef, ref } from 'vue'
import { useSearchbarStore } from '@/stores/searchbar.ts'

interface Named {
    Name: string
}

export const extractFirstLetter = (name: string) => {
    return name.substring(0, 1)
}

export function useSort() {
    const sorting = ref<1 | -1>(1)

    const sortAddons = <T extends Named>(addons: T[], reverse: boolean): T[] => {
        if (reverse) sorting.value = (sorting.value * -1) as 1 | -1

        return addons.sort((a, b) => sorting.value * a.Name.localeCompare(b.Name))
    }

    return { sorting, sortAddons }
}

export function useFilteredList<T extends Named>(addons: T[]): ComputedRef<T[]> {
    const searchbarStore = useSearchbarStore()

    return computed(() => {
        const text = searchbarStore.text.trim().toLowerCase()
        if (!text) return addons

        return addons.filter((item) => item.Name.toLowerCase().includes(text))
    })
}

export function useTotalAddons<T extends Named>(addons: T[]) {
    return computed(() => {
        return addons.length
    })
}
