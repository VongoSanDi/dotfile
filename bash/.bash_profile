# ~/.bash_profile

# Charger ~/.bashrc si besoin
[[ -f ~/.bashrc ]] && . ~/.bashrc

# Démarrer Hyprland automatiquement via uwsm
if [ -z "$DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  if command -v uwsm &>/dev/null && uwsm check may-start; then
    exec uwsm start hyprland.desktop
  fi
fi
