#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 thatnerdjosh
# SPDX-License-Identifier: AGPL-3.0-or-later

# Runtime verification. Requires the configs to be stowed (see README) and
# the plugins/tools bootstrapped (make bootstrap).

# shellcheck source=tests/lib.sh
source "${BASH_SOURCE[0]%/*}/lib.sh"

export NVIM_CONFIG

section "Neovim"

if require_cmd nvim; then
	check "lua syntax" nvim --headless --clean \
		"+luafile $REPO_ROOT/tests/lua/syntax.lua" +qa
	check "config loads" nvim --headless \
		"+luafile $REPO_ROOT/tests/lua/config_load.lua" +qa
	check "treesitter solidity parser" nvim --headless \
		"+luafile $REPO_ROOT/tests/lua/treesitter.lua" +qa
	check "ai plugins load" nvim --headless \
		"+luafile $REPO_ROOT/tests/lua/ai_plugins.lua" +qa
else
	skip "neovim checks" "install neovim"
fi

section "Solidity"

if require_cmd nvim; then
	check "solidity LSP attaches" bash -c \
		"cd '$FIXTURE_DIR' && nvim --headless src/Smoke.sol '+luafile $REPO_ROOT/tests/lua/lsp_attach.lua' +qa"
else
	skip "solidity LSP attaches" "install neovim"
fi

if require_cmd forge; then
	check "forge fmt --check" bash -c "cd '$FIXTURE_DIR' && forge fmt --check"
else
	skip "forge fmt --check" "install foundry"
fi

section "tmux"

tmux_source() {
	local conf="$1"
	local socket="dotfiles-verify-$$"
	tmux -L "$socket" new-session -d -s verify || return 1
	tmux -L "$socket" set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins"
	tmux -L "$socket" source-file "$conf"
	local rc=$?
	tmux -L "$socket" kill-server >/dev/null 2>&1
	return $rc
}

# Asserts that the catppuccin cpu and battery modules survived assembly.
tmux_status_modules() {
	local socket="dotfiles-status-$$"
	tmux -L "$socket" new-session -d -s verify || return 1
	tmux -L "$socket" set-environment -g TMUX_PLUGIN_MANAGER_PATH "$HOME/.tmux/plugins"
	if ! tmux -L "$socket" source-file "$TMUX_CONFIG"; then
		tmux -L "$socket" kill-server >/dev/null 2>&1
		return 1
	fi
	local right
	right="$(tmux -L "$socket" show -g status-right)"
	tmux -L "$socket" kill-server >/dev/null 2>&1
	case "$right" in
	*tmux-cpu/scripts*) ;;
	*)
		printf 'cpu module missing from status-right\n' >&2
		return 1
		;;
	esac
	case "$right" in
	*tmux-battery/scripts*) ;;
	*)
		printf 'battery module missing from status-right\n' >&2
		return 1
		;;
	esac
	case "$right" in
	*catppuccin_status_date_time*) ;;
	*)
		printf 'date_time module missing from status-right\n' >&2
		return 1
		;;
	esac
}

if require_cmd tmux; then
	# Parse the config without plugin invocations so the check does not depend
	# on installed plugins.
	grep -vE '^[[:space:]]*(run|run-shell)[[:space:]]' "$TMUX_CONFIG" >"$TESTS_TMP/tmux.conf"
	check "tmux config parses" tmux_source "$TESTS_TMP/tmux.conf"

	if [ -d "$HOME/.tmux/plugins/tpm" ] &&
		[ -d "$HOME/.tmux/plugins/tmux" ] &&
		[ -d "$HOME/.tmux/plugins/tmux-cpu" ] &&
		[ -d "$HOME/.tmux/plugins/tmux-battery" ]; then
		check "tmux status modules resolve" tmux_status_modules
	else
		skip "tmux status modules resolve" "install tmux plugins with prefix + I"
	fi
else
	skip "tmux config parses" "install tmux"
fi

section "Stow layout"

if require_cmd stow; then
	mkdir -p "$TESTS_TMP/config"
	check "stow package has no conflicts" bash -c \
		"cd '$REPO_ROOT' && stow --simulate -t '$TESTS_TMP/config' current"
else
	skip "stow package has no conflicts" "install stow"
fi

summary
