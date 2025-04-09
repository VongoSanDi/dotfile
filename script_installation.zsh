#!/usr/bin/env zsh

# ===============================
# 📦 Installation des paquets utiles
# ===============================
echo "➡️  Installation des paquets supplémentaires..."

sudo pacman -S --needed \
  bat eza \
  pipewire pipewire-audio pipewire-alsa wireplumber \
  ttf-jetbrains-mono-nerd \
  kitty zsh git base-devel \
  starship curl wget unzip \
  nodejs npm

# ===============================
# 🔧 Installation de paru (AUR helper)
# ===============================
echo "➡️  Installation de paru (AUR)..."

mkdir -p ~/Downloads/paru
cd ~/Downloads/paru
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si

# ===============================
# 🌐 Audio + Wayland + Hyprland
# ===============================
echo "➡️  Installation d'Hyprland et dépendances..."

sudo pacman -S --needed \
  hyprland wl-clipboard \
  xdg-desktop-portal-hyprland \
  xdg-desktop-portal \
  wayland-protocols

echo "➡️  Installation d'eww (barre customisable)..."
sudo pacman -S eww-wayland

# Mise à jour du cache des polices
echo "➡️  Mise à jour du cache des polices..."
fc-cache -fv
fc-list | grep "JetBrainsMono Nerd Font Mono"

# Exemple de config eww à faire manuellement
# nvim ~/.config/eww/style.css
# * {
#   font-family: "JetBrainsMono Nerd Font Mono";
#   font-size: 12px;
# }

# ===============================
# 🔊 Activation audio PipeWire
# ===============================
echo "➡️  Activation des services PipeWire..."
systemctl --user enable --now pipewire wireplumber

# ===============================
# 🔐 Sécurité & utilitaires
# ===============================

echo "➡️  Installer un firewall (nftables)..."
sudo pacman -S --needed nftables
sudo systemctl enable nftables

echo "➡️  Installer dnscrypt-proxy (sans systemd-resolved !)..."
sudo pacman -S --needed dnscrypt-proxy

# ===============================
# ⚡️ Environnement de travail moderne
# ===============================
echo "➡️  Installation de bun (runtime JS rapide)..."
curl -fsSL https://bun.sh/install | bash

# ===============================
# 📸 Utilitaires Wayland
# ===============================
echo "➡️  Installation de wofi, grim et slurp..."
sudo pacman -S --needed wofi grim slurp

# ===============================
# 📁 Gestion des dotfiles (à adapter selon ton setup)
# ===============================
echo "➡️  N'oublie pas de faire les liens symboliques vers tes dotfiles !"
# Exemple : ln -s ~/.dotfile/zsh/.zshrc ~/.zshrc

echo "✅ Post-installation terminée !"
