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

CONFIG_DIR="$HOME/.dotfile/nushell/"
DEST_CONFIG_DIR="$HOME/.config/nushell/"

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
  echo "📂 Configuration de nushell → symlinks depuis $CONFIG_DIR"

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
      echo "   ↪ cp $file $DEST_CONFIG_DIR/$filename"
    else
      cp "$file" "$DEST_CONFIG_DIR/$filename"
    fi
  done
}

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  install_if_missing nushell
  copy_config
fi

if [[ "$SHELL" != *nu ]]; then
  echo "🔁 Changement de shell par défaut vers Nushell..."

  if chsh -s "$(which nu)" 2>/dev/null; then
    echo "✅ Shell changé avec succès sans sudo."
  elif sudo -v && sudo chsh -s "$(which nu)"; then
    echo "✅ Shell changé avec succès avec sudo."
  else
    echo "❌ Échec du changement de shell. Essaie manuellement : chsh -s $(which nu)"
  fi

  echo "ℹ️  Redémarre ta session ou ton terminal pour que Nushell soit actif."
else
  echo "✅ Nushell est déjà ton shell par défaut."
fi
