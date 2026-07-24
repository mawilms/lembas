import { database, remote } from '@/wailsjs/go/models.ts'
import Addon = database.Addon
import RemoteAddon = remote.RemoteAddon

export interface IAddon {
    Id: number
    Name: string
    Author: string
    Version: string
    Category: string
    Downloads: number
    UpdatedAt: string
    ArchiveSize: string
}

export interface ExtendedAddon extends Addon {
    Type: 'local'
    HasUpdate: boolean
}

export interface ExtendedRemoteAddon extends RemoteAddon {
    Type: 'remote'
    HasUpdate: boolean
    IsInstalled: boolean
}
