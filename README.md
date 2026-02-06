# Arch Linux Installer & DMS Setup

Scripts interativos para instalar o Arch Linux em **Hardware ou VMs** e configurar um ambiente moderno com Hyprland e **Dank Material Shell (DMS)**.

> 🙏 **Créditos**: Este projeto é um fork de [r3dg0d/arch-installer](https://github.com/r3dg0d/arch-installer). Obrigado ao autor original pela base do projeto!

## Funcionalidades

### 🖥️ Instalação Base (`install-arch.sh`)
- **Interface Gum TUI**: Interface visual bonita no terminal
- **Configuração Interativa**: Escolha timezone, idioma, filesystem e driver gráfico
- **Opções de Filesystem**: ext4 (estável) ou BTRFS (com suporte a snapshots)
- **Suporte a Drivers**: Intel, AMD, Nvidia (Proprietário/Open/DKMS) e VM (VirtIO)
- **Validação de Disco**: Aviso antes de apagar discos com dados existentes
- **Dependências de Build**: Pacotes pré-instalados para Node.js, Erlang, Elixir, Go, Rust, Ruby
- **Logs de Instalação**: Salvos em `/tmp/arch-install.log` para debug

### 🎨 Configuração Desktop (`setup-dms.sh`)
- **Hyprland**: Compositor Wayland moderno com tiling
- **DMS Shell**: Shell inspirado no Material Design 3
- **Teclado US International**: Pré-configurado para acentos
- **Nerd Fonts**: JetBrainsMono para ícones no terminal
- **Bluetooth**: Suporte opcional (perguntado durante a instalação)
- **Apps Opcionais**: Escolha entre Firefox, VS Code, Discord, Spotify, Telegram, Thunar, VLC
- **Backup de Configs**: Backup automático de configurações existentes

## Como Usar

### 1. Instalação Base
Execute este script dentro do ambiente live ISO do Arch Linux.
```bash
curl -O https://raw.githubusercontent.com/moouro/arch-installer/master/install-arch.sh
chmod +x install-arch.sh
./install-arch.sh
```

### 2. Configuração Desktop & DMS
Após reiniciar no novo sistema, execute este script para instalar o Hyprland e DMS.
```bash
curl -O https://raw.githubusercontent.com/moouro/arch-installer/master/setup-dms.sh
chmod +x setup-dms.sh
./setup-dms.sh
```

## Atalhos
- `SUPER + ENTER`: Abrir terminal Ghostty
- `SUPER + Q`: Fechar janela ativa

## Pacotes Incluídos

### Instalação Base
- **Core**: `base`, `linux`, `linux-firmware`, `base-devel`, `networkmanager`
- **Gráficos**: Auto-configurados (Mesa, Nvidia, etc.)
- **Dev Tools**: `clang`, `openssl`, `zlib`, `readline`, `ncurses`, `libffi`, `libyaml`, `autoconf`, `automake`, `bison`

### Configuração Desktop
- **Shell**: Dank Material Shell, DMS Greeter (via `greetd`)
- **Utilitários**: `dsearch`, `dgop`, `khal`, `power-profiles-daemon`, `cliphist`, `cava`, `matugen`
- **Áudio**: Pipewire (pulse, alsa, jack) + Wireplumber
- **Fontes**: JetBrainsMono Nerd Font

---

## Créditos

Este projeto é um fork de **[r3dg0d/arch-installer](https://github.com/r3dg0d/arch-installer)**.

Agradeço ao autor original pelo trabalho incrível na criação dos scripts base. As modificações feitas neste fork incluem melhorias de UX, suporte a BTRFS, seleção interativa de timezone/locale, e pacotes adicionais para desenvolvimento.
