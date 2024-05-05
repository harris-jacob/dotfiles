#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

ASDF_ROOT="${HOME}/.asdf"
ASDF_BIN="${ASDF_ROOT}/asdf.sh"

function install_asdf() {
    if [[ ! -d "${ASDF_ROOT}" ]]; then
        git clone https://github.com/asdf-vm/asdf.git "${ASDF_ROOT}"
    fi
}

function install_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
}

function source_asdf() {
    . "${ASDF_BIN}"
}

function add_plugins() {
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
    asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
}

function use_latest() {
    asdf install nodejs latest
    asdf install golang latest
    asdf install elixir latest
    
    asdf global nodejs latest
    asdf global golang latest
    asdf global elixir latest
}

function main() {
    command=$1
    case $command in
    "asdf")
        shift
        install_asdf "$@"
        ;;
    "install")
        shift
        source_asdf "$@"
        add_plugins "$@"
        use_latest "$@"
        install_rust "$@"
        ;;
	*)
		echo "$(basename "$0"): '$command' is not a valid command"
		;;
	esac
}

main "$@"
