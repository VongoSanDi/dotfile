#!/usr/bin/env bash
set -euo pipefail

# ────────────────────────────────
# 📁 Création lien environment.d
# ────────────────────────────────
link_environment_dir() {
  local SRC="$HOME/.dotfile/environment.d"
  local DEST="$HOME/.config/environment.d"

  echo "🔗 Lien symbolique pour environment.d → $DEST"

  # If the destination folder already exist, we delete it so we can start anew
  # If it doesn't exist we create it
  if [[ -d "$DEST" || -L "$DEST" ]]; then
    echo "📦 Suppression de l'ancien $DEST"
    $DRY_RUN || rm -rf "$DEST"
  else
    echo "Creation du dossier de destination"
    mkdir -p $DEST
  fi

  if [[ -d "$SRC" ]]; then
    if $DRY_RUN; then
      echo "🔍 [dry-run] ln -s $SRC $DEST"
    else
      ln -s "$SRC" "$DEST"
    fi
  else
    echo "❌ Le dossier source $SRC n'existe pas."
  fi
}

# ────────────────────────────────
# ⚙️ Flags & dry-run
# ────────────────────────────────
DRY_RUN=false
REBOOT=true

link_environment_dir

# Gestion des arguments
for arg in "$@"; do
  case "$arg" in
  --dry-run)
    DRY_RUN=true
    echo "🔍 Mode dry-run activé : aucune modification ne sera faite"
    ;;
  --no-reboot)
    REBOOT=false
    echo "🔕 Redémarrage automatique désactivé"
    ;;
  esac
done

# Détection distribution
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  DISTRO=$ID
else
  echo "❌ Impossible de détecter la distribution"
  exit 1
fi

configure_xdg_user_dirs() {
  echo "⚙️ Configuration des dossiers XDG personnalisés"

  local xdg_dir="$HOME/.config/user-dirs.dirs"
  local media="$HOME/Media"

  mkdir -p "$media/Pictures" "$media/Videos" "$media/Music"

  cat >"$xdg_dir" <<EOF
XDG_DESKTOP_DIR="\$HOME/Desktop"
XDG_DOWNLOAD_DIR="\$HOME/Downloads"
XDG_DOCUMENTS_DIR="\$HOME/Documents"
XDG_PICTURES_DIR="\$HOME/Media/Pictures"
XDG_VIDEOS_DIR="\$HOME/Media/Videos"
XDG_MUSIC_DIR="\$HOME/Media/Music"
EOF

  echo 'enabled=False' >"$HOME/.config/user-dirs.conf"

  echo "🔄 Mise à jour avec xdg-user-dirs-update"
  xdg-user-dirs-update
}

# Liste des paquets
typeset -a PACKAGE_LIST_COMMON
typeset -a PACKAGE_LIST_DEBIAN
typeset -a PACKAGE_LIST_ARCH

PACKAGE_LIST_COMMON=(eza bat fd curl wget)
PACKAGE_LIST_DEBIAN=()
# vivid is used for the LS_COLOR environment variable
# jq is used for formatting json files (mostly kulala response at this moment)
PACKAGE_LIST_ARCH=(
  xdg-user-dirs
  pipewire
  pipewire-audio
  pipewire-alsa
  pipewire-jack
  wireplumber
  ttf-jetbrains-mono-nerd
  vim-spell-fr
  vim-spell-en
  bluez
  bluez-utils
  tlp
  man-db
  man-pages
  mesa
  intel-media-driver
  vulkan-intel
  noto-fonts
  noto-fonts-emoji
  noto-fonts-cjk
  ttf-jetbrains-mono-nerd
  unzip
  brightnessctl
  playerctl
  papirus-icon-theme
  cliphist
  grim
  slurp
  lazygit
  vivid
  jq
)

