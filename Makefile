# SPDX-FileCopyrightText: 2026 thatnerdjosh
# SPDX-License-Identifier: AGPL-3.0-or-later

SHELL := /bin/bash
.DEFAULT_GOAL := help

.PHONY: help install lint verify test doctor bootstrap fmt ci

help: ## Show this help
	@awk 'BEGIN {FS = ":.*## "} /^[a-zA-Z_-]+:.*## / {printf "%-12s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

install: ## Install fonts, TPM, and stow the configs
	@./install.sh

lint: ## Static analysis: shellcheck, shfmt, stylua, reuse, gitleaks, actionlint
	@tests/static.sh

verify: ## Runtime verification in Neovim, Foundry, and tmux
	@tests/verify.sh

test: lint verify ## Run static analysis and runtime verification
	@:

doctor: ## Report local tool, link, and integration status
	@tests/doctor.sh

bootstrap: ## Install plugins, language server, and treesitter parsers
	@tests/bootstrap.sh

fmt: ## Format shell and Lua sources in place
	@shfmt -w install.sh utils/get-composer.sh tests/*.sh
	@stylua .config/nvim/nvchad/lua tests/lua
	@printf 'formatted\n'

ci: lint verify ## Run everything CI runs
	@:
