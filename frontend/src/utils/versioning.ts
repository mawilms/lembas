import { database, remote } from '../wailsjs/go/models.ts'
import Addon = database.Addon
import RemoteAddon = remote.RemoteAddon

export const normalizeVersion = (version: string): number[] => {
    return version
        .trim()
        .replace('v', '')
        .split('.')
        .map((part) => {
            const num = parseInt(part, 10)
            return Number.isNaN(num) ? 0 : num
        })
}

export const compareVersions = (remoteVersion: string, localVersion: string): number => {
    const normRemote = normalizeVersion(remoteVersion)
    const normLocal = normalizeVersion(localVersion)
    const length = Math.max(normRemote.length, normLocal.length)

    for (let i = 0; i < length; i++) {
        const versionRemote = normRemote[i] ?? 0
        const versionLocal = normLocal[i] ?? 0

        if (versionRemote > versionLocal) return 1
        if (versionRemote < versionLocal) return -1
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
