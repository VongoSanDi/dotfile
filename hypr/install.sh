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

CONFIG_DIR="$HOME/.dotfile/hypr"
DEST_CONFIG_DIR="$HOME/.config/hypr"
THEME_URL="https://raw.githubusercontent.com/catppuccin/hyprland/main/themes/mocha.conf"
THEME_FILE="mocha.conf"

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

# Installation du thème hyprcursor rose-pine
install_rosepine_cursor() {
  local ICON_DIR="$HOME/.dotfile/hypr/icons"
  local LOCAL_ICONS_DIR="$HOME/.icons"
  local THEME_NAME="rose-pine-hyprcursor"
  local THEME_PATH="$ICON_DIR/$THEME_NAME"
  local REPO_URL="https://github.com/ndom91/rose-pine-hyprcursor.git"

  echo "🎨 Installation du thème de curseur Hyprland rose-pine pour hyprcursor..."

  if [[ -d "$THEME_PATH" ]]; then
    echo "✅ Le thème $THEME_NAME est déjà présent dans $ICON_DIR"
  else
    echo "📥 Clonage du thème depuis GitHub..."
    if $DRY_RUN; then
      echo "   ↪ git clone $REPO_URL $THEME_PATH"
    else
      git clone --depth=1 "$REPO_URL" "$THEME_PATH"
    fi
  fi

  echo "🔗 Création du lien symbolique vers ~/.icons..."
  if $DRY_RUN; then
    echo "   ↪ mkdir -p $LOCAL_ICONS_DIR"
    echo "   ↪ ln -s $THEME_PATH $LOCAL_ICONS_DIR/$THEME_NAME"
  else
    mkdir -p "$LOCAL_ICONS_DIR"
    ln -sf "$THEME_PATH" "$LOCAL_ICONS_DIR/$THEME_NAME"
  fi
}

# Installation de Hyprland et outils
install_packages() {
  install_if_missing hyprland
  install_if_missing hypridle
  install_if_missing hyprlock
  install_if_missing hyprlauncher
  install_if_missing hyprsunset
  install_if_missing hyprcursor
  install_if_missing hyprtoolkit
  install_if_missing wl-clipboard
  install_if_missing uwsm
  install_if_missing xdg-desktop-portal-hyprland
  install_if_missing xdg-desktop-portal
  install_if_missing wayland-protocols
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

  echo "📥 Téléchargement du thème Catppuccin mocha..."
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
  install_rosepine_cursor
fi

# Terminé !
echo "✅ Installation et configuration de Hyprland terminées."
