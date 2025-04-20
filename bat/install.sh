#!/usr/bin/env bash

set -euo pipefail


# Mode dry-run
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🔍 Mode dry-run activé : aucune modification ne sera faite"
fi

# Détection distribution
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  DISTRO=$ID
else
  echo "❌ Impossible de détecter la distribution"
  exit 1
fi

CONFIG_DIR="$HOME/.dotfile/bat"
DEST_CONFIG_DIR="$HOME/.config/bat"

# Vérification et installation des dépendances
install_if_missing() {
  local pkg=$1
  if command -v "$pkg" &>/dev/null; then
    echo "✅ $pkg déjà installé"
  else
    echo "📦 Installation de $pkg..."
    $DRY_RUN || sudo pacman -S "$pkg"
  fi
}

copy_config() {
  echo "📂 Configuration de bat → symlinks depuis $CONFIG_DIR"

  if [[ ! -d "$CONFIG_DIR" ]]; then
    echo "❌ Dossier $CONFIG_DIR introuvable"
    exit 1
  fi

    echo "🔗 Création du lien symbolique vers ~/.config/bat..."
  if $DRY_RUN; then
    echo "   ↪ rm -rf $DEST_CONFIG_DIR"
    echo "   ↪ ln -s $CONFIG_DIR $DEST_CONFIG_DIR"
  else
    rm -rf "$DEST_CONFIG_DIR"
    ln -s "$CONFIG_DIR" "$DEST_CONFIG_DIR"
  fi

    echo "📥 Téléchargement des thèmes ..."
  if $DRY_RUN; then
    echo "   ↪ Téléchargement des thèmes"
  else
    mkdir -p "$DEST_CONFIG_DIR/themes"
    wget -P "$DEST_CONFIG_DIR/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Latte.tmTheme
    wget -P "$DEST_CONFIG_DIR/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Frappe.tmTheme
    wget -P "$DEST_CONFIG_DIR/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Macchiato.tmTheme
    wget -P "$DEST_CONFIG_DIR/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme

    # Rebuild du cache de bat
    bat cache --build
  fi
}

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  install_if_missing bat
  copy_config
fi

# Terminé !
echo "✅ Installation et configuration de bat terminées."
