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

CONFIG_DIR="$HOME/.dotfile/zsh"
ZSH_CONFIG_FILES=(.zshrc .zshenv .zcompdump .zprofile)
ZSH_PLUGINS_DIR="$CONFIG_DIR/plugins"
DEST_ZSH_CONFIG_DIR="$HOME/.config/zsh"

# Fonction de lien symbolique sécurisé
link() {
  local src="$1"
  local dest="$2"
  echo "🔗 $dest → $src"
  if $DRY_RUN; then
    echo "   ↪ rm -rf $dest"
    echo "   ↪ ln -s $src $dest"
  else
    rm -rf "$dest"
    ln -s "$src" "$dest"
  fi
}

# Création des liens symboliques pour les fichiers Zsh
setup_links() {
  echo "🔗 Création des liens symboliques Zsh..."
  for file in "${ZSH_CONFIG_FILES[@]}"; do
    link "$CONFIG_DIR/$file" "$HOME/$file"
  done

  echo "📁 Création du dossier de configuration ~/.config/zsh..."
  $DRY_RUN || mkdir -p "$DEST_ZSH_CONFIG_DIR"
  link "$ZSH_PLUGINS_DIR" "$DEST_ZSH_CONFIG_DIR/plugins"
}

# Téléchargement des plugins Zsh
install_plugins() {
  echo "📦 Téléchargement des plugins Zsh..."

  local autosuggestions_repo="https://github.com/zsh-users/zsh-autosuggestions"
  local syntax_highlighting_repo="https://github.com/zsh-users/zsh-syntax-highlighting"

  if [[ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]]; then
    echo "⬇️  Clonage zsh-autosuggestions..."
    $DRY_RUN || git clone "$autosuggestions_repo" "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
  else
    echo "✅ zsh-autosuggestions déjà présent"
  fi

  if [[ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]]; then
    echo "⬇️  Clonage zsh-syntax-highlighting..."
    $DRY_RUN || git clone "$syntax_highlighting_repo" "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
  else
    echo "✅ zsh-syntax-highlighting déjà présent"
  fi
}

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  setup_links
  install_plugins
fi

# Terminé !
echo "✅ Configuration de Zsh terminée."
