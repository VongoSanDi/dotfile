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

CONFIG_DIR="$HOME/.dotfile/dnscrypt-proxy"
DEST_DIR="/etc/dnscrypt-proxy"

# Vérification et installation des dépendances
install_if_missing() {
  local pkg=$1
  if command -v "$pkg" &>/dev/null; then
    echo "✅ $pkg déjà installé"
  else
    echo "📦 Installation de $pkg..."
    $DRY_RUN || sudo pacman -S --noconfirm "$pkg"
  fi
}

# Sauvegarde et copie des fichiers de config
copy_config() {
  echo "📦 Sauvegarde des fichiers de config existants..."
  for f in /etc/resolv.conf /etc/dhcpcd.conf "$DEST_DIR/dnscrypt-proxy.toml" "$DEST_DIR/blocked-names.txt"; do
    if [[ -f "$f" ]]; then
      echo "  ↪ $f → $f.bak"
      $DRY_RUN || sudo cp "$f" "$f.bak"
    fi
  done

  echo "🧹 Nettoyage de l'ancienne configuration dnscrypt-proxy..."
  $DRY_RUN || sudo rm -f "$DEST_DIR/dnscrypt-proxy.toml" "$DEST_DIR/blocked-names.txt"

  echo "📂 Copie des nouveaux fichiers de configuration..."
  $DRY_RUN || sudo cp "$CONFIG_DIR/dnscrypt-proxy.toml" "$DEST_DIR/"
  $DRY_RUN || sudo chmod 644 "$DEST_DIR/dnscrypt-proxy.toml"

  $DRY_RUN || sudo cp "$CONFIG_DIR/blocked-names.txt" "$DEST_DIR/"
  $DRY_RUN || sudo chmod 644 "$DEST_DIR/blocked-names.txt"

  echo "📝 Création du fichier de log /var/log/dnscrypt-query.log..."
  $DRY_RUN || {
    sudo touch /var/log/dnscrypt-query.log
    sudo chown dnscrypt-proxy:dnscrypt-proxy /var/log/dnscrypt-query.log
    sudo chmod 644 /var/log/dnscrypt-query.log
  }
}

# Configuration spécifique Arch
configure_arch() {
  install_if_missing dnscrypt-proxy
  copy_config

  echo "🛡️ Désactivation de la modification de resolv.conf par dhcpcd..."
  if ! grep -q 'nohook resolv.conf' /etc/dhcpcd.conf; then
    echo 'nohook resolv.conf' | sudo tee -a /etc/dhcpcd.conf > /dev/null
  fi

  echo "🧹 Mise à jour de /etc/resolv.conf..."
  $DRY_RUN || sudo chattr -i /etc/resolv.conf 2>/dev/null || true
  if ! $DRY_RUN; then
    cat <<EOF | sudo tee /etc/resolv.conf > /dev/null
nameserver ::1
nameserver 127.0.0.1
options edns0
EOF
    sudo chattr +i /etc/resolv.conf
  fi
}

# Exécution principale
if [[ "$DISTRO" == "debian" || "$DISTRO" == "ubuntu" ]]; then
  echo "❌ Ce script ne prend plus en charge Debian/Ubuntu pour le moment."
  echo "Il faut refaire l'installation à la main avec des étapes spécifiques."
  exit 1
else
  configure_arch
fi

# Activation du service
echo "🚀 Activation et démarrage du service dnscrypt-proxy..."
$DRY_RUN || sudo systemctl enable --now dnscrypt-proxy.service

# Test de fonctionnement avec dig
echo "🧪 Test de résolution DNS via dnscrypt-proxy..."
install_if_missing bind

if command -v dig >/dev/null; then
  if dig github.com @127.0.0.1 | grep -q "ANSWER SECTION"; then
    echo "✅ Résolution réussie via dnscrypt-proxy"
  else
    echo "❌ La commande dig n'a pas renvoyé de réponse"
  fi

  echo "🔍 Vérification du serveur utilisé..."
  SERVER_LINE="$(dig github.com @127.0.0.1 | grep 'SERVER:')"
  if [[ "$SERVER_LINE" == *"127.0.0.1"* ]]; then
    echo "✅ Le serveur utilisé est bien dnscrypt-proxy"
  else
    echo "❌ Le serveur utilisé n'est pas 127.0.0.1 — attention à la configuration"
  fi

  echo "🧪 Test anti-FAI : domaine inexistant..."
  if [[ -z "$(dig +short shouldnotexist1234567.com @127.0.0.1)" ]]; then
    echo "✅ Aucun résultat pour domaine inexistant, le DNS ne ment pas"
  else
    echo "❌ Une IP a été retournée pour un domaine inexistant, redirection suspecte"
  fi
else
  echo "ℹ️ dig non installé, test non effectué"
fi

# Suppression de bind (utilisé uniquement pour les tests)
echo "🧹 Suppression du package bind (dig) après le test..."
$DRY_RUN || sudo pacman -Rns --noconfirm bind

# Terminé !
echo "✅ Configuration terminée."
