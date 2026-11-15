#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 thatnerdjosh
# SPDX-License-Identifier: AGPL-3.0-or-later

# First-run bootstrap: install pinned plugins, the Solidity language server,
# and the Treesitter parsers. Safe to re-run and never waits on stdin.

# shellcheck source=tests/lib.sh
source "${BASH_SOURCE[0]%/*}/lib.sh"

if ! require_cmd nvim; then
	printf 'neovim is required\n' >&2
	exit 1
fi

printf 'installing plugins pinned by lazy-lock.json...\n'
nvim --headless "+Lazy! install" +qa </dev/null
nvim --headless "+Lazy! restore" +qa </dev/null

server="$HOME/.local/share/nvim/mason/bin/nomicfoundation-solidity-language-server"
if [ -x "$server" ]; then
	printf 'language server already installed\n'
else
	printf 'installing language server...\n'
	nvim --headless \
		-c 'MasonInstall nomicfoundation-solidity-language-server lua-language-server' \
		-c 'lua vim.wait(300000, function() local ok, registry = pcall(require, "mason-registry"); if not ok then return false end; local ok2, pkg = pcall(registry.get_package, "nomicfoundation-solidity-language-server"); return ok2 and pkg:is_installed() end, 1000)' \
		-c 'qa!' </dev/null
fi

printf 'installing missing treesitter parsers...\n'
nvim --headless \
	-c 'lua require("lazy").load({ plugins = { "nvim-treesitter" } })' \
	-c 'lua require("nvim-treesitter.install").ensure_installed_sync()' \
	-c 'qa!' </dev/null

install_tmux_plugins() {
	local tpm="$HOME/.tmux/plugins/tpm"
	if ! require_cmd tmux || [ ! -x "$tpm/bin/install_plugins" ]; then
		printf 'skipping tmux plugins (run ./install.sh, then prefix + I)\n'
		return 0
	fi

	printf 'installing tmux plugins...\n'
	local socket="$TESTS_TMP/tmux.sock"
	tmux -S "$socket" new-session -d -s bootstrap
	tmux -S "$socket" set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins"
	tmux -S "$socket" source-file "$TMUX_CONFIG"
	local tmux_env
	tmux_env="$(tmux -S "$socket" display -p '#{socket_path},#{pid},0')"
	TMUX="$tmux_env" "$tpm/bin/install_plugins"
	tmux -S "$socket" kill-server >/dev/null 2>&1 || true
}

install_tmux_plugins

printf 'bootstrap complete\n'
