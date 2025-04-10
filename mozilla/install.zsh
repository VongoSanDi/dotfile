#!/usr/bin/env zsh
set -euo pipefail

# ─────────────────────────────
# 🔧 Flags
# ─────────────────────────────
DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
  DRY_RUN=true
  echo "🔍 Mode dry-run activé : aucune modification ne sera faite"
fi

# ─────────────────────────────
# 📦 Détection de la distribution
# ─────────────────────────────
if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  DISTRO=$ID
else
  echo "❌ Impossible de détecter la distribution"
  exit 1
fi

# ─────────────────────────────
# 📁 Répertoires
# ─────────────────────────────
CONFIG_DIR="$HOME/.dotfile/mozilla"
DEST_CONFIG_DIR="$HOME/.mozilla"

# ─────────────────────────────
# 🔧 Installation de Firefox
# ─────────────────────────────
install_if_missing() {
  local pkg=$1
  if pacman -Q "$pkg" &>/dev/null; then
    echo "✅ $pkg déjà installé"
  else
    echo "📦 Installation de $pkg..."
    $DRY_RUN || sudo pacman -S "$pkg"
  fi
}

# ─────────────────────────────
# 🧠 Création d'un profil Firefox custom
# ─────────────────────────────
create_firefox_profile() {
  local profile_name="vongo.default-release"
  local profile_dir="$DEST_CONFIG_DIR/firefox/$profile_name"
  local profiles_ini="$DEST_CONFIG_DIR/firefox/profiles.ini"

  echo "🧠 Vérification du profil Firefox $profile_name..."

  if [[ ! -d "$profile_dir" ]]; then
    echo "📁 Création du dossier de profil $profile_dir"
    if ! $DRY_RUN; then
      mkdir -p "$profile_dir"
    fi
  fi

  echo "🛠️ Configuration de $profiles_ini"
  if ! $DRY_RUN; then
    mkdir -p "$DEST_CONFIG_DIR/firefox"

    cat > "$profiles_ini" <<EOF
[Profile0]
Name=default-release
IsRelative=1
Path=$profile_name
Default=1

[General]
StartWithLastProfile=1
Version=2
EOF
  else
    echo "🔍 [dry-run] Écriture du fichier $profiles_ini avec profil $profile_name"
  fi
}

# ─────────────────────────────
# 🔗 Symlinks des fichiers vers bons emplacements
# ─────────────────────────────
link_configs() {
  echo "📂 Lien des fichiers de configuration Mozilla..."

  for appdir in "$CONFIG_DIR"/*; do
    [[ -d "$appdir" ]] || continue
    appname=$(basename "$appdir")
    echo "📁 Application détectée : $appname"

    local target=""
    if [[ "$appname" == "firefox" ]]; then
      target="$DEST_CONFIG_DIR/firefox/vongo.default-release"
    elif [[ "$appname" == "thunderbird" ]]; then
      target="$DEST_CONFIG_DIR/thunderbird"
    else
      echo "⚠️ Application inconnue : $appname"
      continue
    fi

    for file in "$appdir"/*; do
      filename=$(basename "$file")
      if [[ "$filename" == "install.zsh" ]]; then
        echo "⚠️ Ignoré : $filename"
        continue
      fi

      if $DRY_RUN; then
        echo "   ↪ ln -sf $file $target/$filename"
      else
        ln -sf "$file" "$target/$filename"
        echo "✅ $filename lié vers $target"
      fi
    done
  done
}

# ─────────────────────────────
# 🚀 Exécution
# ─────────────────────────────
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  exit 1
else
  install_if_missing firefox
  create_firefox_profile
  link_configs
fi

echo "✅ Installation et configuration des applications Mozilla terminées."
