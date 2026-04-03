# TODO
Install TLP libreofice-fresh

# Set the console keyboard layout and font
localectl list-keymaps
loadkeys fr

## Persistent configuration
echo "KEYMAP=fr" > /etc/vconsole.conf

# Partitionnement
fdisk -l -> We need to find the right disk (in my case I have only one storage unit and usually the name is nvme0n1 )

sudo fdisk /dev/nvme0n1

## Create a new GPT partition
g

## Create an EFI partition
n
  Partition number: 1
  First sector: Entrée
  Last sector: +1G

## Change the type of the partition to EFI
t
  Partition number: 1
  Hex code: 1       ← EFI System

## Now we will create a new root partition(/)
n
  Partition number: 2
  First sector: Entrée
  Last sector: +100G

## Change the type of the partition to Linuxroot (x86_64)
t
  Partition number: 2
  Hex code: 23

## New we will create the swap partition
n
  Partition number: 3
  First sector: Entrée
  Last sector: +4G

## Change the type of the partition
t
  Partition number: 3
  Hex code: 19      ← Linux swap

## Create a new home partition(/home)
n
  Partition number: 4
  First sector: Entrée
  Last sector: Entrée  ← (Use the remaining disk space)

## Change the type of the partition to Linux home
t
  Partition number: 4
  Hex code: 42

## Display the table to check
p

## Write and quit
w

# Partition formatting
sudo mkfs.fat -F32 /dev/nvme0n1p1        # EFI
sudo mkfs.ext4 /dev/nvme0n1p2            # root
sudo mkswap /dev/nvme0n1p3               # swap
sudo mkfs.ext4 /dev/nvme0n1p4            # home
sudo swapon /dev/nvme0n1p3

# Partition mounting
sudo mount /dev/nvme0n1p2 /mnt                    # root
sudo mkdir /mnt/boot                              # EFI
sudo mount /dev/nvme0n1p1 /mnt/boot
sudo mkdir /mnt/home                              # home
sudo mount /dev/nvme0n1p4 /mnt/home               # activate swap

# Essential packages to install
pacstrap -K /mnt base linux linux-firmware intel-ucode iwd sudo man-db man-pages # If we have internet, we can add neovim git

# fstab generation
genfstab -U /mnt >> /mnt/etc/fstab

# Enter in chroot
arch-chroot /mnt

# Install basic packages in the chroot
pacman -S tlp dhcpd wl-clipboard cliphist

# Forbid non-root users to read the kernel
chmod 700 /boot

# Create the user
useradd -m -G wheel -s /bin/bash <your_pseudo>
passwd <your_pseudo>

# Create the password for root
passwd

# Define neovim as the default text editor
EDITOR=nvim 

# In visudo add our user
visudo
<your_pseudo>   ALL=(ALL:ALL) ALL

# Sudo protection in visudo
Defaults timestamp_timeout=5      # Expire sudo after 5 minutes
Defaults passwd_timeout=1         # Set a limit of 1s between each incorrect sudo password

# Timezone
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

# Locale
nvim /etc/locale.gen   ← Uncomment `en_US.UTF-8 UTF-8`
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Enable iwd & dhcpcd
systemctl enable iwd
systemctl enable dhcpcd

# Connecting to wifi
## If the interface is shutdown
rfkill unblock wifi

iwctl

# In the CLI iwctl
device list -> Find the interface name of our wifi device
station <interface_name> scan
station <interface_name> get-networks
station <interface_name> connect NETWORK_NAME -> Here, tab works
station <interface_name> show
exit
ping archlinux.org


# booloader installation (systemd-boot is more recent and light)
bootctl install

# Create the config file for systemd-boot
touch /boot/loader/entries/arch.conf

# Find the PARTUUID of / partition et the UUID of the swap partition
blkid -> Following the partitioning I did, it should be /dev/nvme0n1p2
lsblk -f | grep swap -> To find the swap partition UUID

# This is what need to be written in /boot/loader/entries/arch.conf
```
```
```
title   Arch Linux Zen
linux   /vmlinuz-linux-zed
initrd  /intel-ucode.img
initrd  /initramfs-linux-zen.img
options root=PARTUUID=XXXX rw i915.enable_psr=1 i915.enable_fbc=1 i915.enable_guc=2 quiet resume=PARTUUID=XXXX # Ne pas oublier le rw apres le PARTUUID, il faut ajouter le quiet et resume si on est pas en hardened
```
```
```

# In /etc/mkinitcpio.conf
HOOKS=(base udev autodetect microcode modconf kms keyboard keymap consolefont block resume filesystems fsck)

# Regenerate initramfs
mkinitcpio -P

# Config file for arch startup creation
```
```
```
touch /boot/loader/loader.conf
```

# Write in /boot/loader/loader.conf
```
default arch
timeout 3
editor no
console-mode max
```

# Get out of chroot
exit
unmount -R /mnt
reboot

# After installation
## Font

## Limit journal max size
In /etc/systemd/journald.conf
```
SystemMaxUse=150M
```
```
```
```
```

# Credit
Thanks to Pahasara who game me the idea of this guide: https://raw.githubusercontent.com/Pahasara/My-Linux-Journey/main/My%20Linux%20Journey.pdf
