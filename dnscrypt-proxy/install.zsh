#!/usr/bin/env zsh
set -euo pipefail

echo "dnscrypt-proxy & systemd-resolved installation ..."
sudo apt install systemd-resolved && sudo apt install -t unstable dnscrypt-proxy
echo "Installation completed"

echo "Remove the previous dnscrypt-proxy service"
sudo dnscrypt-proxy -service stop
sudo dnscrypt-proxy -service uninstall

echo "Disable the socket because it's not recommanded and useless in my situation"
# It's useless because I use dnscrypt-proxy as a daemon so it's always running
# The socket job is to receive request and then enable the daemon but like I said in my case it's useless and worse it run in the same port than dnscrypt-proxy
sudo systemctl disable dnscrypt-proxy.socket

echo "Copy the example configuration files to /etc/dnscrypt-proxy/"
sudo cp /usr/share/doc/dnscrypt-proxy/examples/* /etc/dnscrypt-proxy/

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
