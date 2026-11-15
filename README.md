# Kairo releases

Installers for Kairo, the real-time call assistant, for Windows and macOS.

| System | Download |
|---|---|
| Windows 10 or 11, 64-bit | [Kairo-Setup.exe](https://github.com/NikhilDendeti/kairo-releases/releases/latest/download/Kairo-Setup.exe) |
| macOS 13 or newer, Apple Silicon (M1 and later) | [Kairo-mac-arm64.dmg](https://github.com/NikhilDendeti/kairo-releases/releases/latest/download/Kairo-mac-arm64.dmg) |
| macOS 13 or newer, Intel | [Kairo-mac-x64.dmg](https://github.com/NikhilDendeti/kairo-releases/releases/latest/download/Kairo-mac-x64.dmg) |

The macOS version is new. If something does not work, please tell us through the
Contact page on the Kairo website.

## Windows

Paste this into PowerShell:

```powershell
irm https://raw.githubusercontent.com/NikhilDendeti/kairo-releases/main/install.ps1 | iex
```

It downloads the newest installer, checks it against the checksum published with that release,
installs it for your Windows account (no administrator prompt) and starts Kairo.

Or download the installer directly:
[Kairo-Setup.exe](https://github.com/NikhilDendeti/kairo-releases/releases/latest/download/Kairo-Setup.exe)

Kairo updates itself after that.

## macOS

1. Download the file for your Mac's chip:
   [Apple Silicon](https://github.com/NikhilDendeti/kairo-releases/releases/latest/download/Kairo-mac-arm64.dmg)
   or [Intel](https://github.com/NikhilDendeti/kairo-releases/releases/latest/download/Kairo-mac-x64.dmg).
   Not sure which? Apple menu > About This Mac: "Chip: Apple M..." is Apple Silicon,
   "Processor: Intel" is Intel.
2. Open the downloaded file and drag Kairo to Applications.
3. Open Kairo. macOS blocks it the first time, because Kairo for Mac is not yet signed with an
   Apple developer certificate. Go to System Settings > Privacy & Security and choose
   **Open Anyway**.
4. Allow the microphone when macOS asks, and switch Kairo on under Privacy & Security >
   **Screen & System Audio Recording**. Then quit Kairo and open it again. Kairo needs both to
   hear the call.

Good to know:

- **Updates are not automatic.** Kairo tells you when a new version is out. Download it and
  replace the copy in Applications. macOS may ask for the permissions again after an update.
- **Hiding Kairo from screen shares is not confirmed on macOS yet.** Do a test share before you
  rely on it.
