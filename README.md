# Arch Linux Installer & DMS Setup

Interactive scripts for installing Arch Linux on **Hardware or VMs** and setting up a modern Hyprland environment with **Dank Material Shell (DMS)**.

## Features

### 🖥️ Base Installation (`install-arch.sh`)
- **Gum TUI**: Beautiful terminal interface for configuration
- **Interactive Setup**: Choose timezone, locale, filesystem, and graphics driver
- **Filesystem Options**: ext4 (stable) or BTRFS (with snapshots support)
- **Driver Support**: Intel, AMD, Nvidia (Proprietary/Open/DKMS), and VM (VirtIO)
- **Disk Validation**: Warning before erasing disks with existing data
- **Build Dependencies**: Pre-installed packages for Node.js, Erlang, Elixir, Go, Rust, Ruby
- **Installation Logs**: Saved to `/tmp/arch-install.log` for debugging

### 🎨 Desktop Setup (`setup-dms.sh`)
- **Hyprland**: Modern Wayland tiling compositor
- **DMS Shell**: Material Design 3 inspired desktop shell
- **US International Keyboard**: Pre-configured for accents
- **Nerd Fonts**: JetBrainsMono for terminal icons
- **Bluetooth**: Optional support (prompted during setup)
- **Optional Apps**: Choose from Firefox, VS Code, Discord, Spotify, Telegram, Thunar, VLC
- **Config Backup**: Automatic backup of existing configs

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
- `SUPER + Q`: Close active window

## Included Packages

### Base Installation
- **Core**: `base`, `linux`, `linux-firmware`, `base-devel`, `networkmanager`
- **Graphics**: Auto-configured (Mesa, Nvidia, etc.)
- **Dev Tools**: `openssl`, `zlib`, `readline`, `ncurses`, `libffi`, `libyaml`, `autoconf`, `automake`, `bison`

### Desktop Setup
- **Shell**: Dank Material Shell, DMS Greeter (via `greetd`)
- **Utilities**: `dsearch`, `dgop`, `khal`, `power-profiles-daemon`, `cliphist`, `cava`, `matugen`
- **Audio**: Pipewire (pulse, alsa, jack) + Wireplumber
- **Fonts**: JetBrainsMono Nerd Font
