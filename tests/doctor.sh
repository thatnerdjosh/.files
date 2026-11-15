#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 thatnerdjosh
# SPDX-License-Identifier: AGPL-3.0-or-later

# Reports the state of the local workbench: tools, stow links, fonts, tmux
# plugins, and the Mason-installed language server. Read-only.

# shellcheck source=tests/lib.sh
source "${BASH_SOURCE[0]%/*}/lib.sh"

missing=0

report_cmd() {
	local cmd="$1" kind="$2"
	if command -v "$cmd" >/dev/null 2>&1; then
		printf 'ok   %-28s %s\n' "$cmd" "$("$cmd" --version 2>/dev/null | head -n 1)"
	elif [ "$kind" = "required" ]; then
		printf 'MISS %-28s required\n' "$cmd"
		missing=$((missing + 1))
	else
		printf 'skip %-28s optional\n' "$cmd"
	fi
}

printf '== tools ==\n'
for cmd in git nvim tmux stow node npm forge; do
	report_cmd "$cmd" required
done
for cmd in shellcheck shfmt stylua reuse gitleaks actionlint; do
	report_cmd "$cmd" optional
done

printf '\n== stow links ==\n'
for link in "$HOME/.config/nvim" "$HOME/.config/tmux"; do
	if [ -L "$link" ] && [ -e "$link" ]; then
		printf 'ok   %s -> %s\n' "$link" "$(readlink "$link")"
	else
		printf 'MISS %s is not a valid symlink\n' "$link"
		missing=$((missing + 1))
	fi
done

printf '\n== editor integrations ==\n'
mason_server="$HOME/.local/share/nvim/mason/bin/nomicfoundation-solidity-language-server"
if [ -x "$mason_server" ]; then
	printf 'ok   %s\n' "$mason_server"
else
	printf 'MISS %s (run: make bootstrap)\n' "$mason_server"
	missing=$((missing + 1))
fi

parser_dir="$HOME/.local/share/nvim/lazy/nvim-treesitter/parser"
if [ -f "$parser_dir/solidity.so" ]; then
	printf 'ok   solidity treesitter parser\n'
else
	printf 'MISS solidity treesitter parser (run: make bootstrap)\n'
	missing=$((missing + 1))
fi

printf '\n== terminal ==\n'
printf 'info TERM=%s COLORTERM=%s\n' "${TERM:-unset}" "${COLORTERM:-unset}"
if [ "$TERM" = "linux" ]; then
	printf 'warn Linux VT detected; Catppuccin truecolor will not render\n'
fi
font_dir="$HOME/.local/share/fonts/mononoki"
if [ -d "$font_dir" ]; then
	printf 'ok   %s\n' "$font_dir"
else
	printf 'skip %s not installed\n' "$font_dir"
fi

printf '\n== tmux plugins ==\n'
for plugin in tpm tmux-battery tmux-cpu tmux-sensible tmux; do
	if [ -d "$HOME/.tmux/plugins/$plugin" ]; then
		printf 'ok   %s\n' "$plugin"
	else
		printf 'skip %s not installed (prefix + I inside tmux)\n' "$plugin"
	fi
done

printf '\n'
if [ "$missing" -gt 0 ]; then
	printf '%d required item(s) missing\n' "$missing"
	exit 1
fi

printf 'all required items present\n'
