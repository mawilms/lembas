import { computed, type ComputedRef, type Ref, ref } from 'vue'
import { useSearchbarStore } from '@/stores/searchbar.ts'
import { internal } from '@/wailsjs/go/models.ts'
import Addon = internal.Addon

export const extractFirstLetter = (name: string) => {
    return name.substring(0, 1)
}

export const useSort = () => {
    const sorting = ref<1 | -1>(1)

    const sortAddons = (addons: Addon[], reverse: boolean): Addon[] => {
        if (reverse) sorting.value = (sorting.value * -1) as 1 | -1

        return addons.sort((a, b) => {
            if (a.HasUpdate !== b.HasUpdate) {
                return a.HasUpdate ? -1 : 1
            }

            return sorting.value * a.Name.localeCompare(b.Name)
        })
    }

    return { sorting, sortAddons }
}

export const useFilteredList = (
    addons: Ref<Addon[]>,
    categories: Ref<string[]>
): ComputedRef<Addon[]> => {
    const searchbarStore = useSearchbarStore()

    return computed(() => {
        const text = searchbarStore.text.trim().toLowerCase()
        const hasCategories = (categories?.value?.length ?? 0) > 0

        if (!text && !hasCategories) return addons.value

        let filteredAddons: Addon[] = addons.value

        if (hasCategories) {
            filteredAddons = filteredAddons.filter((item) =>
                categories.value.includes(item.Category)
            )
        }

        return filteredAddons.filter((item) => item.Name.toLowerCase().includes(text))
    })
}

export const useRemoveCategory = () => {
    const selectedCategories = ref<string[]>([])

    const removeCategory = (category: string) => {
        selectedCategories.value = selectedCategories.value.filter((v) => v !== category)
    }

    return { selectedCategories, removeCategory }
}

export const useCategories = (addons: Ref<Addon[]>) => {
    return computed(() => {
        return [
            ...new Set(
                addons.value.map((a) => {
                    return a.Category
                })
            ),
        ]
    })
}
