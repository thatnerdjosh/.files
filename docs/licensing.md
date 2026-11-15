<!-- SPDX-FileCopyrightText: 2026 thatnerdjosh -->
<!-- SPDX-License-Identifier: AGPL-3.0-or-later -->

# Licensing

## Project license

This repository is licensed under **AGPL-3.0-or-later**. The full text is in
[`LICENSE`](../LICENSE), with a REUSE-compatible copy at
`LICENSES/AGPL-3.0-or-later.txt`.

SPDX headers are present on hand-maintained source and config files. JSON
lockfiles and legacy/alternative configs are covered by [`REUSE.toml`](../REUSE.toml).

## Compatibility notes

- **AGPL-3.0-or-later + GPL-3.0:** compatible. NvChad is GPL-3.0; keep its
  notices and do not relicense NvChad code. The combined distribution must
  satisfy both licenses, including the AGPL network clause where applicable.
- **AGPL-3.0-or-later + MIT/Apache-2.0/ISC:** compatible. Permissive
  dependencies do not weaken the AGPL on this repository's own code.
- **AGPL-3.0-or-later + GPL-3.0-or-later (`solc`):** compatible. The optional
  `SOLIDITY_LSP=solc` path uses the GPL-licensed compiler LSP.
- **AGPL-3.0-or-later + proprietary:** not compatible. Avoid proprietary
  components such as `solidity-ls` (qiuxiang).
- **AGPL-3.0-or-later + GPL-3.0 AI plugins:** compatible. `minuet-ai.nvim`,
  `llm.nvim`, and `pi-coding-agent.nvim` are GPL-3.0; the combined
  distribution is governed by AGPLv3. `flemma.nvim` and `teamtype-nvim` are
  AGPL-3.0, the same family as this repository.

## Dependency inventory

| Component | License | Notes |
|---|---|---|
| Neovim | Apache-2.0 | Editor |
| tmux | ISC | Terminal multiplexer |
| NvChad | GPL-3.0 | Neovim distribution; notices preserved |
| lazy.nvim | Apache-2.0 | Plugin manager |
| Catppuccin (nvim, tmux) | MIT | Colorscheme |
| nvim-lspconfig | Apache-2.0 | LSP configuration |
| mason.nvim / mason-lspconfig.nvim | Apache-2.0 | LSP/tool installer |
| nvim-treesitter | Apache-2.0 | Parsers and highlighting |
| conform.nvim | MIT | Formatting |
| minuet-ai.nvim | GPL-3.0 | Optional inline completion |
| llm.nvim | GPL-3.0 | Optional chat and selected-text tools |
| flemma.nvim | AGPL-3.0 | Optional `.chat` client and agent |
| pi-coding-agent.nvim | GPL-3.0 | Optional terminal agent pane |
| teamtype-nvim | AGPL-3.0-or-later | Optional collaborative editing |
| nui.nvim | MIT | UI dependency of llm.nvim |
| pi (external binary) | see upstream | Terminal agent; installed separately from pi.dev |
| teamtype (external binary) | AGPL-3.0 | Collaboration daemon; packaged as `teamtype` |
| Nomic Foundation Solidity LSP | MIT | Default Solidity LSP |
| solc | GPL-3.0-or-later | Optional Solidity LSP/compiler |
| Foundry (`forge`, `cast`, `anvil`) | MIT OR Apache-2.0 | Solidity toolchain |
| Node.js | MIT | Runtime for the Nomic LSP |
| npm | Artistic-2.0 | Node package manager; GPL-compatible |
| GNU Emacs | GPL-3.0-or-later | Planned "when bored" editor |
| Spacemacs | GPL-3.0 | Existing Emacs config, retained for later |

This inventory should be re-checked whenever a plugin, LSP, or system package is
added. `reuse lint` is the intended automated check.

## Copyright

Unless a file says otherwise, the copyright holder is `thatnerdjosh`. Update the
SPDX copyright line if you prefer a legal name and email address.
