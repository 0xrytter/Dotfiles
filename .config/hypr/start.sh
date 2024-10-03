#!/usr/bin/env bash

# initializing wallpaper daemon
swww init &
# setting wallpaper
swww img ~/Wallpapers/gruvbox-mountain-village.png &

# you can install this by adding
# pks.networkmanagerapplet to your packages
nm-applet --indicator &

# the bar
waybar &

# dunst
dunst
