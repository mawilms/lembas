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
                506: { Id: '506', Name: 'AH Buyout Calculator' },
            },
            remoteAddons: {
                414: { Id: '414', Name: 'Inventory' },
                506: { Id: '506', Name: 'AH Buyout Calculator' },
            },
        })
        mockedGetAddons.mockResolvedValue(mockResponse)

        const store = useAddonsStore()
        const { addons, remoteAddons } = storeToRefs(store)
        const { getAddons } = store

        await getAddons()

        expect(Object.values(addons.value)).toEqual([
            {
                Id: '506',
                Name: 'AH Buyout Calculator',
            },
        ])
        expect(Object.values(remoteAddons.value)).toEqual([
            {
                Id: '506',
                Name: 'AH Buyout Calculator',
            },
            {
                Id: '414',
                Name: 'Inventory',
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
                506: { Id: 506, Name: 'AH Buyout Calculator' },
            },
            remoteAddons: {
                414: { Id: 414, Name: 'Inventory' },
                506: { Id: 506, Name: 'AH Buyout Calculator' },
            },
        })
        mockedGetAddons.mockResolvedValue(mockResponse)

        const store = useAddonsStore()
        const { addons } = storeToRefs(store)
        const { setAddons } = store

        setAddons({
            506: {
                Id: 506,
                Name: 'AH Buyout Calculator',
                Category: 'Others',
                Type: 'local',
                HasUpdate: true,
                UpdatedAt: '01/05/2026',
                Downloads: 12345,
                Author: 'MuNkEy',
                Description: 'Hello World',
                IsInstalled: true,
                CurrentVersion: '1.0.0',
                LatestVersion: '1.0.0',
                ArchiveSize: '5 MB',
                ArchiveName: 'AH Buyout Calculator.zip',
            },
        })

        expect(Object.values(addons.value)).toEqual([
            {
                Id: 506,
                Name: 'AH Buyout Calculator',
                Category: 'Others',
                Type: 'local',
                HasUpdate: true,
                UpdatedAt: '01/05/2026',
                Downloads: 12345,
                Author: 'MuNkEy',
                Description: 'Hello World',
                IsInstalled: true,
                CurrentVersion: '1.0.0',
                LatestVersion: '1.0.0',
                ArchiveSize: '5 MB',
                ArchiveName: 'AH Buyout Calculator.zip',
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
                414: { Id: 414, Name: 'Inventory' },
            },
            remoteAddons: {},
        })
        mockedGetAddons.mockResolvedValue(mockResponse)

        const store = useAddonsStore()
        const { remoteAddons } = storeToRefs(store)
        const { setRemoteAddons } = store

        setRemoteAddons({
            506: {
                Id: 506,
                Name: 'AH Buyout Calculator',
                Category: 'Others',
                Type: 'local',
                HasUpdate: true,
                UpdatedAt: '01/05/2026',
                Downloads: 12345,
                Author: 'MuNkEy',
                Description: 'Hello World',
                IsInstalled: true,
                CurrentVersion: '1.0.0',
                LatestVersion: '1.0.0',
                ArchiveSize: '5 MB',
                ArchiveName: 'AH Buyout Calculator.zip',
            },
        })

        expect(Object.values(remoteAddons.value)).toEqual([
            {
                Id: 506,
                Name: 'AH Buyout Calculator',
                Category: 'Others',
                Type: 'local',
                HasUpdate: true,
                UpdatedAt: '01/05/2026',
                Downloads: 12345,
                Author: 'MuNkEy',
                Description: 'Hello World',
                IsInstalled: true,
                CurrentVersion: '1.0.0',
                LatestVersion: '1.0.0',
                ArchiveSize: '5 MB',
                ArchiveName: 'AH Buyout Calculator.zip',
            },
        ])
    })
})
