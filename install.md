# Installation
This guide is written for me to remember how to install ArchLinux easy and if it can help other people, this guide served it's purpose

# My Windows/Linux journey
I think, as everyone I had my first computer with Windows installed, for me it was Windows 98. Then XP, then Vista, then 7. During My Windows 7 era, at school I learned about Ubuntu and the Linux environment. But at that time i still kept Windows for my personal use. Then when Windows 8 arrived, I swapped on my personal computed, but I installed Ubuntu on my laptop. After a few years of Ubuntu, i changed to Debian. On both my laptop and big PC. Ubuntu was too heavy, too useless things installed that I didn't need and also I spent too many times playing video games(damn League) and not much working on it. I used the main branch of Debian then swapped to Sid, because i need up to date packages. But after a few years of use, tweaks, I wanted some change, some new challenge. I already heard about Arch and Hyprland and about how you can customize it to look exactly how you want, the install is minimal and light. So I decided to install it, At first first I failed, but after a few tries, I succeeded. Big up to my current laptop because I reinstalled so many OS with him.

# Introduction
If you want to follow this guide, please try to understand what each line do and why it does that. For the install part I followed the tutorial from the Arch wiki https://wiki.archlinux.org/title/Installation_guide#

# Why Hyprland ?
On Ubuntu and Debian I always used Gnome, it was good and beautiful, but like Ubuntu, it came with too many apps pre-installed. I think I could have just installed the window manager and the utilities apps separately but I already decided to change to Hyprland.

# PC configuration
Dell XPS 15 7590
16Go RAM
1 NVME To

# Keyboard
loadkeys fr

# Partitionnement
fdisk -l -> We need to find the right disk (in my case I have only one storage unit and usually the name is nvme0n1 )

sudo fdisk /dev/nvme0n1

g                   ← Create a new GPT partition

n                   ← Create an EFI partition
  Partition number: 1
  First sector: Entrée
  Last sector: +1G

t                   ← Change the type of the partition
  Partition number: 1
  Hex code: 1       ← EFI System

n                   ← Now we will create a new root partition(/)
  Partition number: 2
  First sector: Entrée
  Last sector: +100G

n                   ← New we will create the swap partition
  Partition number: 3
  First sector: Entrée
  Last sector: +4G

t                   ← Change the type of the partition
  Partition number: 3
  Hex code: 19      ← Linux swap

n                   ← Create a new home partition(/home)
  Partition number: 4
  First sector: Entrée
  Last sector: Entrée  ← (Use the remaining disk space)

p                   ← Display the table to check
w                   ← Write and quit

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
sudo mount /dev/nvme0n1p4 /mnt/home

# Essential packages to install
# intel-ucore -> Intel processors fixes
# iwd -> Wifi manager
pacstrap -K /mnt base linux-hardened linux-firmware intel-ucode iwd neovim sudo man-db man-pages git

# TLP: Optimize Linux Laptop Battery Life
This package is provided by arch, it helps improve the laptop battery life
systemctl enable tlp

# fstab generation
genfstab -U /mnt >> /mnt/etc/fstab

# Enter in chroot
arch-chroot /mnt

# Forbid non-root users to read the kernel
chmod 700 /boot

# Create the user
useradd -m -G wheel -s /bin/zsh <your_name>
passwd <your_name>

# Create the password for root
passwd

# Define neovim as the default text editor
EDITOR=nvim visudo

# In visudo add our user
<ton_nom>   ALL=(ALL:ALL) ALL

# Sudo protection
Defaults timestamp_timeout=5      # Expire sudo after 5 minutes
Defaults passwd_timeout=1         # Set a limit of 1s between each incorrect sudo password

# Timezone
ln -sf /usr/share/zoneinfo/Europe/Paris /etc/localtime
hwclock --systohc

# Locale
nvim /etc/locale.gen   ← Uncomment `en_US.UTF-8 UTF-8`
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

# Enable the keyboard in the TTY
echo "KEYMAP=fr" > /etc/vconsole.conf

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
title   Arch Linux Hardened
linux   /vmlinuz-linux-hardened
initrd  /intel-ucode.img
initrd  /initramfs-linux-hardened.img
options root=PARTUUID=XXXX rw i915.enable_psr=1 i915.enable_fbc=1 i915.enable_guc=2 # Ne pas oublier le rw apres le PARTUUID, il faut ajouter le quiet et resume si on est pas en hardened
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
