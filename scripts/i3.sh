#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

sudo pacman -Syy

sudo pacman -S --noconfirm \
    arandr \
    nitrogen \
    rofi \
    ttf-font-awesome \
    adobe-source-code-pro-fonts \
    binutils \
    gcc \
    make \
    pkg-config \
    fakeroot \
    python-yaml \
    ttf-nerd-fonts-symbols \
    i3-wm \
    picom
