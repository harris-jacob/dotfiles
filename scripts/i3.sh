#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

sudo pacman -Syy

# nitrogen was dropped from the official Arch repos (AUR-only now, if it
# still exists at all) and broke this install with "target not found:
# nitrogen". feh is the in-repo replacement for setting the wallpaper;
# i3/.config/i3/config and i3/.config/nitrogen/ still reference nitrogen
# and need migrating to a feh call by hand.
sudo pacman -S --noconfirm \
    xorg \
    xorg-xinit \
    arandr \
    feh \
    rofi \
    i3-wm \
    picom
