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

CONFIG_DIR="$HOME/.dotfile/kitty"
DEST_CONFIG_DIR="$HOME/.config/kitty"

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

# Installation de kitty
install_kitty() {
  install_if_missing kitty
}

# Copie de la configuration
copy_config() {
  if [[ ! -f "$CONFIG_DIR/kitty.conf" ]]; then
    echo "❌ Fichier kitty.conf introuvable dans $CONFIG_DIR"
    exit 1
  fi

  echo "📂 Suppression de l'ancienne configuration kitty..."
  if $DRY_RUN; then
    echo "   ↪ rm -rf $DEST_CONFIG_DIR"
  else
    rm -rf "$DEST_CONFIG_DIR"
  fi

  echo "📁 Création du dossier de destination..."
  if $DRY_RUN; then
    echo "   ↪ mkdir -p $DEST_CONFIG_DIR"
  else
    mkdir -p "$DEST_CONFIG_DIR"
  fi

  echo "🔗 Copie des fichiers de configuration..."
  for file in kitty.conf current-theme.conf; do
    if [[ -f "$CONFIG_DIR/$file" ]]; then
      if $DRY_RUN; then
        echo "   ↪ cp $CONFIG_DIR/$file $DEST_CONFIG_DIR/"
      else
        cp "$CONFIG_DIR/$file" "$DEST_CONFIG_DIR/"
      fi
    else
      echo "⚠️  Fichier manquant : $file"
    fi
  done
}

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  install_kitty
  copy_config
fi

# Terminé !
echo "✅ Installation et configuration de kitty terminées."
