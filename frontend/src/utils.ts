import { computed, type ComputedRef, type Ref, ref } from 'vue'
import { useSearchbarStore } from '@/stores/searchbar.ts'

interface Named {
    Name: string
    Category: string
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

export function useFilteredList<T extends Named>(
    addons: T[],
    categories: Ref<string[]>
): ComputedRef<T[]> {
    const searchbarStore = useSearchbarStore()

    return computed(() => {
        const text = searchbarStore.text.trim().toLowerCase()
        const hasCategories = (categories?.value?.length ?? 0) > 0

        if (!text && !hasCategories) return addons

        let filteredAddons = addons

        if (hasCategories) {
            filteredAddons = filteredAddons.filter((item) =>
                categories.value.includes(item.Category)
            )
        }

        return filteredAddons.filter((item) => item.Name.toLowerCase().includes(text))
    })
}

export function useTotalAddons<T extends Named>(addons: T[]) {
    return computed(() => {
        return addons.length
    })
}