# Fonction d'installation
install_package() {
  local pkg="$1"
  if pacman -Si "$pkg" &>/dev/null; then
    echo "📦 $pkg trouvé dans pacman"
    if [[ "$DRY_RUN" == false ]]; then
      sudo pacman -S --needed "$pkg"
    else
      echo "🔍 [dry-run] sudo pacman -S --needed $pkg"
    fi
  else
    echo "📦 $pkg non trouvé dans pacman, tentative avec paru"
    if [[ "$DRY_RUN" == false ]]; then
      paru -S --needed "$pkg"
    else
      echo "🔍 [dry-run] paru -S --needed $pkg"
    fi
  fi
}

# Paru installation as the extra packet manager
install_paru() {
  if ! command -v paru &>/dev/null; then
    echo "🔧 Installation de paru..."
    mkdir -p ~/Downloads/paru
    cd ~/Downloads/paru
    if [[ ! -d paru ]]; then
      git clone https://aur.archlinux.org/paru.git
    fi
    cd paru
    if [[ "$DRY_RUN" == false ]]; then
      makepkg -si
      echo "✅ Paru installé, suppression des sources..."
      rm -rf ~/Downloads/paru
    else
      echo "🔍 [dry-run] makepkg -si"
      fixdg-user-dirs
    fi
  else
    echo "✅ paru est déjà installé"
  fi
}

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  # Vérifier si paru est installé
  #install_paru
  echo "on passe l'install de paru pour le moment"
fi

# Install User DIRS
install_package "xdg-user-dirs"

# Create them immediatly
configure_xdg_user_dirs

# Combinaison des paquets communs et spécifiques à Arch
packages_to_install=("${PACKAGE_LIST_COMMON[@]}" "${PACKAGE_LIST_ARCH[@]}")

# Installation des paquets
for package in "${packages_to_install[@]}"; do
  install_package "$package"
done

# Mise à jour des polices
if [[ "$DRY_RUN" == false ]]; then
  fc-cache -fv
else
  echo "🔍 [dry-run] fc-cache -fv"
fi

# Optimisation de la batterie avec TLP
if [[ "$DRY_RUN" == false ]]; then
  echo "⚙️ Activation de TLP"
  sudo systemctl enable --now tlp
else
  echo "🔍 [dry-run] sudo systemctl enable --now tlp"
fi

# Activation des services audio
if [[ "$DRY_RUN" == false ]]; then
  echo "⚙️ Activation de l'audio"
  systemctl --user enable --now pipewire wireplumber
else
  echo "🔍 [dry-run] systemctl --user enable --now pipewire wireplumber"
fi

# Activation du service Bluetooth
if [[ "$DRY_RUN" == false ]]; then
  echo "⚙️ Activation du bluetooth"
  sudo systemctl enable --now bluetooth.service
else
  echo "🔍 [dry-run] sudo systemctl enable --now bluetooth.service"
fi

# Installation de bun
if [[ "$DRY_RUN" == false ]]; then
  echo "⚙️ Installation de bun"
  curl -fsSL https://bun.sh/install | bash
else
  echo "🔍 [dry-run] curl -fsSL https://bun.sh/install | bash"
fi

# Appel du script install_dotfile si présent
if [[ -x "$HOME/.dotfile/install_dotfile.sh" ]]; then
  if [[ "$DRY_RUN" == false ]]; then
    "$HOME/.dotfile/install_dotfile.sh" "$@"
  else
    echo "🔍 [dry-run] $HOME/.dotfile/install_dotfile.sh $*"
  fi
fi

echo "✅ Tous les paquets de base ont été installés avec succès."

# Redémarrage à la fin de l'installation (si autorisé)
if [[ "$REBOOT" == true ]]; then
  if [[ "$DRY_RUN" == false ]]; then
    echo "✅ Installation terminée. Redémarrage dans 10 secondes..."
    sleep 10
    sudo reboot
  else
    echo "🔍 [dry-run] sudo reboot (simulé)"
  fi
else
  echo "🛑 Redémarrage automatique désactivé (--no-reboot)"
fi
