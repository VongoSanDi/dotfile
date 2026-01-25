#!/usr/bin/env sh
set -euo pipefail

echo "🚀 Lancement de l'installation des dotfiles..."

# Liste explicite
"$HOME/.dotfile/starship/install.sh" "$@"
"$HOME/.dotfile/nvim/install.sh" "$@"
"$HOME/.dotfile/kitty/install.sh" "$@"
"$HOME/.dotfile/hypr/install.sh" "$@"
"$HOME/.dotfile/yazi/install.sh" "$@"
"$HOME/.dotfile/ashell/install.sh" "$@"
"$HOME/.dotfile/dnscrypt-proxy/install.sh" "$@"

echo "✅ Tous les modules ont été installés avec succès."
