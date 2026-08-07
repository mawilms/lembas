import { beforeEach, describe, expect, it } from 'vitest'
import { createPinia, setActivePinia } from 'pinia'
import { type Ref, ref } from 'vue'
import { useFilteredList, useSort } from './utils'
import { useSearchbarStore } from './stores/searchbar'
import { internal } from '@/wailsjs/go/models.ts'
import Addon = internal.Addon

const createAddon = (overrides: Partial<Addon> = {}): Addon =>
    ({
        ...overrides,
    }) as Addon

describe('useFilteredList', () => {
    let addons: Ref<Addon[]>

    beforeEach(() => {
        setActivePinia(createPinia())

        addons = ref<Addon[]>([
            createAddon({
                Name: 'AH Buyout Calculator',
                Category: 'Outdated LotRO Interfaces',
                HasUpdate: true,
            }),
            createAddon({
                Name: 'Alt Inventory',
                Category: 'Bags Bank & Inventory',
                HasUpdate: false,
            }),
            createAddon({
                Name: 'Bevy o Bars',
                Category: 'Action Bars & Main Bar',
                HasUpdate: false,
            }),
            createAddon({
                Name: 'Class DragBar with Examples',
                Category: 'Outdated LotRO Interfaces',
                HasUpdate: false,
            }),
        ])
    })

    it('Return all addons because no sort text and categories are used', () => {
        const categories = ref<string[]>([])

        const result = useFilteredList(addons, categories)

        expect(result.value).toHaveLength(4)
        expect(result.value).toEqual(addons.value)
    })

    it('filter for case insensitive text search', () => {
        const categories = ref<string[]>([])

        const searchbarStore = useSearchbarStore()
        searchbarStore.text = 'ah buyout'

        const result = useFilteredList(addons, categories)

        expect(result.value).toHaveLength(1)
        expect(result.value.map((a) => a.Name)).toEqual(['AH Buyout Calculator'])
    })

    it('filter for category without text search', () => {
        const categories = ref<string[]>(['Bags Bank & Inventory'])

        const result = useFilteredList(addons, categories)

        expect(result.value).toHaveLength(1)
        expect(result.value.map((a) => a.Name)).toEqual(['Alt Inventory'])
    })

    it('use text search and category together', () => {
        const categories = ref<string[]>(['Outdated LotRO Interfaces'])

        const searchbarStore = useSearchbarStore()
        searchbarStore.text = 'ah Buyout'

        const result = useFilteredList(addons, categories)

        expect(result.value).toHaveLength(1)
        expect(result.value[0]!.Name).toBe('AH Buyout Calculator')
    })

    it('no addons found because of the not fitting text search', () => {
        const categories = ref<string[]>([])

        const searchbarStore = useSearchbarStore()
        searchbarStore.text = 'hello world'

        const result = useFilteredList(addons, categories)

        expect(result.value).toHaveLength(0)
    })

    it('ignore leading and trailing whitespaces in text search', () => {
        const categories = ref<string[]>([])

        const searchbarStore = useSearchbarStore()
        searchbarStore.text = '  AH  '

        const result = useFilteredList(addons, categories)

        expect(result.value).toHaveLength(1)
        expect(result.value[0]!.Name).toBe('AH Buyout Calculator')
    })
})

describe('useSort', () => {
    let addons: Ref<Addon[]>

    beforeEach(() => {
        setActivePinia(createPinia())

        addons = ref<Addon[]>([
            createAddon({
                Name: 'AH Buyout Calculator',
                HasUpdate: false,
            }),
            createAddon({
                Name: 'Bevy o Bars',
                HasUpdate: true,
            }),
            createAddon({
                Name: 'Alt Inventory',
                HasUpdate: false,
            }),
            createAddon({
                Name: 'Class DragBar with Examples',
                HasUpdate: false,
            }),
        ])
    })

    it('sort from a - z', () => {
        const { sortAddons } = useSort()

        const result = sortAddons(addons.value, false)

        expect(result.map((a) => a.Name)).toEqual([
            'AH Buyout Calculator',
            'Alt Inventory',
            'Bevy o Bars',
            'Class DragBar with Examples',
        ])
    })

    it('sort from z - a', () => {
        const { sortAddons } = useSort()

        const result = sortAddons(addons.value, true)

        expect(result.map((a) => a.Name)).toEqual([
            'Class DragBar with Examples',
            'Bevy o Bars',
            'Alt Inventory',
            'AH Buyout Calculator',
        ])
    })

    it('reverse sort key', () => {
        const { sorting, sortAddons } = useSort()

        sortAddons(addons.value, true)
        expect(sorting.value).toBe(-1)

        sortAddons(addons.value, true)
        expect(sorting.value).toBe(1)

        sortAddons(addons.value, true)
        expect(sorting.value).toBe(-1)
    })

    it('change sorting direction', () => {
        const { sortAddons } = useSort()

        const firstResult = sortAddons(addons.value, true)
        expect(firstResult.map((a) => a.Name)).toEqual([
            'Class DragBar with Examples',
            'Bevy o Bars',
            'Alt Inventory',
            'AH Buyout Calculator',
        ])

        const secondResult = sortAddons(addons.value, true)
        expect(secondResult.map((a) => a.Name)).toEqual([
            'AH Buyout Calculator',
            'Alt Inventory',
            'Bevy o Bars',
            'Class DragBar with Examples',
        ])
    })

    it('accepts empty array', () => {
        const { sortAddons } = useSort()

        const result = sortAddons([], false)

        expect(result).toEqual([])
    })

    it('updatable addons on alphabetically on top', () => {
        const { sortAddons } = useSort()

        const result = sortAddons(addons.value, false)

        expect(result.map((a) => a.Name)).toEqual([
            'Bevy o Bars',
            'AH Buyout Calculator',
            'Alt Inventory',
            'Class DragBar with Examples',
        ])
    })
})
