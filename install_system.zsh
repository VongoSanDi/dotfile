#!/usr/bin/env zsh
set -euo pipefail

# Flags
DRY_RUN=false
REBOOT=true

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

# Liste des paquets
typeset -a PACKAGE_LIST_COMMON
typeset -a PACKAGE_LIST_DEBIAN
typeset -a PACKAGE_LIST_ARCH

PACKAGE_LIST_COMMON=(eza bat fd curl wget)
PACKAGE_LIST_DEBIAN=()
PACKAGE_LIST_ARCH=(
  pipewire
  pipewire-audio
  pipewire-alsa
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
  unzip
  brightnessctl
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

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  # Vérifier si paru est installé
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
    fi
  else
    echo "✅ paru est déjà installé"
  fi
fi

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
if [[ -x "$HOME/.dotfile/install_dotfile.zsh" ]]; then
  if [[ "$DRY_RUN" == false ]]; then
    "$HOME/.dotfile/install_dotfile.zsh" "$@"
  else
    echo "🔍 [dry-run] $HOME/.dotfile/install_dotfile.zsh $*"
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
