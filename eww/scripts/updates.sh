#!/usr/bin/env bash

updates_arch=$(pacman -Qu 2>/dev/null | wc -l)
updates_aur=$(paru -Qua 2>/dev/null | wc -l)

[ -z "$updates_arch" ] && updates_arch=0
[ -z "$updates_aur" ] && updates_aur=0

echo $((updates_arch + updates_aur))
