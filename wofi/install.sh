#!/usr/bin/env bash

set -euo pipefail

# Mode dry-run
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🔍 Mode dry-run activé : aucune modification ne sera faite"
fi

# Détection de la distribution
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  DISTRO=$ID
else
  echo "❌ Impossible de détecter la distribution"
  exit 1
fi

CONFIG_DIR="$HOME/.dotfile/wofi"
DEST_CONFIG_DIR="$HOME/.config/wofi"
REPO_URL="https://github.com/quantumfate/wofi"

# Fonction pour installer les paquets si manquants
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

# Fonction d'installation du thème Wofi Catppuccin
install_theme() {
  if [[ ! -d "$DEST_CONFIG_DIR/.git" ]]; then
    echo "📥 Clonage du thème depuis GitHub..."
    if $DRY_RUN; then
      echo "   ↪ git clone $REPO_URL $DEST_CONFIG_DIR"
    else
      git clone --depth=1 "$REPO_URL" "$DEST_CONFIG_DIR"
    fi
  else
    echo "✅ Thème Catppuccin-Wofi déjà présent, skip clone."
  fi

  echo "🔗 Création du lien symbolique vers ~/.config/wofi/config/config"
  if $DRY_RUN; then
    echo "   ↪ ln -sf $CONFIG_DIR/config/config $DEST_CONFIG_DIR/config/config"
  else
    if [[ ! -d "$DEST_CONFIG_DIR" ]]; then
      echo "❌ Le dossier $DEST_CONFIG_DIR est manquant. Clonage probablement échoué."
      exit 1
    fi
    ln -sf "$CONFIG_DIR/config/config" "$DEST_CONFIG_DIR/config/config"
  fi
}

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  install_if_missing wofi
  install_theme
fi

# Terminé !
echo "✅ Installation et configuration de Wofi Catppuccin terminées."
