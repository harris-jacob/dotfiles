#!/usr/bin/env bash
#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

sudo pacman -Syy

sudo pacman -S --noconfirm \
    xorg \
    xorg-xinit \
    arandr \
    nitrogen \
    rofi \
    i3-wm \
    picom \

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

sudo pacman -Syy

sudo pacman -S --noconfirm \
    xorg \
    xorg-xinit \
    arandr \
    nitrogen \
    rofi \
    i3-wm \
    picom \
