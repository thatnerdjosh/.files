local plugins = {
  -- LSP
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "clangd"
      }
    }
  },
  {
    "neovim/nvim-lspconfig",
     config = function()
        require "configs.lspconfig"
     end,
  },
  {
    "tpope/vim-sleuth",
    lazy = false
  }
}


return plugins
