<div align="center">

<img src="resources/assets/bread_light.svg" width="30%">

# Lembas

![Github testing](https://github.com/mawilms/lembas/actions/workflows/testing.yml/badge.svg)
![GitHub issues](https://img.shields.io/github/issues/mawilms/lembas)
[![GitHub license](https://img.shields.io/github/license/mawilms/lembas)](https://github.com/mawilms/lembas/blob/main/LICENSE)

</div>

Lembas is a plugin management tool completely written in Rust for the game "Lord of the Rings Online". You may ask why we chose the name "Lembas"? Good question. For a succesful journey in LotRO you may need some plugins but definitely the famous lembas bread!

## Table of contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Installation](#installation)
- [FAQ](#faq)
- [Contribute](#contribute)
- [Special thanks](#special-thanks)
- [License](#license)

## Features

- Currently we retrieve the plugin information from [lotrointerface.com](https://www.lotrointerface.com/).
- You can install every plugin from the catalog
- (Bulk) update functionality
- Delete plugins + their dependencies

We also have plans for the futures. Some futures that are in the pipeline are:

- [ ] Backup functionality
- [ ] Ignore list to set a fixed plugin version
- [ ] Install addons from the [lotrointerface.com](https://www.lotrointerface.com) URL
- [ ] Include additional plugin providers

## Screenshots

![plugins_ui](./screenshots/plugins.png 'Plugins UI')

## Installation

We provided prebuilt binaries for Windows, Linux and macOS. These binaries can be found [here](https://github.com/mawilms/lembas/releases)

If you want to build this package on your own you can simply clone the repository and run `cargo build --release`. Keep in mind that you need a working installation of Rust on your computer.

## FAQ

### **_Wait there is already a plugin manager. Why should we use Lembas?_**

Yes. LotRO has already [LOTRO Plugin Compendium](https://www.lotrointerface.com/downloads/info663-LOTROPluginCompendium.html) and it works fairly well. We just wanted to provide a more modern version with a small footprint and that runs fast.

### **_Why Rust?_**

I've built in the past small projects in Rust but nothing fancy. So this project is a learning experience for myself. I enjoy Rust and I love Middle Earth so why not combine both? :blush:

### **_Where can I find the configs?_**

The settings can be found here:

Windows:

- `%APPDATA%\Roaming`

Linux:

- `$HOME/.local/share`

macOS:

- `$HOME/Library/Application Support`

## Contribute

Lembas is meant to be a community project. So anyone who wants to be part of Lembas is welcome. It doesn't matter if you have a feature request or if you are a developer who wants to develop a feature. You're an experienced Rust developer and want to critize my code? Also no problem. Any feedback is welcome!

You can open a Feature request or Bug issue [here](https://github.com/mawilms/lembas/issues/new/choose)

## Special thanks

I want to especially thank [@13r0ck](https://github.com/13r0ck) and [@hecrj](https://github.com/hecrj) from the [Iced zulip server](https://iced.zulipchat.com). Both were very helpful and their tips were essential for this app. I also want to thank [Thornbach](https://fungalmancy.netlify.app/) for the great icon.

## License

Lembas is release under the [GNU GPLv3](https://github.com/mawilms/lembas/blob/main/LICENSE)
