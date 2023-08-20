require "core" -- Load OmnidApps NeoViM core

---@type UserConfig
local userConfig = {
    lsp = {
        languages = {
            "lua",
        }
    },
    packages = {
        manager = "lazy.nvim",
        installed = {
            {
                "thatnerdjosh/nvim-ketho-wow",
            },
            {
                "preservim/NerdTREE",
            },
            {
                -- lazy = true,
                "neovim/nvim-lspconfig",
            },
            {
                -- TODO: Remove lazy.nvim specifics from main config
                -- lazy = false,
                -- priority = 1000,
                "tanvirtin/monokai.nvim"
            },
            {
                "folke/neodev.nvim"
            },
            {
                "hrsh7th/nvim-cmp",
                -- TODO: Abstract out below in this table
                -- event = "InsertEnter",
                dependencies = {
                    "hrsh7th/cmp-nvim-lsp",
                    "hrsh7th/cmp-buffer",
                },
            },
            {
                "L3MON4D3/LuaSnip",
                version = "2.*",
            },
            {
                "vijaymarupudi/nvim-fzf"
            }
        },
    },
    options = {
        linum = {
            Options.Linum.Normal,
            Options.Linum.Relative
        }
    }
}

Core.Setup(userConfig)

-- TODO: Migrate to setting
vim.cmd [[autocmd BufWritePre * lua vim.lsp.buf.format()]]
vim.cmd [[autocmd VimEnter * NERDTree | wincmd p]]
