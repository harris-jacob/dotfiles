#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

ZSH_ROOT="${HOME}/.oh-my-zsh"
ZSH_CUSTOM="${HOME}/.oh-my-zsh/custom"

declare -a ZSH_CUSTOM_PLUGINS=(
	"themes/powerlevel10k=https://github.com/romkatv/powerlevel10k"
	"plugins/F-Sy-H=https://github.com/z-shell/F-Sy-H"
	"plugins/zsh-completions=https://github.com/zsh-users/zsh-completions"
	"plugins/you-should-use=https://github.com/MichaelAquilina/zsh-you-should-use"
	"plugins/fzf-tab=https://github.com/Aloxaf/fzf-tab"
)

function do_install() {
    if [[ ! -d "${ZSH_ROOT}" ]]
    then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
        rm ~/.zshrc
    else
        echo "Oh-my-zsh Already installed!"
    fi
}

function do_configure() {
	for value in "${ZSH_CUSTOM_PLUGINS[@]}"; do
		path="${value%%=*}"
		repo="${value##*=}"
		if [[ ! -d "${ZSH_CUSTOM}/${path}" ]]; then
			git clone --quiet "${repo}" "${ZSH_CUSTOM}/${path}"
		fi
	done
}

function do_update_plugins() {
	for value in "${ZSH_CUSTOM_PLUGINS[@]}"; do
		path="${value%%=*}"
		if [[ -d "${ZSH_CUSTOM}/${path}" ]]; then
			git -C "${ZSH_CUSTOM}/${path}" pull --quiet --rebase --autostash
		fi
	done
}

function main() {
	command=$1
	case $command in
	"install")
		shift
		do_install "$@"
		;;
	"configure")
		shift
		do_configure "$@"
		;;
	"update_plugins")
		shift
		do_update_plugins "$@"
		;;
	*)
		echo "$(basename "$0"): '$command' is not a valid command"
		;;
	esac
}

main "$@"
