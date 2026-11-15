<!-- SPDX-FileCopyrightText: 2026 thatnerdjosh -->
<!-- SPDX-License-Identifier: AGPL-3.0-or-later -->

# Quality / Sigma 6 control plan

This is a lightweight DMAIC-style plan for the dotfiles workbench. The goal is a
reproducible, verifiable, low-surprise environment rather than a formal
certification.

## Critical-to-quality requirements (CTQs)

1. Neovim starts with zero configuration errors.
2. The Solidity LSP attaches in a Foundry project (`foundry.toml` detected).
3. `forge fmt` succeeds and produces deterministic output.
4. tmux loads its config and renders all configured status modules.
5. Installation is idempotent and does not overwrite unrelated user files.
6. Every distributed file has clear license information.
7. Tool and plugin versions are pinned or recorded.

## Automated checks

| Command | Scope |
|---|---|
| `make lint` | ShellCheck, shfmt, StyLua, `reuse lint`, gitleaks, actionlint |
| `make verify` | Lua syntax, config load, LSP attach, Treesitter parser, `forge fmt --check`, tmux parse, status modules, stow layout |
| `make test` | `lint` + `verify` |
| `make doctor` | Local tools, stow links, Mason server, parsers, fonts, tmux plugins |
| `make bootstrap` | Pinned plugins, language server, missing parsers, tmux plugins |

CI (`.github/workflows/ci.yml`) runs `make lint` on every push/PR and a second
job that executes `./install.sh`, `make bootstrap`, and `make verify` on a clean
Arch container. The installer is therefore tested, not duplicated.

## Current gaps and controls

| Gap | Risk | Status / control |
|---|---|---|
| Mason installs the LSP at "latest" | Different machines get different LSP versions | **Open.** Record Mason versions or pin the npm package; verify in CI |
| `forge fmt` version drift | Formatting churn | **Open.** Pin Foundry; `forge fmt --check` runs in `make verify` |
| Format-on-save | Unexpected diffs | Controlled: Solidity-only on-save; manual `<leader>fm`; fixture check in `make verify` |
| tmux plugin ordering | Catppuccin module options do not exist before its script loads, silently dropping segments | Controlled: Catppuccin loads before status assembly; `make verify` asserts cpu/battery/date_time |
| `TSInstallSync` prompts on re-run | Headless bootstrap hangs on stdin | Controlled: bootstrap uses `ensure_installed_sync` and `</dev/null` |
| `Lazy! sync` rewrites the lockfile | Bootstrap changes tracked state | Controlled: bootstrap runs `Lazy! install` + `Lazy! restore` |
| Font download | Supply-chain and reproducibility risk | Controlled: Mononoki 3.2.1 with SHA-256 verification |
| Installer idempotency | Partial installs and repeated work | Controlled: skips installed fonts/TPM; install is safe to re-run |
| `current/.spacemacs` stow target | It previously landed in `~/.config/.spacemacs` | Controlled: stow ignores it and install.sh links `~/.spacemacs` |
| Catppuccin assumes truecolor | Wrong colors in a Linux VT/256-color terminal | **Open.** Test the target terminal; add a TTY fallback profile |
| `nvim-treesitter` `master` pin | Frozen branch; NvChad v2.5 uses the old API | **Open.** Revisit when NvChad migrates to the current API |
| Secret scanning | Accidental credential commits | Controlled in CI by gitleaks; skipped locally when not installed |

## Measurement and control

- `make lint` and `make verify` are the local control gates; CI enforces them.
- Non-zero exit codes are the contract. Output is human-readable but not parsed.
- Optional tools (`gitleaks`, `actionlint`) are skipped locally with a clear
  message and installed in CI.
- Lockfiles: `lazy-lock.json` is committed; Mason/Foundry/Node versions remain
  to be recorded.
- Rollback: every change is a git commit; bump the lockfile with a visible diff.

## Current iteration scope

- NvChad baseline with Catppuccin Mocha.
- Nomic Foundation Solidity LSP (MIT) with an optional `SOLIDITY_LSP=solc` path.
- `forge fmt` on save for Solidity.
- AGPL-3.0-or-later license and SPDX/REUSE metadata.
- Test harness, static analysis, and CI.
