<!-- SPDX-FileCopyrightText: 2026 thatnerdjosh -->
<!-- SPDX-License-Identifier: AGPL-3.0-or-later -->

# .files

A terminal-first development workbench, currently centered on **Neovim + tmux**
with **Solidity/Foundry** support. Emacs and deeper TTY hardening are staged for
later iterations.

## Layout

| Path | Purpose |
|---|---|
| `current/nvim` | Active NvChad-based Neovim config (symlink into `.config/nvim/nvchad`) |
| `current/tmux/tmux.conf` | tmux config, stowed to `~/.config/tmux/tmux.conf` |
| `current/.spacemacs` | Emacs config kept for a later iteration |
| `.config/nvim/personal` | Alternative standalone Neovim configs |
| `old/` | Legacy configs retained for reference |
| `docs/` | Licensing and quality notes |

## Quick start

Prerequisites (Arch/CachyOS):

```sh
sudo pacman -S --needed git make gcc neovim tmux stow \
  nodejs-lts-krypton npm ripgrep fd fzf
```

Install the configs:

```sh
git clone https://github.com/thatnerdjosh/.files.git
cd .files
./install.sh
```

The first Neovim start bootstraps `lazy.nvim` and installs the pinned plugins.
Mason installs the Solidity language server.

## Solidity

- **Language server:** Nomic Foundation `solidity_ls_nomicfoundation` (MIT) by
  default. It understands `foundry.toml`, remappings, and Foundry projects.
- **Formatter:** `forge fmt`, run on save for Solidity buffers. Manual formatting
  is still available with `<leader>fm`.
- **Treesitter:** Solidity parser plus a small set of common filetypes.
- **Trial the GPL compiler LSP:** set `SOLIDITY_LSP=solc` before starting Neovim:

  ```sh
  SOLIDITY_LSP=solc nvim
  ```

  This selects `solc --lsp` (GPL-3.0-or-later) and asks Mason for the `solc`
  package. It is an experiment: the system compiler must match the project's
  compiler, and Foundry/remapping support is weaker than the Nomic server.

## Licensing

This repository is licensed under **AGPL-3.0-or-later**. See [`LICENSE`](LICENSE)
and [`docs/licensing.md`](docs/licensing.md) for the dependency inventory and
compatibility notes.

Third-party plugins and tools retain their own licenses. In particular, NvChad
is GPL-3.0 and its notices must be preserved.

## Development

`./install.sh` installs fonts, TPM, and the stow links. It is idempotent, verifies
the Mononoki download against a SHA-256 checksum, and puts `.spacemacs` in
`$HOME` rather than `~/.config`.

`make bootstrap` installs plugins from `lazy-lock.json`, the Solidity language
server, any missing Treesitter parsers, and the tmux plugins. It never prompts.

```sh
make lint     # shellcheck, shfmt, stylua, reuse lint, gitleaks, actionlint
make verify   # Neovim load, LSP attach, treesitter, forge fmt, tmux, stow
make test     # lint + verify
make doctor   # report local tools, links, and integrations
```

CI runs the same targets, and its verification job exercises `./install.sh`
and `make bootstrap` on a clean Arch container.

## Quality

See [`docs/quality.md`](docs/quality.md) for the current Sigma 6/DMAIC control
plan, known gaps, and planned verification steps.
