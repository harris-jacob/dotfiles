#!/bin/bash

set -o errexit

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
    ttf-firacode-nerd \
    fzf \
    ripgrep
