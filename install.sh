#!/bin/sh
# SPDX-FileCopyrightText: 2026 thatnerdjosh
# SPDX-License-Identifier: AGPL-3.0-or-later

set -eu

REPO_DIR=$(CDPATH='' cd -- "$(dirname -- "$0")" && pwd)
MONONOKI_VERSION=3.2.1
MONONOKI_SHA256=3a6cd53ec11108090d9271331ad6b02f7dce8dff368068bdeb25affaaca8ce4a

require() {
	if ! command -v "$1" >/dev/null 2>&1; then
		echo "missing required command: $1" >&2
		exit 1
	fi
}

installTPM() {
	if [ -d "$HOME/.tmux/plugins/tpm" ]; then
		echo "tmux plugin manager already installed"
		return 0
	fi
	mkdir -p "$HOME/.tmux/plugins"
	git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
}

installFonts() {
	font_dir="$HOME/.local/share/fonts/mononoki"
	if [ -d "$font_dir" ]; then
		echo "Mononoki already installed"
		return 0
	fi

	tmp_dir=$(mktemp -d)
	archive="$tmp_dir/Mononoki.zip"
	url="https://github.com/ryanoasis/nerd-fonts/releases/download/v${MONONOKI_VERSION}/Mononoki.zip"

	wget -q -O "$archive" "$url"
	if ! echo "${MONONOKI_SHA256}  ${archive}" | sha256sum -c -; then
		rm -rf "$tmp_dir"
		echo "Mononoki archive checksum mismatch; aborting" >&2
		exit 1
	fi

	mkdir -p "$font_dir"
	unzip -q -d "$font_dir" "$archive"
	rm -rf "$tmp_dir"
	fc-cache -f
}

installConfig() {
	if [ "$1" != "current" ]; then
		echo "$1 config is not supported." >&2
		exit 1
	fi

	mkdir -p "$HOME/.config"

	# Older versions of this script stowed .spacemacs into ~/.config; clean up.
	if [ -L "$HOME/.config/.spacemacs" ]; then
		rm -f "$HOME/.config/.spacemacs"
	fi

	if ! stow -d "$REPO_DIR" -t "$HOME/.config" --ignore='\.spacemacs' current; then
		echo "Error installing config package." >&2
		exit 1
	fi

	# .spacemacs belongs directly in the home directory.
	if [ -e "$HOME/.spacemacs" ] && [ ! -L "$HOME/.spacemacs" ]; then
		echo "Refusing to overwrite existing $HOME/.spacemacs" >&2
		exit 1
	fi
	ln -sfn "$REPO_DIR/current/.spacemacs" "$HOME/.spacemacs"
}

for cmd in git stow wget unzip fc-cache sha256sum; do
	require "$cmd"
done

installFonts
installTPM
installConfig current

echo "install complete"
