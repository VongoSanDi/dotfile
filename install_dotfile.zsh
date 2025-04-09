#!/usr/bin/env zsh
set -euo pipefail

echo "🚀 Lancement de l'installation des dotfiles..."

# Liste explicite
"$HOME/.dotfile/zsh/install.zsh" "$@"
"$HOME/.dotfile/nvim/install.zsh" "$@"
"$HOME/.dotfile/kitty/install.zsh" "$@"
"$HOME/.dotfile/starship/install.zsh" "$@"
"$HOME/.dotfile/hypr/install.zsh" "$@"
"$HOME/.dotfile/dnscrypt-proxy/install.zsh" "$@"

echo "✅ Tous les modules ont été installés avec succès."
