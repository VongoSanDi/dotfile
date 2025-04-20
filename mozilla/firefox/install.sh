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

CONFIG_DIR="$HOME/.dotfile/mozilla/firefox"
DEST_CONFIG_DIR="$HOME/.mozilla/firefox"

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
  echo "📂 Configuration des fichiers liés aux apps mozilla → symlinks depuis $CONFIG_DIR"

  if [[ ! -d "$CONFIG_DIR" ]]; then
    echo "❌ Dossier $CONFIG_DIR introuvable"
    exit 1
  fi

  for file in "$CONFIG_DIR"/*; do
    filename=$(basename "$file")

    # Skip install.sh
    if [[ "$filename" == "install.sh" ]]; then
      echo "⚠️  Ignoré : $filename"
      continue
    fi

    if $DRY_RUN; then
      echo "   ↪ ln -s $file $DEST_CONFIG_DIR/$filename"
    else
      ln -sf "$file" "$DEST_CONFIG_DIR/$filename"
    fi
  done
}

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  install_if_missing mozilla
  copy_config
fi

# Terminé !
echo "✅ Installation et configuration de kitty terminées."
