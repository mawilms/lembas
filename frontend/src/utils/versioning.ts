import { database, remote } from '../../wailsjs/go/models.ts'
import Addon = database.Addon
import RemoteAddon = remote.RemoteAddon

export const normalizeVersion = (version: string): number[] => {
    return version
        .trim()
        .replace(/^v/i, '') // "v1.4" -> "1.4"
        .split('.')
        .map((part) => {
            const num = parseInt(part, 10)
            return Number.isNaN(num) ? 0 : num
        })
}

export const compareVersions = (a: string, b: string): number => {
    const partsA = normalizeVersion(a)
    const partsB = normalizeVersion(b)
    const length = Math.max(partsA.length, partsB.length)

    for (let i = 0; i < length; i++) {
        const numA = partsA[i] ?? 0
        const numB = partsB[i] ?? 0

        if (numA > numB) return 1
        if (numA < numB) return -1
    }

    return 0
}

export const hasUpdate = (local: Addon, remote: RemoteAddon): boolean => {
    return compareVersions(remote.Version, local.Version) > 0
}

interface ID {
    Id: number
}

export const buildAddonsMap = <T extends ID>(addons: T[]) => {
    const map = new Map<number, T>()
    for (const addon of addons) {
        map.set(addon.Id, addon)
    }
    return map
}
