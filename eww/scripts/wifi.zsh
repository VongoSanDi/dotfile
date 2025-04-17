#!/usr/bin/env zsh

interface=$(iw dev | awk '$1=="Interface"{print $2}')
ssid=$(iw dev "$interface" link | awk -F': ' '/SSID/ {print $2}')

if [[ -z "$ssid" ]]; then
  echo "0"
else
  echo "$ssid"
fi
