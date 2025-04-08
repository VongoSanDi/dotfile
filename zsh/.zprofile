#######################
###WAYLAND ENV VAR  ###
######################
# Wayland native mode
export MOZ_ENABLE_WAYLAND=1 # Firefox utilise Wayland en mode natif (performances & fluidité améliorées).
export XDG_SESSION_TYPE=wayland # Informe les applications que tu es sur une session Wayland.
export QT_QPA_PLATFORM=wayland # Force les applications Qt à utiliser Wayland nativement (ex. OBS Studio, VLC).
export GDK_BACKEND=wayland # Force les applications GTK (Gnome) à utiliser Wayland nativement (ex. Firefox, Nautilus).
export CLUTTER_BACKEND=wayland # Force Clutter (certaines applis GNOME) à utiliser Wayland.
export SDL_VIDEODRIVER=wayland # 	Force les jeux/applications SDL2 à utiliser Wayland directement (performances & stabilité).
