<div align="center">

<img src="Sources/CleanBRUH/Resources/AppIcon.iconset/icon_256x256@2x.png" width="128" alt="CleanBRUH icon" />

# CleanBRUH

**Clean your Mac without triggering keys, clicks or gestures by accident.**

[![Download for macOS](https://img.shields.io/badge/Download_for_macOS-0071E3?style=for-the-badge&logo=apple&logoColor=white)](https://github.com/pablo96sancho/CleanBRUH/releases/latest/download/CleanBRUH-Installer.dmg)

![Version](https://img.shields.io/github/v/release/pablo96sancho/CleanBRUH?style=flat-square&label=version&color=000000)
![macOS 13+](https://img.shields.io/badge/macOS-13%2B-000000?style=flat-square&logo=apple&logoColor=white)
![Apple Silicon](https://img.shields.io/badge/Apple_Silicon-M1%2B-000000?style=flat-square)
![MIT License](https://img.shields.io/badge/license-MIT-000000?style=flat-square)

[🇪🇸 Versión en español](./README.md)

</div>

<br />

<p align="center">
  <img src="cover.jpg" width="720" alt="CleanBRUH's cleaning mode active on a MacBook screen" />
</p>

CleanBRUH is a menu bar app that temporarily locks the keyboard, mouse and trackpad, so
you can clean your Mac without typing, opening apps or changing the volume by mistake.
The interface is in Spanish.

## Features

- 🧹 Turns on with one click from the menu bar.
- ⌨️ Locks the keyboard, mouse and trackpad instantly, including shortcuts and function keys.
- ⏱️ To unlock, hold the **space bar for 3 seconds**.
- 💻 Native and lightweight: written in Swift, no dependencies.

## Installation

1. [Download the installer](https://github.com/pablo96sancho/CleanBRUH/releases/latest/download/CleanBRUH-Installer.dmg).
2. Open it and drag **CleanBRUH.app** to **Applications**.
3. Launch it. It will appear in the menu bar.

### First launch

The app isn't signed with an Apple Developer account, so macOS blocks it the first time.
To open it:

1. Try to open CleanBRUH and close the warning (don't move it to the Trash).
2. Go to **System Settings → Privacy & Security**.
3. Under **Security**, click **Open Anyway** next to the message about CleanBRUH.
4. Confirm with your password or Touch ID. You only need to do this once.

<details>
<summary>Alternative using Terminal</summary>

```bash
xattr -dr com.apple.quarantine /Applications/CleanBRUH.app
```

</details>

### Permissions

CleanBRUH uses a macOS `event tap` to block input, so it needs **Accessibility**
permission: *System Settings → Privacy & Security → Accessibility*.

## Development

Requirements: macOS 13 or later, Xcode 15+ (or the Command Line Tools) and Swift 5.9+.

```bash
./build_and_run.sh   # builds and opens the app
./create_dmg.sh      # creates CleanBRUH-Installer.dmg
```

Every GitHub Release publishes the DMG automatically with GitHub Actions.

## License

[MIT](LICENSE) © Pablo Sancho
