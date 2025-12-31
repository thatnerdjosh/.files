-- Leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.termguicolors = true

-- Enable basic Vim syntax/filetype handling (fallback if Treesitter missing)
vim.cmd([[
  syntax on
  filetype plugin indent on
]])

-- Use a more colorful built-in colorscheme
pcall(vim.cmd, "colorscheme koehler")

-- Make PHP open tag (`<?php`) stand out more
vim.api.nvim_create_autocmd("FileType", {
  pattern = "php",
  callback = function()
    vim.cmd([[
      highlight! link phpRegion Keyword
      highlight! link phpRegionDelimiter Keyword
      highlight! link phpDelimiter Keyword
    ]])
  end,
})

-- Use simple ASCII diagnostic signs (avoid icon glyphs in gutter)
for type, icon in pairs({ Error = "E", Warn = "!", Hint = "H", Info = "i" }) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-----------------------------------------------------------
-- Global LSP keymaps (apply to any LSP server)
-----------------------------------------------------------
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", {}),
  callback = function(ev)
    local bufnr = ev.buf
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, silent = true, noremap = true, desc = desc })
    end
    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "K", vim.lsp.buf.hover, "Hover")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code action")
    -- Show function parameters / signature (works with intelephense)
    map("i", "<C-k>", vim.lsp.buf.signature_help, "Signature help")
  end,
})

-----------------------------------------------------------
-- Bootstrap lazy.nvim
-----------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-----------------------------------------------------------
-- Plugins
-----------------------------------------------------------
require("lazy").setup({

  ---------------------------------------------------------
  -- Simple file browser: nvim-tree
  ---------------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    -- No devicons: keep it simple and ASCII-only
    config = function()
      require("nvim-tree").setup({
        renderer = {
          icons = {
            show = {
              file = false,
              folder = false,
              folder_arrow = false,
              git = false,
            },
          },
        },
      })
      -- <leader>e toggles file explorer
      vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", {
        silent = true,
        noremap = true,
        desc = "Toggle file explorer",
      })
    end,
  },

  ---------------------------------------------------------
  -- Treesitter (better syntax highlighting, folding, etc.)
  ---------------------------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        return
      end

      configs.setup({
        -- Add more languages here as you need them
        ensure_installed = {
          "lua",
          "php",
          "javascript",
          "typescript",
          "html",
          "css",
          "json",
        },
        auto_install = true,
        highlight = {
          enable = true,
          -- Also use Vim's regex highlight for PHP as a fallback
          additional_vim_regex_highlighting = { "php" },
        },
        indent = {
          enable = true,
        },
      })
    end,
  },

  ---------------------------------------------------------
  -- Completion: nvim-cmp (LSP-powered)
  ---------------------------------------------------------
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({ select = true }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping.select_prev_item(),
        }),
        sources = {
          { name = "nvim_lsp" },
        },
      })
    end,
  },

  ---------------------------------------------------------
  -- PHP LSP via Mason + LSP
  ---------------------------------------------------------
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
    config = function()
      local mason_lspconfig = require("mason-lspconfig")
      mason_lspconfig.setup({
        ensure_installed = { "intelephense" }, -- PHP
        automatic_installation = true,
      })

      -- Capabilities for LSP completion (integrate with nvim-cmp if present)
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end

      -- Define and enable PHP LSP using the new vim.lsp.config API
      vim.lsp.config("intelephense", {
        capabilities = capabilities,
      })
      vim.lsp.enable("intelephense")
    end,
  },

})
