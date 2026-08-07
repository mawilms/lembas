import { computed, type ComputedRef, type Ref, ref } from 'vue'
import { useSearchbarStore } from '@/stores/searchbar.ts'
import { internal } from '@/wailsjs/go/models.ts'
import Addon = internal.Addon
import type { Criteria } from '@/types/criteria.ts'

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

    const sortAddonsByCriteria = (addons: Ref<Addon[]>, criteria: Criteria): Addon[] => {
        if (criteria == 'Name') {
            return addons.value.sort((a, b) => {
                return sorting.value * a.Name.localeCompare(b.Name)
            })
        } else if (criteria == 'Category') {
            return addons.value.sort((a, b) => {
                return sorting.value * a.Category.localeCompare(b.Category)
            })
        } else if (criteria == 'Recently updated') {
            return addons.value.sort((a, b) => {
                const [monthA, dayA, yearA] = a.UpdatedAt.split('/').map(Number)
                const [monthB, dayB, yearB] = b.UpdatedAt.split('/').map(Number)

                return (
                    new Date(yearB!, monthB! - 1, dayB).getTime() -
                    new Date(yearA!, monthA! - 1, dayA).getTime()
                )
            })
        } else {
            return addons.value.sort((a, b) => {
                return a.Downloads > b.Downloads ? -1 : 1
            })
        }
    }

    return { sorting, sortAddons, sortAddonsByCriteria }
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
