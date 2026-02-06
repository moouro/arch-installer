# Arch Linux Installer & DMS Setup

Interactive scripts for installing Arch Linux on **Hardware or VMs** and setting up a modern Hyprland environment with **Dank Material Shell (DMS)**.

## Features
- **Gum TUI**: A beautiful terminal interface for configuration via `gum`.
- **Driver Support**: Built-in support for Intel (Arc/Integrated), AMD (Radeon), Nvidia (Proprietary/Open/DKMS), and VM (VirtIO) graphics.
- **Hardware & VM Compatible**: Handles NVMe/SATA partitioning and bootloader setup automatically.
- **Modern Desktop**: Installs Hyprland with the Material Design 3 inspired Dank Material Shell.
- **Full Tooling**:
    - `power-profiles-daemon` for power management.
    - `dsearch` and `dgop` for shell features.
    - `khal` for calendar.
    - `Ghostty` as the default terminal.
    - `yay` as AUR helper.

## How to Use

### 1. Base Installation
Run this script inside the Arch Linux live ISO environment.
```bash
curl -O https://raw.githubusercontent.com/moouro/arch-installer/master/install-arch.sh
chmod +x install-arch.sh
./install-arch.sh
```

### 2. Desktop & DMS Setup
After rebooting into your new system, run this script to install Hyprland and DMS.
```bash
curl -O https://raw.githubusercontent.com/moouro/arch-installer/master/setup-dms.sh
chmod +x setup-dms.sh
./setup-dms.sh
```

## Shortcuts
- `SUPER + ENTER`: Open Ghostty terminal
- `SUPER + Q`: Close active window (killactive)

## Included Packages
- **Shell**: Dank Material Shell, DMS Greeter (via `greetd`)
- **Utilities**: `dsearch`, `dgop`, `khal`, `power-profiles-daemon`, `cliphist`, `cava`, `matugen`
- **Graphics**: Auto-configured based on your hardware selection (Mesa, Nvidia, etc.).
