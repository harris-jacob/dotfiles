#!/bin/bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

pacman -Syu --noconfirm
pacman -S --noconfirm \
    ttf-font-awesome \
    adobe-source-code-pro-fonts \
    binutils \
    gcc \
    pkg-config \
    fakeroot \
    python-yaml \
    ttf-nerd-fonts-symbols \
    gnome-keyring \
    libsecret \
    zip \
    unzip \
    ttf-firacode-nerd
