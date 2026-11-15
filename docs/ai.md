<!-- SPDX-FileCopyrightText: 2026 thatnerdjosh -->
<!-- SPDX-License-Identifier: AGPL-3.0-or-later -->

# AI and collaboration plugins

These plugins are optional. The Solidity workbench works without any of them,
and none is required at startup. Credentials are read from environment
variables by the plugins themselves; this repository never stores a key.

## What is wired in

| Plugin | Purpose | Loads |
|---|---|---|
| [minuet-ai.nvim](https://github.com/milanglacier/minuet-ai.nvim) | Inline completion (manual by default) | `InsertEnter` |
| [llm.nvim](https://github.com/Kurama622/llm.nvim) | Chat and selected-text tools | Commands and keymaps |
| [flemma.nvim](https://github.com/Flemma-Dev/flemma.nvim) | `.chat` files, agent, documents | Startup (filetype detection) |
| [pi-coding-agent.nvim](https://github.com/anuragrao04/pi-coding-agent.nvim) | `pi` terminal agent pane | Commands and keymaps |
| [teamtype-nvim](https://github.com/teamtype/teamtype-nvim) | Peer-to-peer collaborative editing | Startup |

## Keymaps

| Key | Mode | Action |
|---|---|---|
| `<leader>ac` | n | Open/close the LLM chat |
| `<leader>al` | v | Send the selection to the selected-text handler |
| `<leader>af` | n | Create/open a `.chat` file |
| `<leader>ap` | n | Toggle the `pi` terminal pane |
| `<leader>aP` | n | Continue the previous `pi` session |
| `<leader>aR` | n | Resume a `pi` session |
| `<leader>am` | n | Pick the `pi` model |
| `<leader>ab` | n | Send the current buffer to `pi` |
| `<leader>as` | v | Send the selection to `pi` |
| `<leader>tj` | n | Jump to a Teamtype peer's cursor |
| `<leader>tf` | n | Follow a Teamtype peer's cursor |
| `<leader>ti` | n | Teamtype connection info |

Minuet is manual by default. In a buffer where it is enabled:

| Key | Action |
|---|---|
| `<A-]>` | Request or cycle to the next completion |
| `<A-[>` | Cycle to the previous completion |
| `<A-a>` | Accept one line |
| `<A-A>` | Accept the whole completion |
| `<A-z>` | Accept *n* lines (prompts) |
| `<A-e>` | Dismiss |

Flemma registers its own buffer-local mappings in `.chat` files. `Ctrl-]`
sends the buffer; `Alt-A` approves the tool at the cursor.

## Credentials

| Variable | Used by | Default |
|---|---|---|
| `OPENAI_API_KEY` | Minuet (default provider) | required for requests |
| `MINUET_PROVIDER` | Minuet | `openai` |
| `MINUET_MODEL` | Minuet | `gpt-5.6-luna` |
| `MINUET_AUTO_FT` | Minuet auto-trigger filetypes | empty (manual only) |
| `LLM_KEY` | llm.nvim | required for requests |
| `LLM_URL` | llm.nvim endpoint | OpenAI chat completions |
| `LLM_MODEL` | llm.nvim | `gpt-5.6-luna` |
| `LLM_API_TYPE` | llm.nvim result parser | `openai` |
| `ANTHROPIC_API_KEY` | Flemma (default provider) | required for requests |
| `PI_CMD` | pi-coding-agent.nvim | `pi` |
| `TEAMTYPE_BINARY` | teamtype-nvim | `teamtype` |

Minuet also honours its own provider variables (`ANTHROPIC_API_KEY`,
`GEMINI_API_KEY`, `CODESTRAL_API_KEY`, …) when `MINUET_PROVIDER` is changed.
Flemma supports OpenAI, Moonshot, and Vertex AI as well; a `.chat` file can
override the provider with `:Flemma switch`.

`LLM_KEY=NONE` works for local OpenAI-compatible servers that ignore auth.

### Auto-triggering completion

Minuet sends a request only when you ask for a completion unless you opt in:

```sh
MINUET_AUTO_FT=solidity,lua nvim
MINUET_AUTO_FT='*' nvim
```

Auto-triggering spends tokens continuously, including in repositories you may
not intend to send to a provider.

## External prerequisites

- **pi** — install the agent from <https://pi.dev>; it must be on `$PATH`.
  Credentials and model selection belong to `pi`, not to Neovim.
- **Teamtype** — install the daemon with `sudo pacman -S teamtype`, a release
  binary, `cargo install --locked teamtype`, or Homebrew. The plugin only
  launches `teamtype client`; the daemon and the `.teamtype` marker in a
  project root decide when a session starts.
- **Flemma** — needs `curl` and the Markdown Treesitter parser (installed).
  `bwrap` is optional and used for shell-command sandboxing on Linux.

## Safety notes

- Minuet is manual by default, so idle editing makes no network requests.
- llm.nvim and pi send buffer contents or selections to a provider when you
  invoke them.
- Flemma can run tools and act autonomously. It gates tools, uses a Bubblewrap
  sandbox when available, and stops after 100 turns. Inspect or change this
  with `:Flemma sandbox:status` and `:Flemma autopilot:disable`.
- Teamtype is peer-to-peer and encrypted; there is no central server and no
  account.
- `make lint` runs gitleaks, and the config only ever names environment
  variables.

## Turning them off

Delete or comment out the corresponding block in
`current/nvim/lua/plugins.lua`, then run `make bootstrap` and `make verify`.
The rest of the configuration has no dependency on these plugins.
