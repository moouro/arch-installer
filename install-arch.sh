#!/bin/bash

# Improved Arch Linux Installation Script with Gum UI
set -e

# Ensure gum is installed for the UI
if ! command -v gum &> /dev/null; then
    echo "Installing gum for the UI..."
    pacman -Sy --noconfirm gum
fi

# Define a style function for headers
header() {
    gum style --foreground 212 --border-foreground 212 --border double --align center --width 50 --margin "1 2" --padding "2 4" "$1"
}

header "Arch Linux Automated Installer"

# --- INTERACTIVE CONFIGURATION ---

# 1. Disk Selection
gum style --foreground 99 "Select the disk to install to:"
DISK_LIST=$(lsblk -d -n -o NAME,SIZE,TYPE,MODEL | grep "disk")
SELECTED_DISK_LINE=$(gum choose <<< "$DISK_LIST")
DISK="/dev/$(echo "$SELECTED_DISK_LINE" | awk '{print $1}')"

if [[ -z "$DISK" ]]; then
    gum style --foreground 196 "No disk selected. Exiting."
    exit 1
fi
gum style --foreground 46 "Selected Disk: $DISK"

# 2. Hostname
gum style --foreground 99 "Enter hostname:"
HOSTNAME=$(gum input --placeholder "arch-vm" --value "arch-vm")
HOSTNAME=${HOSTNAME:-arch-vm}

# 3. User setup
gum style --foreground 99 "Enter username:"
USERNAME=$(gum input --placeholder "moouro" --value "moouro")
USERNAME=${USERNAME:-moouro}

# 4. Passwords
gum style --foreground 99 "Enter password for $USERNAME:"
PASSWORD=$(gum input --password)
gum style --foreground 99 "Confirm password for $USERNAME:"
PASSWORD_CONFIRM=$(gum input --password)

if [ "$PASSWORD" != "$PASSWORD_CONFIRM" ]; then
    gum style --foreground 196 "Passwords do not match. Exiting."
    exit 1
fi

gum style --foreground 99 "Enter root password:"
ROOT_PASSWORD=$(gum input --password)
gum style --foreground 99 "Confirm root password:"
ROOT_PASSWORD_CONFIRM=$(gum input --password)

if [ "$ROOT_PASSWORD" != "$ROOT_PASSWORD_CONFIRM" ]; then
    gum style --foreground 196 "Passwords do not match. Exiting."
    exit 1
fi

# 5. Swap Size
# Get total RAM in GiB
RAM_GIB=$(free -g | awk '/^Mem:/{print $2}')
# Recommend 1x or 2x RAM depending on size. 4G is usually safe for small VMs.
RECOMMENDED_SWAP=$(( RAM_GIB > 4 ? 4 : RAM_GIB ))
if [ "$RECOMMENDED_SWAP" -eq 0 ]; then RECOMMENDED_SWAP=2; fi

gum style --foreground 99 "Enter swap size in GiB:"
SWAP_SIZE=$(gum input --placeholder "$RECOMMENDED_SWAP" --value "$RECOMMENDED_SWAP")
SWAP_SIZE=${SWAP_SIZE:-$RECOMMENDED_SWAP}

# 6. Graphics Driver Selection
gum style --foreground 99 "Select Graphics Driver:"
GRAPHICS_DRIVER_CHOICE=$(gum choose "Intel (Arc/Integrated)" "AMD (Radeon)" "Nvidia (Proprietary)" "Nvidia (Open)" "Nvidia (DKMS)" "VM/None (VirtIO/QXL)")

GRAPHICS_PACKAGES=""
case "$GRAPHICS_DRIVER_CHOICE" in
    "Intel (Arc/Integrated)")
        GRAPHICS_PACKAGES="mesa vulkan-intel intel-media-driver"
        ;;
    "AMD (Radeon)")
        GRAPHICS_PACKAGES="mesa vulkan-radeon xf86-video-amdgpu"
        ;;
    "Nvidia (Proprietary)")
        GRAPHICS_PACKAGES="nvidia nvidia-utils nvidia-settings"
        ;;
    "Nvidia (Open)")
        GRAPHICS_PACKAGES="nvidia-open nvidia-utils nvidia-settings"
        ;;
    "Nvidia (DKMS)")
        GRAPHICS_PACKAGES="nvidia-dkms nvidia-utils nvidia-settings"
        ;;
    "VM/None (VirtIO/QXL)")
        GRAPHICS_PACKAGES="mesa"
        ;;
esac

gum style --border normal --margin "1" --padding "1" \
"Configuration Summary:" \
"Disk:      $DISK" \
"Hostname:  $HOSTNAME" \
"Username:  $USERNAME" \
"Swap:      ${SWAP_SIZE}G" \
"Graphics:  $GRAPHICS_DRIVER_CHOICE ($GRAPHICS_PACKAGES)"

