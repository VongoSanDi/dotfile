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

CONFIG_DIR="$HOME/.dotfile/yazi"
DEST_CONFIG_DIR="$HOME/.config/yazi"

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
  echo "📂 Configuration de Yazi → symlinks depuis $CONFIG_DIR"

  if [[ ! -d "$CONFIG_DIR" ]]; then
    echo "❌ Dossier $CONFIG_DIR introuvable"
    exit 1
  fi

  if $DRY_RUN; then
    echo "   ↪ rm -rf $DEST_CONFIG_DIR"
    echo "   ↪ mkdir -p $DEST_CONFIG_DIR"
  else
    rm -rf "$DEST_CONFIG_DIR"
    mkdir -p "$DEST_CONFIG_DIR"
  fi

  for file in "$CONFIG_DIR"/*; do
    filename=$(basename "$file")

    # Skip install.zsh
    if [[ "$filename" == "install.zsh" ]]; then
      echo "⚠️  Ignoré : $filename"
      continue
    fi

    if $DRY_RUN; then
      echo "   ↪ ln -sf $file $DEST_CONFIG_DIR/$filename"
    else
      ln -sf "$file" "$DEST_CONFIG_DIR/$filename"
    fi
  done
}

install_flavor() {
  ya pkg add yazi-rs/flavors:catppuccin-macchiato
}

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  install_if_missing yazi
  install_flavor
  copy_config
fi

# Terminé !
echo "✅ Installation et configuration de kitty terminées."
