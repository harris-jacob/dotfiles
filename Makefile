SHELL := /bin/bash

.DEFAULT_GOAL := all
.PHONY: kitty zsh nvim i3

DOTFILES_DIR ?= $(HOME)/dev/dotfiles
XDG_CONFIG_HOME ?= $(HOME)/.config
PLATFORM ?= $(shell uname | tr '[:upper:]' '[:lower:]')

all: homebrew stow zsh kitty nvim i3

stow: 
	@echo "Installing stow..."
ifeq ($(PLATFORM), linux)
	@sudo pacman -S stow --noconfirm
else
	@brew install stow
endif

homebrew:
ifeq ($(PLATFORM), darwin)
	@echo "Installing Homebrew..."
	@/bin/bash -c NON_INTERACTIVE=1 "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
endif

zsh: install-zsh configure-zsh ohmyzsh-install ohmyzsh-configure
nvim: install-nvim nvim-deps configure-nvim
kitty: install-kitty configure-kitty
i3: install-i3 configure-i3

configure-zsh:
	@echo "Configuring zsh..."
	@stow zsh -t $(HOME)

install-zsh:
ifeq ($(PLATFORM), linux)
	@echo "Installing zsh..."
	@sudo pacman -S zsh --noconfirm
	@sudo usermod -s "$$(type -P zsh)" $$(whoami)
endif

ohmyzsh-install:
	@echo "Installing oh-my-zsh..."
	@sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended

ohmyzsh-configure:
	@echo "Configuring oh-my-zsh..."
	@./scripts/ohmyzsh.sh configure

install-nvim:
	@echo "Installing neovim..."
ifeq ($(PLATFORM), linux)
	@sudo pacman -S neovim --noconfirm
else
	@brew install neovim
endif

nvim-deps:
ifeq ($(PLATFORM), linux)
	@sudo pacman -S ripgrep --noconfirm
else
	@brew install ripgrep
endif

configure-nvim:
	@echo "Configuring neovim..."
	@stow nvim -t $(HOME)

install-kitty:
	@echo "Installing kitty..."
	@/bin/bash -c "$(curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin)"

configure-kitty:
	@echo "Configuring kitty..."
	@stow kitty -t $(HOME)

configure-i3:
ifeq ($(PLATFORM), linux)
	@echo "Configuring i3..."
	@stow i3 -t $(HOME)
endif

install-i3:
ifeq ($(PLATFORM), linux)
	@echo "Installing i3 and deps..."
	@./scripts/i3.sh
endif

