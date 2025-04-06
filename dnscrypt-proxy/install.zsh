#!/usr/bin/env zsh
set -euo pipefail

echo "🔧 Installation de la config dnscrypt-proxy..."

CONFIG_DIR="$HOME/.dotfile/dnscrypt-proxy"
DEST_DIR="/etc/dnscrypt-proxy"

if [[ ! -f "$CONFIG_DIR/dnscrypt-proxy.toml" ]]; then
  echo "❌ Fichier dnscrypt-proxy.toml introuvable dans $CONFIG_DIR"
  exit 1
fi

sudo systemctl stop dnscrypt-proxy

echo "📄 Copie des fichiers de configuration..."
sudo cp "$CONFIG_DIR/dnscrypt-proxy.toml" "$DEST_DIR/dnscrypt-proxy.toml"

if [[ -f "$CONFIG_DIR/blocked-names.txt" ]]; then
  sudo cp "$CONFIG_DIR/blocked-names.txt" "$DEST_DIR/blocked-names.txt"
fi

echo "🚀 Redémarrage du service..."
sudo systemctl restart dnscrypt-proxy

echo "✅ Config dnscrypt-proxy installée avec succès !"
