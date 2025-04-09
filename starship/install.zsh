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

# Installation de starship
install_starship() {
  install_if_missing starship
}

# Copie du fichier de configuration
copy_config() {
  if [[ ! -f "$CONFIG_DIR/starship.toml" ]]; then
    echo "❌ Fichier starship.toml introuvable dans $CONFIG_DIR"
    exit 1
  fi

  mkdir -p "$DEST_CONFIG_DIR"

  echo "🔗 Copie de la configuration starship.toml..."
  if $DRY_RUN; then
    echo "   ↪ cp $CONFIG_DIR/starship.toml $DEST_CONFIG_DIR/"
  else
    cp "$CONFIG_DIR/starship.toml" "$DEST_CONFIG_DIR/"
  fi
}

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  install_starship
  copy_config
fi

# Terminé !
echo "✅ Installation et configuration de starship terminées."
