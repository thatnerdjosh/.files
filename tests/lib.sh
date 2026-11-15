#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 thatnerdjosh
# SPDX-License-Identifier: AGPL-3.0-or-later

# Shared helpers for the repository's test scripts.

set -uo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
FIXTURE_DIR="$REPO_ROOT/tests/fixtures/foundry"
NVIM_CONFIG="$REPO_ROOT/.config/nvim/nvchad"
TMUX_CONFIG="$REPO_ROOT/current/tmux/tmux.conf"
export REPO_ROOT FIXTURE_DIR NVIM_CONFIG TMUX_CONFIG
readonly REPO_ROOT FIXTURE_DIR NVIM_CONFIG TMUX_CONFIG

# Foundry installs here; make it available without changing the caller's shell.
if [ -d "$HOME/.foundry/bin" ]; then
	PATH="$HOME/.foundry/bin:$PATH"
	export PATH
fi

TESTS_TMP="$(mktemp -d "${TMPDIR:-/tmp}/dotfiles-tests.XXXXXX")"
readonly TESTS_TMP
trap 'rm -rf "$TESTS_TMP"' EXIT

PASSED=0
FAILED=0
SKIPPED=0

pass() {
	PASSED=$((PASSED + 1))
	printf 'ok   %s\n' "$1"
}

fail() {
	FAILED=$((FAILED + 1))
	printf 'FAIL %s\n' "$1"
}

skip() {
	SKIPPED=$((SKIPPED + 1))
	printf 'skip %s (%s)\n' "$1" "${2:-not available}"
}

# check <name> <command...>
# Runs a command, prints its output only on failure.
check() {
	local name="$1"
	shift
	local log="$TESTS_TMP/check.log"

	if "$@" >"$log" 2>&1; then
		pass "$name"
	else
		fail "$name"
		sed 's/^/     /' "$log" | tail -n 40
	fi
}

require_cmd() {
	command -v "$1" >/dev/null 2>&1
}

section() {
	printf '\n== %s ==\n' "$1"
}

summary() {
	printf '\n%d passed, %d failed, %d skipped\n' "$PASSED" "$FAILED" "$SKIPPED"
	[ "$FAILED" -eq 0 ]
}