if ! gum confirm "Proceed with installation?"; then
    gum style --foreground 196 "Installation aborted."
    exit 0
fi

header "Starting installation..."

# 1. Partitioning (UEFI + Swap + Root)
# 1G EFI (ef00), Specified Swap (8200), Remainder Root (8300)
gum spin --title "Partitioning disk..." -- sleep 2
sgdisk --zap-all "$DISK"
sgdisk --new=1:0:+1G --typecode=1:ef00 --change-name=1:EFI "$DISK"
sgdisk --new=2:0:+${SWAP_SIZE}G --typecode=2:8200 --change-name=2:SWAP "$DISK"
sgdisk --new=3:0:0 --typecode=3:8300 --change-name=3:ROOT "$DISK"

# Handle optional 'p' in partition names (nvme)
PART_EFI="${DISK}1"
PART_SWAP="${DISK}2"
PART_ROOT="${DISK}3"
if [[ "$DISK" == *"nvme"* ]] || [[ "$DISK" == *"mmcblk"* ]]; then
    PART_EFI="${DISK}p1"
    PART_SWAP="${DISK}p2"
    PART_ROOT="${DISK}p3"
fi

# 2. Filesystems
gum spin --title "Formatting filesystems..." -- sleep 2
mkfs.fat -F32 "$PART_EFI"
mkswap "$PART_SWAP"
swapon "$PART_SWAP"
mkfs.ext4 "$PART_ROOT"

# 3. Mount
gum spin --title "Mounting partitions..." -- sleep 1
# Ensure /mnt is clean
umount -R /mnt 2>/dev/null || true
mount "$PART_ROOT" /mnt
mkdir -p /mnt/boot
# MOUNT WITH UMASK=0077 TO FIX SECURITY HOLE WARNING
mount -o fmask=0077,dmask=0077 "$PART_EFI" /mnt/boot

# 4. Install Base
# Add graphics packages to installation
PACKAGES="base linux linux-firmware base-devel networkmanager sudo git vi nano $GRAPHICS_PACKAGES"
gum spin --title "Installing core packages (this may take a while)..." -- pacstrap /mnt $PACKAGES

# 5. Generate fstab
# genfstab will include the mount options from the current mount (-o)
genfstab -U /mnt >> /mnt/etc/fstab

# 6. Chroot configuration
gum spin --title "Configuring system..." -- sleep 1

# Pre-calculate PARTUUID to avoid blkid issues inside chroot
PARTUUID_ROOT=$(blkid -s PARTUUID -o value "$PART_ROOT")

arch-chroot /mnt /bin/bash <<EOF
ln -sf /usr/share/zoneinfo/UTC /etc/localtime
hwclock --systohc
echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf
echo "$HOSTNAME" > /etc/hostname
echo "127.0.0.1 localhost" >> /etc/hosts
echo "::1       localhost" >> /etc/hosts
echo "127.0.1.1 $HOSTNAME.localdomain $HOSTNAME" >> /etc/hosts

# Root and User setup
useradd -m -G wheel "$USERNAME"
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

# Bootloader
bootctl install
echo "default arch" > /boot/loader/loader.conf
echo "timeout 3" >> /boot/loader/loader.conf

echo "title Arch Linux" > /boot/loader/entries/arch.conf
echo "linux /vmlinuz-linux" >> /boot/loader/entries/arch.conf
echo "initrd /initramfs-linux.img" >> /boot/loader/entries/arch.conf
echo "options root=PARTUUID=$PARTUUID_ROOT rw" >> /boot/loader/entries/arch.conf

# ENABLE NETWORKMANAGER
systemctl enable NetworkManager

# Configure Mkinitcpio for Nvidia if selected
if [[ "$GRAPHICS_DRIVER_CHOICE" == *"Nvidia"* ]]; then
    sed -i 's/MODULES=()/MODULES=(nvidia nvidia_modeset nvidia_uvm nvidia_drm)/' /etc/mkinitcpio.conf
    mkinitcpio -P
    # Add nvidia_drm.modeset=1 for Wayland support
    sed -i '/options root=/ s/$/ nvidia_drm.modeset=1/' /boot/loader/entries/arch.conf
fi
EOF

# Use printf to securely set passwords (avoids shell expansion/interpretation issues)
printf "root:%s" "$ROOT_PASSWORD" | arch-chroot /mnt chpasswd
printf "%s:%s" "$USERNAME" "$PASSWORD" | arch-chroot /mnt chpasswd

sync
umount -R /mnt
header "Arch Linux installed successfully! Please reboot."
