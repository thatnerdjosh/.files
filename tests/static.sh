#!/usr/bin/env bash
# SPDX-FileCopyrightText: 2026 thatnerdjosh
# SPDX-License-Identifier: AGPL-3.0-or-later

# Static analysis. Everything here is non-interactive and CI-friendly.
# Security-relevant checks (secret scanning, workflow analysis) run when the
# tools are available; CI installs them.

# shellcheck source=tests/lib.sh
source "${BASH_SOURCE[0]%/*}/lib.sh"

section "Shell"

if require_cmd shellcheck; then
	check "shellcheck" shellcheck --severity=style \
		"$REPO_ROOT/install.sh" \
		"$REPO_ROOT/utils/get-composer.sh" \
		"$REPO_ROOT"/tests/*.sh
else
	skip "shellcheck" "install shellcheck"
fi

if require_cmd shfmt; then
	check "shfmt" shfmt -d \
		"$REPO_ROOT/install.sh" \
		"$REPO_ROOT/utils/get-composer.sh" \
		"$REPO_ROOT"/tests/*.sh
else
	skip "shfmt" "install shfmt"
fi

section "Lua"

if require_cmd stylua; then
	check "stylua" stylua --check "$NVIM_CONFIG/lua" "$REPO_ROOT/tests/lua"
else
	skip "stylua" "install stylua"
fi

section "Licensing"

if require_cmd reuse; then
	check "reuse lint" reuse lint
else
	skip "reuse lint" "install reuse"
fi

section "Security"

if require_cmd gitleaks; then
	check "gitleaks" gitleaks detect --no-git --source "$REPO_ROOT" --no-banner --redact
else
	skip "gitleaks" "install gitleaks"
fi

if require_cmd actionlint && [ -d "$REPO_ROOT/.github/workflows" ]; then
	check "actionlint" actionlint
else
	skip "actionlint" "install actionlint or add workflows"
fi

summary
