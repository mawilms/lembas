<div align="center">

<img src="resources/assets/bread_light.svg" width="30%">

# Lembas

![Github testing](https://github.com/mawilms/lembas/actions/workflows/testing.yml/badge.svg)
![GitHub issues](https://img.shields.io/github/issues/mawilms/lembas)
![GitHub downloads](https://img.shields.io/github/downloads/mawilms/lembas/total)

</div>

> **Note: Lembas is currently heavily work in progress and will contain a lot of changes in the upcoming release. The
app
will get a major rework.**

Lembas is a plugin management tool completely written in Go and Sveltekit for the game "Lord of the Rings Online". You
may ask why I
chose the name "Lembas"? Good question. For a successful journey in LotRO you may need some plugins but definitely the
famous Lembas bread!

## Table of contents

- [Features](#features)
- [Screenshots](#screenshots)
- [Installation](#installation)
- [FAQ](#faq)
- [Contribute](#contribute)
- [Special thanks](#special-thanks)
- [License](#license)

## Features

- Currently, Lembas retrieves the plugin information from [lotrointerface.com](https://www.lotrointerface.com/).
- You can install every plugin from the catalog
- (Bulk) update functionality
- Delete plugins + their dependencies

## Screenshots

![plugins_ui](screenshots/post-05/plugins.png 'Plugins UI')

![plugins_ui](screenshots/post-05/catalog.png 'Catalog UI')

## Installation

You can build the app from source or find the binaries [here](https://github.com/mawilms/lembas/releases)

To build the application from source, you have to install [Wails](https://wails.io/).

## FAQ

### **_Why the rewrite?_**

Initially Lembas was written in Rust, with Iced for the frontend. Due to some changes in my professional career, I
completely ditched Rust and switched to Go. For the frontend, I use Sveltekit which is really pleasant to work with. I'm
still in the Go learning phase and because I love Middle Earth, this is a good project to combine both worlds :blush:

### **_Where can I find the configs?_**

The settings can be found here:

Windows:

- `%APPDATA%\lembas`

## Contribute

Lembas is meant to be a community project. So anyone who wants to be part of Lembas is welcome. Any feedback is welcome!

You can open a Feature request or Bug issue [here](https://github.com/mawilms/lembas/issues/new/choose)

## Special thanks

I want to especially thank [@13r0ck](https://github.com/13r0ck) and [@hecrj](https://github.com/hecrj) from
the [Iced zulip server](https://iced.zulipchat.com). Both were very helpful and their tips were essential for this app.
I also want to thank [Thornbach](https://fungalmancy.netlify.app/) for the great icon
and [Casperstorm](https://github.com/casperstorm) for his great inspirational WoW plugin
manager [Ajour](https://github.com/ajour/ajour).

## License

Lembas is release under the [GNU GPLv3](https://github.com/mawilms/lembas/blob/main/LICENSE)
