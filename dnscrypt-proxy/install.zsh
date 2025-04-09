#!/usr/bin/env zsh
set -euo pipefail

echo "🖥️ Détection de la distribution..."

if [[ -f /etc/os-release ]]; then
  source /etc/os-release
  DISTRO=$ID
else
  echo "❌ Impossible de détecter la distribution"
  exit 1
fi

CONFIG_DIR="$HOME/.dotfile/dnscrypt-proxy"
DEST_DIR="/etc/dnscrypt-proxy"

# Vérifie la présence du fichier de config principal
if [[ ! -f "$CONFIG_DIR/dnscrypt-proxy.toml" ]]; then
  echo "❌ Fichier dnscrypt-proxy.toml introuvable dans $CONFIG_DIR"
  exit 1
fi

clean_copy() {
  echo "🧹 Nettoyage de l'ancienne configuration dnscrypt-proxy..."
  sudo rm -f "$DEST_DIR/dnscrypt-proxy.toml"
  sudo rm -f "$DEST_DIR/blocked-names.txt"

  echo "📂 Copie des nouveaux fichiers de configuration depuis ~/.dotfile"
  sudo cp "$CONFIG_DIR/dnscrypt-proxy.toml" "$DEST_DIR/"
  sudo chmod 644 "$DEST_DIR/dnscrypt-proxy.toml"

  sudo cp "$CONFIG_DIR/blocked-names.txt" "$DEST_DIR/"
  sudo chmod 644 "$DEST_DIR/blocked-names.txt"

  echo "📝 Création du fichier de log /var/log/dnscrypt-query.log..."
  sudo touch /var/log/dnscrypt-query.log
  sudo chown dnscrypt-proxy:dnscrypt-proxy /var/log/dnscrypt-query.log
  sudo chmod 644 /var/log/dnscrypt-query.log

}

echo "🛠️ Installation et configuration de dnscrypt-proxy pour $DISTRO..."

if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then

  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  echo "Il faut refaire l'instllation pas à pas, j'ai oublié des étapes tels que le resolv.conf, ne plus utiliser dns dans le networkManager et plein d'autres"
  exit 1

  echo "📦 Installation (Debian/Ubuntu)..."
  sudo apt update
  sudo apt install -y systemd-resolved
  sudo apt install -y -t unstable dnscrypt-proxy

  echo "🧼 Nettoyage ancien service dnscrypt-proxy..."
  sudo dnscrypt-proxy -service stop || true
  sudo dnscrypt-proxy -service uninstall || true

  echo "🚫 Désactivation du socket systemd..."
  sudo systemctl disable dnscrypt-proxy.socket || true

  clean_copy

else
  echo "📦 Installation (Arch Linux)..."
  sudo pacman -S --noconfirm dnscrypt-proxy

  echo "📦 Sauvegarde des fichiers de config existants..."
  for f in /etc/resolv.conf /etc/dhcpcd.conf "$DEST_DIR/dnscrypt-proxy.toml" "$DEST_DIR/blocked-names.txt"; do
    if [[ -f "$f" ]]; then
      echo "  ↪ $f → $f.bak"
      sudo cp "$f" "$f.bak"
    fi
  done

  clean_copy

  echo "🛡️ Désactivation de la modification de resolv.conf par dhcpcd..."
  if ! grep -q 'nohook resolv.conf' /etc/dhcpcd.conf; then
    echo 'nohook resolv.conf' | sudo tee -a /etc/dhcpcd.conf > /dev/null
  fi

  echo "🧹 Mise à jour de /etc/resolv.conf..."
  sudo chattr -i /etc/resolv.conf 2>/dev/null || true
  cat <<EOF | sudo tee /etc/resolv.conf > /dev/null
nameserver ::1
nameserver 127.0.0.1
options edns0
EOF
  sudo chattr +i /etc/resolv.conf
fi

echo "🚀 Activation et démarrage du service dnscrypt-proxy..."
sudo systemctl enable --now dnscrypt-proxy.service

echo "✅ Configuration terminée."

echo "🧪 Test de résolution DNS via dnscrypt-proxy..."
if command -v dig >/dev/null; then
  dig github.com @127.0.0.1 || echo "❌ dig a échoué, vérifie le service"
else
  echo "ℹ️ dig non installé, impossible de tester automatiquement"
fi
