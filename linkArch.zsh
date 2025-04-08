#!/usr/bin/env zsh

set -e  # Stoppe le script en cas d’erreur

echo "🔗 Création des liens symboliques depuis ~/.dotfile..."

# ──────────────────────────────────────────────
# 🔁 Fonctions utilitaires
# ──────────────────────────────────────────────

link() {
  local src="$1"
  local dest="$2"
  echo "🔗 $dest → $src"
  rm -rf "$dest"
  ln -s "$src" "$dest"
}

# ──────────────────────────────────────────────
# 🧠 ZSH
# ──────────────────────────────────────────────
echo "🔗 Liens Zsh..."
link ~/.dotfile/zsh/.zshrc ~/.zshrc
link ~/.dotfile/zsh/.zshenv ~/.zshenv
link ~/.dotfile/zsh/.zcompdump ~/.zcompdump
mkdir -p ~/.config/zsh
link ~/.dotfile/zsh/plugins ~/.config/zsh/plugins
echo "✔️ Zsh OK"

# ──────────────────────────────────────────────
# 🔮 Starship
# ──────────────────────────────────────────────
echo "🔗 Lien Starship..."
mkdir -p ~/.config
link ~/.dotfile/starship/starship.toml ~/.config/starship.toml
echo "✔️ Starship OK"

# ──────────────────────────────────────────────
# 📝 Neovim
# ──────────────────────────────────────────────
echo "🔗 Lien Neovim..."
link ~/.dotfile/nvim ~/.config/nvim
echo "✔️ Neovim OK"

# ──────────────────────────────────────────────
# 🖥️ Kitty
# ──────────────────────────────────────────────
echo "🔗 Lien Kitty..."
link ~/.dotfile/kitty ~/.config/kitty
echo "✔️ Kitty OK"

# ──────────────────────────────────────────────
# 🧙 Hyprland
# ──────────────────────────────────────────────
echo "🔗 Lien Hyprland..."
link ~/.dotfile/hypr ~/.config/hypr
echo "✔️ Hyprland OK"

# ──────────────────────────────────────────────
# 🌍 Portals
# ──────────────────────────────────────────────
echo "🔗 Lien xdg portals.conf..."
sudo mkdir -p /etc/xdg
sudo rm -f /etc/xdg/portals.conf
sudo ln -s ~/.dotfile/xdg/portals.conf /etc/xdg/portals.conf
echo "✔️ Portals OK"

echo "🎉 Tous les dotfiles ont été liés avec succès."

