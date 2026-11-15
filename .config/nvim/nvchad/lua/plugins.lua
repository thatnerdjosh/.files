-- SPDX-FileCopyrightText: 2026 thatnerdjosh
-- SPDX-License-Identifier: AGPL-3.0-or-later

-- Default to the Nomic Foundation language server (MIT).  Set
-- SOLIDITY_LSP=solc to trial the GPL-3.0-or-later compiler LSP instead.
local solidity_lsp = vim.env.SOLIDITY_LSP
if solidity_lsp ~= "solc" then
  solidity_lsp = "nomic"
end

local mason_lsp_servers = {
  "lua_ls",
  solidity_lsp == "solc" and "solc" or "solidity_ls_nomicfoundation",
}

local plugins = {
  -- LSP installation.  `automatic_enable = false` keeps NvChad in charge of
  -- enabling servers, so we do not get duplicate clients.
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
    opts = {
      ensure_installed = mason_lsp_servers,
      automatic_enable = false,
    },
  },

  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },

  -- Solidity syntax/treesitter support.
  -- NvChad v2.5 still uses the pre-`main` Treesitter API.  Pin the frozen
  -- `master` branch for now; revisit when NvChad migrates to the new API.
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    opts = {
      ensure_installed = {
        "lua",
        "luadoc",
        "printf",
        "vim",
        "vimdoc",
        "solidity",
        "bash",
        "json",
        "yaml",
        "toml",
        "markdown",
        "markdown_inline",
      },
    },
  },

  -- Foundry's formatter.  `forge fmt --raw -` reads Solidity from stdin and
  -- writes the formatted source to stdout, which is exactly what conform wants.
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        solidity = { "forge_fmt" },
      },
      formatters = {
        forge_fmt = {
          command = "forge",
          args = { "fmt", "--raw", "-" },
          stdin = true,
          cwd = function()
            return vim.fs.root(0, { "foundry.toml", ".git" }) or vim.fn.getcwd()
          end,
        },
      },
      format_on_save = function(bufnr)
        if vim.bo[bufnr].filetype == "solidity" then
          return { timeout_ms = 2000, lsp_format = "never" }
        end
      end,
    },
  },

  -- Optional AI and collaboration plugins.  None is needed to edit Solidity,
  -- and each one loads lazily or only touches its own filetype.  Credentials
  -- come from environment variables; see docs/ai.md for the full reference.
  {
    "milanglacier/minuet-ai.nvim",
    event = "InsertEnter",
    opts = function()
      return require("configs.ai").minuet()
    end,
  },

  {
    "Kurama622/llm.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "MunifTanjim/nui.nvim" },
    cmd = { "LLMSessionToggle", "LLMSelectedTextHandler", "LLMAppHandler" },
    keys = {
      { "<leader>ac", "<cmd>LLMSessionToggle<cr>", desc = "LLM chat" },
      { "<leader>al", "<cmd>LLMSelectedTextHandler<cr>", mode = "v", desc = "LLM selected text" },
    },
    config = function()
      require("llm").setup(require("configs.ai").llm())
    end,
  },

  {
    "Flemma-Dev/flemma.nvim",
    lazy = false,
    keys = {
      {
        "<leader>af",
        function()
          require("configs.ai").new_chat()
        end,
        desc = "New Flemma chat",
      },
    },
    opts = function()
      return require("configs.ai").flemma()
    end,
  },

  {
    "anuragrao04/pi-coding-agent.nvim",
    cmd = { "PiToggle", "PiContinue", "PiResume", "PiSelectModel", "PiSendBuffer", "PiSendSelection" },
    keys = {
      { "<leader>ap", "<cmd>PiToggle<cr>", desc = "pi toggle" },
      { "<leader>aP", "<cmd>PiContinue<cr>", desc = "pi continue" },
      { "<leader>aR", "<cmd>PiResume<cr>", desc = "pi resume" },
      { "<leader>am", "<cmd>PiSelectModel<cr>", desc = "pi model" },
      { "<leader>ab", "<cmd>PiSendBuffer<cr>", desc = "pi send buffer" },
      { "<leader>as", "<cmd>PiSendSelection<cr>", mode = "v", desc = "pi send selection" },
    },
    opts = function()
      return require("configs.ai").pi()
    end,
  },

  {
    "teamtype/teamtype-nvim",
    lazy = false,
    keys = {
      { "<leader>tj", "<cmd>TeamtypeJumpToCursor<cr>", desc = "Teamtype jump to peer" },
      { "<leader>tf", "<cmd>TeamtypeFollow<cr>", desc = "Teamtype follow peer" },
      { "<leader>ti", "<cmd>TeamtypeInfo<cr>", desc = "Teamtype info" },
    },
  },

  { "tpope/vim-sleuth", lazy = false },
}

return plugins
