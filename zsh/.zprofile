# Démarrage auto d'Hyprland via uwsm
if uwsm check may-start; then
    exec uwsm start hyprland.desktop
fi
