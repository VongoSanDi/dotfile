#!/usr/bin/env zsh
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

CONFIG_DIR="$HOME/.dotfile/starship"
DEST_CONFIG_DIR="$HOME/.config"

# Vérification et installation des dépendances
install_if_missing() {
  local pkg=$1
  if command -v "$pkg" &>/dev/null; then
    echo "✅ $pkg déjà installé"
  else
    echo "📦 Installation de $pkg..."
    $DRY_RUN || sudo pacman -S --noconfirm "$pkg"
  fi
}

# Copie du fichier de configuration
copy_config() {
  local SOURCE_FILE="$CONFIG_DIR/starship.toml"
  local TARGET_FILE="$DEST_CONFIG_DIR/starship.toml"

  if [[ ! -f "$SOURCE_FILE" ]]; then
    echo "❌ Fichier introuvable : $SOURCE_FILE"
    exit 1
  fi

  echo "🔗 Lien symbolique : starship.toml → $DEST_CONFIG_DIR"

  if $DRY_RUN; then
    echo "   ↪ mkdir -p $DEST_CONFIG_DIR"
    echo "   ↪ ln -s $SOURCE_FILE $TARGET_FILE"
  else
    mkdir -p "$DEST_CONFIG_DIR"
    rm -f "$TARGET_FILE"
    ln -s "$SOURCE_FILE" "$TARGET_FILE"
  fi
}

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  install_if_missing starship
  copy_config
fi

# Terminé !
echo "✅ Installation et configuration de starship terminées."
