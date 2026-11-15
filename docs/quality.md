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
4. tmux loads its config without errors.
5. Installation is idempotent and does not overwrite unrelated user files.
6. Every distributed file has clear license information.
7. Tool and plugin versions are pinned or recorded.

## Current gaps and controls

| Gap | Risk | Control |
|---|---|---|
| Mason installs the LSP at "latest" | Different machines get different LSP versions | Pin the npm version or record Mason versions; verify in CI |
| NvChad runs `TSInstallAll` by default | Slow, fragile, unused parsers | Override the Treesitter build to `:TSUpdate`; install only listed parsers |
| `forge fmt` version drift | Formatting churn | Pin Foundry; run `forge fmt --check` in verification |
| Format-on-save | Unexpected diffs | Solidity-only on-save; CI `--check`; manual `<leader>fm` remains |
| No automated smoke test yet | Regressions go unnoticed | Add `make verify`: headless Neovim load, LSP attach, tmux config parse |
| `install.sh` downloads a font without a checksum | Supply-chain and reproducibility risk | Add a checksum or use a packaged font |
| `install.sh` is not idempotent | Partial installs and repeated work | Make each step idempotent; add `--dry-run` |
| `current/.spacemacs` stow target is unclear | It may land in `~/.config/.spacemacs` | Fix the Emacs install path in the Emacs iteration |
| Catppuccin assumes truecolor | Wrong colors in a Linux VT/256-color terminal | Test the target terminal; add a TTY fallback profile |

## Measurement and control (planned)

- `make doctor` — check commands, versions, fonts, terminal capabilities.
- `make verify` — headless Neovim config load, `:checkhealth`, LSP attach,
  `forge fmt --check`, tmux config parse.
- `make lint` — ShellCheck, StyLua, `reuse lint`.
- CI — run the same checks on a clean runner.
- Lockfiles — commit `lazy-lock.json`; record Mason/Node/Foundry versions.
- Rollback — every config change is a git commit; document how to revert.

## Current iteration scope

- NvChad baseline (keeping the existing tmux config unchanged for now).
- Catppuccin Mocha.
- Nomic Foundation Solidity LSP (MIT) with an optional `SOLIDITY_LSP=solc` path.
- `forge fmt` on save for Solidity.
- AGPL-3.0-or-later license and SPDX/REUSE metadata.
