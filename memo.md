# Connect simple bluetooth devices such as mouse
bluetoothctl
power on
agent on
default-agent
discoverable on
pairable on
scan on

pair XX:XX:XX:XX:XX:XX
trust XX:XX:XX:XX:XX:XX
connect XX:XX:XX:XX:XX:XX
exit

# Desactiver le bluetooth
bluetoothctl
power off


# Connect to wifi
iwctl
device wlan0 scan
station wlan0 conect <xxxxxxxx>
