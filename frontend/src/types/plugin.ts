export interface BasePlugin {
    id: number
    name: string
    author: string
    description: string
    currentVersion: string
    latestVersion: string
    infoUrl: string
    downloadUrl: string
}

export interface Plugin {
    base: BasePlugin
}

export interface RemotePlugin {
    base: BasePlugin
    totalDownloads: number
    category: string
    filename: string
    isInstalled: boolean
    lastUpdated: string
}
