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

CONFIG_DIR="$HOME/.dotfile/ashell"
DEST_CONFIG_DIR="$HOME/.config/ashell"

# Vérification et installation des dépendances
install_if_missing() {
  local pkg=$1
  if pacman -Q "$pkg" &>/dev/null; then
    echo "✅ $pkg déjà installé"
  else
    echo "📦 Installation de $pkg..."
    if pacman -Ss "^$pkg$" &>/dev/null; then
      $DRY_RUN || sudo pacman -S --noconfirm "$pkg"
    else
      echo "📦 $pkg non trouvé dans les dépôts officiels. Installation via paru..."
      $DRY_RUN || paru -S --noconfirm "$pkg"
    fi
  fi
}

# Installation de Ashell
install_packages() {
  install_if_missing ashell
}

# Copie de la configuration
copy_config() {
  if [[ ! -d "$CONFIG_DIR" ]]; then
    echo "❌ Le dossier de config Ashell n'existe pas : $CONFIG_DIR"
    exit 1
  fi

  echo "🔗 Création du lien symbolique vers ~/.config/ashell..."
  if $DRY_RUN; then
    echo "   ↪ rm -rf $DEST_CONFIG_DIR"
    echo "   ↪ ln -s $CONFIG_DIR $DEST_CONFIG_DIR"
  else
    rm -rf "$DEST_CONFIG_DIR"
    ln -s "$CONFIG_DIR" "$DEST_CONFIG_DIR"
  fi
}

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  install_packages
  copy_config
fi

# Terminé !
echo "✅ Installation et configuration de Ashell terminées."
