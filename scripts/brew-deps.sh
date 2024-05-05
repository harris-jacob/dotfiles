#!/bin/bash

set -o errexit

brew tap homebrew/cask-fonts
brew install --cask font-fira-mono-nerd-font
brew install ripgrep fzf
