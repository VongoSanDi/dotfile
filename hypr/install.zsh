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

CONFIG_DIR="$HOME/.dotfile/hypr"
DEST_CONFIG_DIR="$HOME/.config/hypr"
THEME_URL="https://raw.githubusercontent.com/catppuccin/hyprland/main/themes/macchiato.conf"
THEME_FILE="macchiato.conf"

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

# Installation de Hyprland et outils
install_packages() {
  install_if_missing hyprland
  install_if_missing hypridle
  install_if_missing hyprlock
  install_if_missing hyprsunset
  install_if_missing wl-clipboard
  install_if_missing xdg-desktop-portal-hyprland
  install_if_missing xdg-desktop-portal
  install_if_missing wayland-protocols
  install_if_missing wofi
}

# Copie de la configuration
copy_config() {
  if [[ ! -d "$CONFIG_DIR" ]]; then
    echo "❌ Le dossier de config Hyprland n'existe pas : $CONFIG_DIR"
    exit 1
  fi

  echo "🔗 Création du lien symbolique vers ~/.config/hypr..."
  if $DRY_RUN; then
    echo "   ↪ rm -rf $DEST_CONFIG_DIR"
    echo "   ↪ ln -s $CONFIG_DIR $DEST_CONFIG_DIR"
  else
    rm -rf "$DEST_CONFIG_DIR"
    ln -s "$CONFIG_DIR" "$DEST_CONFIG_DIR"
  fi

  echo "📥 Téléchargement du thème Catppuccin macchiato..."
  if $DRY_RUN; then
    echo "   ↪ curl -fsSL $THEME_URL -o $DEST_CONFIG_DIR/$THEME_FILE"
  else
    curl -fsSL "$THEME_URL" -o "$DEST_CONFIG_DIR/$THEME_FILE"
  fi

  echo "📂 Configuration de /etc/xdg/portals.conf..."
  if $DRY_RUN; then
    echo "   ↪ sudo mkdir -p /etc/xdg"
    echo "   ↪ sudo rm -f /etc/xdg/portals.conf"
    echo "   ↪ sudo ln -s $HOME/.dotfile/xdg/portals.conf /etc/xdg/portals.conf"
  else
    sudo mkdir -p /etc/xdg
    sudo rm -f /etc/xdg/portals.conf
    sudo ln -s "$HOME/.dotfile/xdg/portals.conf" /etc/xdg/portals.conf
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
echo "✅ Installation et configuration de Hyprland terminées."
