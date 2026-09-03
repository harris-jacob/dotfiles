#!/bin/bash

set -o errexit

brew install --cask font-fira-mono-nerd-font
brew install ripgrep fzf tree-sitter-cli
# Elixir needs an Erlang runtime on PATH; installed as a system package
# rather than via asdf (see scripts/languages.sh for why).
brew install erlang
