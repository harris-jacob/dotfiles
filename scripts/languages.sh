#!/usr/bin/env bash

set -o errexit  # abort on nonzero exitstatus
set -o nounset  # abort on unbound variable
set -o pipefail # don't hide errors within pipes

ASDF_BIN_DIR="${HOME}/.local/bin"
PLATFORM="$(uname | tr '[:upper:]' '[:lower:]')"

# asdf >=0.16 is a single Go binary — there is no more asdf.sh to git-clone
# and source, so install it via the right method per platform instead.
function install_asdf() {
    if command -v asdf >/dev/null 2>&1; then
        return
    fi

    if [[ "${PLATFORM}" == "darwin" ]]; then
        brew install asdf
    else
        local arch tag
        case "$(uname -m)" in
        x86_64) arch="amd64" ;;
        aarch64 | arm64) arch="arm64" ;;
        *)
            echo "install_asdf: unsupported architecture $(uname -m)" >&2
            exit 1
            ;;
        esac
        # Resolve the latest tag via the releases-latest redirect rather than
        # api.github.com: the API's anonymous rate limit (60 req/hour per
        # source IP) is shared across every GitHub-hosted runner on the
        # planet and gets exhausted constantly, which was silently producing
        # an empty ${tag} here and a 404 on the download below.
        tag=$(curl -fsSL -o /dev/null -w '%{url_effective}' https://github.com/asdf-vm/asdf/releases/latest)
        tag="${tag##*/}"
        if [[ -z "${tag}" ]]; then
            echo "install_asdf: failed to resolve latest asdf release tag" >&2
            exit 1
        fi
        mkdir -p "${ASDF_BIN_DIR}"
        curl -fsSL "https://github.com/asdf-vm/asdf/releases/download/${tag}/asdf-${tag}-linux-${arch}.tar.gz" |
            tar -xz -C "${ASDF_BIN_DIR}"
    fi
}

function install_rust() {
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
}

function source_asdf() {
    export PATH="${ASDF_BIN_DIR}:${PATH}"
    if ! command -v asdf >/dev/null 2>&1; then
        echo "source_asdf: asdf not found on PATH after install" >&2
        exit 1
    fi
}

function add_plugins() {
    asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
    asdf plugin add golang https://github.com/asdf-community/asdf-golang.git
    asdf plugin add elixir https://github.com/asdf-vm/asdf-elixir.git
    asdf plugin add gleam https://github.com/asdf-community/asdf-gleam.git
}

# asdf-elixir resolves "latest" by shelling out to `asdf current erlang` to
# pick a build matching the installed OTP. We install Erlang via the system
# package manager rather than as an asdf plugin (see deps target), so that
# lookup always comes back empty and corrupts the resolved version (e.g.
# "1.20.4-otp-such"), which then 404s against Hex. Resolve the latest plain
# (no -otp suffix) release ourselves instead.
function latest_elixir_version() {
    asdf list all elixir | tr -s ' \n' '\n' | grep -Ev '^0|^main$|^master$|otp|rc|^$' | tail -n 1
}

function use_latest() {
    local elixir_version
    elixir_version="$(latest_elixir_version)"

    asdf install nodejs latest
    asdf install golang latest
    asdf install elixir "${elixir_version}"
    asdf install gleam latest

    # asdf >=0.16 dropped `asdf global`/`asdf local` in favor of `asdf set`.
    asdf set --home nodejs latest
    asdf set --home golang latest
    asdf set --home elixir "${elixir_version}"
    asdf set --home gleam latest
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
