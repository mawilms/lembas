import { database, remote } from '../../wailsjs/go/models.ts'
import Addon = database.Addon
import RemoteAddon = remote.RemoteAddon

export interface ExtendedAddon extends Addon {
    HasUpdate: boolean
}

export interface ExtendedRemoteAddon extends RemoteAddon {
    IsInstalled: boolean
}
