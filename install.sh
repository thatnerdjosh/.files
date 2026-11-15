#!/bin/sh
# SPDX-FileCopyrightText: 2026 thatnerdjosh
# SPDX-License-Identifier: AGPL-3.0-or-later

installTPM() {
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

installFonts() {
	mkdir -p "$HOME/.local/share/fonts"
	if [ ! -d "$HOME/.local/share/fonts/mononoki" ]; then
		wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/Mononoki.zip
		unzip -d "$HOME/.local/share/fonts/mononoki" Mononoki.zip
		rm Mononoki.zip
	fi
	fc-cache -v
}

installConfig() {
	if [ "$1" = "current" ]; then
		if ! stow -t "$HOME/.config" current; then
			echo "Error installing config package."
			exit 1
		fi
	else
		echo "$1 config is not supported."
		exit 1
	fi
}

installFonts
installTPM
installConfig "current"
