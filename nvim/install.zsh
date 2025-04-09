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

CONFIG_DIR="$HOME/.dotfile/nvim"
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

# Installation de Neovim et outils
install_packages() {
  install_if_missing base-devel
  install_if_missing neovim
  install_if_missing lazygit
  install_if_missing ripgrep
  install_if_missing fzf
  install_if_missing fd
  install_if_missing nodejs
  install_if_missing npm
}

# Copie de la configuration
copy_config() {
  if [[ ! -d "$CONFIG_DIR" ]]; then
    echo "❌ Le dossier de config Neovim n'existe pas : $CONFIG_DIR"
    exit 1
  fi

  echo "📂 Suppression de l'ancienne configuration Neovim..."
  if $DRY_RUN; then
    echo "   ↪ rm -rf $DEST_CONFIG_DIR/nvim"
  else
    rm -rf "$DEST_CONFIG_DIR/nvim"
  fi

  echo "🔗 Création du lien symbolique..."
  if $DRY_RUN; then
    echo "   ↪ ln -s $CONFIG_DIR $DEST_CONFIG_DIR/nvim"
  else
    ln -s "$CONFIG_DIR" "$DEST_CONFIG_DIR/nvim"
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
echo "✅ Installation et configuration de Neovim terminées."
