#!/bin/bash

fonts_list=(
  font-fira-mono-nerd-font
)

plugin_list=(
    ripgrep
    fzf
)

brew tap homebrew/cask-fonts

for font in "${fonts_list[@]}"
do
  brew install --cask "$font"
done

for plugin in "${plugin_list[@]}"
do
  brew install "$plugin"
done

exit
