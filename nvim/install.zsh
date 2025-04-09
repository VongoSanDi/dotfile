#!/usr/bin/env zsh

set -euo pipefail

# Dry-run mode
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🔍 Mode dry-run activé : aucune modification ne sera faite"
fi

echo "🖥️ Détection de la distribution..."
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  DISTRO=$ID
else
  echo "❌ Impossible de détecter la distribution"
  exit 1
fi

CONFIG_DIR="$HOME/.dotfile/nvim"
DEST_DIR="$HOME/.config"

# Fonction utilitaire d'installation
install_if_missing() {
  local pkg=$1
  if command -v "$pkg" &>/dev/null; then
    echo "✅ $pkg déjà installé"
  else
    echo "📦 Installation de $pkg..."
    $DRY_RUN || sudo pacman -S --noconfirm "$pkg"
  fi
}

echo "🛠️ Installation et configuration de Neovim ..."

echo "📦 Installation Neovim..."
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1

  sudo apt update
else
  echo "🛠️ Installation des outils Neovim et utilitaires"
  install_if_missing neovim
  install_if_missing lazygit
  install_if_missing ripgrep
  install_if_missing fzf
  install_if_missing fd

  if [[ ! -d "$CONFIG_DIR" ]]; then
    echo "❌ Le dossier de config Neovim n'existe pas : $CONFIG_DIR"
    exit 1
  fi

  echo "Suppression du dossier de base"
  rm -rf "$DEST_DIR/nvim"

  echo "🔗 Création du lien symbolique"
  $DRY_RUN || ln -s "$CONFIG_DIR" "$DEST_DIR/nvim"
fi

