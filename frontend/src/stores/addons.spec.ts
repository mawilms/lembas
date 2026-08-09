import { beforeEach, describe, expect, test, vi } from 'vitest'
import { createPinia, setActivePinia, storeToRefs } from 'pinia'
import { useAddonsStore } from '@/stores/addons.ts'
import { GetAddons } from '@/wailsjs/go/main/App'
import { main } from '@/wailsjs/go/models.ts'
import AddonMap = main.AddonMap

vi.mock('../wailsjs/go/main/App', () => ({
    GetAddons: vi.fn(),
}))

const mockedGetAddons = vi.mocked(GetAddons)

describe('getAddons', () => {
    beforeEach(() => {
        setActivePinia(createPinia())
        vi.clearAllMocks()
    })

    test('fetch addons from the go backend', async () => {
        const mockResponse = new AddonMap({
            localAddons: {
                506: { id: '506', name: 'AH Buyout Calculator' },
            },
            remoteAddons: {
                414: { id: '414', name: 'Inventory' },
                506: { id: '506', name: 'AH Buyout Calculator' },
            },
        })
        mockedGetAddons.mockResolvedValue(mockResponse)

        const store = useAddonsStore()
        const { addons, remoteAddons } = storeToRefs(store)
        const { getAddons } = store

        await getAddons(false)

        expect(Object.values(addons.value)).toEqual([
            {
                id: '506',
                name: 'AH Buyout Calculator',
            },
        ])
        expect(Object.values(remoteAddons.value)).toEqual([
            {
                id: '506',
                name: 'AH Buyout Calculator',
            },
            {
                id: '414',
                name: 'Inventory',
            },
        ])
    })
})

describe('setAddons', () => {
    beforeEach(() => {
        setActivePinia(createPinia())
        vi.clearAllMocks()
    })

    test('set local addons', async () => {
        const mockResponse = new AddonMap({
            localAddons: {
                506: { id: 506, name: 'AH Buyout Calculator' },
            },
            remoteAddons: {
                414: { id: 414, name: 'Inventory' },
                506: { id: 506, name: 'AH Buyout Calculator' },
            },
        })
        mockedGetAddons.mockResolvedValue(mockResponse)

        const store = useAddonsStore()
        const { addons } = storeToRefs(store)
        const { setAddons } = store

        setAddons({
            506: {
                id: 506,
                name: 'AH Buyout Calculator',
                category: 'Others',
                type: 'local',
                hasUpdate: true,
                updatedAt: '01/05/2026',
                downloads: 12345,
                author: 'MuNkEy',
                description: 'Hello World',
                isInstalled: true,
                localVersion: '1.0.0',
                remoteVersion: '1.0.0',
                archiveSize: '5 MB',
                archiveName: 'AH Buyout Calculator.zip',
            },
        })

        expect(Object.values(addons.value)).toEqual([
            {
                id: 506,
                name: 'AH Buyout Calculator',
                category: 'Others',
                type: 'local',
                hasUpdate: true,
                updatedAt: '01/05/2026',
                downloads: 12345,
                author: 'MuNkEy',
                description: 'Hello World',
                isInstalled: true,
                localVersion: '1.0.0',
                remoteVersion: '1.0.0',
                archiveSize: '5 MB',
                archiveName: 'AH Buyout Calculator.zip',
            },
        ])
    })
})

describe('setRemoteAddons', () => {
    beforeEach(() => {
        setActivePinia(createPinia())
        vi.clearAllMocks()
    })

    test('set remote addons', async () => {
        const mockResponse = new AddonMap({
            localAddons: {
                414: { id: 414, name: 'Inventory' },
            },
            remoteAddons: {},
        })
        mockedGetAddons.mockResolvedValue(mockResponse)

        const store = useAddonsStore()
        const { remoteAddons } = storeToRefs(store)
        const { setRemoteAddons } = store

        setRemoteAddons({
            506: {
                id: 506,
                name: 'AH Buyout Calculator',
                category: 'Others',
                type: 'local',
                hasUpdate: true,
                updatedAt: '01/05/2026',
                downloads: 12345,
                author: 'MuNkEy',
                description: 'Hello World',
                isInstalled: true,
                localVersion: '1.0.0',
                remoteVersion: '1.0.0',
                archiveSize: '5 MB',
                archiveName: 'AH Buyout Calculator.zip',
            },
        })

        expect(Object.values(remoteAddons.value)).toEqual([
            {
                id: 506,
                name: 'AH Buyout Calculator',
                category: 'Others',
                type: 'local',
                hasUpdate: true,
                updatedAt: '01/05/2026',
                downloads: 12345,
                author: 'MuNkEy',
                description: 'Hello World',
                isInstalled: true,
                localVersion: '1.0.0',
                remoteVersion: '1.0.0',
                archiveSize: '5 MB',
                archiveName: 'AH Buyout Calculator.zip',
            },
        ])
    })
})
