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

CONFIG_DIR="$HOME/.dotfile/starship"
DEST_CONFIG_DIR="$HOME/.config"

# Vérification et installation de starship
install_starship_if_missing() {
  if command -v starship &>/dev/null; then
    echo "✅ starship déjà installé"
  else
    echo "📦 Installation de starship via le script officiel..."
    if [[ "$DRY_RUN" == false ]]; then
      curl -sS https://starship.rs/install.sh | sh
    else
      echo "🔍 [dry-run] curl -sS https://starship.rs/install.sh | sh"
    fi
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
  install_starship_if_missing
  copy_config
fi

# Terminé !
if command -v starship &>/dev/null; then
  echo "✅ Installation et configuration de starship $(starship --version) terminées."
else
  echo "⚠️ Starship ne semble pas être installé correctement."
fi
